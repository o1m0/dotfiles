local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ==================================================
-- Basic
-- ==================================================

config.automatically_reload_config = true
config.use_ime = true

if wezterm.target_triple:find("windows") then
    config.default_domain = "WSL:Ubuntu"
end

-- ==================================================
-- Font
-- ==================================================

config.font = wezterm.font("Maple Mono NF")
config.font_size = 13.0

-- ==================================================
-- Design Tokens
-- ==================================================

local BG = "#111111"
local TAB_BAR = "#0D0D0D"
local TAB_INACTIVE = "#242424"
local TAB_HOVER = "#333333"

local TEXT = "#EAEAEA"
local MUTED = "#777777"

local ORANGE = "#E8813C"

-- ==================================================
-- Colors
-- ==================================================

config.colors = {
    foreground = TEXT,
    background = BG,

    cursor_bg = ORANGE,
    cursor_fg = BG,
    cursor_border = ORANGE,

    selection_fg = "#FFFFFF",
    selection_bg = "#3A2A20",

    split = "#333333",

    ansi = {
        "#151515",
        "#D75F5F",
        "#87AF87",
        "#D7AF5F",
        "#7C9CBF",
        "#A98AB0",
        "#7FA7A7",
        "#D0D0D0",
    },

    brights = {
        "#666666",
        "#E06C75",
        "#98C379",
        "#E5C07B",
        "#8FAFD1",
        "#C39AC9",
        "#8FBABA",
        "#FFFFFF",
    },

    tab_bar = {
        background = TAB_BAR,
        inactive_tab_edge = "none",
    },
}

-- ==================================================
-- Glass Window
-- ==================================================

config.window_background_opacity = 0.92

if wezterm.target_triple:find("darwin") then
    config.macos_window_background_blur = 20
end

config.window_padding = {
    left = 14,
    right = 14,
    top = 12,
    bottom = 12,
}

config.window_decorations = "RESIZE"

config.initial_cols = 120
config.initial_rows = 32

config.enable_scroll_bar = false

-- ==================================================
-- Tab Bar
-- ==================================================

config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 28

-- ==================================================
-- Helper Functions
-- ==================================================

local function basename(path)
    if not path then
        return nil
    end

    path = path:gsub("\\", "/")
    path = path:gsub("/$", "")

    return path:match("([^/]+)$")
end

local function get_cwd(pane)
    local cwd = pane.current_working_dir

    if not cwd then
        return nil
    end

    -- WezTermのUrlオブジェクトの場合
    if type(cwd) == "userdata" then
        return cwd.file_path
    end

    -- 文字列として返ってきた場合
    local cwd_string = tostring(cwd)

    cwd_string = cwd_string:gsub("^file://[^/]*", "")

    return cwd_string
end

local function get_process(pane)
    local process = pane.foreground_process_name

    if not process then
        return ""
    end

    process = process:gsub("\\", "/")

    return string.lower(process:match("([^/]+)$") or process)
end

-- ==================================================
-- Automatic Tab Name
-- ==================================================

local function get_tab_info(tab)
    local pane = tab.active_pane

    local process = get_process(pane)
    local cwd = get_cwd(pane)
    local folder = basename(cwd)

    -- Neovim
    if process:find("nvim") then
        return "", "NVIM"
    end

    -- Git
    if process:find("git") then
        return "", "GIT"
    end

    -- Go
    if process == "go" or process:find("go.exe") then
        return "", "GO"
    end

    -- Node
    if process:find("node") or process:find("npm") then
        return "", "NODE"
    end

    -- Python
    if process:find("python") then
        return "", "PYTHON"
    end

    -- Docker
    if process:find("docker") then
        return "", "DOCKER"
    end

    -- 通常のTerminalならディレクトリ名
    if folder and folder ~= "" then
        return "󰉋", string.upper(folder)
    end

    return "󰆍", "TERM"
end

-- ==================================================
-- Capsule Tabs
-- ==================================================

local LEFT_CAP = ""
local RIGHT_CAP = ""

wezterm.on("format-tab-title", function(
    tab,
    tabs,
    panes,
    cfg,
    hover,
    max_width
)
    local background = TAB_INACTIVE
    local foreground = MUTED

    if tab.is_active then
        background = ORANGE
        foreground = BG
    end

    if hover and not tab.is_active then
        background = TAB_HOVER
        foreground = TEXT
    end

    local icon, name = get_tab_info(tab)

    -- 長すぎるプロジェクト名を切る
    name = wezterm.truncate_right(name, 14)

    local title = "  " .. icon .. " " .. name .. "  "

    return {
        {
            Background = {
                Color = TAB_BAR,
            },
        },
        {
            Text = " ",
        },

        -- Left cap
        {
            Foreground = {
                Color = background,
            },
        },
        {
            Text = LEFT_CAP,
        },

        -- Body
        {
            Background = {
                Color = background,
            },
        },
        {
            Foreground = {
                Color = foreground,
            },
        },
        {
            Text = title,
        },

        -- Right cap
        {
            Background = {
                Color = TAB_BAR,
            },
        },
        {
            Foreground = {
                Color = background,
            },
        },
        {
            Text = RIGHT_CAP,
        },

        {
            Text = " ",
        },
    }
end)

-- ==================================================
-- Right Status
-- ==================================================

wezterm.on("update-right-status", function(window, pane)
    local time = wezterm.strftime("%H:%M")

    local cwd = pane:get_current_working_dir()
    local cwd_text = "~"

    if cwd then
        local path = cwd.file_path

        if path then
            -- /home/o1m0/dev/oshiato
            -- ↓
            -- ~/dev/oshiato

            local home =
                wezterm.home_dir:gsub("\\", "/")

            path = path:gsub("\\", "/")

            if path:sub(1, #home) == home then
                path = "~" .. path:sub(#home + 1)
            end

            cwd_text = path
        end
    end

    -- 長すぎるパスは短縮
    if #cwd_text > 30 then
        local folder = basename(cwd_text)

        if folder then
            cwd_text = "…/" .. folder
        end
    end

    local domain = pane:get_domain_name()

    local environment = "TERM"

    if domain and string.lower(domain):find("wsl") then
        environment = "WSL"
    elseif wezterm.target_triple:find("darwin") then
        environment = "MAC"
    elseif wezterm.target_triple:find("windows") then
        environment = "WIN"
    end

    window:set_right_status(
        wezterm.format({
            {
                Foreground = {
                    Color = MUTED,
                },
            },

            {
                Text = "  󰉋 " .. cwd_text,
            },

            {
                Foreground = {
                    Color = "#444444",
                },
            },

            {
                Text = "  │  ",
            },

            {
                Foreground = {
                    Color = MUTED,
                },
            },

            {
                Text = environment,
            },

            {
                Foreground = {
                    Color = "#444444",
                },
            },

            {
                Text = "  │  ",
            },

            {
                Foreground = {
                    Color = ORANGE,
                },
            },

            {
                Text = time .. "  ",
            },
        })
    )
end)

-- ==================================================
-- Pane
-- ==================================================

config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.70,
}

-- ==================================================
-- Cursor
-- ==================================================

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600

-- ==================================================
-- Key Bindings
-- ==================================================

config.keys = {
    -- Font Size
    {
        key = "-",
        mods = "CTRL",
        action = act.DecreaseFontSize,
    },

    {
        key = "=",
        mods = "CTRL",
        action = act.IncreaseFontSize,
    },

    {
        key = "0",
        mods = "CTRL",
        action = act.ResetFontSize,
    },
    -- 左右Pane分割
    {
        key = "h",
        mods = "ALT|SHIFT",
        action = act.SplitHorizontal({
            domain = "CurrentPaneDomain",
        }),
    },

    -- 上下Pane分割
    {
        key = "v",
        mods = "ALT|SHIFT",
        action = act.SplitVertical({
            domain = "CurrentPaneDomain",
        }),
    },

    -- Pane移動
    {
        key = "h",
        mods = "ALT",
        action = act.ActivatePaneDirection("Left"),
    },

    {
        key = "j",
        mods = "ALT",
        action = act.ActivatePaneDirection("Down"),
    },

    {
        key = "l",
        mods = "ALT",
        action = act.ActivatePaneDirection("Right"),
    },

    -- Paneを閉じる
    {
        key = "x",
        mods = "CTRL|SHIFT",
        action = act.CloseCurrentPane({
            confirm = true,
        }),
    },

    -- Tab 1〜9
    {
        key = "1",
        mods = "ALT",
        action = act.ActivateTab(0),
    },

    {
        key = "2",
        mods = "ALT",
        action = act.ActivateTab(1),
    },

    {
        key = "3",
        mods = "ALT",
        action = act.ActivateTab(2),
    },

    {
        key = "4",
        mods = "ALT",
        action = act.ActivateTab(3),
    },

    {
        key = "5",
        mods = "ALT",
        action = act.ActivateTab(4),
    },

    {
        key = "6",
        mods = "ALT",
        action = act.ActivateTab(5),
    },

    {
        key = "7",
        mods = "ALT",
        action = act.ActivateTab(6),
    },

    {
        key = "8",
        mods = "ALT",
        action = act.ActivateTab(7),
    },

    {
        key = "9",
        mods = "ALT",
        action = act.ActivateTab(8),
    },

    -- Copy
    {
        key = "c",
        mods = "CTRL|SHIFT",
        action = act.CopyTo("Clipboard"),
    },

    -- Paste
    {
        key = "v",
        mods = "CTRL|SHIFT",
        action = act.PasteFrom("Clipboard"),
    },
}

-- ==================================================
-- Finish
-- ==================================================

return config
