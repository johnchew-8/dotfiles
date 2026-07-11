require "nvchad.autocmds"

-- .jsonc comment autocmd
vim.api.nvim_create_autocmd("FileType", {
  pattern = "jsonc",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
  }
)
