local wezterm = require 'wezterm';

local keys = {
    {
        key = "\"",
        mods = "CTRL",
        action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } }
    },
    {
        key = "%",
        mods = "CTRL",
        action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } }
    },
}

for i = 1, 9 do
    table.insert(keys, {
        key = tostring(i),
        mods = "ALT",
        action = wezterm.action { ActivateTab = i - 1 }
    })
end

return {
    use_fancy_tab_bar = false,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    window_background_opacity = 0.9,
    use_ime = true,
    enable_wayland = false,
    freetype_load_target = "HorizontalLcd",
    font = wezterm.font_with_fallback({
        { family = 'Iosevka Term', weight = 'Medium', stretch = 'Expanded' },
        'Inconsolata Nerd Font',
        'Noto Sans CJK TC',
        'Noto Color Emoji',
    }),
    font_rules = {
        {
            intensity = "Bold",
            font = wezterm.font_with_fallback({
                { family = 'Iosevka Term', weight = 'Black', stretch = 'Expanded' },
                'Inconsolata Nerd Font',
                { family = 'Noto Sans CJK TC', weight = 'Bold' },
                'Noto Color Emoji',
            })
        },
        {
            italic = true,
            font = wezterm.font_with_fallback({
                { family = 'Iosevka Term', weight = 'Medium', stretch = 'Expanded', italic = true },
                'Inconsolata Nerd Font',
                { family = 'Noto Sans CJK TC', weight = 'Bold', italic = true },
                'Noto Color Emoji',
            })
        },
        {
            italic = true,
            intensity = "Bold",
            font = wezterm.font_with_fallback({
                { family = 'Iosevka Term', weight = 'Black', stretch = 'Expanded', italic = true },
                'Inconsolata Nerd Font',
                { family = 'Noto Sans CJK TC', weight = 'Bold', italic = true },
                'Noto Color Emoji',
            })
        }
    },
    font_size = 12.0,
    color_scheme = 'OneHalfLight',
    check_for_updates = false,
    tab_max_width = 32,
    hide_tab_bar_if_only_one_tab = true,
    colors = {
        tab_bar = {
            background = "#e7eaed",
            active_tab = {
                bg_color = "#f7f7f7",
                fg_color = "#222222",
            },

            inactive_tab = {
                bg_color = "#e7eaed",
                fg_color = "#444444",
            },

            inactive_tab_hover = {
                bg_color = "#3b3052",
                fg_color = "#e7eaed",
                italic = true,
            },
        }
    },
    warn_about_missing_glyphs = false,
    keys = keys,
}
