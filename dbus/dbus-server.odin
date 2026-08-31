/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-server.h DBusServer object
 *
 * Copyright (C) 2002, 2003  Red Hat Inc.
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

Server :: struct {}

/** Called when a new connection to the server is available. Must reference and save the new
* connection, or close the new connection. Set with dbus_server_set_new_connection_function().
*/
NewConnectionFunction :: proc "c" (server: ^Server, new_connection: ^Connection, data: rawptr)

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	server_listen                      :: proc(address: cstring, error: ^Error) -> ^Server ---
	server_ref                         :: proc(server: ^Server) -> ^Server ---
	server_unref                       :: proc(server: ^Server) ---
	server_disconnect                  :: proc(server: ^Server) ---
	server_get_is_connected            :: proc(server: ^Server) -> dbus_bool_t ---
	server_get_address                 :: proc(server: ^Server) -> cstring ---
	server_get_id                      :: proc(server: ^Server) -> cstring ---
	server_set_new_connection_function :: proc(server: ^Server, function: NewConnectionFunction, data: rawptr, free_data_function: FreeFunction) ---
	server_set_watch_functions         :: proc(server: ^Server, add_function: AddWatchFunction, remove_function: RemoveWatchFunction, toggled_function: WatchToggledFunction, data: rawptr, free_data_function: FreeFunction) -> dbus_bool_t ---
	server_set_timeout_functions       :: proc(server: ^Server, add_function: AddTimeoutFunction, remove_function: RemoveTimeoutFunction, toggled_function: TimeoutToggledFunction, data: rawptr, free_data_function: FreeFunction) -> dbus_bool_t ---
	server_set_auth_mechanisms         :: proc(server: ^Server, mechanisms: ^cstring) -> dbus_bool_t ---
	server_allocate_data_slot          :: proc(slot_p: ^dbus_int32_t) -> dbus_bool_t ---
	server_free_data_slot              :: proc(slot_p: ^dbus_int32_t) ---
	server_set_data                    :: proc(server: ^Server, slot: i32, data: rawptr, free_data_func: FreeFunction) -> dbus_bool_t ---
	server_get_data                    :: proc(server: ^Server, slot: i32) -> rawptr ---
}

