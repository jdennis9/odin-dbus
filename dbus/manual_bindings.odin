package odin_dbus

Error :: struct {
	name: cstring,
	message: cstring,
	_reserved: u64,
	_padding1: uintptr,
}

ObjectPathVTable :: struct {
	unregister_function: ObjectPathUnregisterFunction,
	message_function: ObjectPathMessageFunction,
	_reserved: [4]rawptr,
}

MessageIter :: [128]u8
