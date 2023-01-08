--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below
-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "v2.*", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_reload = false, -- automatically reload and sync packer after a successful update
    auto_quit = false -- automatically quit the current session after a successful update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme to use
  -- colorscheme = "default_theme",
  colorscheme = "tokyonight-night",
  -- colorscheme = "poimandres",

  -- Add highlight groups in any theme
  highlights = {
    init = { -- this table overrides highlights in all themes
      EndOfBuffer         = { bg = "NONE" },
      FloatBorder         = { bg = "NONE" },
      MsgArea             = { bg = "NONE" },
      NeoTreeNormal       = { bg = "NONE" },
      NeoTreeNormalNC     = { bg = "NONE" },
      Normal              = { bg = "NONE" },
      NormalNC            = { bg = "NONE" },
      NormalFloat         = { bg = "NONE" },
      Pmenu               = { bg = "NONE" },
      SignColumn          = { bg = "NONE" },
      TelescopeBorder     = { bg = "NONE" },
      TelescopeNormal     = { bg = "NONE" },
      WhichKeyBorder      = { bg = "NONE" },
      WhichKeyFloat       = { bg = "NONE" },
      CursorLine          = { bg = "#0c0c0c" },
      NeoTreeCursorLine   = { bg = "#16161e" },
      NeoTreeGitAdded     = { fg = "#495466" },
      NeoTreeGitConflict  = { fg = "#495466" },
      NeoTreeGitDeleted   = { fg = "#495466" },
      NeoTreeGitIgnored   = { fg = "#495466" },
      NeoTreeGitModified  = { fg = "#495466" },
      NeoTreeGitUnstaged  = { fg = "#495466" },
      NeoTreeGitUntracked = { fg = "#495466" },
      NeoTreeGitStaged    = { fg = "#495466" },
      NeoTreeRootName     = { fg = "#7aa2f7" },
      NeoTreeTabActive    = { fg = "#c0caf5" },
      Winbar              = { fg = "#495466" },
      WinbarNC            = { fg = "#495466" },
    },
    ["tokyonight"] = { -- a table of overrides/changes to the tokyonight theme

      ["Comment"]                = { fg = "#565f89", italic = false },
      ["Keyword"]                = { fg = "#7dcfff", italic = false },
      ["@keyword"]               = { fg = "#9d7cd8", italic = false },
      ["@field"]                 = { fg = "#7aa2f7" },
      ["@string"]                = { fg = "#73daca" },
      ["@boolean"]               = { fg = "#1cff1c" },
      ["@number"]                = { fg = "#1cff1c" },
      ["Constant"]               = { fg = "#1cff1c" },
      ["String"]                 = { fg = "#73daca" },
      IndentBlanklineChar        = { fg = "#3b4261" },
      IndentBlanklineContextChar = { fg = "#7aa2f7" },
      IlluminatedWordText        = { bg = "#080811" },
      IlluminatedWordRead        = { bg = "#080811" },
      IlluminatedWordWrite       = { bg = "#080811" },
      LspReferenceRead           = { bg = "#080811" },
      LspReferenceText           = { bg = "#080811" },
      LspReferenceWrite          = { bg = "#080811" },
      NotifyBackground           = { bg = "#000000" },
      NotifyDEBUGBody            = { fg = "#c0caf5" },
      NotifyDEBUGBorder          = { fg = "#2c2f44" },
      NotifyERRORBody            = { fg = "#c0caf5" },
      NotifyERRORBorder          = { fg = "#542931" },
      NotifyINFOBody             = { fg = "#c0caf5" },
      NotifyINFOBorder           = { fg = "#164a5b" },
      NotifyTRACEBody            = { fg = "#c0caf5" },
      NotifyTRACEBorder          = { fg = "#41385b" },
      NotifyWARNBody             = { fg = "#c0caf5" },
      NotifyWARNBorder           = { fg = "#55473a" },
      TelescopeSelection         = { bg = "#080811" },
      TelescopeSelectionCaret    = { bg = "#080811" },
      rainbowcol2                = { fg = "#89ddff" },
      rainbowcol1                = { fg = "#2ac3de" },
      rainbowcol3                = { fg = "#7dcfff" },
      rainbowcol4                = { fg = "#1abc9c" },
      rainbowcol5                = { fg = "#7aa2f7" },
      rainbowcol6                = { fg = "#bb9af7" },
      rainbowcol7                = { fg = "#9d7cd8" },

    },
    ["poimandres"] = { -- a table of overrides/changes to the poimandres theme
      ["@comment"]               = { fg = "#3e4041" },
      ["Comment"]                = { fg = "#a6accd" },
      ["Visual"]                 = { bg = "#1c1c1c" },
      IndentBlanklineChar        = { fg = "#3b4261" },
      IndentBlanklineContextChar = { fg = "#7aa2f7" },
      IlluminatedWordText        = { bg = "#080811" },
      IlluminatedWordRead        = { bg = "#080811" },
      IlluminatedWordWrite       = { bg = "#080811" },
      LspReferenceRead           = { bg = "#080811" },
      LspReferenceText           = { bg = "#080811" },
      LspReferenceWrite          = { bg = "#080811" },
      TelescopeSelection         = { bg = "#080811" },
      TelescopeSelectionCaret    = { bg = "#080811" },
    }
  },

  -- set vim options here (vim.<first_key>.<second_key> = value)
  options = {
    opt = {
      -- set to true or false etc.
      number = true, -- sets vim.opt.number
      relativenumber = true, -- sets vim.opt.relativenumber
      cursorline = false, -- sets vim.opt.cursorline
      completeopt = { "menu", "menuone", "noinsert" }, -- mostly just for cmp
      scrolloff = 8, -- vertical scrolloff
      sidescrolloff = 8, -- horizontal scrolloff
      signcolumn = "auto", -- sets vim.opt.signcolumn to auto
      spell = false, -- sets vim.opt.spell
      undofile = false, -- disable persistent undo
      virtualedit = "all", -- allow cursor bypass end of line
      wrap = false, -- sets vim.opt.wrap

      -- Indentation
      expandtab = true, -- convert tabs to spaces
      tabstop = 2, -- length of an actual \t character (eg. formmatters)
      softtabstop = 2, -- length to use when editing text (eg. pressing TAB and BS keys)
      shiftwidth = 2, -- length to use when shifting text (eg. <<, >> and == commands)
      smartindent = true, -- autoindenting when starting a new line

    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      cmp_enabled = true, -- enable completion at start
      autopairs_enabled = true, -- enable autopairs at start
      diagnostics_enabled = true, -- enable diagnostics at start
      status_diagnostics_enabled = true, -- enable diagnostics in statusline
      icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
      ui_notifications_enabled = true, -- disable notifications when toggling UI elements
      heirline_bufferline = true -- enable new heirline based bufferline (requires :PackerSync after changing)
    }
  },
  -- If you need more control, you can use the function()...end notation
  -- options = function(local_vim)
  --   local_vim.opt.relativenumber = true
  --   local_vim.g.mapleader = " "
  --   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
  --   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
  --
  --   return local_vim
  -- end,

  -- Set dashboard header
  header = {
    "██████  ███████ ████████ ██████   ██████",
    "██   ██ ██         ██    ██   ██ ██    ██",
    "██████  ███████    ██    ██████  ██    ██",
    "██   ██ ██         ██    ██   ██ ██    ██",
    "██   ██ ███████    ██    ██   ██  ██████",
    " ",
    "    ███    ██ ██    ██ ██ ███    ███",
    "    ████   ██ ██    ██ ██ ████  ████",
    "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
    "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
    "    ██   ████   ████   ██ ██      ██"
  },

  -- Default theme configuration
  default_theme = {
    -- Modify the color palette for the default theme
    colors = {
      fg = "#abb2bf",
      bg = "#1e222a",
    },
    highlights = function(hl) -- or a function that returns a new table of colors to set
      local C = require "default_theme.colors"

      hl.Normal = { fg = C.fg, bg = C.bg }

      -- New approach instead of diagnostic_style
      hl.DiagnosticError.italic = true
      hl.DiagnosticHint.italic = true
      hl.DiagnosticInfo.italic = true
      hl.DiagnosticWarn.italic = true

      return hl
    end,
    -- enable or disable highlighting for extra plugins
    plugins = {
      aerial = true,
      beacon = false,
      bufferline = true,
      cmp = true,
      dashboard = true,
      highlighturl = true,
      hop = false,
      indent_blankline = true,
      lightspeed = false,
      ["neo-tree"] = true,
      notify = true,
      ["nvim-tree"] = false,
      ["nvim-web-devicons"] = true,
      rainbow = true,
      symbols_outline = false,
      telescope = true,
      treesitter = true,
      vimwiki = false,
      ["which-key"] = true
    }
  },

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = { virtual_text = true, underline = true },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        }
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- "sumneko_lua",
      },
      timeout_ms = 1000 -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        ["<leader>lF"] = { function() vim.lsp.buf.format(astronvim.lsp.format_opts) end,
          desc = "Format buffer" },
        -- ["H"] = false, -- disable prev buffer
        -- ["L"] = false, -- disable next buffer
        ["K"] = false, -- disable Hover symbol
        ["gh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover Symbol" },
        ["go"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Hover Diagnostics" },
        ["gl"] = { "`.", desc = "Jump to Last change" }, -- Overwrites Hover Diagnostics
      }
    },
    -- add to the global LSP on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the mason server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = { -- override table for require("lspconfig").yamlls.setup({...})
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    }
  },

  -- Mapping data with "desc" stored directly by vim.keymap.set().
  --
  -- Please use this mappings table to set keyboard mapping since this is the
  -- lower level configuration and more robust one. (which-key will
  -- automatically pick-up stored data by this setting.)
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      -- mappings seen under group name "Buffer"
      ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      ["R"] = { "<cmd>w<cr>", desc = "Save" },
      ["Q"] = { "<cmd>q<cr>", desc = "Quit" },
      ["Y"] = { "yg_", desc = "Forward yank" },
      ["<left>"] = { "<cmd>bprevious<cr>", desc = "buffer prev" },
      ["<right>"] = { "<cmd>bnext<cr>", desc = "buffer next" },
      ["<M-Up>"] = { "<cmd>resize -2<cr>", desc = "Resize up" },
      ["<M-Down>"] = { "<cmd>resize +2<cr>", desc = "Resize down" },
      ["<M-Left>"] = { "<cmd>vertical resize -2<cr>", desc = "Resize left" },
      ["<M-Right>"] = { "<cmd>vertical resize +2<cr>", desc = "Resize right" },
      ["<C-s>"] = { ":%s//g<Left><Left>", desc = "replace" },
      ["<C-y>"] = { "<C-i>", desc = "Prev cursor position" },
      ["<Tab>"] = { "<cmd>bnext<cr>", desc = "buffer next" },
      ["<S-Tab>"] = { "<cmd>bprevious<cr>", desc = "buffer prev" },
      ["<leader><Tab>"] = { "<cmd>tabnext<cr>", desc = "tab next" },
      ["<leader><S-Tab>"] = { "<cmd>tabprevious<cr>", desc = "tab prev" },
      ["<leader>X"] = { "<cmd>tabclose<cr>", desc = "tab close" },
      ["<leader>x"] = { function() astronvim.close_buf(0) end, desc = "Close buffer" },
      ["<leader>v"] = { "<Cmd>ToggleTerm direction=vertical   size=70<CR>",
        desc = "ToggleTerm vertical" },
      ["<leader>V"] = { "<Cmd>ToggleTerm direction=horizontal size=10<CR>",
        desc = "ToggleTerm horizontal" },
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
      ["<M-Up>"] = { "<C-\\><C-n>:resize -2<CR>", desc = "Resize up" },
      ["<M-Down>"] = { "<C-\\><C-n>:resize +2<CR>", desc = "Resize down" },
      ["<M-Left>"] = { "<C-\\><C-n>:vertical resize -2<CR>", desc = "Resize left" },
      ["<M-Right>"] = { "<C-\\><C-n>:vertical resize +2<CR>", desc = "Resize right" }
    },
    o = {
      ["im"] = { "<cmd>normal! `[v`]<Left><cr>", desc = "Last change" }
    },
    x = {
      ["im"] = { "<cmd>normal! `[v`]<Left><cr>", desc = "last change" }
    },
    v = {
      ["p"] = { '"_dP', desc = "Paste unaltered" },
      ["P"] = { 'g_P', desc = "Forward Paste" },
      ["<leader>p"] = { '"*p', desc = "Paste unaltered (second_clip)" },
      ["<leader>P"] = { 'g_"*P', desc = "Forward Paste (second_clip)" },
      ["<leader>y"] = { '"*y', desc = "Copy (second_clip)" },
      ["<leader>Y"] = { 'y:let @* .= @0<cr>', desc = "Copy Append (second_clip)" },
      ["<leader>z"] = { ":'<,'>fold<CR>", desc = "fold" },
      ["<leader>Z"] = { ":'<,'>!column -t<CR>", desc = "Format Column" },
      ["<leader>gw"] = { "gw", desc = "Format Comment" }
    },
    c = {
      ["w!!"] = { "w !sudo tee %", desc = "save as sudo" },
    }
  },

  -- Configure plugins
  plugins = {
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      -- You can also add new plugins here as well:
      -- Add plugins, the packer syntax without the "use"
      -- { "andweeb/presence.nvim" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },

      -- We also support a key value style plugin definition similar to NvChad:
      -- ["ray-x/lsp_signature.nvim"] = {
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },

      -- UI
      ["folke/tokyonight.nvim"] = {},
      ["olivercederborg/poimandres.nvim"] = {},
      ["DaikyXendo/nvim-material-icon"] = {},

      -- Automation
      ["tzachar/cmp-tabnine"] = {
        commit = "851fbcc8ee54bdb93f9482e13b5fc31b50012422",
        run = "./install.sh",
        config = function()
          require("cmp_tabnine.config"):setup()
          astronvim.add_cmp_source({ name = "cmp_tabnine", priority = 1000, max_item_count = 7 })
        end
      },
      ["github/copilot.vim"] = { commit = "5a411d19ce7334ab10ba12516743fc25dad363fa" },
      ["ahmedkhalf/project.nvim"] = {
        commit = "685bc8e3890d2feb07ccf919522c97f7d33b94e4",
        config = function()
          require("project_nvim").setup()
          require("telescope").load_extension('projects')
        end
      },
      ["hrsh7th/nvim-cmp"] = { keys = { ":", "/", "?" } },
      ["hrsh7th/cmp-cmdline"] = { commit = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063", after = "nvim-cmp" },
      {
        "hrsh7th/cmp-emoji",
        commit = "19075c36d5820253d32e2478b6aaf3734aeaafa0",
        after = "nvim-cmp",
        config = function() astronvim.add_user_cmp_source "emoji" end,
      },

      -- Motions
      ["tpope/vim-repeat"] = { commit = "24afe922e6a05891756ecf331f39a1f6743d3d5a" },
      ["justinmk/vim-sneak"] = { commit = "93395f5b56eb203e4c8346766f258ac94ea81702", },

      -- Text-Objects
      ["nvim-treesitter/nvim-treesitter-textobjects"] = { commit = "98476e7364821989ab9b500e4d20d9ae2c5f6564" },
      ["RRethy/nvim-treesitter-textsubjects"] = { commit = "bc047b20768845fd54340eb76272b2cf2f6fa3f3" },
      ["coderifous/textobj-word-column.vim"] = { commit = "cb40e1459817a7fa23741ff6df05e4481bde5a33" },
      ["chrisgrieser/nvim-various-textobjs"] = {
        commit = "2fddc521bd8172dc157c89d2c182983caa898164",
        config = function() require("various-textobjs").setup({ useDefaultKeymaps = true }) end
      },
      ["RRethy/vim-illuminate"] = {
        commit = "a6d0b28ea7d6b9d139374be1f94a16bd120fcda3",
        config = function() require("illuminate").configure({ filetypes_denylist = { 'neo-tree', } }) end
      },

      ["echasnovski/mini.nvim"] = {
        commit = "",
        config = function()

          local spec_treesitter = require('mini.ai').gen_spec.treesitter
          require('mini.ai').setup({
            custom_textobjects = {
              q = spec_treesitter({ a = '@call.outer', i = '@call.inner', }),
              Q = spec_treesitter({ a = '@class.outer', i = '@class.inner', }),
              g = spec_treesitter({ a = '@comment.outer', i = '@comment.inner', }),
              G = spec_treesitter({ a = '@conditional.outer', i = '@conditional.inner', }),
              B = spec_treesitter({ a = '@block.outer', i = '@block.inner', }),
              F = spec_treesitter({ a = '@function.outer', i = '@function.inner', }),
              L = spec_treesitter({ a = '@loop.outer', i = '@loop.inner', }),
              P = spec_treesitter({ a = '@parameter.outer', i = '@parameter.inner', }),
            },
            mappings = {
              around = 'a',
              inside = 'i',
              around_next = 'aN',
              inside_next = 'iN',
              around_last = 'al',
              inside_last = 'il',
              goto_left = 'g[',
              goto_right = 'g]',
            },
          })

          require('mini.align').setup({
            mappings = {
              start = 'ga',
              start_with_preview = 'gA',
            },
          })

          require('mini.indentscope').setup({
            draw = {
              delay = 100,
              animation = nil
            },
            mappings = {
              object_scope = 'ii',
              object_scope_with_border = 'ai',
              goto_top = '[ii',
              goto_bottom = ']ii',
            },
            options = {
              border = 'both',
              indent_at_cursor = true,
              try_as_border = false,
            },
            symbol = '',
          })

          require('mini.surround').setup({
            custom_surroundings = nil,
            highlight_duration = 500,
            mappings = {
              add = 'ys', -- Add surrounding in Normal and Visual modes
              delete = 'ds', -- Delete surrounding
              find = 'zf', -- Find surrounding (to the right)
              find_left = 'zF', -- Find surrounding (to the left)
              highlight = 'zh', -- Highlight surrounding
              replace = 'cs', -- Replace surrounding
              update_n_lines = 'zn', -- Update `n_lines`
              suffix_last = 'l', -- Suffix to search with "prev" method
              suffix_next = 'N', -- Suffix to search with "next" method
            },
          })

        end
      },

    },

    ["treesitter"] = {
      ensure_installed = { "html", "css", "javascript" },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_previous_start = {
            ['[aq'] = '@call.outer',
            ['[aQ'] = '@class.outer',
            ['[ag'] = '@comment.outer',
            ['[aG'] = '@conditional.outer',
            ['[aB'] = '@block.outer',
            ['[aF'] = '@function.outer',
            ['[aL'] = '@loop.outer',
            ['[aP'] = '@parameter.outer',
            ['[iq'] = '@call.inner',
            ['[iQ'] = '@class.inner',
            ['[ig'] = '@comment.inner',
            ['[iG'] = '@conditional.inner',
            ['[iB'] = '@block.inner',
            ['[iF'] = '@function.inner',
            ['[iL'] = '@loop.inner',
            ['[iP'] = '@parameter.inner',
            ['[['] = '@parameter.inner',
          },
          goto_next_start = {
            [']aq'] = '@call.outer',
            [']aQ'] = '@class.outer',
            [']ag'] = '@comment.outer',
            [']aG'] = '@conditional.outer',
            [']aB'] = '@block.outer',
            [']aF'] = '@function.outer',
            [']aL'] = '@loop.outer',
            [']aP'] = '@parameter.outer',
            [']iq'] = '@call.inner',
            [']iQ'] = '@class.inner',
            [']ig'] = '@comment.inner',
            [']iG'] = '@conditional.inner',
            [']iB'] = '@block.inner',
            [']iF'] = '@function.inner',
            [']iL'] = '@loop.inner',
            [']iP'] = '@parameter.inner',
            [']]'] = '@parameter.inner',
          },
          goto_previous_end = {
            ['[eaq'] = '@call.outer',
            ['[eaQ'] = '@class.outer',
            ['[eag'] = '@comment.outer',
            ['[eaG'] = '@conditional.outer',
            ['[eaB'] = '@block.outer',
            ['[eaF'] = '@function.outer',
            ['[eaL'] = '@loop.outer',
            ['[eaP'] = '@parameter.outer',
            ['[eiq'] = '@call.inner',
            ['[eiQ'] = '@class.inner',
            ['[eig'] = '@comment.inner',
            ['[eiG'] = '@conditional.inner',
            ['[eiB'] = '@block.inner',
            ['[eiF'] = '@function.inner',
            ['[eiL'] = '@loop.inner',
            ['[eiP'] = '@parameter.inner',
          },
          goto_next_end = {
            [']eaq'] = '@call.outer',
            [']eaQ'] = '@class.outer',
            [']eag'] = '@comment.outer',
            [']eaG'] = '@conditional.outer',
            [']eaB'] = '@block.outer',
            [']eaF'] = '@function.outer',
            [']eaL'] = '@loop.outer',
            [']eaP'] = '@parameter.outer',
            [']eiq'] = '@call.inner',
            [']eiQ'] = '@class.inner',
            [']eig'] = '@comment.inner',
            [']eiG'] = '@conditional.inner',
            [']eiB'] = '@block.inner',
            [']eiF'] = '@function.inner',
            [']eiL'] = '@loop.inner',
            [']eiP'] = '@parameter.inner',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['>,'] = '@parameter.inner',
          },
          swap_previous = {
            ['<,'] = '@parameter.inner',
          },
        },
        lsp_interop = {
          enable = true,
          border = 'rounded', --'none', 'single', 'double', 'rounded', 'solid', 'shadow'.
          peek_definition_code = {
            ['<leader>lf'] = '@function.outer',
            ['<leader>lc'] = '@class.outer',
          },
        },
      },
      textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
          ['.'] = 'textsubjects-smart', -- useful for block of comments
          ['aK'] = 'textsubjects-container-outer',
          ['iK'] = 'textsubjects-container-inner',
        },
      },
    },

    ["indent_blankline"] = {
      show_first_indent_level = true,
      show_current_context = true,
      show_current_context_start = false,
    },

    ["neo-tree"] = {
      window = {
        mappings = {
          ["F"] = "filter_on_submit",
          ["v"] = "open_vsplit",
          ["V"] = "open_split",
          ["s"] = false,
          ["S"] = false,
          ["f"] = false,
          ["fa"] = function() vim.cmd [[normal 0]] vim.cmd [[/ a]] vim.cmd [[normal n]] end,
          ["fb"] = function() vim.cmd [[normal 0]] vim.cmd [[/ b]] vim.cmd [[normal n]] end,
          ["fc"] = function() vim.cmd [[normal 0]] vim.cmd [[/ c]] vim.cmd [[normal n]] end,
          ["fd"] = function() vim.cmd [[normal 0]] vim.cmd [[/ d]] vim.cmd [[normal n]] end,
          ["fe"] = function() vim.cmd [[normal 0]] vim.cmd [[/ e]] vim.cmd [[normal n]] end,
          ["ff"] = function() vim.cmd [[normal 0]] vim.cmd [[/ f]] vim.cmd [[normal n]] end,
          ["fg"] = function() vim.cmd [[normal 0]] vim.cmd [[/ g]] vim.cmd [[normal n]] end,
          ["fh"] = function() vim.cmd [[normal 0]] vim.cmd [[/ h]] vim.cmd [[normal n]] end,
          ["fi"] = function() vim.cmd [[normal 0]] vim.cmd [[/ i]] vim.cmd [[normal n]] end,
          ["fj"] = function() vim.cmd [[normal 0]] vim.cmd [[/ j]] vim.cmd [[normal n]] end,
          ["fk"] = function() vim.cmd [[normal 0]] vim.cmd [[/ k]] vim.cmd [[normal n]] end,
          ["fl"] = function() vim.cmd [[normal 0]] vim.cmd [[/ l]] vim.cmd [[normal n]] end,
          ["fm"] = function() vim.cmd [[normal 0]] vim.cmd [[/ m]] vim.cmd [[normal n]] end,
          ["fn"] = function() vim.cmd [[normal 0]] vim.cmd [[/ n]] vim.cmd [[normal n]] end,
          ["fo"] = function() vim.cmd [[normal 0]] vim.cmd [[/ o]] vim.cmd [[normal n]] end,
          ["fp"] = function() vim.cmd [[normal 0]] vim.cmd [[/ p]] vim.cmd [[normal n]] end,
          ["fq"] = function() vim.cmd [[normal 0]] vim.cmd [[/ q]] vim.cmd [[normal n]] end,
          ["fr"] = function() vim.cmd [[normal 0]] vim.cmd [[/ r]] vim.cmd [[normal n]] end,
          ["fs"] = function() vim.cmd [[normal 0]] vim.cmd [[/ s]] vim.cmd [[normal n]] end,
          ["ft"] = function() vim.cmd [[normal 0]] vim.cmd [[/ t]] vim.cmd [[normal n]] end,
          ["fu"] = function() vim.cmd [[normal 0]] vim.cmd [[/ u]] vim.cmd [[normal n]] end,
          ["fv"] = function() vim.cmd [[normal 0]] vim.cmd [[/ v]] vim.cmd [[normal n]] end,
          ["fw"] = function() vim.cmd [[normal 0]] vim.cmd [[/ w]] vim.cmd [[normal n]] end,
          ["fx"] = function() vim.cmd [[normal 0]] vim.cmd [[/ x]] vim.cmd [[normal n]] end,
          ["fy"] = function() vim.cmd [[normal 0]] vim.cmd [[/ y]] vim.cmd [[normal n]] end,
          ["fz"] = function() vim.cmd [[normal 0]] vim.cmd [[/ z]] vim.cmd [[normal n]] end,
        },
      },
      filesystem = {
        commands = {

          getparent_closenode = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' and node:is_expanded() then
              require 'neo-tree.sources.filesystem'.toggle_directory(state,
                node)
            else
              require 'neo-tree.ui.renderer'.focus_node(state,
                node:get_parent_id())
            end
          end,

          open_unfocus = function(state)
            state.commands["open"](state)
            vim.cmd("Neotree reveal")
          end,

          quit_on_open = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' then
              if not node:is_expanded() then
                require 'neo-tree.sources.filesystem'.toggle_directory(state
                  , node)
              elseif node:has_children() then
                require 'neo-tree.ui.renderer'.focus_node(state,
                  node:get_child_ids()[1])
              end
            else
              state.commands['open'](state)
              state.commands["close_window"](state)
              vim.cmd('normal! M')
            end
          end,

        },
        window = {
          mappings = {
            ["h"] = "getparent_closenode",
            ["H"] = "toggle_hidden",
            ["l"] = "quit_on_open",
            ["L"] = "open_unfocus",
          },
        },
      },
    },

    ["cmp"] = function(opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"

      -- modify the mapping part of the table
      opts.mapping["<A-j>"] = cmp.mapping.select_next_item()
      opts.mapping["<A-k>"] = cmp.mapping.select_prev_item()

      -- modify the formatting part of the table
      opts.formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = require("lspkind").symbolic(vim_item.kind, { mode = "symbol" })
          vim_item.menu = ({
            cmp_tabnine = "[TN]",
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
            emoji = "[Emoji]",
          })[entry.source.name]
          return vim_item
        end,
      }

      -- return the new table to be used
      return opts
    end,

    -- All other entries override the require("<key>").setup({...}) call for default plugins
    ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
      -- config variable is the default configuration table for the setup function call
      -- local null_ls = require "null-ls"

      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        -- Set a formatter
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
      }
      return config -- return final config table
    end,
    -- use mason-lspconfig to configure LSP installations
    ["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
      ensure_installed = { "tsserver" },
    },
    -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
    ["mason-null-ls"] = { -- overrides `require("mason-null-ls").setup(...)`
      -- ensure_installed = { "prettier" },
    },
    ["mason-nvim-dap"] = { -- overrides `require("mason-nvim-dap").setup(...)`
      -- ensure_installed = { "chrome" },
    },
  },

  -- LuaSnip Options
  luasnip = {
    -- Extend filetypes
    filetype_extend = {
      -- javascript = { "javascriptreact" },
    },
    -- Configure luasnip loaders (vscode, lua, and/or snipmate)
    vscode = {
      -- Add paths for including more VS Code style snippets in luasnip
      paths = {}
    }
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000

  ["cmp"] = {
    source_priority = {
      cmp_tabnine = 1000,
      nvim_lsp = 900,
      luasnip = 750,
      buffer = 500,
      path = 250,
      emoji = 200,
    },

    setup = function()
      -- load cmp to access it's internal functions
      local cmp = require "cmp"

      -- configure mappings for cmdline
      local fallback_func = function(func)
        return function(fallback)
          if cmp.visible() then
            cmp[func]()
          else
            fallback()
          end
        end
      end
      local mappings = cmp.mapping.preset.cmdline {
        ["<C-j>"] = { c = fallback_func "select_next_item" },
        ["<C-k>"] = { c = fallback_func "select_prev_item" },
        ["<M-j>"] = { c = fallback_func "select_next_item" },
        ["<M-k>"] = { c = fallback_func "select_prev_item" },
      }

      local config = {
        -- configure cmp.setup.cmdline(source, options)
        cmdline = {
          [":"] = {
            mapping = mappings,
            -- configure sources normally without getting priority from cmp.source_priority
            sources = cmp.config.sources({ { name = "path" } },
              { { name = "cmdline" } })
          },
          ["/"] = { mapping = mappings, sources = { { name = "buffer" } } },
          ["?"] = { mapping = mappings, sources = { { name = "buffer" } } },
        },
      }
      return config
    end,
  },

  -- Customize Heirline options
  heirline = {
    -- Customize different separators between sections
    -- separators = { tab = { "", "" } },
    separators = { tab = { "▎", " " } },
    -- Customize colors for each element each element has a `_fg` and a `_bg`
    colors = function(colors)
      -- colors.bg                      = astronvim.get_hlgroup("Normal").bg
      colors.bg = "NONE" -- Status line
      colors.section_bg = "NONE" -- Status icons
      colors.buffer_bg = "#000000" -- Inactive buffer
      colors.buffer_fg = "#3b4261" -- Inactive buffer
      colors.buffer_path_fg = "#3b4261" -- Inactive buffer
      colors.buffer_close_fg = "#3b4261" -- Inactive buffer
      colors.buffer_active_fg = "#ffffff" -- Active buffer
      colors.buffer_active_path_fg = "#ffffff" -- Active buffer path
      colors.buffer_active_close_fg = "#ffffff" -- Active buffer close button
      colors.buffer_visible_fg = "NONE" -- Unfocus buffer
      colors.buffer_visible_path_fg = "NONE" -- Unfocus buffer path
      colors.buffer_visible_close_fg = "NONE" -- Unfocus buffer close button
      colors.tab_close_fg = "#5c5c5c" -- Tab close button
      colors.tabline_bg = "NONE" -- buffer line
      return colors
    end,
    -- Customize attributes of highlighting in Heirline components
    attributes = {
      -- styling choices for each heirline element, check possible attributes with `:h attr-list`
      -- git_branch = { bold = true }, -- bold the git branch statusline component
      -- buffer_active = { bold = false },
    }
    -- -- Customize if icons should be highlighted
    -- icon_highlights = {
    --   breadcrumbs = false, -- LSP symbols in the breadcrumbs
    --   file_icon = {
    --     winbar = false, -- Filetype icon in the winbar inactive windows
    --     statusline = true, -- Filetype icon in the statusline
    --   },
    -- },
  },

  -- Modify which-key registration (Use this with mappings table in the above.)
  ["which-key"] = {
    -- Add bindings which show up as group name
    register = {
      -- first key is the mode, n == normal mode
      n = {
        ["H"] = { "10h", "Jump 10h" },
        ["J"] = { "10j", "Jump 10j" },
        ["K"] = { "10k", "Jump 10k" },
        ["L"] = { "10l", "Jump 10l" },
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- third key is the key to bring up next level and its displayed
          -- group name in which-key top level menu
          ["u"] = {
            name = "UI",
            h = { "<cmd>set cmdheight=1<cr>", "enable cmdheight" },
            H = { "<cmd>set cmdheight=0<cr>", "disable cmdheight" },
            u = {
              function()
                local ok, start = require("indent_blankline.utils").get_current_context(
                  vim.g.indent_blankline_context_patterns,
                  vim.g.indent_blankline_use_treesitter_scope
                )
                if ok then
                  vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win()
                    , { start, 0 })
                  vim.cmd [[normal! _]]
                end
              end,
              "Jump to current_context",
            },
            U = { function() astronvim.ui.toggle_url_match() end,
              "Toggle URL highlight" },
            w = { "<cmd>set winbar=%@<cr>", "enable winbar" },
            W = { "<cmd>set winbar=  <cr>", "disable winbar" },
          },

          ["s"] = {
            name = "Search",
            c = { "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true, initial_mode='normal'})<cr>",
              "Colorscheme" },
            p = { "<cmd>Telescope projects<cr>", "Projects" },
          },

          ["v"] = "which_key_ignore",
          ["V"] = "which_key_ignore",
          ["q"] = "which_key_ignore",
          ["w"] = "which_key_ignore",
          ["X"] = "which_key_ignore",
          ["<Tab>"] = { "which_key_ignore" },
          ["<S-Tab>"] = { "which_key_ignore" },

        }
      }
    }
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    -- pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }

    -- _jump_to_last_position_on_reopen
    vim.cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

    -- _sneakLabel_or_bnext
    vim.cmd [[ nmap <expr> <Tab> sneak#is_sneaking() ? '<Plug>SneakLabel_s<cr>' : ':bnext<cr>' ]]

    -- _illuminate_text_objects
    vim.keymap.set({ 'n', 'x', 'o' }, '<a-n>', '<cmd>lua require"illuminate".goto_next_reference(wrap)<cr>')
    vim.keymap.set({ 'n', 'x', 'o' }, '<a-p>', '<cmd>lua require"illuminate".goto_prev_reference(wrap)<cr>')
    vim.keymap.set({ 'n', 'x', 'o' }, '<a-i>', '<cmd>lua require"illuminate".textobj_select()<cr>')

    -- _disable_autocommented_new_lines
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        vim.opt.formatoptions:remove { "c", "r", "o" }
      end,
    })

    -- _material_icons
    require("nvim-web-devicons").setup({ override = require("nvim-material-icon").get_icons() })

  end
}

return config
