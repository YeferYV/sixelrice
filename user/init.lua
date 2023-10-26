return {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin",     -- remote to use
    channel = "stable",    -- "stable" or "nightly"
    version = "v3.*",      -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly",    -- branch name (NIGHTLY ONLY)
    commit = nil,          -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil,     -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false,  -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false,     -- automatically quit the current session after a successful update
    remotes = {            -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "tokyonight-night",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true,     -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    mappings = {
      n = {
        -- ["<leader>lF"] = { function() vim.lsp.buf.format(astronvim.lsp.format_opts) end, desc = "Format buffer" },
        ["K"] = false,                                   -- disable Hover symbol
        ["gl"] = { "`.", desc = "Jump to Last change" }, -- Overwrites Hover Diagnostics
      }
    },
  },

  ["config"] = {
    jsonls = {
      settings = {
        json = {
          schemas = function() require("schemastore").json.schemas() end,
          validate = { enable = true },
          keepLines = { enable = true },
        },
      },
    },
  },

  heirline = {
    -- separators = { tab = { "", "" } },
    separators = { tab = { "▎", " " } },
    colors = function(colors)
      -- colors.bg                      = astronvim.get_hlgroup("Normal").bg
      colors.bg = "NONE"                        -- Status line
      colors.section_bg = "NONE"                -- Status icons
      colors.buffer_bg = "NONE"                 -- Inactive buffer
      colors.buffer_fg = "#3b4261"              -- Inactive buffer
      colors.buffer_path_fg = "#3b4261"         -- Inactive buffer
      colors.buffer_close_fg = "#3b4261"        -- Inactive buffer
      colors.buffer_active_fg = "#ffffff"       -- Active buffer
      colors.buffer_active_path_fg = "#ffffff"  -- Active buffer path
      colors.buffer_active_close_fg = "#ffffff" -- Active buffer close button
      colors.buffer_visible_fg = "NONE"         -- Unfocus buffer
      colors.buffer_visible_path_fg = "NONE"    -- Unfocus buffer path
      colors.buffer_visible_close_fg = "NONE"   -- Unfocus buffer close button
      colors.tab_close_fg = "#5c5c5c"           -- Tab close button
      colors.tabline_bg = "NONE"                -- buffer line
      return colors
    end,
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  plugins = {

    -- Automation
    {
      "windwp/nvim-autopairs",
      commit = "0fd6519d44eac3a6736aafdb3fe9da916c3701d4",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup()

        local ts_utils = require("nvim-treesitter.ts_utils")
        require("cmp").event:on("confirm_done", function(evt)
          local name = ts_utils.get_node_at_cursor()
          if name ~= nil then
            if name:type() ~= "named_imports" then
              require("nvim-autopairs.completion.cmp").on_confirm_done()(evt)
            end
          end
        end)
      end,
    },
    {
      "Exafunction/codeium.vim",
      commit = "41b718e550b26a34075b79a50128cf853b2b917e",
      event = "InsertEnter"
    },

    -- tabline + statusline + columnstatus + winbar
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require("astronvim.utils.status")

        -- statuscolumn order
        opts.statuscolumn = {
          status.component.foldcolumn(),
          status.component.signcolumn(),
          status.component.fill(),
          status.component.fill(),
          status.component.numbercolumn(),
        }

        return opts
      end,
    },

    -- cmp-plugins
    {
      "hrsh7th/cmp-cmdline",
      commit = "8fcc934a52af96120fe26358985c10c035984b53",
      event = { "InsertEnter", "CmdlineEnter" },
    },

    -- LSP
    {
      "RRethy/vim-illuminate",
      commit = "a2907275a6899c570d16e95b9db5fd921c167502",
      event = "VeryLazy",
      config = function() require("illuminate").configure({ filetypes_denylist = { 'neo-tree', } }) end
    },

    -- Motions
    {
      "justinmk/vim-sneak",
      commit = "93395f5b56eb203e4c8346766f258ac94ea81702",
      event = "VeryLazy",
      dependencies = { "tpope/vim-repeat", commit = "24afe922e6a05891756ecf331f39a1f6743d3d5a" },
    },

    -- Text Objects
    { "echasnovski/mini.nvim",  commit = "e8a413b1a29f05bb556a804ebee990eb54479586" },
    {
      "kana/vim-textobj-user",
      commit = "41a675ddbeefd6a93664a4dc52f302fe3086a933",
      event = "VeryLazy",
      dependencies = {
        { "coderifous/textobj-word-column.vim", commit = "cb40e1459817a7fa23741ff6df05e4481bde5a33" },
      }
    },
    {
      "nvim-treesitter/nvim-treesitter",
      commit = "9161093fc7e13b12aa5bc86c641768c049d43a26",
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", commit = "b55fe6175f0001347a433c9df358c8cbf8a4e90f" },
      }
    },
    { "mg979/vim-visual-multi", commit = "724bd53adfbaf32e129b001658b45d4c5c29ca1a", event = "VeryLazy" },
    {
      "chrisgrieser/nvim-various-textobjs",
      commit = "eba7c5d09c97ac8a73bad5793618b7d376d91048",
      config = { useDefaultKeymaps = false, lookForwardSmall = 30, lookForwardBig = 30 }
    },

    -- TUI
    {
      "nvim-telescope/telescope-file-browser.nvim",
      commit = "e0fcb12702ad0d2873544a31730f9aaef04fd032",
      lazy = false,
      config = function() require("telescope").load_extension("file_browser") end
    },
    {
      "AckslD/nvim-neoclip.lua",
      commit = "5b9286a40ea2020352280caeb713515badb03d99",
      lazy = false,
    },

    -- UI
    {
      "ahmedkhalf/project.nvim",
      commit = "8c6bad7d22eef1b71144b401c9f74ed01526a4fb",
      lazy = false,
      config = function()
        require("project_nvim").setup()
        require("telescope").load_extension('projects')
      end
    },
    { "machakann/vim-columnmove",        commit = "21a43d809a03ff9bf9946d983d17b3a316bf7a64", event = "VeryLazy" },
    { "olivercederborg/poimandres.nvim", event = "VeryLazy" },
    { "folke/tokyonight.nvim" },
    {
      "Allianaab2m/nvim-material-icon-v3",
      commit = "89a89f7fa20330b21c93f4446bf99c20e7cea8d8",
      lazy = false,
      config = function()
        require("nvim-web-devicons").setup({ override = require("nvim-material-icon").get_icons() })
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      commit = "372d5cb485f2062ac74abc5b33054abac21d8b58",
      config = {
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "│" },
          topdelete    = { text = "" },
          changedelete = { text = "~" },
          untracked    = { text = '┆' },
        },
      }
    },
    -- {
    --   'oncomouse/lushwal.nvim',
    --   commit = "ff3598395270c7f64d4dff5b15845a531abc4bc7",
    --   cmd = { "LushwalCompile" },
    --   dependencies = {
    --     { "rktjmp/lush.nvim",       commit = "a8f0f7b9f837887f13a61d67b40ae26188fe4d62" },
    --     { "rktjmp/shipwright.nvim", commit = "ab70e80bb67b7ed3350bec89dd73473539893932" }
    --   },
    --   -- config = function() vim.g.lushwal_configuration = { compile_to_vimscript = false } end
    -- },
  },

  polish = function()
    require "user.user.alpha"        -- minor changes from github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.autocommands" -- minor changes from github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.cmp"          -- minor changes from github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.colorscheme"  -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.keymaps"      -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.mini"         -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.neo-tree"     -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.neoclip"      -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.options"      -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.telescope"    -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.toggleterm"   -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.treesitter"   -- same as github.com/YeferYV/dotfiles/blob/main/.config/nvim
    require "user.user.whichkey"     -- minor changes from github.com/YeferYV/dotfiles/blob/main/.config/nvim
  end,
}
