/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-connection.h DBusConnection object
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

import "core:c"

foreign import lib "system:dbus-1"
_ :: lib

Watch            :: struct {}
Timeout          :: struct {}
PreallocatedSend :: struct {}
PendingCall      :: struct {}
Connection       :: struct {}

/**
* Indicates the status of a #DBusWatch.
*/
WatchFlags :: enum u32 {
	READABLE = 1, /**< As in POLLIN */
	WRITABLE = 2, /**< As in POLLOUT */
	ERROR    = 4, /**< As in POLLERR (can't watch for
                                 *   this, but can be present in
                                 *   current state passed to
                                 *   dbus_watch_handle()).
                                 */
	HANGUP   = 8, /**< As in POLLHUP (can't watch for
                                 *   it, but can be present in current
                                 *   state passed to
                                 *   dbus_watch_handle()).
                                 */
}

/**
* Indicates the status of incoming data on a #DBusConnection. This determines whether
* dbus_connection_dispatch() needs to be called.
*/
DispatchStatus :: enum u32 {
	DATA_REMAINS = 0, /**< There is more data to potentially convert to messages. */
	COMPLETE     = 1, /**< All currently available data has been processed. */
	NEED_MEMORY  = 2, /**< More memory is needed to continue. */
}

/** Called when libdbus needs a new watch to be monitored by the main
* loop. Returns #FALSE if it lacks enough memory to add the
* watch. Set by dbus_connection_set_watch_functions() or
* dbus_server_set_watch_functions().
*/
AddWatchFunction :: proc "c" (watch: ^Watch, data: rawptr) -> dbus_bool_t

/** Called when dbus_watch_get_enabled() may return a different value
*  than it did before.  Set by dbus_connection_set_watch_functions()
*  or dbus_server_set_watch_functions().
*/
WatchToggledFunction :: proc "c" (watch: ^Watch, data: rawptr)

/** Called when libdbus no longer needs a watch to be monitored by the
* main loop. Set by dbus_connection_set_watch_functions() or
* dbus_server_set_watch_functions().
*/
RemoveWatchFunction :: proc "c" (watch: ^Watch, data: rawptr)

/** Called when libdbus needs a new timeout to be monitored by the main
* loop. Returns #FALSE if it lacks enough memory to add the
* watch. Set by dbus_connection_set_timeout_functions() or
* dbus_server_set_timeout_functions().
*/
AddTimeoutFunction :: proc "c" (timeout: ^Timeout, data: rawptr) -> dbus_bool_t

/** Called when dbus_timeout_get_enabled() may return a different
* value than it did before.
* Set by dbus_connection_set_timeout_functions() or
* dbus_server_set_timeout_functions().
*/
TimeoutToggledFunction :: proc "c" (timeout: ^Timeout, data: rawptr)

/** Called when libdbus no longer needs a timeout to be monitored by the
* main loop. Set by dbus_connection_set_timeout_functions() or
* dbus_server_set_timeout_functions().
*/
RemoveTimeoutFunction :: proc "c" (timeout: ^Timeout, data: rawptr)

/** Called when the return value of dbus_connection_get_dispatch_status()
* may have changed. Set with dbus_connection_set_dispatch_status_function().
*/
DispatchStatusFunction :: proc "c" (connection: ^Connection, new_status: DispatchStatus, data: rawptr)

/**
* Called when the main loop's thread should be notified that there's now work
* to do. Set with dbus_connection_set_wakeup_main_function().
*/
WakeupMainFunction :: proc "c" (data: rawptr)

/**
* Called during authentication to check whether the given UNIX user
* ID is allowed to connect, if the client tried to auth as a UNIX
* user ID. Normally on Windows this would never happen. Set with
* dbus_connection_set_unix_user_function().
*/
AllowUnixUserFunction :: proc "c" (connection: ^Connection, uid: c.ulong, data: rawptr) -> dbus_bool_t

/**
* Called during authentication to check whether the given Windows user
* ID is allowed to connect, if the client tried to auth as a Windows
* user ID. Normally on UNIX this would never happen. Set with
* dbus_connection_set_windows_user_function().
*/
AllowWindowsUserFunction :: proc "c" (connection: ^Connection, user_sid: cstring, data: rawptr) -> dbus_bool_t

/**
* Called when a pending call now has a reply available. Set with
* dbus_pending_call_set_notify().
*/
PendingCallNotifyFunction :: proc "c" (pending: ^PendingCall, user_data: rawptr)

/**
* Called when a message needs to be handled. The result indicates whether or
* not more handlers should be run. Set with dbus_connection_add_filter().
*/
HandleMessageFunction :: proc "c" (connection: ^Connection, message: ^Message, user_data: rawptr) -> HandlerResult

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	connection_open                         :: proc(address: cstring, error: ^Error) -> ^Connection ---
	connection_open_private                 :: proc(address: cstring, error: ^Error) -> ^Connection ---
	connection_ref                          :: proc(connection: ^Connection) -> ^Connection ---
	connection_unref                        :: proc(connection: ^Connection) ---
	connection_close                        :: proc(connection: ^Connection) ---
	connection_get_is_connected             :: proc(connection: ^Connection) -> dbus_bool_t ---
	connection_get_is_authenticated         :: proc(connection: ^Connection) -> dbus_bool_t ---
	connection_get_is_anonymous             :: proc(connection: ^Connection) -> dbus_bool_t ---
	connection_get_server_id                :: proc(connection: ^Connection) -> cstring ---
	connection_can_send_type                :: proc(connection: ^Connection, type: i32) -> dbus_bool_t ---
	connection_set_exit_on_disconnect       :: proc(connection: ^Connection, exit_on_disconnect: dbus_bool_t) ---
	connection_flush                        :: proc(connection: ^Connection) ---
	connection_read_write_dispatch          :: proc(connection: ^Connection, timeout_milliseconds: i32) -> dbus_bool_t ---
	connection_read_write                   :: proc(connection: ^Connection, timeout_milliseconds: i32) -> dbus_bool_t ---
	connection_borrow_message               :: proc(connection: ^Connection) -> ^Message ---
	connection_return_message               :: proc(connection: ^Connection, message: ^Message) ---
	connection_steal_borrowed_message       :: proc(connection: ^Connection, message: ^Message) ---
	connection_pop_message                  :: proc(connection: ^Connection) -> ^Message ---
	connection_get_dispatch_status          :: proc(connection: ^Connection) -> DispatchStatus ---
	connection_dispatch                     :: proc(connection: ^Connection) -> DispatchStatus ---
	connection_has_messages_to_send         :: proc(connection: ^Connection) -> dbus_bool_t ---
	connection_send                         :: proc(connection: ^Connection, message: ^Message, client_serial: ^dbus_uint32_t) -> dbus_bool_t ---
	connection_send_with_reply              :: proc(connection: ^Connection, message: ^Message, pending_return: ^^PendingCall, timeout_milliseconds: i32) -> dbus_bool_t ---
	connection_send_with_reply_and_block    :: proc(connection: ^Connection, message: ^Message, timeout_milliseconds: i32, error: ^Error) -> ^Message ---
	connection_set_watch_functions          :: proc(connection: ^Connection, add_function: AddWatchFunction, remove_function: RemoveWatchFunction, toggled_function: WatchToggledFunction, data: rawptr, free_data_function: FreeFunction) -> dbus_bool_t ---
	connection_set_timeout_functions        :: proc(connection: ^Connection, add_function: AddTimeoutFunction, remove_function: RemoveTimeoutFunction, toggled_function: TimeoutToggledFunction, data: rawptr, free_data_function: FreeFunction) -> dbus_bool_t ---
	connection_set_wakeup_main_function     :: proc(connection: ^Connection, wakeup_main_function: WakeupMainFunction, data: rawptr, free_data_function: FreeFunction) ---
	connection_set_dispatch_status_function :: proc(connection: ^Connection, function: DispatchStatusFunction, data: rawptr, free_data_function: FreeFunction) ---
	connection_get_unix_user                :: proc(connection: ^Connection, uid: ^c.ulong) -> dbus_bool_t ---
	connection_get_unix_process_id          :: proc(connection: ^Connection, pid: ^c.ulong) -> dbus_bool_t ---
	connection_get_adt_audit_session_data   :: proc(connection: ^Connection, data: ^rawptr, data_size: ^dbus_int32_t) -> dbus_bool_t ---
	connection_set_unix_user_function       :: proc(connection: ^Connection, function: AllowUnixUserFunction, data: rawptr, free_data_function: FreeFunction) ---
	connection_get_windows_user             :: proc(connection: ^Connection, windows_sid_p: ^cstring) -> dbus_bool_t ---
	connection_set_windows_user_function    :: proc(connection: ^Connection, function: AllowWindowsUserFunction, data: rawptr, free_data_function: FreeFunction) ---
	connection_set_allow_anonymous          :: proc(connection: ^Connection, value: dbus_bool_t) ---
	connection_set_builtin_filters_enabled  :: proc(connection: ^Connection, value: dbus_bool_t) ---
	connection_set_route_peer_messages      :: proc(connection: ^Connection, value: dbus_bool_t) ---

	/* Filters */
	connection_add_filter    :: proc(connection: ^Connection, function: HandleMessageFunction, user_data: rawptr, free_data_function: FreeFunction) -> dbus_bool_t ---
	connection_remove_filter :: proc(connection: ^Connection, function: HandleMessageFunction, user_data: rawptr) ---

	/* Other */
	connection_allocate_data_slot        :: proc(slot_p: ^dbus_int32_t) -> dbus_bool_t ---
	connection_free_data_slot            :: proc(slot_p: ^dbus_int32_t) ---
	connection_set_data                  :: proc(connection: ^Connection, slot: dbus_int32_t, data: rawptr, free_data_func: FreeFunction) -> dbus_bool_t ---
	connection_get_data                  :: proc(connection: ^Connection, slot: dbus_int32_t) -> rawptr ---
	connection_set_change_sigpipe        :: proc(will_modify_sigpipe: dbus_bool_t) ---
	connection_set_max_message_size      :: proc(connection: ^Connection, size: c.long) ---
	connection_get_max_message_size      :: proc(connection: ^Connection) -> c.long ---
	connection_set_max_received_size     :: proc(connection: ^Connection, size: c.long) ---
	connection_get_max_received_size     :: proc(connection: ^Connection) -> c.long ---
	connection_set_max_message_unix_fds  :: proc(connection: ^Connection, n: c.long) ---
	connection_get_max_message_unix_fds  :: proc(connection: ^Connection) -> c.long ---
	connection_set_max_received_unix_fds :: proc(connection: ^Connection, n: c.long) ---
	connection_get_max_received_unix_fds :: proc(connection: ^Connection) -> c.long ---
	connection_get_outgoing_size         :: proc(connection: ^Connection) -> c.long ---
	connection_get_outgoing_unix_fds     :: proc(connection: ^Connection) -> c.long ---
	connection_preallocate_send          :: proc(connection: ^Connection) -> ^PreallocatedSend ---
	connection_free_preallocated_send    :: proc(connection: ^Connection, preallocated: ^PreallocatedSend) ---
	connection_send_preallocated         :: proc(connection: ^Connection, preallocated: ^PreallocatedSend, message: ^Message, client_serial: ^dbus_uint32_t) ---
}

/**
* Called when a #DBusObjectPathVTable is unregistered (or its connection is freed).
* Found in #DBusObjectPathVTable.
*/
ObjectPathUnregisterFunction :: proc "c" (connection: ^Connection, user_data: rawptr)

/**
* Called when a message is sent to a registered object path. Found in
* #DBusObjectPathVTable which is registered with dbus_connection_register_object_path()
* or dbus_connection_register_fallback().
*/
ObjectPathMessageFunction :: proc "c" (connection: ^Connection, message: ^Message, user_data: rawptr) -> HandlerResult

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	connection_try_register_object_path :: proc(connection: ^Connection, path: cstring, vtable: ^ObjectPathVTable, user_data: rawptr, error: ^Error) -> dbus_bool_t ---
	connection_register_object_path     :: proc(connection: ^Connection, path: cstring, vtable: ^ObjectPathVTable, user_data: rawptr) -> dbus_bool_t ---
	connection_try_register_fallback    :: proc(connection: ^Connection, path: cstring, vtable: ^ObjectPathVTable, user_data: rawptr, error: ^Error) -> dbus_bool_t ---
	connection_register_fallback        :: proc(connection: ^Connection, path: cstring, vtable: ^ObjectPathVTable, user_data: rawptr) -> dbus_bool_t ---
	connection_unregister_object_path   :: proc(connection: ^Connection, path: cstring) -> dbus_bool_t ---
	connection_get_object_path_data     :: proc(connection: ^Connection, path: cstring, data_p: ^rawptr) -> dbus_bool_t ---
	connection_list_registered          :: proc(connection: ^Connection, parent_path: cstring, child_entries: ^^cstring) -> dbus_bool_t ---
	connection_get_unix_fd              :: proc(connection: ^Connection, fd: ^i32) -> dbus_bool_t ---
	connection_get_socket               :: proc(connection: ^Connection, fd: ^i32) -> dbus_bool_t ---
	watch_get_fd                        :: proc(watch: ^Watch) -> i32 ---
	watch_get_unix_fd                   :: proc(watch: ^Watch) -> i32 ---
	watch_get_socket                    :: proc(watch: ^Watch) -> i32 ---
	watch_get_flags                     :: proc(watch: ^Watch) -> u32 ---
	watch_get_data                      :: proc(watch: ^Watch) -> rawptr ---
	watch_set_data                      :: proc(watch: ^Watch, data: rawptr, free_data_function: FreeFunction) ---
	watch_handle                        :: proc(watch: ^Watch, flags: u32) -> dbus_bool_t ---
	watch_get_enabled                   :: proc(watch: ^Watch) -> dbus_bool_t ---

	/**
	* @addtogroup DBusTimeout
	* @{
	*/
	timeout_get_interval :: proc(timeout: ^Timeout) -> i32 ---
	timeout_get_data     :: proc(timeout: ^Timeout) -> rawptr ---
	timeout_set_data     :: proc(timeout: ^Timeout, data: rawptr, free_data_function: FreeFunction) ---
	timeout_handle       :: proc(timeout: ^Timeout) -> dbus_bool_t ---
	timeout_get_enabled  :: proc(timeout: ^Timeout) -> dbus_bool_t ---
}

