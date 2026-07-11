-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}
M.base46 = {
  theme = "tokyodark",
  transparency = false,
}

M.ui = {
  statusline = {
    theme = "default",
    separator_style = "round",
  },
}

M.cheatsheet = {
  theme = "grid",
  excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens", "Move (v)", "Move (i)", "Save", "Move" },
}

-- M.nvdash = { load_on_startup = true }
return M
