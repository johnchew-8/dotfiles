local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    toml = { "taplo" },
    svelte = { "prettier" },
    sql = { "sqlfluff" },
    kdl = { "kdlfmt" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
