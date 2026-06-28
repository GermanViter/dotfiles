hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "30")

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "30")

hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 30")
    hl.exec_cmd("hyprctl reload")
end)

misc = {
    vrr = 0
}

hl.monitor({
    output  = "DP-2",
    mode    = "2560x1440@144",
    scale   = 1,
})

hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

hl.bind( "CTRL + ALT + Delete", hl.dsp.exec_cmd("pkill Hyprland"))
