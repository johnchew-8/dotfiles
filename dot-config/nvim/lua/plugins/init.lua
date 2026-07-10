if vim.fn.has "wsl" == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -NoProfile -ExecutionPolicy Bypass -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -NoProfile -ExecutionPolicy Bypass -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

--vim.api.nvim_create_autocmd("VimEnter", {
--  callback = function()
--    vim.cmd(":NvimTreeToggle")
--  end,
--})

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', uncomment for format on save
    opts = require "configs.conform",
    cmd = { "ConformInfo" },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      columns = {
        "icon",
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-\\>"] = { "actions.select", opts = { vertical = true } },
        ["<C-->"] = { "actions.select", opts = { horizontal = true } },
      },
    },
    dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        ["*"] = { "typos" },
        javascript = { "typos", "eslint_d" },
        typescript = { "typos", "eslint_d" },
        javascriptreact = { "typos", "eslint_d" },
        typescriptreact = { "typos", "eslint_d" },
        python = { "typos", "ruff" },
        sql = { "typos", "sqlfluff" },
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "rmagatti/auto-session",
    lazy = false, -- False to run immediately when Neovim opens
    opts = {
      auto_restore_enabled = true,
      auto_save_enabled = true,
      suppressed_dirs = { "~/", "~/Downloads", "/", "/tmp" },

      -- Prevents NvimTree from breaking or duplicating during session restore
      session_lens = {
        load_on_setup = false,
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>F", "<cmd>GrugFar<CR>", desc = "Find and Replace (grug-far)" },
    },
    config = function()
      require("grug-far").setup {
        -- All defaults are fine. https://github.com/MagicDuck/grug-far.nvim/blob/main/doc/grug-far.txt
      }
    end,
  },
  --TODO: DAPs: https://www.lazyvim.org/extras/dap/core
}
