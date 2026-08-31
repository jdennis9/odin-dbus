/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*- */
/* dbus-protocol.h  D-Bus protocol constants
 *
 * Copyright (C) 2002, 2003  CodeFactory AB
 * Copyright (C) 2004, 2005 Red Hat, Inc.
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

/** Protocol version. */
MAJOR_PROTOCOL_VERSION :: 1

/** #DBUS_TYPE_BYTE as a string literal instead of a int literal */
TYPE_BYTE_AS_STRING           :: "y"

/** #DBUS_TYPE_BOOLEAN as a string literal instead of a int literal */
TYPE_BOOLEAN_AS_STRING        :: "b"

/** #DBUS_TYPE_INT16 as a string literal instead of a int literal */
TYPE_INT16_AS_STRING          :: "n"

/** #DBUS_TYPE_UINT16 as a string literal instead of a int literal */
TYPE_UINT16_AS_STRING         :: "q"

/** #DBUS_TYPE_INT32 as a string literal instead of a int literal */
TYPE_INT32_AS_STRING          :: "i"

/** #DBUS_TYPE_UINT32 as a string literal instead of a int literal */
TYPE_UINT32_AS_STRING         :: "u"

/** #DBUS_TYPE_INT64 as a string literal instead of a int literal */
TYPE_INT64_AS_STRING          :: "x"

/** #DBUS_TYPE_UINT64 as a string literal instead of a int literal */
TYPE_UINT64_AS_STRING         :: "t"

/** #DBUS_TYPE_DOUBLE as a string literal instead of a int literal */
TYPE_DOUBLE_AS_STRING         :: "d"

/** #DBUS_TYPE_STRING as a string literal instead of a int literal */
TYPE_STRING_AS_STRING         :: "s"

/** #DBUS_TYPE_OBJECT_PATH as a string literal instead of a int literal */
TYPE_OBJECT_PATH_AS_STRING    :: "o"

/** #DBUS_TYPE_SIGNATURE as a string literal instead of a int literal */
TYPE_SIGNATURE_AS_STRING      :: "g"

/** #DBUS_TYPE_UNIX_FD as a string literal instead of a int literal */
TYPE_UNIX_FD_AS_STRING        :: "h"

/** #DBUS_TYPE_ARRAY as a string literal instead of a int literal */
TYPE_ARRAY_AS_STRING          :: "a"

/** #DBUS_TYPE_VARIANT as a string literal instead of a int literal */
TYPE_VARIANT_AS_STRING        :: "v"

/** #DBUS_TYPE_STRUCT as a string literal instead of a int literal */
TYPE_STRUCT_AS_STRING         :: "r"

/** #DBUS_TYPE_DICT_ENTRY as a string literal instead of a int literal */
TYPE_DICT_ENTRY_AS_STRING     :: "e"

/** Does not include #DBUS_TYPE_INVALID, #DBUS_STRUCT_BEGIN_CHAR, #DBUS_STRUCT_END_CHAR,
* #DBUS_DICT_ENTRY_BEGIN_CHAR, or #DBUS_DICT_ENTRY_END_CHAR - i.e. it is the number of
* valid types, not the number of distinct characters that may appear in a type signature.
*/
NUMBER_OF_TYPES    :: (16)

/** #DBUS_STRUCT_BEGIN_CHAR as a string literal instead of a int literal */
STRUCT_BEGIN_CHAR_AS_STRING   :: "("

/** #DBUS_STRUCT_END_CHAR a string literal instead of a int literal */
STRUCT_END_CHAR_AS_STRING     :: ")"

/** #DBUS_DICT_ENTRY_BEGIN_CHAR as a string literal instead of a int literal */
DICT_ENTRY_BEGIN_CHAR_AS_STRING   :: "{"

/** #DBUS_DICT_ENTRY_END_CHAR as a string literal instead of a int literal */
DICT_ENTRY_END_CHAR_AS_STRING     :: "}"

/** Max length in bytes of a bus name, interface, or member (not object
* path, paths are unlimited). This is limited because lots of stuff
* is O(n) in this number, plus it would be obnoxious to type in a
* paragraph-long method name so most likely something like that would
* be an exploit.
*/
MAXIMUM_NAME_LENGTH :: 255

/** This one is 255 so it fits in a byte */
MAXIMUM_SIGNATURE_LENGTH :: 255

/** Max length of a match rule string; to keep people from hosing the
* daemon with some huge rule
*/
MAXIMUM_MATCH_RULE_LENGTH :: 1024

/** Max arg number you can match on in a match rule, e.g.
* arg0='hello' is OK, arg3489720987='hello' is not
*/
MAXIMUM_MATCH_RULE_ARG_NUMBER :: 63

/** Max length of a marshaled array in bytes (64M, 2^26) We use signed
* int for lengths so must be INT_MAX or less.  We need something a
* bit smaller than INT_MAX because the array is inside a message with
* header info, etc.  so an INT_MAX array wouldn't allow the message
* overhead.  The 64M number is an attempt at a larger number than
* we'd reasonably ever use, but small enough that your bus would chew
* through it fairly quickly without locking up forever. If you have
* data that's likely to be larger than this, you should probably be
* sending it in multiple incremental messages anyhow.
*/
MAXIMUM_ARRAY_LENGTH :: (67108864)

/** Number of bits you need in an unsigned to store the max array size */
MAXIMUM_ARRAY_LENGTH_BITS :: 26

/** The maximum total message size including header and body; similar
* rationale to max array size.
*/
MAXIMUM_MESSAGE_LENGTH :: (MAXIMUM_ARRAY_LENGTH*2)

/** Number of bits you need in an unsigned to store the max message size */
MAXIMUM_MESSAGE_LENGTH_BITS :: 27

/** The maximum total number of unix fds in a message. Similar
* rationale as DBUS_MAXIMUM_MESSAGE_LENGTH. However we divide by four
* given that one fd is an int and hence at least 32 bits.
*/
MAXIMUM_MESSAGE_UNIX_FDS :: (MAXIMUM_MESSAGE_LENGTH/4)

/** Number of bits you need in an unsigned to store the max message unix fds */
MAXIMUM_MESSAGE_UNIX_FDS_BITS :: (MAXIMUM_MESSAGE_LENGTH_BITS-2)

/** Depth of recursion in the type tree. This is automatically limited
* to DBUS_MAXIMUM_SIGNATURE_LENGTH since you could only have an array
* of array of array of ... that fit in the max signature.  But that's
* probably a bit too large.
*/
MAXIMUM_TYPE_RECURSION_DEPTH :: 32

/* Types of message */

/** This value is never a valid message type, see dbus_message_get_type() */
MESSAGE_TYPE_INVALID       :: 0

/** Message type of a method call message, see dbus_message_get_type() */
MESSAGE_TYPE_METHOD_CALL   :: 1

/** Message type of a method return message, see dbus_message_get_type() */
MESSAGE_TYPE_METHOD_RETURN :: 2

/** Message type of an error reply message, see dbus_message_get_type() */
MESSAGE_TYPE_ERROR         :: 3

/** Message type of a signal message, see dbus_message_get_type() */
MESSAGE_TYPE_SIGNAL        :: 4
NUM_MESSAGE_TYPES          :: 5

/* Header flags */

/** If set, this flag means that the sender of a message does not care about getting
* a reply, so the recipient need not send one. See dbus_message_set_no_reply().
*/
HEADER_FLAG_NO_REPLY_EXPECTED :: 0x1

/**
* If set, this flag means that even if the message bus knows how to start an owner for
* the destination bus name (see dbus_message_set_destination()), it should not
* do so. If this flag is not set, the bus may launch a program to process the
* message.
*/
HEADER_FLAG_NO_AUTO_START     :: 0x2

/**
* If set on a method call, this flag means that the caller is prepared to
* wait for interactive authorization.
*/
HEADER_FLAG_ALLOW_INTERACTIVE_AUTHORIZATION :: 0x4

/* Header fields */

/** Not equal to any valid header field code */
HEADER_FIELD_INVALID        :: 0

/** Header field code for the path - the path is the object emitting a signal or the object receiving a method call.
* See dbus_message_set_path().
*/
HEADER_FIELD_PATH           :: 1

/** Header field code for the interface containing a member (method or signal).
* See dbus_message_set_interface().
*/
HEADER_FIELD_INTERFACE      :: 2

/** Header field code for a member (method or signal). See dbus_message_set_member(). */
HEADER_FIELD_MEMBER         :: 3

/** Header field code for an error name (found in #DBUS_MESSAGE_TYPE_ERROR messages).
* See dbus_message_set_error_name().
*/
HEADER_FIELD_ERROR_NAME     :: 4

/** Header field code for a reply serial, used to match a #DBUS_MESSAGE_TYPE_METHOD_RETURN message with the
* message that it's a reply to. See dbus_message_set_reply_serial().
*/
HEADER_FIELD_REPLY_SERIAL   :: 5

/**
* Header field code for the destination bus name of a message. See dbus_message_set_destination().
*/
HEADER_FIELD_DESTINATION    :: 6

/**
* Header field code for the sender of a message; usually initialized by the message bus.
* See dbus_message_set_sender().
*/
HEADER_FIELD_SENDER         :: 7

/**
* Header field code for the type signature of a message.
*/
HEADER_FIELD_SIGNATURE      :: 8

/**
* Header field code for the number of unix file descriptors associated
* with this message.
*/
HEADER_FIELD_UNIX_FDS       :: 9

/**
* Header field code for the container instance that sent this message.
*/
HEADER_FIELD_CONTAINER_INSTANCE :: 10

/**
* Value of the highest-numbered header field code, can be used to determine
* the size of an array indexed by header field code. Remember though
* that unknown codes must be ignored, so check for that before
* indexing the array.
*/
HEADER_FIELD_LAST :: HEADER_FIELD_CONTAINER_INSTANCE

/**
* The smallest header size that can occur.  (It won't be valid due to
* missing required header fields.) This is 4 bytes, two uint32, an
* array length. This isn't any kind of resource limit, just the
* necessary/logical outcome of the header signature.
*/
MINIMUM_HEADER_SIZE :: 16

/* Errors */
/* WARNING these get autoconverted to an enum in dbus-glib.h. Thus,
* if you change the order it breaks the ABI. Keep them in order.
* Also, don't change the formatting since that will break the sed
* script.
*/
/** A generic error; "something went wrong" - see the error message for more. */
ERROR_FAILED                     :: "org.freedesktop.DBus.Error.Failed"

/** There was not enough memory to complete an operation. */
ERROR_NO_MEMORY                  :: "org.freedesktop.DBus.Error.NoMemory"

/** The bus doesn't know how to launch a service to supply the bus name you wanted. */
ERROR_SERVICE_UNKNOWN            :: "org.freedesktop.DBus.Error.ServiceUnknown"

/** The bus name you referenced doesn't exist (i.e. no application owns it). */
ERROR_NAME_HAS_NO_OWNER          :: "org.freedesktop.DBus.Error.NameHasNoOwner"

/** No reply to a message expecting one, usually means a timeout occurred. */
ERROR_NO_REPLY                   :: "org.freedesktop.DBus.Error.NoReply"

/** Something went wrong reading or writing to a socket, for example. */
ERROR_IO_ERROR                   :: "org.freedesktop.DBus.Error.IOError"

/** A D-Bus bus address was malformed. */
ERROR_BAD_ADDRESS                :: "org.freedesktop.DBus.Error.BadAddress"

/** Requested operation isn't supported (like ENOSYS on UNIX). */
ERROR_NOT_SUPPORTED              :: "org.freedesktop.DBus.Error.NotSupported"

/** Some limited resource is exhausted. */
ERROR_LIMITS_EXCEEDED            :: "org.freedesktop.DBus.Error.LimitsExceeded"

/** Security restrictions don't allow doing what you're trying to do. */
ERROR_ACCESS_DENIED              :: "org.freedesktop.DBus.Error.AccessDenied"

/** Authentication didn't work. */
ERROR_AUTH_FAILED                :: "org.freedesktop.DBus.Error.AuthFailed"

/** Unable to connect to server (probably caused by ECONNREFUSED on a socket). */
ERROR_NO_SERVER                  :: "org.freedesktop.DBus.Error.NoServer"

/** Certain timeout errors, possibly ETIMEDOUT on a socket.
* Note that #DBUS_ERROR_NO_REPLY is used for message reply timeouts.
* @warning this is confusingly-named given that #DBUS_ERROR_TIMED_OUT also exists. We can't fix
* it for compatibility reasons so just be careful.
*/
ERROR_TIMEOUT                    :: "org.freedesktop.DBus.Error.Timeout"

/** No network access (probably ENETUNREACH on a socket). */
ERROR_NO_NETWORK                 :: "org.freedesktop.DBus.Error.NoNetwork"

/** Can't bind a socket since its address is in use (i.e. EADDRINUSE). */
ERROR_ADDRESS_IN_USE             :: "org.freedesktop.DBus.Error.AddressInUse"

/** The connection is disconnected and you're trying to use it. */
ERROR_DISCONNECTED               :: "org.freedesktop.DBus.Error.Disconnected"

/** Invalid arguments passed to a method call. */
ERROR_INVALID_ARGS               :: "org.freedesktop.DBus.Error.InvalidArgs"

/** Missing file. */
ERROR_FILE_NOT_FOUND             :: "org.freedesktop.DBus.Error.FileNotFound"

/** Existing file and the operation you're using does not silently overwrite. */
ERROR_FILE_EXISTS                :: "org.freedesktop.DBus.Error.FileExists"

/** Method name you invoked isn't known by the object you invoked it on. */
ERROR_UNKNOWN_METHOD             :: "org.freedesktop.DBus.Error.UnknownMethod"

/** Object you invoked a method on isn't known. */
ERROR_UNKNOWN_OBJECT             :: "org.freedesktop.DBus.Error.UnknownObject"

/** Interface you invoked a method on isn't known by the object. */
ERROR_UNKNOWN_INTERFACE          :: "org.freedesktop.DBus.Error.UnknownInterface"

/** Property you tried to access isn't known by the object. */
ERROR_UNKNOWN_PROPERTY           :: "org.freedesktop.DBus.Error.UnknownProperty"

/** Property you tried to set is read-only. */
ERROR_PROPERTY_READ_ONLY         :: "org.freedesktop.DBus.Error.PropertyReadOnly"

/** Certain timeout errors, e.g. while starting a service.
* @warning this is confusingly-named given that #DBUS_ERROR_TIMEOUT also exists. We can't fix
* it for compatibility reasons so just be careful.
*/
ERROR_TIMED_OUT                  :: "org.freedesktop.DBus.Error.TimedOut"

/** Tried to remove or modify a match rule that didn't exist. */
ERROR_MATCH_RULE_NOT_FOUND       :: "org.freedesktop.DBus.Error.MatchRuleNotFound"

/** The match rule isn't syntactically valid. */
ERROR_MATCH_RULE_INVALID         :: "org.freedesktop.DBus.Error.MatchRuleInvalid"

/** While starting a new process, the exec() call failed. */
ERROR_SPAWN_EXEC_FAILED          :: "org.freedesktop.DBus.Error.Spawn.ExecFailed"

/** While starting a new process, the fork() call failed. */
ERROR_SPAWN_FORK_FAILED          :: "org.freedesktop.DBus.Error.Spawn.ForkFailed"

/** While starting a new process, the child exited with a status code. */
ERROR_SPAWN_CHILD_EXITED         :: "org.freedesktop.DBus.Error.Spawn.ChildExited"

/** While starting a new process, the child exited on a signal. */
ERROR_SPAWN_CHILD_SIGNALED       :: "org.freedesktop.DBus.Error.Spawn.ChildSignaled"

/** While starting a new process, something went wrong. */
ERROR_SPAWN_FAILED               :: "org.freedesktop.DBus.Error.Spawn.Failed"

/** We failed to setup the environment correctly. */
ERROR_SPAWN_SETUP_FAILED         :: "org.freedesktop.DBus.Error.Spawn.FailedToSetup"

/** We failed to setup the config parser correctly. */
ERROR_SPAWN_CONFIG_INVALID       :: "org.freedesktop.DBus.Error.Spawn.ConfigInvalid"

/** Bus name was not valid. */
ERROR_SPAWN_SERVICE_INVALID      :: "org.freedesktop.DBus.Error.Spawn.ServiceNotValid"

/** Service file not found in system-services directory. */
ERROR_SPAWN_SERVICE_NOT_FOUND    :: "org.freedesktop.DBus.Error.Spawn.ServiceNotFound"

/** Permissions are incorrect on the setuid helper. */
ERROR_SPAWN_PERMISSIONS_INVALID  :: "org.freedesktop.DBus.Error.Spawn.PermissionsInvalid"

/** Service file invalid (Name, User or Exec missing). */
ERROR_SPAWN_FILE_INVALID         :: "org.freedesktop.DBus.Error.Spawn.FileInvalid"

/** There was not enough memory to complete the operation. */
ERROR_SPAWN_NO_MEMORY            :: "org.freedesktop.DBus.Error.Spawn.NoMemory"

/** Tried to get a UNIX process ID and it wasn't available. */
ERROR_UNIX_PROCESS_ID_UNKNOWN    :: "org.freedesktop.DBus.Error.UnixProcessIdUnknown"

/** A type signature is not valid. */
ERROR_INVALID_SIGNATURE          :: "org.freedesktop.DBus.Error.InvalidSignature"

/** A file contains invalid syntax or is otherwise broken. */
ERROR_INVALID_FILE_CONTENT       :: "org.freedesktop.DBus.Error.InvalidFileContent"

/** Asked for SELinux security context and it wasn't available. */
ERROR_SELINUX_SECURITY_CONTEXT_UNKNOWN    :: "org.freedesktop.DBus.Error.SELinuxSecurityContextUnknown"

/** Asked for ADT audit data and it wasn't available. */
ERROR_ADT_AUDIT_DATA_UNKNOWN     :: "org.freedesktop.DBus.Error.AdtAuditDataUnknown"

/** There's already an object with the requested object path. */
ERROR_OBJECT_PATH_IN_USE         :: "org.freedesktop.DBus.Error.ObjectPathInUse"

/** The message meta data does not match the payload. e.g. expected
number of file descriptors were not sent over the socket this message was received on. */
ERROR_INCONSISTENT_MESSAGE       :: "org.freedesktop.DBus.Error.InconsistentMessage"

/** The message is not allowed without performing interactive authorization,
* but could have succeeded if an interactive authorization step was
* allowed. */
ERROR_INTERACTIVE_AUTHORIZATION_REQUIRED :: "org.freedesktop.DBus.Error.InteractiveAuthorizationRequired"

/** The connection is not from a container, or the specified container instance
* does not exist. */
ERROR_NOT_CONTAINER :: "org.freedesktop.DBus.Error.NotContainer"

/* XML introspection format */

/** XML namespace of the introspection format version 1.0 */
INTROSPECT_1_0_XML_NAMESPACE         :: "http://www.freedesktop.org/standards/dbus" //www.freedesktop.org/standards/dbus"

/** XML public identifier of the introspection format version 1.0 */
INTROSPECT_1_0_XML_PUBLIC_IDENTIFIER :: "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN" //freedesktop//DTD D-BUS Object Introspection 1.0//EN"

/** XML system identifier of the introspection format version 1.0 */
INTROSPECT_1_0_XML_SYSTEM_IDENTIFIER :: "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd" //www.freedesktop.org/standards/dbus/1.0/introspect.dtd"

