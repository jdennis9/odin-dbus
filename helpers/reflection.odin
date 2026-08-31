package dbus_helpers

import "core:log"
import "core:testing"
import "core:time"
import "core:fmt"
import "core:reflect"
import "core:mem"
import "core:strings"

ACCESS_STRING := [Access]string {
	.Read = "read",
	.ReadWrite = "readwrite",
}

DIRECTION_STRING := [Method_Arg_Direction]string {
	.In = "in",
	.Out = "out",
}

build_type_signature :: proc(b: ^strings.Builder, T: typeid) -> (error: Error) {
	switch T {
	case i32: fmt.sbprint(b, 'i'); return
	case i64, int: fmt.sbprint(b, 'x'); return
	case cstring, string: fmt.sbprint(b, 's'); return
	case f32, f64: fmt.sbprint(b, 'd'); return
	case Object_Path: fmt.sbprint(b, 'o'); return
	case Variant: fmt.sbprint(b, 'v'); return
	case bool, b16, b32, b64: fmt.sbprint(b, 'b'); return
	}

	ti := reflect.type_info_base(type_info_of(T))
	#partial switch v in ti.variant {
	case reflect.Type_Info_Array:
		fmt.sbprint(b, 'a')
		return build_type_signature(b, v.elem.id)
	case reflect.Type_Info_Slice:
		fmt.sbprint(b, 'a')
		return build_type_signature(b, v.elem.id)
	case reflect.Type_Info_Dynamic_Array:
		fmt.sbprint(b, 'a')
		return build_type_signature(b, v.elem.id)
	case reflect.Type_Info_Map:
		fmt.sbprint(b, "a{")
		build_type_signature(b, v.key.id) or_return
		build_type_signature(b, v.value.id) or_return
		fmt.sbprint(b, '}')
		return
	}

	fmt.println("Unsupported type", T)
	return Error_Code.UnsupportedType
}

property_map_from_type :: proc(
	T: typeid, string_allocator: mem.Allocator, map_allocator: mem.Allocator
) -> (props: map[string]Property, error: Error) {
	props = make(map[string]Property, map_allocator)

	ti := reflect.type_info_base(type_info_of(T))
	assert(reflect.is_struct(ti))

	field_count := reflect.struct_field_count(T)
	reserve(&props, field_count)

	for field_index in 0..<field_count {
		name: string
		access: Access
		field := reflect.struct_field_at(T, field_index)
		tag, has_tag := reflect.struct_tag_lookup(field.tag, "dbus")
		access_str := reflect.struct_tag_lookup(field.tag, "access") or_else "read"

		// Type signature
		b: strings.Builder
		strings.builder_init_len_cap(&b, 0, 8, string_allocator) or_return
		build_type_signature(&b, field.type.id) or_return

		if tag == "-" do continue

		if has_tag {
			name = strings.clone(tag, string_allocator) or_return
		}
		else {
			name = strings.to_upper_camel_case(field.name, string_allocator) or_return
		}

		switch access_str {
		case "readwrite": access = .ReadWrite
		case: access = .Read
		}

		props[name] = Property {
			offset = field.offset,
			type_signature = strings.to_cstring(&b),
			type = reflect.typeid_base(field.type.id),
			access = access,
		}
	}

	return
}

generate_interface_introspection :: proc(b: ^strings.Builder, obj: Interface) -> Error {
	fmt.sbprintfln(b, "<interface name='%s'>", obj.name)
	defer fmt.sbprintln(b, "</interface>")

	type_sig: strings.Builder
	defer strings.builder_destroy(&type_sig)

	// Properties
	for name, prop in obj.properties {
		fmt.sbprintfln(b, "\t<property name='%s' type='%s' access='%s' />", name, prop.type_signature, ACCESS_STRING[prop.access])
	}

	// Methods
	for method in obj.methods {
		fmt.sbprintfln(b, "\t<method name='%s'>", method.name)

		for arg in method.args {
			strings.builder_reset(&type_sig)
			build_type_signature(&type_sig, arg.type) or_continue
			sig := strings.to_string(type_sig)
			dir := DIRECTION_STRING[arg.direction]
			fmt.sbprintfln(b, "\t\t<arg name='%s' type='%s' direction='%s' />", arg.name, sig, dir)
		}

		defer fmt.sbprintfln(b, "\t</method>")
	}

	return nil
}

make_method_return_value :: proc(data: ^$T, allocator: mem.Allocator) -> (v: Method_Return_Value, e: Error) {
	return Method_Return_Value {
		data = new_clone(data, allocator) or_return,
		type = T,
	}, nil
}

@test
test_type_signatures :: proc(t: ^testing.T) {
	dump_sig :: proc($T: typeid) -> Error {
		b: strings.Builder
		defer strings.builder_destroy(&b)

		build_type_signature(&b, T) or_return
		fmt.println(typeid_of(T), "->", strings.to_string(b))
		return nil
	}

	testing.expect(t, dump_sig(i32) == nil)
	testing.expect(t, dump_sig(i64) == nil)
	testing.expect(t, dump_sig([]i64) == nil)
	testing.expect(t, dump_sig([32]i64) == nil)
	testing.expect(t, dump_sig(map[i32]cstring) == nil)
	testing.expect(t, dump_sig(map[string]Variant) == nil)
	testing.expect(t, dump_sig(f32) == nil)
}

