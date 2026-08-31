/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-types.h  types such as dbus_bool_t
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

dbus_unichar_t :: dbus_uint32_t

/* boolean size must be fixed at 4 bytes due to wire protocol! */
dbus_bool_t :: b32

/**
* An 8-byte struct you could use to access int64 without having
* int64 support. Use #dbus_int64_t or #dbus_uint64_t instead.
*/
_8ByteStruct :: struct {
	first32:  dbus_uint32_t, /**< first 32 bits in the 8 bytes (beware endian issues) */
	second32: dbus_uint32_t, /**< second 32 bits in the 8 bytes (beware endian issues) */
}

/**
* A simple value union that lets you access bytes as if they
* were various types; useful when dealing with basic types via
* void pointers and varargs.
*
* This union also contains a pointer member (which can be used
* to retrieve a string from dbus_message_iter_get_basic(), for
* instance), so on future platforms it could conceivably be larger
* than 8 bytes.
*/
BasicValue :: struct #raw_union {
	bytes:    [8]u8,         /**< as 8 individual bytes */
	_i16:     dbus_int16_t,  /**< as int16 */
	_u16:     dbus_uint16_t, /**< as int16 */
	_i32:     dbus_int32_t,  /**< as int32 */
	_u32:     dbus_uint32_t, /**< as int32 */
	bool_val: dbus_bool_t,   /**< as boolean */
	_i64:     dbus_int64_t,  /**< as int64 */
	_u64:     dbus_uint64_t, /**< as int64 */
	eight:    _8ByteStruct,  /**< as 8-byte struct */
	dbl:      f64,           /**< as double */
	byt:      u8,            /**< as byte */
	str:      cstring,       /**< as char* (string, object path or signature) */
	fd:       i32,           /**< as Unix file descriptor */
}

