local nix = require("nix")

hl.config({
	dwindle = {
		preserve_split = true,
	},
	general = {
		allow_tearing = true,
		col = {
			inactive_border = "rgba(444444ff)",
		},
	},
	misc = {
		focus_on_activate = true,
		enable_swallow = true,
		swallow_regex = nix.terminal,
		swallow_exception_regex = "npm test.*",
		middle_click_paste = false,
	},
	render = {
		direct_scanout = 2,
		cm_auto_hdr = 1,
	},
	cursor = {
		no_hardware_cursors = 0,
		no_break_fs_vrr = 0,
		use_cpu_buffer = true,
		min_refresh_rate = 50,
	},
	decoration = {
		rounding = 10,
	},
})

-- Animation curves
hl.curve("easeInOut", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })

-- Animations
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "default", style = "popin" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "easeInOut" })
hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 2,
	bezier = "default",
	style = "slidefadevert -100%",
})
hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 2,
	bezier = "default",
	style = "slidefadevert -100%",
})
