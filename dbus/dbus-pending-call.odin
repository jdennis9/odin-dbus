/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-pending-call.h Object representing a call in progress.
 *
 * Copyright (C) 2002, 2003 Red Hat Inc.
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

TIMEOUT_USE_DEFAULT :: (-1)

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	pending_call_ref                :: proc(pending: ^PendingCall) -> ^PendingCall ---
	pending_call_unref              :: proc(pending: ^PendingCall) ---
	pending_call_set_notify         :: proc(pending: ^PendingCall, function: PendingCallNotifyFunction, user_data: rawptr, free_user_data: FreeFunction) -> dbus_bool_t ---
	pending_call_cancel             :: proc(pending: ^PendingCall) ---
	pending_call_get_completed      :: proc(pending: ^PendingCall) -> dbus_bool_t ---
	pending_call_steal_reply        :: proc(pending: ^PendingCall) -> ^Message ---
	pending_call_block              :: proc(pending: ^PendingCall) ---
	pending_call_allocate_data_slot :: proc(slot_p: ^dbus_int32_t) -> dbus_bool_t ---
	pending_call_free_data_slot     :: proc(slot_p: ^dbus_int32_t) ---
	pending_call_set_data           :: proc(pending: ^PendingCall, slot: dbus_int32_t, data: rawptr, free_data_func: FreeFunction) -> dbus_bool_t ---
	pending_call_get_data           :: proc(pending: ^PendingCall, slot: dbus_int32_t) -> rawptr ---
}

