/* -*- mode: C; c-file-style: "gnu" -*- */
/* dbus-glib-lowlevel.h GLib integration details that require dbus/dbus.h
 *
 * Copyright (C) 2002, 2003  CodeFactory AB
 * Copyright (C) 2003, 2004 Red Hat, Inc.
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
	set_g_error                  :: proc(gerror: ^^i32, derror: ^Error) -> i32 ---
	connection_setup_with_g_main :: proc(connection: ^Connection, _context: ^i32) ---
	server_setup_with_g_main     :: proc(server: ^Server, _context: ^i32) ---
	g_proxy_send                 :: proc(proxy: ^GProxy, message: ^Message, client_serial: ^dbus_uint32_t) ---
	g_connection_get_connection  :: proc(gconnection: ^GConnection) -> ^Connection ---
	connection_get_g_connection  :: proc(connection: ^Connection) -> ^GConnection ---
	g_message_get_message        :: proc(gmessage: ^GMessage) -> ^Message ---
	g_method_get_sender          :: proc(_context: ^GMethodInvocation) -> ^gchar ---
	g_method_get_reply           :: proc(_context: ^GMethodInvocation) -> ^Message ---
	g_method_send_reply          :: proc(_context: ^GMethodInvocation, reply: ^Message) ---
}

