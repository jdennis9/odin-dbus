package dbus_helpers

import "core:mem"
import "base:runtime"
import "../dbus"

Object_Path :: struct {
	path: string,
}

Error_Code :: enum {
	ConnectionFailed,
	RequestNameFailed,
	RegisterObjectPathFailed,
	UnsupportedType,
	UnknownInterface,
}

Error :: union {
	bool,
	Error_Code,
	mem.Allocator_Error,
}

Variant :: union {
	string,
	bool,
	int,
	f64,
	f32,
	Object_Path,
}

Access :: enum {
	Read,
	ReadWrite,
}

Property :: struct {
	offset:         uintptr,
	type:           typeid,
	type_signature: cstring,
	access:         Access,
}

Method_Arg_Direction :: enum {
	In,
	Out,
}

Method_Arg_Definition :: struct {
	name:      string,
	type:      typeid,
	direction: Method_Arg_Direction,
}

Method_Definition :: struct {
	name: cstring,
	args: []Method_Arg_Definition,
}

Interface :: struct {
	name:            cstring,
	properties_type: typeid, // Type of struct where properties are stored
	property_data:   rawptr, // Pointer to struct where properties are stored
	properties:      map[string]Property,
	methods:         []Method_Definition,
	method_proc:     proc(call: Method_Call, result_allocator: mem.Allocator) -> (Method_Result, Error),
}

Object :: struct {
	path:       cstring,
	interfaces: []Interface,
}

Method_Call :: struct {
	method_name: string,
	args:        map[string]Variant,
}

Method_Return_Value :: struct {
	data: rawptr,
	type: typeid,
}

Method_Result :: struct {
	return_values: []Method_Return_Value,
}

Server_Info :: struct {
	bus_name:     cstring,
	objects:      []Object,
	init_context: runtime.Context,
}

