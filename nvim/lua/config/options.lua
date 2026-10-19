-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ハルの設定（読みやすさ）
local opt = vim.opt

opt.relativenumber = true -- 相対行番号。通常の行番号にしたいときは false
opt.scrolloff = 8 -- カーソルの上下に常に残す行数（標準は4）
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" } -- タブは見えなくして、行末の余分なスペースだけ点で表示

-- Goはタブ文字でインデントする（表示の幅は4）
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})
