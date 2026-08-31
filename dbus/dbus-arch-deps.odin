/* -*- mode: C; c-file-style: "gnu" -*- */
/* dbus-arch-deps.h Header with architecture/compiler specific information, installed to libdir
 *
 * Copyright (C) 2003 Red Hat, Inc.
 * SPDX-License-Identifier: AFL-2.0 OR GPL-2.0-or-later
 *
 * Licensed under the Academic Free License version 2.0
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

/* D-Bus no longer supports platforms with no 64-bit integer type. */
HAVE_INT64 :: 1

dbus_int64_t  :: i64
dbus_uint64_t :: u64

INT64_MODIFIER :: "l"

dbus_int32_t  :: i32
dbus_uint32_t :: u32
dbus_int16_t  :: i16
dbus_uint16_t :: u16

SIZEOF_VOID_P :: 8

/* This is not really arch-dependent, but it's not worth
* creating an additional generated header just for this
*/
MAJOR_VERSION  :: 1
MINOR_VERSION  :: 16
MICRO_VERSION  :: 2
VERSION_STRING :: "1.16.2"
VERSION        :: ((1<<16)|(16<<8)|(2))

