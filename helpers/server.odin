package dbus_helpers

import "core:slice"
import "core:reflect"
import "base:runtime"
import "core:mem"
import "core:log"
import "core:fmt"
import "core:strings"

import "../dbus"

INTROSPECTABLE_INTERFACE_XML ::
`
<interface name='org.freedesktop.DBus.Introspectable'>
	<method name='Introspect'>
		<arg name='data' type='s' direction='out' />
	</method>
</interface>
`

PROPERTIES_INTERFACE_XML ::
`
<interface name='org.freedesktop.DBus.Properties'>
	<method name='Get'>
		<arg name='interface', type='s', direction='in' />
		<arg name='properties', type='a{sv}', direction='out' />
	</method>
</interface>
`

INTERFACE_NAME_INTROSPECTABLE :: "org.freedesktop.DBus.Introspectable"
INTERFACE_NAME_PROPERTIES :: "org.freedesktop.DBus.Properties"

Server_State :: struct {
	info: ^Server_Info,
	conn: ^dbus.Connection,
}

@(private="file")
_Message_Proc_Data :: struct {
	s: ^Server_State,
	object_index: int,
}

// This procedure is the main entry point for running a server. It is completely synchronous, 
// but will automatically change the values of properties in interfaces. If you want to access
// the values of an interface outside of the session, you must first lock the interface
// with server_lock_interface(). All data passed to this procedure must stay alive for the duration
// of it.
server_run :: proc(info: ^Server_Info) -> Error {
	assert(info.bus_name != nil)
	assert(info.objects != nil)
	assert(
		info.init_context.allocator.procedure != nil, 
		"Must provide a context for server callbacks to use"
	)

	s := Server_State {info = info}
	error: dbus.Error
	ret: i32

	arena: mem.Dynamic_Arena
	mem.dynamic_arena_init(&arena)
	defer mem.dynamic_arena_destroy(&arena)
	temp_allocator := mem.dynamic_arena_allocator(&arena)

	// --------------------------------------------------------------------------
	// VTables
	// --------------------------------------------------------------------------
	object_vtable := dbus.ObjectPathVTable {
		unregister_function = _unregister_proc,
		message_function = _message_proc,
	}

	root_vtable := dbus.ObjectPathVTable {
		unregister_function = _introspect_unregister_proc,
		message_function = _introspect_message_proc,
	}

	dbus.error_init(&error)
	defer dbus.error_free(&error)

	s.conn = dbus.bus_get(.SESSION, &error)
	if s.conn == nil do return Error_Code.ConnectionFailed
	//defer dbus.connection_close(s.conn)

	dbus.connection_set_exit_on_disconnect(s.conn, false)

	ret = dbus.bus_request_name(s.conn, info.bus_name, dbus.NAME_FLAG_DO_NOT_QUEUE, &error)

	if ret != dbus.REQUEST_NAME_REPLY_PRIMARY_OWNER {
		return Error_Code.RequestNameFailed
	}

	for obj, index in info.objects {
		proc_data := new(_Message_Proc_Data, temp_allocator)
		proc_data.s = &s
		proc_data.object_index = index
		log.debug("Register object", obj.path)
		if !dbus.connection_register_object_path(s.conn, obj.path, &object_vtable, proc_data) {
			log.error("Failed to register object", obj.path)
			return Error_Code.RegisterObjectPathFailed
		}
	}

	// Listen for messages
	for {
		if !dbus.connection_read_write_dispatch(s.conn, -1) {
			log.error("connection_read_write_dispatch failed")
			return .ConnectionFailed
		}
	}

	log.info("Closing server connection")

	return nil
}

object_get_interface_from_name :: proc(obj: Object, name: string) -> (iface: ^Interface, found: bool) {
	for &i in obj.interfaces {
		if string(i.name) == name {
			return &i, true
		}
	}

	return
}

write_value_to_message :: proc(ptr: rawptr, T: typeid, iter: ^dbus.MessageIter, sb: ^strings.Builder) -> (error: Error) {
	a := any{ptr, T}

	switch v in a {
	case i64, int:
		dbus.message_iter_append_basic(iter, 'x', ptr)
		return		
	case i32:
		dbus.message_iter_append_basic(iter, 'i', ptr)
		return
	case f64, f32, f16:
		f := reflect.as_f64(a) or_else 0
		dbus.message_iter_append_basic(iter, 'd', &f)
		return
	case b64, b32, b16, bool:
		b := b32(reflect.as_bool(a) or_else false)
		dbus.message_iter_append_basic(iter, 'b', &b)
		return
	case cstring:
		dbus.message_iter_append_basic(iter, 's', ptr)
		return
	case string:
		as_cstring := strings.clone_to_cstring(v)
		defer delete(as_cstring)
		dbus.message_iter_append_basic(iter, 's', &as_cstring)
		return
	}

	write_array :: proc(base_ptr: rawptr, elem: typeid, stride, count: int, iter: ^dbus.MessageIter, sb: ^strings.Builder) -> Error {
		array: dbus.MessageIter
		bytes := cast([^]byte) base_ptr
		ptr := base_ptr

		strings.builder_reset(sb)
		build_type_signature(sb, elem) or_return

		dbus.message_iter_open_container(iter, 'a', strings.to_cstring(sb), &array)
		defer dbus.message_iter_close_container(iter, &array)

		for i in 0..<count {
			ptr = raw_data(bytes[stride*i:][:stride])
			write_value_to_message(ptr, elem, &array, sb) or_return
		}

		return nil
	}

	ti := type_info_of(T)
	#partial switch v in ti.variant {
	case reflect.Type_Info_Slice:
		raw := cast(^mem.Raw_Slice) ptr
		write_array(raw.data, v.elem.id, v.elem_size, raw.len, iter, sb)
		return
	case reflect.Type_Info_Array:
		write_array(ptr, v.elem.id, v.elem_size, v.count, iter, sb)
		return
	case reflect.Type_Info_Dynamic_Array:
		raw := cast(^mem.Raw_Dynamic_Array) ptr
		write_array(raw.data, v.elem.id, v.elem_size, raw.len, iter, sb)
		return
	case reflect.Type_Info_Map:
		dict: dbus.MessageIter
		it: int
		raw := cast(^mem.Raw_Map) ptr

		strings.builder_reset(sb)
		strings.write_string(sb, "{")
		build_type_signature(sb, v.key.id)
		build_type_signature(sb, v.value.id)
		strings.write_string(sb, "}")

		dbus.message_iter_open_container(iter, 'a', strings.to_cstring(sb), &dict)
		defer dbus.message_iter_close_container(iter, &dict)

		for key, value in reflect.iterate_map(a, &it) {
			entry: dbus.MessageIter
			dbus.message_iter_open_container(&dict, 'e', nil, &entry)			
			defer dbus.message_iter_close_container(&dict, &entry)

			write_value_to_message(key.data, v.key.id, &entry, sb)
			write_value_to_message(value.data, v.value.id, &entry, sb)
		}
		return
	}

	return Error_Code.UnsupportedType
}

append_property_as_variant :: proc(iface: Interface, prop: Property, iter: ^dbus.MessageIter) -> bool {
	ti := type_info_of(prop.type)
	data_slice := (cast([^]byte) iface.property_data)[prop.offset:][:ti.size]
	ptr := raw_data(data_slice)
	prop_signature := prop.type_signature


	a := any{ptr, ti.id}

	variant: dbus.MessageIter

	dbus.message_iter_open_container(iter, 'v', prop_signature, &variant)
	defer dbus.message_iter_close_container(iter, &variant)

	sig_builder: strings.Builder
	defer strings.builder_destroy(&sig_builder)
	write_value_to_message(ptr, prop.type, &variant, &sig_builder)

	return true
}

dump_message :: proc(msg: ^dbus.Message, loc := #caller_location) {
	log.info(
		"Sender:", dbus.message_get_sender(msg), "\n",
		"Destination:", dbus.message_get_destination(msg), "\n",
		"Object:", dbus.message_get_path(msg), "\n",
		"Interface:", dbus.message_get_interface(msg), "\n",
		"Member:", dbus.message_get_member(msg), "\n",
		location = loc
	)
}

@(private="file")
_handle_properties_method :: proc(object: Object, msg: ^dbus.Message, reply: ^dbus.Message, error: ^dbus.Error) -> Error {
	if dbus.message_is_method_call(msg, INTERFACE_NAME_PROPERTIES, "GetAll") {
		target_iface_name: cstring
		
		dbus.message_get_args(msg, error, 's', &target_iface_name, i32(0))
		
		log.debug("Get all properties for", target_iface_name)
		
		iface := object_get_interface_from_name(object, string(target_iface_name)) or_return

		iter: dbus.MessageIter
		dbus.message_iter_init_append(reply, &iter)
		log.debug("start reply")
		defer log.debug("end reply")

		dict: dbus.MessageIter
		dbus.message_iter_open_container(&iter, 'a', "{sv}", &dict)
		defer dbus.message_iter_close_container(&iter, &dict)

		for prop_name, prop in iface.properties {
			prop_name_cstring := strings.clone_to_cstring(prop_name, context.allocator) or_return
			defer delete(prop_name_cstring)
			
			entry: dbus.MessageIter
			dbus.message_iter_open_container(&dict, 'e', nil, &entry)
			defer dbus.message_iter_close_container(&dict, &entry)
			
			dbus.message_iter_append_basic(&entry, 's', &prop_name_cstring)
			log.debug("in", prop_name)
			append_property_as_variant(iface^, prop, &entry) or_return
			log.debug("out", prop_name)
		}
	}	
	else if dbus.message_is_method_call(msg, INTERFACE_NAME_PROPERTIES, "Get") {
		target_iface_name: cstring
		property_name: cstring
	
		dbus.message_get_args(msg, error, 's', &target_iface_name, 's', &property_name, i32(0))

		log.debug("Get property", property_name, "on interface", target_iface_name)

		iface := object_get_interface_from_name(object, string(target_iface_name)) or_return
		prop := iface.properties[string(property_name)] or_return

		variant: dbus.MessageIter
		dbus.message_iter_init_append(reply, &variant)

		append_property_as_variant(iface^, prop, &variant)
	}
	else if dbus.message_is_method_call(msg, INTERFACE_NAME_PROPERTIES, "Set") {
		target_iface_name: cstring
		property_name: cstring
	
		dbus.message_get_args(msg, error, 's', &target_iface_name, 's', &property_name, i32(0))

		iface := object_get_interface_from_name(object, string(target_iface_name)) or_return
		prop := iface.properties[string(property_name)] or_return

		if prop.access != .ReadWrite do return Error_Code.AccessViolation

		// @TODO: Set property
	}

	return nil
}

/*@(private="file")
_process_message :: proc(s: ^Server_State, iface: ^Interface, msg: ^dbus.Message) -> Error {
	arena: mem.Dynamic_Arena
	mem.dynamic_arena_init(&arena, block_size = 4096)
	defer mem.dynamic_arena_destroy(&arena)
	allocator := mem.dynamic_arena_allocator(&arena)

	for method in iface.methods {
		if dbus.message_is_method_call(msg, iface.name, method.name) {
			result := iface.method_proc(Method_Call {
				method_name = string(method.name),
			}, allocator) or_return
		}
	}
}*/


@(private="file")
_unregister_proc :: proc "c" (conn: ^dbus.Connection, userdata: rawptr) {
}

@(private="file")
_handle_message :: proc(
	conn: ^dbus.Connection, msg: ^dbus.Message, reply: ^dbus.Message, data: ^_Message_Proc_Data
) -> Error {
	s := data.s
	object := s.info.objects[data.object_index]
	error: dbus.Error

	arena: mem.Dynamic_Arena
	mem.dynamic_arena_init(&arena)
	defer mem.dynamic_arena_destroy(&arena)
	temp_allocator := mem.dynamic_arena_allocator(&arena)

	dbus.error_init(&error)
	defer dbus.error_free(&error)

	message_iface_name := string(dbus.message_get_interface(msg))

	// --------------------------------------------------------------------------
	// Handle properties or introspect method
	// --------------------------------------------------------------------------
	if message_iface_name == INTERFACE_NAME_PROPERTIES {
		return _handle_properties_method(object, msg, reply, &error)
	}
	else if message_iface_name == INTERFACE_NAME_INTROSPECTABLE {
		return _handle_introspect_method(object, msg, reply, &error)
	}

	// --------------------------------------------------------------------------
	// Figure out which interface the call was for
	// --------------------------------------------------------------------------
	iface, iface_found := object_get_interface_from_name(object, message_iface_name)

	if !iface_found {
		return Error_Code.UnknownInterface
	}

	// --------------------------------------------------------------------------
	// Call the method
	// --------------------------------------------------------------------------
	for method in iface.methods {
		if dbus.message_is_method_call(msg, iface.name, method.name) {
			sb: strings.Builder
			strings.builder_init_len(&sb, 0, temp_allocator) or_return

			// Get arguments
			for arg in method.args {
				if arg.direction == .Out do continue
			}

			// Call method handler
			result := iface.method_proc(Method_Call {
				method_name = string(method.name),
			}, temp_allocator) or_return

			// Append return values
			if len(result.return_values) > 0 {
				iter: dbus.MessageIter
				dbus.message_iter_init_append(reply, &iter)

				for retval in result.return_values {
					write_value_to_message(retval.data, retval.type, &iter, &sb) or_return
				}
			}
		}
	}

	return nil
}

@(private="file")
_message_proc :: proc "c" (conn: ^dbus.Connection, msg: ^dbus.Message, userdata: rawptr) -> dbus.HandlerResult {
	data := cast(^_Message_Proc_Data) userdata
	s := data.s

	context = s.info.init_context
	
	dump_message(msg)

	reply := dbus.message_new_method_return(msg)
	defer dbus.message_unref(reply)
	error := _handle_message(conn, msg, reply, data)

	if error != nil {
		log.error("Error when handling message:", error)
		return .NOT_YET_HANDLED
	}

	dbus.connection_send(conn, reply, nil)

	//dump_message(reply)
	log.debug("Waga")

	return .HANDLED
}

@(private="file")
_introspect_unregister_proc :: proc "c" (conn: ^dbus.Connection, userdata: rawptr) {
}

@(private="file")
_introspect_message_proc :: proc "c" (conn: ^dbus.Connection, msg: ^dbus.Message, userdata: rawptr) -> dbus.HandlerResult {
	s := cast(^Server_State) userdata
	context = s.info.init_context
	reply: ^dbus.Message

	dump_message(msg)

	reply = dbus.message_new_method_return(msg)
	iface_name := string(dbus.message_get_interface(msg))

	if iface_name == INTERFACE_NAME_PROPERTIES {
	}
	else if iface_name == INTERFACE_NAME_INTROSPECTABLE {
		
	}
	
	dbus.connection_send(conn, reply, nil)
	return .HANDLED
}

@(private="file")
_handle_introspect_method :: proc(obj: Object, msg: ^dbus.Message, reply: ^dbus.Message, error: ^dbus.Error) -> Error {
	if dbus.message_is_method_call(msg, INTERFACE_NAME_INTROSPECTABLE, "Introspect") {
		log.debug("Received introspect call from", dbus.message_get_sender(msg))

		// Generate introspection
		introspection_xml: cstring
		introspection_builder: strings.Builder
		{
			b := &introspection_builder

			//for obj in s.info.objects {
				fmt.sbprintfln(b, "<node name='%s'>", obj.path)
				defer fmt.sbprintfln(b, "</node>")
				
				fmt.sbprintln(b, INTROSPECTABLE_INTERFACE_XML)

				for iface in obj.interfaces {
					generate_interface_introspection(b, iface)
				}
			//}
		}

		introspection_xml = strings.to_cstring(&introspection_builder)
		defer delete(introspection_xml)

		fmt.println(introspection_xml)
		
		dbus.message_append_args(reply, i32('s'), &introspection_xml, 0)
	}

	return nil
}
