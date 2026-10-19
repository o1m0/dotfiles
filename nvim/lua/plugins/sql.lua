return {
  -- SQLの整形は、標準(ansi)ではなくPostgreSQLの書き方で行う
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=postgres", "-" },
        require_cwd = false, -- プロジェクトに設定ファイルがなくても動かす
      }
    end,
  },
}
