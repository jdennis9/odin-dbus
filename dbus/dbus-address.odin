/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-address.h  Server address parser.
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

foreign import lib "system:dbus-1"
_ :: lib

AddressEntry :: struct {}

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	parse_address            :: proc(address: cstring, entry_result: ^^^AddressEntry, array_len: ^i32, error: ^Error) -> dbus_bool_t ---
	address_entry_get_value  :: proc(entry: ^AddressEntry, key: cstring) -> cstring ---
	address_entry_get_method :: proc(entry: ^AddressEntry) -> cstring ---
	address_entries_free     :: proc(entries: ^^AddressEntry) ---
	address_escape_value     :: proc(value: cstring) -> cstring ---
	address_unescape_value   :: proc(value: cstring, error: ^Error) -> cstring ---
}

