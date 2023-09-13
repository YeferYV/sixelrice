return {
  -- Automation
  {
    "windwp/nvim-autopairs",
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
  { "Exafunction/codeium.vim", event = "InsertEnter" },
  -- {
  --   "tzachar/cmp-tabnine",
  --   build = "./install.sh",
  --   config = function()
  --     require("cmp_tabnine.config"):setup()
  --     astronvim.add_cmp_source({ name = "cmp_tabnine", priority = 1000, max_item_count = 7 })
  --   end
  -- },
  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    config = function()
      require("project_nvim").setup()
      require("telescope").load_extension('projects')
    end
  },

  -- Motions
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "justinmk/vim-sneak", event = "VeryLazy" },

  -- Text Objects
  { "paraduxos/vim-indent-object", branch = "new_branch", event = "VeryLazy" },
  {
    "kana/vim-textobj-user",
    event = "VeryLazy",
    dependencies = { "saihoooooooo/vim-textobj-space" }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "RRethy/nvim-treesitter-textsubjects" },
    }
  },
  { "coderifous/textobj-word-column.vim", event = "VeryLazy" },
  { "mg979/vim-visual-multi", event = "VeryLazy" },
  { "svermeulen/vim-easyclip", event = "VeryLazy" },
  {
    "chrisgrieser/nvim-various-textobjs",
    config = { useDefaultKeymaps = false, lookForwardSmall = 30, lookForwardBig = 30 }
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function() require("illuminate").configure({ filetypes_denylist = { 'neo-tree', } }) end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = {
      show_first_indent_level = false,
      show_current_context = true,
      show_current_context_start = false,
    }
  },

  -- UI
  { "olivercederborg/poimandres.nvim", event = "VeryLazy" },
  { "folke/tokyonight.nvim" },
  {
    'oncomouse/lushwal.nvim',
    event = "BufEnter",
    cmd = { "LushwalCompile" },
    dependencies = { "rktjmp/lush.nvim", "rktjmp/shipwright.nvim" },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = false,
    config = function() require("telescope").load_extension("file_browser") end
  },
  {
    "AckslD/nvim-neoclip.lua",
    lazy = false,
    config = function()
      require('neoclip').setup({
        on_select = { move_to_front = true },
        on_paste = { move_to_front = false, },
        keys = {
          telescope = {
            i = {
              select = '<cr>',
              paste = '<c-p>',
              paste_behind = '<c-k>',
              replay = '<c-q>', -- replay a macro
              delete = '<c-d>', -- delete an entry
              edit = '<c-e>', -- edit an entry
              custom = {},
            },
            n = {
              select = '<cr>',
              paste = 'p',
              paste_behind = 'P',
              replay = 'Q',
              delete = 'd',
              edit = 'e',
              custom = {},
            },
          },
        },
      })
      require("telescope").load_extension("neoclip")
    end
  },
  {
    "DaikyXendo/nvim-material-icon",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup({ override = require("nvim-material-icon").get_icons() })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "│" },
        topdelete    = { text = "契" },
        changedelete = { text = "~" },
        untracked    = { text = '┆' },
      },
    }
  },
}
