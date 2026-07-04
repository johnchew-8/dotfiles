require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "pyright",
  "rust_analyzer",
  "gopls",
  "clangd",
  "jsonls",
  "yamlls",
  "tailwindcss",
  "marksman",
  "taplo",
  "svelte",
  "fish_lsp",
  "sqls",
}

-- Python: type checking mode
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = { typeCheckingMode = "basic" },
    },
  },
})

-- TypeScript: inlay hints
vim.lsp.config("ts_ls", {
  settings = {
    completions = { completeFunctionCalls = true },
  },
})

-- Rust: use clippy for diagnostics
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
    },
  },
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
