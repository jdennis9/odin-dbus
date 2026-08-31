/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-message.h DBusMessage object
 *
 * Copyright (C) 2002, 2003, 2005 Red Hat Inc.
 *
 * SPDX-License-Identifier: AFL-2.1 OR GPL-2.0-or-later
 *
 * Licensed under the Academic Free License version 2.1
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */
package odin_dbus

foreign import lib "system:dbus-1"
_ :: lib

Message :: struct {}

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	message_new                    :: proc(message_type: i32) -> ^Message ---
	message_new_method_call        :: proc(bus_name: cstring, path: cstring, iface: cstring, method: cstring) -> ^Message ---
	message_new_method_return      :: proc(method_call: ^Message) -> ^Message ---
	message_new_signal             :: proc(path: cstring, iface: cstring, name: cstring) -> ^Message ---
	message_new_error              :: proc(reply_to: ^Message, error_name: cstring, error_message: cstring) -> ^Message ---
	message_new_error_printf       :: proc(reply_to: ^Message, error_name: cstring, error_format: cstring, #c_vararg _: ..any) -> ^Message ---
	message_copy                   :: proc(message: ^Message) -> ^Message ---
	message_ref                    :: proc(message: ^Message) -> ^Message ---
	message_unref                  :: proc(message: ^Message) ---
	message_get_type               :: proc(message: ^Message) -> i32 ---
	message_set_path               :: proc(message: ^Message, object_path: cstring) -> dbus_bool_t ---
	message_get_path               :: proc(message: ^Message) -> cstring ---
	message_has_path               :: proc(message: ^Message, object_path: cstring) -> dbus_bool_t ---
	message_set_interface          :: proc(message: ^Message, iface: cstring) -> dbus_bool_t ---
	message_get_interface          :: proc(message: ^Message) -> cstring ---
	message_has_interface          :: proc(message: ^Message, iface: cstring) -> dbus_bool_t ---
	message_set_member             :: proc(message: ^Message, member: cstring) -> dbus_bool_t ---
	message_get_member             :: proc(message: ^Message) -> cstring ---
	message_has_member             :: proc(message: ^Message, member: cstring) -> dbus_bool_t ---
	message_set_error_name         :: proc(message: ^Message, name: cstring) -> dbus_bool_t ---
	message_get_error_name         :: proc(message: ^Message) -> cstring ---
	message_set_destination        :: proc(message: ^Message, destination: cstring) -> dbus_bool_t ---
	message_get_destination        :: proc(message: ^Message) -> cstring ---
	message_set_sender             :: proc(message: ^Message, sender: cstring) -> dbus_bool_t ---
	message_get_sender             :: proc(message: ^Message) -> cstring ---
	message_get_signature          :: proc(message: ^Message) -> cstring ---
	message_set_no_reply           :: proc(message: ^Message, no_reply: dbus_bool_t) ---
	message_get_no_reply           :: proc(message: ^Message) -> dbus_bool_t ---
	message_is_method_call         :: proc(message: ^Message, iface: cstring, method: cstring) -> dbus_bool_t ---
	message_is_signal              :: proc(message: ^Message, iface: cstring, signal_name: cstring) -> dbus_bool_t ---
	message_is_error               :: proc(message: ^Message, error_name: cstring) -> dbus_bool_t ---
	message_has_destination        :: proc(message: ^Message, bus_name: cstring) -> dbus_bool_t ---
	message_has_sender             :: proc(message: ^Message, unique_bus_name: cstring) -> dbus_bool_t ---
	message_has_signature          :: proc(message: ^Message, signature: cstring) -> dbus_bool_t ---
	message_get_serial             :: proc(message: ^Message) -> dbus_uint32_t ---
	message_set_serial             :: proc(message: ^Message, serial: dbus_uint32_t) ---
	message_set_reply_serial       :: proc(message: ^Message, reply_serial: dbus_uint32_t) -> dbus_bool_t ---
	message_get_reply_serial       :: proc(message: ^Message) -> dbus_uint32_t ---
	message_set_auto_start         :: proc(message: ^Message, auto_start: dbus_bool_t) ---
	message_get_auto_start         :: proc(message: ^Message) -> dbus_bool_t ---
	message_get_path_decomposed    :: proc(message: ^Message, path: ^^cstring) -> dbus_bool_t ---
	message_get_container_instance :: proc(message: ^Message) -> cstring ---
	message_set_container_instance :: proc(message: ^Message, object_path: cstring) -> dbus_bool_t ---
	message_append_args            :: proc(message: ^Message, first_arg_type: i32, #c_vararg _: ..any) -> dbus_bool_t ---
	message_append_args_valist     :: proc(message: ^Message, first_arg_type: i32, var_args: i32) -> dbus_bool_t ---
	message_get_args               :: proc(message: ^Message, error: ^Error, first_arg_type: i32, #c_vararg _: ..any) -> dbus_bool_t ---
	message_get_args_valist        :: proc(message: ^Message, error: ^Error, first_arg_type: i32, var_args: i32) -> dbus_bool_t ---
	message_contains_unix_fds      :: proc(message: ^Message) -> dbus_bool_t ---
	message_iter_init_closed       :: proc(iter: ^MessageIter) ---
	message_iter_init              :: proc(message: ^Message, iter: ^MessageIter) -> dbus_bool_t ---
	message_iter_has_next          :: proc(iter: ^MessageIter) -> dbus_bool_t ---
	message_iter_next              :: proc(iter: ^MessageIter) -> dbus_bool_t ---
	message_iter_get_signature     :: proc(iter: ^MessageIter) -> cstring ---
	message_iter_get_arg_type      :: proc(iter: ^MessageIter) -> i32 ---
	message_iter_get_element_type  :: proc(iter: ^MessageIter) -> i32 ---
	message_iter_recurse           :: proc(iter: ^MessageIter, sub: ^MessageIter) ---
	message_iter_get_basic         :: proc(iter: ^MessageIter, value: rawptr) ---
	message_iter_get_element_count :: proc(iter: ^MessageIter) -> i32 ---

	/* This function returns the wire protocol size of the array in bytes,
	* you do not want to know that probably
	*/
	message_iter_get_array_len                  :: proc(iter: ^MessageIter) -> i32 ---
	message_iter_get_fixed_array                :: proc(iter: ^MessageIter, value: rawptr, n_elements: ^i32) ---
	message_iter_init_append                    :: proc(message: ^Message, iter: ^MessageIter) ---
	message_iter_append_basic                   :: proc(iter: ^MessageIter, type: i32, value: rawptr) -> dbus_bool_t ---
	message_iter_append_fixed_array             :: proc(iter: ^MessageIter, element_type: i32, value: rawptr, n_elements: i32) -> dbus_bool_t ---
	message_iter_open_container                 :: proc(iter: ^MessageIter, type: i32, contained_signature: cstring, sub: ^MessageIter) -> dbus_bool_t ---
	message_iter_close_container                :: proc(iter: ^MessageIter, sub: ^MessageIter) -> dbus_bool_t ---
	message_iter_abandon_container              :: proc(iter: ^MessageIter, sub: ^MessageIter) ---
	message_iter_abandon_container_if_open      :: proc(iter: ^MessageIter, sub: ^MessageIter) ---
	message_lock                                :: proc(message: ^Message) ---
	set_error_from_message                      :: proc(error: ^Error, message: ^Message) -> dbus_bool_t ---
	message_allocate_data_slot                  :: proc(slot_p: ^dbus_int32_t) -> dbus_bool_t ---
	message_free_data_slot                      :: proc(slot_p: ^dbus_int32_t) ---
	message_set_data                            :: proc(message: ^Message, slot: dbus_int32_t, data: rawptr, free_data_func: FreeFunction) -> dbus_bool_t ---
	message_get_data                            :: proc(message: ^Message, slot: dbus_int32_t) -> rawptr ---
	message_type_from_string                    :: proc(type_str: cstring) -> i32 ---
	message_type_to_string                      :: proc(type: i32) -> cstring ---
	message_marshal                             :: proc(msg: ^Message, marshalled_data_p: ^cstring, len_p: ^i32) -> dbus_bool_t ---
	message_demarshal                           :: proc(str: cstring, len: i32, error: ^Error) -> ^Message ---
	message_demarshal_bytes_needed              :: proc(str: cstring, len: i32) -> i32 ---
	message_set_allow_interactive_authorization :: proc(message: ^Message, allow: dbus_bool_t) ---
	message_get_allow_interactive_authorization :: proc(message: ^Message) -> dbus_bool_t ---
}

