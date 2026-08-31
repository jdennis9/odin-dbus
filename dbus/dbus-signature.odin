/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-signatures.h utility functions for D-Bus types
 *
 * Copyright (C) 2005 Red Hat Inc.
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

/**
* DBusSignatureIter struct; contains no public fields
*/
SignatureIter :: struct {
	dummy1:  rawptr,        /**< Don't use this */
	dummy2:  rawptr,        /**< Don't use this */
	dummy8:  dbus_uint32_t, /**< Don't use this */
	dummy12: i32,           /**< Don't use this */
	dummy17: i32,           /**< Don't use this */
}

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	signature_iter_init             :: proc(iter: ^SignatureIter, signature: cstring) ---
	signature_iter_get_current_type :: proc(iter: ^SignatureIter) -> i32 ---
	signature_iter_get_signature    :: proc(iter: ^SignatureIter) -> cstring ---
	signature_iter_get_element_type :: proc(iter: ^SignatureIter) -> i32 ---
	signature_iter_next             :: proc(iter: ^SignatureIter) -> dbus_bool_t ---
	signature_iter_recurse          :: proc(iter: ^SignatureIter, subiter: ^SignatureIter) ---
	signature_validate              :: proc(signature: cstring, error: ^Error) -> dbus_bool_t ---
	signature_validate_single       :: proc(signature: cstring, error: ^Error) -> dbus_bool_t ---
	type_is_valid                   :: proc(typecode: i32) -> dbus_bool_t ---
	type_is_basic                   :: proc(typecode: i32) -> dbus_bool_t ---
	type_is_container               :: proc(typecode: i32) -> dbus_bool_t ---
	type_is_fixed                   :: proc(typecode: i32) -> dbus_bool_t ---
}

