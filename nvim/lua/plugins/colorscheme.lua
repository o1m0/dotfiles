local ORANGE = "#ff8a1f" -- キーワード・今いる場所などのアクセント
local AMBER = "#ffb84d" -- 数字・定数・true/false
local PEACH = "#ffc9a0" -- 型（string, int, Metadataなど）
local SAND = "#d9b99b" -- 文字列

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
      cache = false, -- 色を直したらすぐ反映されるように
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { italic = true },
        keywords = { bold = true, italic = false },
      },
      on_colors = function(c)
        -- 背景まわり（本体は透明。ポップアップ用などの色）
        c.bg = "#0e0e0e"
        c.bg_dark = "#0a0a0a"
        c.bg_float = "#0a0a0a"
        c.bg_popup = "#0a0a0a"
        c.bg_sidebar = "#0a0a0a"
        c.bg_statusline = "#0a0a0a"
        c.bg_highlight = "#262626"
        c.bg_visual = "#3a3a3a"
        c.border = "#3a3a3a"
        c.border_highlight = "#8a8a8a"
        -- 文字（背景より十分に明るくして読みやすく）
        c.fg = "#ececec"
        c.fg_dark = "#cccccc"
        c.fg_float = "#ececec"
        c.fg_sidebar = "#cccccc"
        c.fg_gutter = "#6a6a6a"
        c.comment = "#8e8e8e"
        c.dark3 = "#707070"
        c.dark5 = "#999999"
        c.terminal_black = "#3a3a3a"
        -- コードの色
        c.purple = ORANGE -- キーワード（func, if, return, import）
        c.magenta = ORANGE
        c.magenta2 = ORANGE
        c.blue = "#ffffff" -- 関数名
        c.blue0 = "#3a3a3a"
        c.blue1 = PEACH -- 型
        c.blue2 = "#b8b8b8"
        c.blue5 = "#b0b0b0" -- 演算子・記号
        c.blue6 = "#b0b0b0"
        c.blue7 = "#3a3a3a"
        c.cyan = "#d0d0d0" -- 組み込み関数
        c.teal = "#c0c0c0"
        c.green = SAND -- 文字列
        c.green1 = "#c8c8c8" -- フィールド・プロパティ
        c.green2 = "#a0a0a0"
        c.yellow = "#e0e0e0" -- 引数
        c.orange = AMBER -- 数字・定数
        -- 診断（エラーは赤のまま）
        c.warning = ORANGE
        c.info = "#b8b8b8"
        c.hint = "#8e8e8e"
      end,
      on_highlights = function(hl, c)
        hl.CursorLineNr = { fg = ORANGE, bold = true }
        hl.LineNr = { fg = "#808080" }
        hl.Search = { bg = ORANGE, fg = "#0a0a0a" }
        hl.CurSearch = { bg = ORANGE, fg = "#0a0a0a" }
        hl.IncSearch = { bg = ORANGE, fg = "#0a0a0a" }
        hl.MatchParen = { fg = ORANGE, bold = true }
        hl.WinSeparator = { fg = "#3a3a3a" }
        hl.FloatBorder = { fg = "#6b6b6b" }
        -- 起動画面
        hl.SnacksDashboardHeader = { fg = ORANGE }
        hl.SnacksDashboardIcon = { fg = ORANGE }
        hl.SnacksDashboardKey = { fg = ORANGE }
        -- HTML/JSXのタグ、this/selfなど（標準だと赤になる部分）
        hl["@tag"] = { fg = ORANGE }
        hl["@tag.attribute"] = { fg = PEACH }
        hl["@tag.delimiter"] = { fg = "#b0b0b0" }
        hl["@variable.builtin"] = { fg = PEACH }
      end,
    },
  },
}
