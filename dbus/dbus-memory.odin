/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-memory.h  D-Bus memory handling
 *
 * Copyright (C) 2002  Red Hat Inc.
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

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	/**
	* @addtogroup DBusMemory
	* @{
	*/
	malloc            :: proc(bytes: i32) -> rawptr ---
	malloc0           :: proc(bytes: i32) -> rawptr ---
	realloc           :: proc(memory: rawptr, bytes: i32) -> rawptr ---
	free              :: proc(memory: rawptr) ---
	free_string_array :: proc(str_array: ^cstring) ---
}

FreeFunction :: proc "c" (memory: rawptr)

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	shutdown :: proc() ---
}

