require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

map("i", "jk", "<ESC>")

-- Cheatsheet
vim.keymap.del("n", "<leader>ch")
map("n", "<leader>cs", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

----------------------------------------------------------------------------
-- Replace C-b with C-a for beginning of line in insert mode
nomap("i", "<C-b>")
map("i", "<C-a>", "<Esc>^i", { desc = "Go to beginning of line" })

-- Remove toggle lines/relative lines. Always on relative line
vim.keymap.del("n", "<leader>n")
vim.keymap.del("n", "<leader>rn")

-- Move current line up or down in normal mode (Alt + j/k)
map("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })

-- Move current selection up or down in Visual mode (Alt + j/k)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Select text using Shift + Arrow keys (VS Code style)
map("n", "<S-Up>", "Vk", { desc = "Select line up" })
map("n", "<S-Down>", "Vj", { desc = "Select line down" })
map("v", "<S-Up>", "k", { desc = "Extend selection up" })
map("v", "<S-Down>", "j", { desc = "Extend selection down" })
map("v", "<S-Left>", "h", { desc = "Extend selection left" })
map("v", "<S-Right>", "l", { desc = "Extend selection right" })

-- Universal Save File (Ctrl + S)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Stay in Visual Mode when indenting/outdenting (with ] or [)
map("v", "[", "<gv", { desc = "Un-indent text keeping selection" })
map("v", "]", ">gv", { desc = "Indent text keeping selection" })

-- Lazygit
map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Git Open LazyGit Window" })

-- Terminal toggle (defaults A-h, A-v, A-i still available)
map({ "n", "t" }, "<C-`>", function()
  require("nvchad.term").toggle { pos = "sp", id = "horizontalToggleTerm" }
end, { desc = "Toggle terminal horizontal" })

-- oil.nvim replaces NvimTree file operations. NvimTree is purely cosmetic
vim.keymap.del("n", "<leader>e")
map("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open oil.nvim explorer" })

-- Dry-run formatter: conform.nvim
map({ "n", "x" }, "<leader>fc", function()
  require("conform").format({
    dry_run = true,
    lsp_fallback = true,
  }, function(err, did_edit)
    if err then
      vim.notify("Format check error: " .. err, vim.log.levels.ERROR)
    elseif did_edit then
      vim.notify("¿  Formatting issues found", vim.log.levels.WARN)
    else
      vim.notify("¿ No formatting issues", vim.log.levels.INFO)
    end
  end)
end, { desc = "format check file" })

-- Lazy plugin manager and Mason package manager
map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy" })
map("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Mason" })
