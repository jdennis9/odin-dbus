/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-threads.h  D-Bus threads handling
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

Mutex   :: struct {}
CondVar :: struct {}

/** Deprecated, provide DBusRecursiveMutexNewFunction instead. */
MutexNewFunction :: proc "c" () -> ^Mutex

/** Deprecated, provide DBusRecursiveMutexFreeFunction instead. */
MutexFreeFunction :: proc "c" (mutex: ^Mutex)

/** Deprecated, provide DBusRecursiveMutexLockFunction instead. Return value is lock success, but gets ignored in practice. */
MutexLockFunction :: proc "c" (mutex: ^Mutex) -> dbus_bool_t

/** Deprecated, provide DBusRecursiveMutexUnlockFunction instead. Return value is unlock success, but gets ignored in practice. */
MutexUnlockFunction :: proc "c" (mutex: ^Mutex) -> dbus_bool_t

/** Creates a new recursively-lockable mutex, or returns #NULL if not
* enough memory.  Can only fail due to lack of memory.  Found in
* #DBusThreadFunctions. Do not just use PTHREAD_MUTEX_RECURSIVE for
* this, because it does not save/restore the recursion count when
* waiting on a condition. libdbus requires the Java-style behavior
* where the mutex is fully unlocked to wait on a condition.
*/
RecursiveMutexNewFunction :: proc "c" () -> ^Mutex

/** Frees a recursively-lockable mutex.  Found in #DBusThreadFunctions.
*/
RecursiveMutexFreeFunction :: proc "c" (mutex: ^Mutex)

/** Locks a recursively-lockable mutex.  Found in #DBusThreadFunctions.
* Can only fail due to lack of memory.
*/
RecursiveMutexLockFunction :: proc "c" (mutex: ^Mutex)

/** Unlocks a recursively-lockable mutex.  Found in #DBusThreadFunctions.
* Can only fail due to lack of memory.
*/
RecursiveMutexUnlockFunction :: proc "c" (mutex: ^Mutex)

/** Creates a new condition variable.  Found in #DBusThreadFunctions.
* Can only fail (returning #NULL) due to lack of memory.
*/
CondVarNewFunction :: proc "c" () -> ^CondVar

/** Frees a condition variable.  Found in #DBusThreadFunctions.
*/
CondVarFreeFunction :: proc "c" (cond: ^CondVar)

/** Waits on a condition variable.  Found in
* #DBusThreadFunctions. Must work with either a recursive or
* nonrecursive mutex, whichever the thread implementation
* provides. Note that PTHREAD_MUTEX_RECURSIVE does not work with
* condition variables (does not save/restore the recursion count) so
* don't try using simply pthread_cond_wait() and a
* PTHREAD_MUTEX_RECURSIVE to implement this, it won't work right.
*
* Has no error conditions. Must succeed if it returns.
*/
CondVarWaitFunction :: proc "c" (cond: ^CondVar, mutex: ^Mutex)

/** Waits on a condition variable with a timeout.  Found in
*  #DBusThreadFunctions. Returns #TRUE if the wait did not
*  time out, and #FALSE if it did.
*
* Has no error conditions. Must succeed if it returns.
*/
CondVarWaitTimeoutFunction :: proc "c" (cond: ^CondVar, mutex: ^Mutex, timeout_milliseconds: i32) -> dbus_bool_t

/** Wakes one waiting thread on a condition variable.  Found in #DBusThreadFunctions.
*
* Has no error conditions. Must succeed if it returns.
*/
CondVarWakeOneFunction :: proc "c" (cond: ^CondVar)

/** Wakes all waiting threads on a condition variable.  Found in #DBusThreadFunctions.
*
* Has no error conditions. Must succeed if it returns.
*/
CondVarWakeAllFunction :: proc "c" (cond: ^CondVar)

/**
* Flags indicating which functions are present in #DBusThreadFunctions. Used to allow
* the library to detect older callers of dbus_threads_init() if new possible functions
* are added to #DBusThreadFunctions.
*/
ThreadFunctionsMask :: enum u32 {
	MUTEX_NEW_MASK              = 1,
	MUTEX_FREE_MASK             = 2,
	MUTEX_LOCK_MASK             = 4,
	MUTEX_UNLOCK_MASK           = 8,
	CONDVAR_NEW_MASK            = 16,
	CONDVAR_FREE_MASK           = 32,
	CONDVAR_WAIT_MASK           = 64,
	CONDVAR_WAIT_TIMEOUT_MASK   = 128,
	CONDVAR_WAKE_ONE_MASK       = 256,
	CONDVAR_WAKE_ALL_MASK       = 512,
	RECURSIVE_MUTEX_NEW_MASK    = 1024,
	RECURSIVE_MUTEX_FREE_MASK   = 2048,
	RECURSIVE_MUTEX_LOCK_MASK   = 4096,
	RECURSIVE_MUTEX_UNLOCK_MASK = 8192,
	ALL_MASK                    = 16383,
}

/**
* Functions that must be implemented to make the D-Bus library
* thread-aware.
*
* If you supply both recursive and non-recursive mutexes,
* libdbus will use the non-recursive version for condition variables,
* and the recursive version in other contexts.
*
* The condition variable functions have to work with nonrecursive
* mutexes if you provide those, or with recursive mutexes if you
* don't.
*/
ThreadFunctions :: struct {
	mask:                   u32,                          /**< Mask indicating which functions are present. */
	mutex_new:              MutexNewFunction,             /**< Function to create a mutex; optional and deprecated. */
	mutex_free:             MutexFreeFunction,            /**< Function to free a mutex; optional and deprecated. */
	mutex_lock:             MutexLockFunction,            /**< Function to lock a mutex; optional and deprecated. */
	mutex_unlock:           MutexUnlockFunction,          /**< Function to unlock a mutex; optional and deprecated. */
	condvar_new:            CondVarNewFunction,           /**< Function to create a condition variable */
	condvar_free:           CondVarFreeFunction,          /**< Function to free a condition variable */
	condvar_wait:           CondVarWaitFunction,          /**< Function to wait on a condition */
	condvar_wait_timeout:   CondVarWaitTimeoutFunction,   /**< Function to wait on a condition with a timeout */
	condvar_wake_one:       CondVarWakeOneFunction,       /**< Function to wake one thread waiting on the condition */
	condvar_wake_all:       CondVarWakeAllFunction,       /**< Function to wake all threads waiting on the condition */
	recursive_mutex_new:    RecursiveMutexNewFunction,    /**< Function to create a recursive mutex */
	recursive_mutex_free:   RecursiveMutexFreeFunction,   /**< Function to free a recursive mutex */
	recursive_mutex_lock:   RecursiveMutexLockFunction,   /**< Function to lock a recursive mutex */
	recursive_mutex_unlock: RecursiveMutexUnlockFunction, /**< Function to unlock a recursive mutex */
	padding1:               proc "c" (),                  /**< Reserved for future expansion */
	padding2:               proc "c" (),                  /**< Reserved for future expansion */
	padding3:               proc "c" (),                  /**< Reserved for future expansion */
	padding4:               proc "c" (),                  /**< Reserved for future expansion */
}

@(default_calling_convention="c", link_prefix="dbus_")
foreign lib {
	threads_init         :: proc(functions: ^ThreadFunctions) -> dbus_bool_t ---
	threads_init_default :: proc() -> dbus_bool_t ---
}

