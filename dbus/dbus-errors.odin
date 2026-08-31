/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-errors.h Error reporting
 *
 * Copyright (C) 2002  Red Hat Inc.
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

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	error_init      :: proc(error: ^Error) ---
	error_free      :: proc(error: ^Error) ---
	set_error       :: proc(error: ^Error, name: cstring, message: cstring, #c_vararg _: ..any) ---
	set_error_const :: proc(error: ^Error, name: cstring, message: cstring) ---
	move_error      :: proc(src: ^Error, dest: ^Error) ---
	error_has_name  :: proc(error: ^Error, name: cstring) -> dbus_bool_t ---
	error_is_set    :: proc(error: ^Error) -> dbus_bool_t ---
}

