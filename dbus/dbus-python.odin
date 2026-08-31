/* C API for _dbus_bindings, used by _dbus_glib_bindings and any third-party
 * main loop integration which might happen in future.
 *
 * This file is currently Python-version-independent - please keep it that way.
 *
 * Copyright (C) 2006 Collabora Ltd. <http://www.collabora.co.uk/>
 *
 * SPDX-License-Identifier: MIT
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package odin_dbus

foreign import lib "system:dbus-1"
_ :: lib

PYDBUS_CAPSULE_NAME :: "_dbus_bindings._C_API"

_dbus_py_func_ptr        :: proc "c" ()
_dbus_py_conn_setup_func :: proc "c" (^Connection, rawptr) -> dbus_bool_t
_dbus_py_srv_setup_func  :: proc "c" (^Server, rawptr) -> dbus_bool_t
_dbus_py_free_func       :: proc "c" (rawptr)

BINDINGS_API_COUNT :: 3

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	import_dbus_bindings :: proc(this_module_name: cstring) -> i32 ---
}

