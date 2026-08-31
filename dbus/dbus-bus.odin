/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-bus.h  Convenience functions for communicating with the bus.
 *
 * Copyright (C) 2003  CodeFactory AB
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

import "core:c"

foreign import lib "system:dbus-1"
_ :: lib

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	/**
	* @addtogroup DBusBus
	* @{
	*/
	bus_get                   :: proc(type: BusType, error: ^Error) -> ^Connection ---
	bus_get_private           :: proc(type: BusType, error: ^Error) -> ^Connection ---
	bus_register              :: proc(connection: ^Connection, error: ^Error) -> dbus_bool_t ---
	bus_set_unique_name       :: proc(connection: ^Connection, unique_name: cstring) -> dbus_bool_t ---
	bus_get_unique_name       :: proc(connection: ^Connection) -> cstring ---
	bus_get_unix_user         :: proc(connection: ^Connection, name: cstring, error: ^Error) -> c.ulong ---
	bus_get_id                :: proc(connection: ^Connection, error: ^Error) -> cstring ---
	bus_request_name          :: proc(connection: ^Connection, name: cstring, flags: u32, error: ^Error) -> i32 ---
	bus_release_name          :: proc(connection: ^Connection, name: cstring, error: ^Error) -> i32 ---
	bus_name_has_owner        :: proc(connection: ^Connection, name: cstring, error: ^Error) -> dbus_bool_t ---
	bus_start_service_by_name :: proc(connection: ^Connection, name: cstring, flags: dbus_uint32_t, reply: ^dbus_uint32_t, error: ^Error) -> dbus_bool_t ---
	bus_add_match             :: proc(connection: ^Connection, rule: cstring, error: ^Error) ---
	bus_remove_match          :: proc(connection: ^Connection, rule: cstring, error: ^Error) ---
}

