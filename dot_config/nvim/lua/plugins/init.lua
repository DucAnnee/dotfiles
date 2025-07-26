return {
  ------------------------------------------- ts autotag --------------------------------------------
  {
    "tronikelis/ts-autotag.nvim",
    event = "VeryLazy",
    opts = {},
    ft = { "jsx", "html", "ts" },
  },
  ----------------------------------------- lsp signature -------------------------------------------
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = function()
      return require "configs.lsp-signature"
    end,
    config = function(_, opts)
      require("lsp_signature").setup { opts }
    end,
  },
  --------------------------------------- rainbow delimiter -----------------------------------------
  {
    "hiphish/rainbow-delimiters.nvim",
    lazy = true,
    event = "BufEnter",
    opts = function()
      return require "configs.rainbow-delimiters"
    end,
    config = function(_, opts)
      require("rainbow-delimiters.setup").setup(opts)
    end,
  },

  --------------------------------------------- smear -----------------------------------------------
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   event = "BufReadPost",
  --   opts = function()
  --     return require "configs.smear"
  --   end,
  -- },

  -------------------------------------------- obsidian ---------------------------------------------
  -- {
  --   "epwalsh/obsidian.nvim",
  --   lazy = true,
  --   cmd = "Obsidian",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-treesitter",
  --   },
  --   opts = function()
  --     return require "configs.obsidian"
  --   end,
  -- },

  ------------------------------------------- nvim-conda --------------------------------------------
  {
    "kmontocam/nvim-conda",
    lazy = true,
    ft = "python",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  ------------------------------------------- copilot ---------------------------------------------
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = "Copilot",
    opts = function()
      return require "configs.copilot"
    end,
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },

  ---------------------------------------------- snack ----------------------------------------------
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = require "configs.snacks",
  },

  ----------------------------------------------- cmp -----------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  ------------------------------------------- neoscroll ---------------------------------------------
  {
    "karb94/neoscroll.nvim",
    lazy = true,
    event = "WinScrolled",
    opts = function()
      return require "configs.neoscroll"
    end,
    config = function(_, opts)
      require("neoscroll").setup(opts)
    end,
  },

  --------------------------------------------- mason -----------------------------------------------
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = require "configs.mason",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  --------------------------------------------- conform ---------------------------------------------
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -------------------------------------------- lspconfig --------------------------------------------
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  ------------------------------------------- treesitter --------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return require "configs.treesitter"
    end,
  },

  ----------------------------------------------- cmp -----------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },
}
