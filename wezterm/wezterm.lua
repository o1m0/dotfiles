local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()
local is_mac = wezterm.target_triple:find('darwin') ~= nil

-- 基本
config.automatically_reload_config = true
config.use_ime = true

-- フォント
config.font = wezterm.font_with_fallback {
  { family = 'Maple Mono NF', weight = 'Medium' },
  'Kiwi Maru',
}
config.font_size = 14

-- 色
config.color_scheme = 'Catppuccin Mocha'

-- 透明＋ぼかし
config.window_background_opacity = 0.55
if is_mac then
  config.macos_window_background_blur = 20
else
  config.win32_system_backdrop = 'Acrylic'
end

-- カーソル
config.default_cursor_style = 'SteadyBar'

-- 余白
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }

-- タイトルバー（赤黄緑のボタンはタブバーの左端に収める）
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

-- タブバー
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
pcall(function() config.show_close_tab_button_in_tabs = false end) -- nightly専用

-- タブバーを透明にして、背景と同じ色に揃える
config.window_frame = {
  inactive_titlebar_bg = 'none',
  active_titlebar_bg = 'none',
}
config.window_background_gradient = {
  colors = { '#1e1e2e' },
}

-- タブ同士の境界線を消す
config.colors = {
  tab_bar = {
    inactive_tab_edge = 'none',
  },
}

-- タブの形と色
local SOLID_LEFT_ARROW = utf8.char(0xe0b6) -- 左の丸い端
local SOLID_RIGHT_ARROW = utf8.char(0xe0b4) -- 右の丸い端

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local background = '#303030'
  local foreground = '#9c9c9c'
  local edge_background = 'none'
  if tab.is_active then
    background = '#d0d0d0'
    foreground = '#0b0b0b'
  end
  local edge_foreground = background
  local title = '   ' .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. '   '
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
    { Background = { Color = 'none' } }, -- tab-gap
    { Text = ' ' },
  }
end)

-- フルスクリーン（Mac純正を使わない）
config.native_macos_fullscreen_mode = false

-- 操作
config.hide_mouse_cursor_when_typing = true

-- 画面分割（Ghosttyと同じキー）＋ Cmd+Wは今の画面だけ閉じる
if is_mac then
config.keys = {
  { key = 'd', mods = 'SUPER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'SUPER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'LeftArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'w', mods = 'SUPER', action = act.CloseCurrentPane { confirm = true } },
}
end

-- ステータスバー（右上：バッテリーと日時）丸いカプセル型
local ORANGE = '#ff8a1f'
local CAP_L = utf8.char(0xe0b6)
local CAP_R = utf8.char(0xe0b4)
local PAD = '  '   -- ブロックの中の余白（スペースの数で調整）
local TIME_L = ' '   -- 時刻ブロックの左の余白
local TIME_R = '  '   -- 時刻ブロックの右の余白
local GAP = '  '   -- ブロックどうしの間の余白

wezterm.on('update-right-status', function(window, pane)
  local nf = wezterm.nerdfonts
  local chips = {}

  for _, b in ipairs(wezterm.battery_info()) do
    local pct = math.floor(b.state_of_charge * 100 + 0.5)
    local charging = (b.state == 'Charging')
    local level = math.min(100, math.floor(pct / 10) * 10)
    local name
    if charging then
      name = (level == 0) and 'md_battery_charging_outline' or ('md_battery_charging_' .. level)
    elseif level == 0 then
      name = 'md_battery_outline'
    elseif level == 100 then
      name = 'md_battery'
    else
      name = 'md_battery_' .. level
    end
    local color = ORANGE
    if pct <= 20 and not charging then
      color = '#ff5f5f'
    end
    table.insert(chips, { icon = nf[name] or '🔋', icon_color = color, text = pct .. '%', bg = '#434343' })
  end

  table.insert(chips, {
    icon = nf.md_clock_outline or '',
    icon_color = ORANGE,
    text = wezterm.strftime('%m/%d %a %H:%M'),
    bg = '#272727',
    lpad = TIME_L,
    rpad = TIME_R,
  })

  local out = {}
  for _, c in ipairs(chips) do
    table.insert(out, { Background = { Color = 'none' } })
    table.insert(out, { Foreground = { Color = c.bg } })
    table.insert(out, { Text = CAP_L })
    table.insert(out, { Background = { Color = c.bg } })
    table.insert(out, { Foreground = { Color = c.icon_color } })
    table.insert(out, { Text = (c.lpad or PAD) .. c.icon .. PAD })
    table.insert(out, { Foreground = { Color = '#c8c8c8' } })
    table.insert(out, { Text = c.text .. (c.rpad or PAD) })
    table.insert(out, { Background = { Color = 'none' } })
    table.insert(out, { Foreground = { Color = c.bg } })
    table.insert(out, { Text = CAP_R .. GAP })
  end
  window:set_right_status(wezterm.format(out))
end)

config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.55 }

config.line_height = 1.15

-- WindowsではPowerShellを開く
if not is_mac then
  config.default_prog = { 'powershell.exe', '-NoLogo' }
end

return config
