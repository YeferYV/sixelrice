return {
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
  {
    "ahmedkhalf/project.nvim",
    commit = "8c6bad7d22eef1b71144b401c9f74ed01526a4fb",
    lazy = false,
    config = function()
      require("project_nvim").setup()
      require("telescope").load_extension('projects')
    end
  },

  -- Motions
  { "tpope/vim-repeat", commit = "24afe922e6a05891756ecf331f39a1f6743d3d5a", event = "VeryLazy" },
  { "justinmk/vim-sneak", commit = "93395f5b56eb203e4c8346766f258ac94ea81702", event = "VeryLazy" },

  -- Text Objects
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "9161093fc7e13b12aa5bc86c641768c049d43a26",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", commit = "b55fe6175f0001347a433c9df358c8cbf8a4e90f" },
      { "RRethy/nvim-treesitter-textsubjects", commit = "b913508f503527ff540f7fe2dcf1bf1d1f259887" },
    }
  },
  { "coderifous/textobj-word-column.vim", commit = "cb40e1459817a7fa23741ff6df05e4481bde5a33", event = "VeryLazy" },
  { "mg979/vim-visual-multi", commit = "724bd53adfbaf32e129b001658b45d4c5c29ca1a", event = "VeryLazy" },
  { "svermeulen/vim-easyclip", commit = "f1a3b95463402b30dd1e22dae7d0b6ea858db2df", event = "VeryLazy" },
  {
    "chrisgrieser/nvim-various-textobjs",
    commit = "eba7c5d09c97ac8a73bad5793618b7d376d91048",
    config = { useDefaultKeymaps = false, lookForwardSmall = 30, lookForwardBig = 30 }
  },
  {
    "RRethy/vim-illuminate",
    commit = "a2907275a6899c570d16e95b9db5fd921c167502",
    event = "VeryLazy",
    config = function() require("illuminate").configure({ filetypes_denylist = { 'neo-tree', } }) end
  },

  -- UI
  { "olivercederborg/poimandres.nvim", event = "VeryLazy" },
  { "folke/tokyonight.nvim" },
  {
    'oncomouse/lushwal.nvim',
    commit = "ff3598395270c7f64d4dff5b15845a531abc4bc7",
    cmd = { "LushwalCompile" },
    dependencies = {
      { "rktjmp/lush.nvim", commit = "a8f0f7b9f837887f13a61d67b40ae26188fe4d62" },
      { "rktjmp/shipwright.nvim", commit = "ab70e80bb67b7ed3350bec89dd73473539893932" }
    },
    -- config = function() vim.g.lushwal_configuration = { compile_to_vimscript = false } end
  },
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
}
