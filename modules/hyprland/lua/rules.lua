local nix = require("nix")

local mon1 = "desc:Microstep MAG 274U E16M CF0H105600717"
local mon2 = "desc:Microstep MSI G24C4 0x00000336"

-- Configure Mon 1 (Primary)
local prim = nix.monitors.primary
local mon1_opts = {
  output = mon1,
  mode = prim.resolution .. "@" .. tostring(prim.rr),
  position = "0x0",
  scale = tostring(prim.scale),
  vrr = prim.vrr,
}
if prim.tenbit then
  mon1_opts.bitdepth = 10
end
if prim.hdr then
  mon1_opts.cm = "hdr"
end
hl.monitor(mon1_opts)

-- Configure Mon 2
hl.monitor({
  output = mon2,
  mode = "highrr",
  position = "2560x200",
  scale = "1",
})

-- Configure laptop eDP-1
hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "-1920x0",
  scale = "1",
})

-- Configure AMZ FireTV
hl.monitor({
  output = "desc:AMZ FireTV",
  mode = "3840x2160@60",
  position = "auto",
  scale = "1",
})

-- Fallback preferred
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "1",
})

-- Gaps rules
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "s[1]", gaps_out = 50, gaps_in = 50 })

-- Workspace monitor mapping
for i = 0, 4 do
  local ws = i + 1
  local is_default = (i == 0)
  hl.workspace_rule({ workspace = tostring(ws), monitor = mon1, default = is_default })
  hl.workspace_rule({ workspace = tostring(ws + 5), monitor = mon2, default = is_default })
  hl.workspace_rule({ workspace = tostring(ws + 10), monitor = "eDP-1", default = is_default })
end

-- Window Rules
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "s[1]" }, border_size = 2 })
hl.window_rule({ match = { float = false, workspace = "s[1]" }, rounding = 10 })

hl.window_rule({ match = { class = "steam_app.*" }, content = "game" })
hl.window_rule({ match = { title = "Terraria.*" }, content = "game" })
hl.window_rule({ match = { class = "steam_app.*" }, immediate = true })
hl.window_rule({ match = { class = "steam_app_2001120" }, immediate = false })
hl.window_rule({ match = { class = "steam_app_920210" }, immediate = false })
