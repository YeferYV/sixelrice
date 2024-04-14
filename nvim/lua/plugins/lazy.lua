return {

  -- -- Configure LazyVim to load poimandres
  -- {
  --   "LazyVim/LazyVim",
  --   opts = { colorscheme = "poimandres" },
  -- },

  -- -- change trouble config
  -- {
  --   "folke/trouble.nvim",
  --   -- opts will be merged with the parent spec
  --   opts = { use_diagnostic_signs = true },
  -- },

  -- -- add symbols-outline
  -- {
  --   "simrat39/symbols-outline.nvim",
  --   cmd = "SymbolsOutline",
  --   keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  --   config = true,
  -- },

  -- -- override nvim-cmp and add cmp-emoji
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = { "hrsh7th/cmp-emoji" },
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     table.insert(opts.sources, { name = "emoji" })
  --   end,
  -- },

  -- LSP keymaps
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      --- change a keymap
      -- keys[#keys + 1] = { "K", "<cmd>echo 'hello'<cr>" }
      --- disable a keymap
      keys[#keys + 1] = { "K", false }
      keys[#keys + 1] = { "gy", false }
      --- add a keymap
      -- keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
    end,
  },

  -- -- add tsserver and setup with typescript.nvim instead of lspconfig
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "jose-elias-alvarez/typescript.nvim",
  --     init = function()
  --       require("lazyvim.util").on_attach(function(_, buffer)
  --         -- stylua: ignore
  --         vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
  --         vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
  --       end)
  --     end,
  --   },
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       -- tsserver will be automatically installed with mason and loaded with lspconfig
  --       tsserver = {},
  --     },
  --     -- you can do any additional lsp server setup here
  --     -- return true if you don't want this server to be setup with lspconfig
  --     ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  --     setup = {
  --       -- example to setup with typescript.nvim
  --       tsserver = function(_, opts)
  --         require("typescript").setup({ server = opts })
  --         return true
  --       end,
  --       -- Specify * to use this function as a fallback for any server
  --       -- ["*"] = function(server, opts) end,
  --     },
  --   },
  -- },

  -- lazyvim extra plugins
  { import = "lazyvim.plugins.extras.ui.alpha" },
  { import = "lazyvim.plugins.extras.util.project" },
  { import = "lazyvim.plugins.extras.lsp.none-ls" },
  { "stevearc/conform.nvim",                       enabled = false },
  { "mfussenegger/nvim-lint",                      enabled = false },
  { "nvim-treesitter/nvim-treesitter-context",     enabled = false },
  { "folke/persistence.nvim",                      enabled = false },

  -- -- Use <tab> for completion and snippets (supertab)
  -- -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  -- {
  --   "L3MON4D3/LuaSnip",
  --   keys = function()
  --     return {}
  --   end,
  -- },

  -- commandline completion:
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-cmdline" },
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        commit = "bc25c56083939f274edcfe395c6ff7de23b67c50",
        config = function() require("tailwindcss-colorizer-cmp").setup({ color_square_width = 1 }) end,
      },
    },
  },

  -- -- then: setup supertab in cmp
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "hrsh7th/cmp-cmdline",
  --   },
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     local has_words_before = function()
  --       unpack = unpack or table.unpack
  --       local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --       return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  --     end
  --
  --     local luasnip = require("luasnip")
  --     local cmp = require("cmp")
  --
  --     opts.mapping = vim.tbl_extend("force", opts.mapping, {
  --       ["<Tab>"] = cmp.mapping(function(fallback)
  --         if cmp.visible() then
  --           cmp.select_next_item()
  --           -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
  --           -- this way you will only jump inside the snippet region
  --         elseif luasnip.expand_or_jumpable() then
  --           luasnip.expand_or_jump()
  --         elseif has_words_before() then
  --           cmp.complete()
  --         else
  --           fallback()
  --         end
  --       end, { "i", "s" }),
  --       ["<S-Tab>"] = cmp.mapping(function(fallback)
  --         if cmp.visible() then
  --           cmp.select_prev_item()
  --         elseif luasnip.jumpable(-1) then
  --           luasnip.jump(-1)
  --         else
  --           fallback()
  --         end
  --       end, { "i", "s" }),
  --
  --     })
  --
  --     -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --       }, {
  --         { name = "cmdline" },
  --       }),
  --     })
  --   end,
  -- },

  -- Motions
  {
    "folke/which-key.nvim",
    dependencies = {
      { "machakann/vim-columnmove", commit = "21a43d809a03ff9bf9946d983d17b3a316bf7a64" },
    },
  },

  -- Text-Objects
  { "JoosepAlviste/nvim-ts-context-commentstring", enabled = false },
  { "echasnovski/mini.ai",                         enabled = false },
  { "echasnovski/mini.comment",                    enabled = false },
  { "echasnovski/mini.indentscope",                enabled = false },
  { "echasnovski/mini.surround",                   enabled = false },
  { "echasnovski/mini.nvim",                       commit = "5d841fcca666bc27ca777807a63381ce2cf6e2f9" },
  {
    "kana/vim-textobj-user",
    commit = "41a675ddbeefd6a93664a4dc52f302fe3086a933",
    event = "VeryLazy",
    dependencies = {
      { "coderifous/textobj-word-column.vim", commit = "cb40e1459817a7fa23741ff6df05e4481bde5a33" },
    }
  },
  { "mg979/vim-visual-multi",                     commit = "724bd53adfbaf32e129b001658b45d4c5c29ca1a", event = "VeryLazy" },
  {
    "chrisgrieser/nvim-various-textobjs",
    commit = "6cefba253d69306004a641a11c395381ae428903",
    opts = { useDefaultKeymaps = false, lookForwardSmall = 30, lookForwardBig = 30 },
  },

  -- TUI
  { "akinsho/toggleterm.nvim",                    commit = "b86982429325112d2b20c6d0cc7a5c4b182ab705" },
  { "nvim-telescope/telescope-file-browser.nvim", commit = "e0fcb12702ad0d2873544a31730f9aaef04fd032" },
  { "AckslD/nvim-neoclip.lua",                    commit = "5b9286a40ea2020352280caeb713515badb03d99", config = true },

  -- UI
  {
    "akinsho/bufferline.nvim",
    dependencies = { { "tiagovla/scope.nvim", commit = "2db6d31de8e3a98d2b41c0f0d1f5dc299ee76875", config = true } },
  },
  { "glepnir/lspsaga.nvim",          commit = "199eb00822f65b811f43736ba65ab7e16501125d", event = "LspAttach" },
  { "Exafunction/codeium.vim",       commit = "41b718e550b26a34075b79a50128cf853b2b917e", event = "InsertEnter" },
  { "mrjones2014/smart-splits.nvim", commit = "d0111ef84fc82c9a31f4b000ff99190eaf18e790" },
  {
    "Allianaab2m/nvim-material-icon-v3",
    commit = "89a89f7fa20330b21c93f4446bf99c20e7cea8d8",
    lazy = false,
    opts = function()
      require("nvim-web-devicons").setup({ override = require("nvim-material-icon").get_icons() })
    end
  },

  {
    "goolord/alpha-nvim",
    commit = "dafa11a6218c2296df044e00f88d9187222ba6b0",
    dependencies = {
      {
        "NvChad/nvim-colorizer.lua",
        commit = "dde3084106a70b9a79d48f426f6d6fec6fd203f7",
        config = function() require("user.colorizer") end
      },
      {
        'olivercederborg/poimandres.nvim'
      },
      {
        'folke/tokyonight.nvim',
      },
    }
  },
  {
    "kevinhwang91/nvim-ufo",
    commit = "9e829d5cfa3de6a2ff561d86399772b0339ae49d",
    event = "VeryLazy",
    config = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end
    },
    dependencies = {
      { "kevinhwang91/promise-async", commit = "7fa127fa80e7d4d447e0e2c78e99af4355f4247b" },
      {
        "luukvbaal/statuscol.nvim",
        commit = "87c7b2f4c4366f83725499f2dea58f169a5d7700",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup(
            {
              relculright = false,
              segments = {
                { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                { text = { "%s" },                  click = "v:lua.ScSa" },
                { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }
              }
            }
          )
        end
      }
    }
  },

  -- Lazyvim overrides
  {
    "lukas-reineke/indent-blankline.nvim",
    version = "^3",
    opts = {
      -- indent = { char = "▏" },
      scope = {
        enabled = true,
        highlight = 'Function',
        include = { node_type = { ['*'] = { '*' } }, },
        show_start = false,
        show_end = false,
      }
    }
  },
  {
    "lewis6991/gitsigns.nvim",
    version = "^0",
    opts = {
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
  {
    "folke/noice.nvim",
    version = "^2",
    opts = {
      messages = { view_search = false },
      presets = {
        lsp_doc_border = true,
      },
    },
  },
}
