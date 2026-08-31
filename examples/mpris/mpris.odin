package example_mpris

import "core:mem"
import "core:log"
import "base:runtime"
import "core:strings"
import "core:fmt"
import "core:time"
import "../../dbus"
import h "../../helpers"

// - Names are converted to camel case for properties
// - Access defaults to 'read'
// - Native strings are supported but I would recommend using cstring as native strings need to be cloned
// every time they are requested through the property interface

Server_Properties :: struct {
	can_quit: bool,
	fullscreen: bool,
	can_set_fullscreen: bool,
	can_raise: bool,
	has_track_list: bool,
	identity: cstring,
	desktop_entry: cstring,
	supported_uri_schemes: []cstring,
	supported_mime_types: []cstring,
}

Player_Properties :: struct {
	playback_status: cstring,
	loop_status:     cstring,
	rate:            f64 `access:"readwrite"`,
	shuffle:         bool `access"readwrite"`,
	volume:          f64 `access:"readwrite"`,
	min_rate:        f64 `dbus:"MinimumRate"`,
	max_rate:        f64 `dbus:"MaximumRate"`,
	can_go_next:     bool,
	can_go_previous: bool,
	can_play:        bool,
	can_pause:       bool,
	can_seek:        bool,
	can_control:     bool,
	position:        i64,

	metadata:        map[string]h.Variant `dbus:"Metadata"`,

	// Ignored field
	my_data: int `dbus:"-"`,
}

handle_player_method :: proc(
	call: h.Method_Call, allocator: mem.Allocator
) -> (res: h.Method_Result, error: h.Error) {
	fmt.println("Call method", call.method_name)
	fmt.println("Args:", call.args)

	res.return_values = make([]h.Method_Return_Value, 1, allocator) or_return

	v := i32(1)
	res.return_values[0] = h.make_method_return_value(&v, allocator) or_return

	return
}

run :: proc() -> h.Error {
	context.logger = log.create_console_logger()

	player_props := Player_Properties {
		rate = 1,
		shuffle = true,
		volume = 1.0,
		min_rate = 1,
		max_rate = 1,
		playback_status = "Paused",
		loop_status = "Playlist",
		can_control = true,
		can_go_next = true,
		can_go_previous = true,
		can_pause = true,
		can_seek = true,
	}

	server_props := Server_Properties {
		identity = "odin_dbus_example",
		desktop_entry = "odin_dbus_example",
		supported_uri_schemes = {"file"},
		supported_mime_types = {"audio/wav", "audio/mp3"},
	}

	server_interface := h.Interface {
		name = "org.mpris.MediaPlayer2",
		properties = h.property_map_from_type(Server_Properties, context.allocator, context.allocator) or_return,
		property_data = &server_props,
	}

	player_interface := h.Interface {
		name = "org.mpris.MediaPlayer2.Player",
		properties = h.property_map_from_type(Player_Properties, context.allocator, context.allocator) or_return,
		properties_type = Player_Properties,
		property_data = &player_props,
		method_proc = handle_player_method,
		methods = {
			{name = "Pause",},
			{name = "Play",},
			{name = "Next",},
			{name = "Previous",},
			{name = "PlayPause",},
			{name = "Stop",},
			{
				name = "Seek",
				args = {
					{name = "Offset", type = i64}
				},
			},
			{
				name = "SetPosition",
				args = {
					{name = "TrackId", type = h.Object_Path},
					{name = "Position", type = i64},
				}
			},
			{
				name = "OpenUri",
				args = {
					{name = "Uri", type = cstring},
				}
			},
		}
	}

	object := h.Object {
		path = "/org/mpris/MediaPlayer2",
		interfaces = {
			server_interface,
			player_interface,
		}
	}

			
	fmt.println("Properties:")
	for name, prop in player_interface.properties {
		fmt.println("\t", name, ": ", prop.type, "  [", prop.access, "]", sep="")
	}

	session := h.Server_Info {
		bus_name = "org.mpris.MediaPlayer2.odin_example",
		objects = {
			object
		},
		init_context = runtime.default_context()
	}

	session.init_context = context

	error := h.server_run(&session)

	if error != nil {
		log.error("Session exited with error", error)
	}

	return nil
}

main :: proc() {
	error := run()
	if error != nil {
		fmt.println("Error:", error)
	}
}


