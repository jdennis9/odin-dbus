/* -*- mode: C; c-file-style: "gnu" -*- */
/* dbus-gtype-specialized.h: Non-DBus-specific functions for specialized GTypes
 *
 * Copyright (C) 2005 Red Hat, Inc.
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
	g_type_get_map                       :: proc(container: cstring, key_specialization: i32, value_specialization: i32) -> i32 ---
	g_type_get_structv                   :: proc(container: cstring, num_members: i32, types: ^i32) -> i32 ---
	g_type_get_struct                    :: proc(container: cstring, first_type: i32, #c_vararg _: ..any) -> i32 ---
	g_type_is_collection                 :: proc(gtype: i32) -> i32 ---
	g_type_is_map                        :: proc(gtype: i32) -> i32 ---
	g_type_is_struct                     :: proc(gtype: i32) -> i32 ---
	g_type_get_collection_specialization :: proc(gtype: i32) -> i32 ---
	g_type_get_map_key_specialization    :: proc(gtype: i32) -> i32 ---
	g_type_get_map_value_specialization  :: proc(gtype: i32) -> i32 ---
	g_type_get_struct_member_type        :: proc(gtype: i32, member: i32) -> i32 ---
	g_type_get_struct_size               :: proc(gtype: i32) -> i32 ---
}

GTypeSpecializedCollectionIterator :: proc "c" (value: ^i32, user_data: i32)
GTypeSpecializedMapIterator        :: proc "c" (key_val: ^i32, value_val: ^i32, user_data: i32)

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	g_type_specialized_construct :: proc(gtype: i32) -> i32 ---
}

GTypeSpecializedAppendContext :: struct {
	/* public */
	val:                 ^i32,
	specialization_type: i32,

	/*< private >*/
	/* padding */
	b:  i32,
	_c: i32,
	d:  i32,
}

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	g_type_specialized_init_append           :: proc(value: ^i32, ctx: ^GTypeSpecializedAppendContext) ---
	g_type_specialized_collection_append     :: proc(ctx: ^GTypeSpecializedAppendContext, elt: ^i32) ---
	g_type_specialized_collection_end_append :: proc(ctx: ^GTypeSpecializedAppendContext) ---
	g_type_specialized_map_append            :: proc(ctx: ^GTypeSpecializedAppendContext, key: ^i32, val: ^i32) ---
	g_type_collection_get_fixed              :: proc(value: ^i32, data_ret: ^i32, len_ret: ^i32) -> i32 ---
	g_type_collection_value_iterate          :: proc(value: ^i32, iterator: GTypeSpecializedCollectionIterator, user_data: i32) ---
	g_type_map_value_iterate                 :: proc(value: ^i32, iterator: GTypeSpecializedMapIterator, user_data: i32) ---
	g_type_struct_get_member                 :: proc(value: ^i32, member: i32, dest: ^i32) -> i32 ---
	g_type_struct_set_member                 :: proc(value: ^i32, member: i32, src: ^i32) -> i32 ---
	g_type_struct_get                        :: proc(value: ^i32, member: i32, #c_vararg _: ..any) -> i32 ---
	g_type_struct_set                        :: proc(value: ^i32, member: i32, #c_vararg _: ..any) -> i32 ---
}

gpointer                 :: proc "c" (^i32) -> i32          /* -*- mode: C; c-file-style: "gnu" -*- */
GTypeSpecializedFreeFunc :: proc "c" (type: i32, val: gpointer)
GTypeSpecializedCopyFunc :: proc "c" (i32, gpointer) -> i32 /* -*- mode: C; c-file-style: "gnu" -*- */

GTypeSpecializedVtable :: struct {
	constructor:      i32,
	free_func:        GTypeSpecializedFreeFunc,
	copy_func:        GTypeSpecializedCopyFunc,
	simple_free_func: i32, /* for type-independent freeing if possible */

	/*<private>*/
	padding2: gpointer,
	padding3: gpointer,
}

gboolean                                :: proc "c" (^i32) -> i32 /* -*- mode: C; c-file-style: "gnu" -*- */
GTypeSpecializedCollectionIteratorFunc  :: proc "c" (type: i32, instance: gpointer, iterator: GTypeSpecializedCollectionIterator, user_data: gpointer)
GTypeSpecializedCollectionAppendFunc    :: proc "c" (ctx: ^GTypeSpecializedAppendContext, val: ^i32)
GTypeSpecializedCollectionEndAppendFunc :: proc "c" (ctx: ^GTypeSpecializedAppendContext)

GTypeSpecializedCollectionVtable :: struct {
	base_vtable:     GTypeSpecializedVtable,
	fixed_accessor:  i32,
	iterator:        GTypeSpecializedCollectionIteratorFunc,
	append_func:     GTypeSpecializedCollectionAppendFunc,
	end_append_func: GTypeSpecializedCollectionEndAppendFunc,
}

GTypeSpecializedMapIteratorFunc :: proc "c" (type: i32, instance: gpointer, iterator: GTypeSpecializedMapIterator, user_data: gpointer)
GTypeSpecializedMapAppendFunc   :: proc "c" (ctx: ^GTypeSpecializedAppendContext, key: ^i32, val: ^i32)

GTypeSpecializedMapVtable :: struct {
	base_vtable: GTypeSpecializedVtable,
	iterator:    GTypeSpecializedMapIteratorFunc,
	append_func: GTypeSpecializedMapAppendFunc,
}

GTypeSpecializedStructGetMember :: proc "c" (i32, gpointer, i32, ^i32) -> i32 /* -*- mode: C; c-file-style: "gnu" -*- */
GTypeSpecializedStructSetMember :: proc "c" (i32, gpointer, i32, ^i32) -> i32 /* -*- mode: C; c-file-style: "gnu" -*- */

GTypeSpecializedStructVtable :: struct {
	base_vtable: GTypeSpecializedVtable,
	get_member:  GTypeSpecializedStructGetMember,
	set_member:  GTypeSpecializedStructSetMember,
}

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	g_type_specialized_init       :: proc() ---
	g_type_register_collection    :: proc(name: cstring, vtable: ^GTypeSpecializedCollectionVtable, flags: i32) ---
	g_type_register_map           :: proc(name: cstring, vtable: ^GTypeSpecializedMapVtable, flags: i32) ---
	g_type_register_struct        :: proc(name: cstring, vtable: ^GTypeSpecializedStructVtable, flags: i32) ---
	g_type_map_peek_vtable        :: proc(map_type: i32) -> ^GTypeSpecializedMapVtable ---
	g_type_collection_peek_vtable :: proc(collection_type: i32) -> ^GTypeSpecializedCollectionVtable ---
	g_type_struct_peek_vtable     :: proc(struct_type: i32) -> ^GTypeSpecializedStructVtable ---
	g_value_build_g_variant       :: proc(value: ^i32) -> ^i32 ---
}

