return {

  -- { "folke/lazydev.nvim", enabled = false }, -- throws error by blink
  { "akinsho/bufferline.nvim",      enabled = false },
  { "nvim-neo-tree/neo-tree.nvim",  enabled = false },
  { "MunifTanjim/nui.nvim",         enabled = false },
  { "nvim-lua/plenary.nvim",        enabled = false },
  { "folke/noice.nvim",             enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false }, --no contains a valid JSON object for mini.snippets
  { "williamboman/mason.nvim",      opts = function() return { ensure_installed = {} } end, },

  -- https://www.lazyvim.org/plugins/lsp
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- disable "K" keymap, use instead "<leader>lH"
      local ok, keymaps = pcall(require, "lazyvim.plugins.lsp.keymaps")
      if not ok then return end
      local keys = keymaps.get()
      keys[#keys + 1] = { "K", false }
    end,
  },

  {
    "folke/flash.nvim",
    version = "v2.1.0",
    event = "VeryLazy",
    opts = { modes = { search = { enabled = true } } },
  },
  {
    "lewis6991/gitsigns.nvim",
    -- version = "0.9.0",
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
    "folke/snacks.nvim",
    -- version = "v2.21.0",
    commit = "f3cdd02620bd5075e453be7451a260dbbee68cab",
    lazy = false,
    cond = not vim.g.vscode,
    opts = {
      scroll = { enabled = false },
      explorer = { replace_netrw = true },
      image = {},
      indent = {},
      input = {},
      picker = { sources = { explorer = { hidden = true } } },
      styles = {
        input = {
          title_pos = "left",
          relative = "cursor",
          row = 1,
          col = -1,
          width = 30,
        },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    commit = "07d20fce48a5629686aefb0a7cd4b25e33947d50",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<A-l>",
        clear_suggestion = "<A-k>",
        accept_word = "<A-j>",
      }
    }
  },
  {
    "echasnovski/mini.nvim",
    version = "v0.15.0",
    lazy = false,
    config = function()
      -- ╭──────────────╮
      -- │ Autocommands │
      -- ╰──────────────╯

      local autocmd = vim.api.nvim_create_autocmd
      local map = vim.keymap.set

      autocmd('LspAttach', {
        callback = function()
          map({ "n" }, "J", "10gj")
          map({ "n" }, "K", "10gk")
          map({ "n" }, "H", "10h")
          map({ "n" }, "L", "10l")
        end
      })

      -- ╭──────╮
      -- │ Mini │
      -- ╰──────╯
      local gen_ai_spec = require("mini.extra").gen_ai_spec

      require("mini.ai").setup({
        custom_textobjects = {
          d = gen_ai_spec.diagnostic(),                                                                                           -- diagnostic textobj
          e = gen_ai_spec.line(),                                                                                                 -- line textobj
          h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } },       -- html attribute textobj
          k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" },                                             -- key textobj
          v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },                                                        -- value textobj
          m = gen_ai_spec.number(),                                                                                               -- number(inside string) textobj { '[-+]?()%f[%d]%d+()%.?%d*' }
          x = { '#()%x%x%x%x%x%x()' },                                                                                            -- hexadecimal textobj
          o = { "%S()%s+()%S" },                                                                                                  -- whitespace textobj
          u = { { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]', }, '^().*()$' }, -- sub word textobj https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-ai.txt

          -- https://thevaluable.dev/vim-create-text-objects
          -- select indent by the same or mayor level delimited by blank-lines
          i = function()
            local start_indent = vim.fn.indent(vim.fn.line('.'))

            local prev_line = vim.fn.line('.') - 1
            while vim.fn.indent(prev_line) >= start_indent do
              prev_line = prev_line - 1
            end

            local next_line = vim.fn.line('.') + 1
            while vim.fn.indent(next_line) >= start_indent do
              next_line = next_line + 1
            end

            return { from = { line = prev_line + 1, col = 1 }, to = { line = next_line - 1, col = 100 }, vis_mode = 'V' }
          end,

          -- select indent by the same level delimited by comment-lines (outer: includes blank-lines)
          y = function()
            local start_indent = vim.fn.indent(vim.fn.line('.'))
            local get_comment_regex = "^%s*" .. string.gsub(vim.bo.commentstring, "%%s", ".*") .. "%s*$"
            local is_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
            local is_comment_line = function(line) return string.find(vim.fn.getline(line), get_comment_regex) end
            local is_out_of_range = function(line) return vim.fn.indent(line) == -1 end

            local prev_line = vim.fn.line('.') - 1
            while vim.fn.indent(prev_line) == start_indent or is_blank_line(prev_line) do
              if is_out_of_range(prev_line) then break end
              if is_comment_line(prev_line) then break end
              if is_blank_line(prev_line) and _G.skip_blank_line then break end
              prev_line = prev_line - 1
            end

            local next_line = vim.fn.line('.') + 1
            while vim.fn.indent(next_line) == start_indent or is_blank_line(next_line) do
              if is_out_of_range(next_line) then break end
              if is_comment_line(next_line) then break end
              if is_blank_line(next_line) and _G.skip_blank_line then break end
              next_line = next_line + 1
            end

            return { from = { line = prev_line + 1, col = 1 }, to = { line = next_line - 1, col = 100 }, vis_mode = 'V' }
          end
        },
        n_lines = 500, -- search range and required by functions less than 500 LOC
      })

      require('mini.indentscope').setup({
        options = { indent_at_cursor = false, },
        mappings = {
          object_scope = 'iI',
          object_scope_with_border = 'aI',
        },
        symbol = '',
      })

      require('mini.surround').setup({
        mappings = {
          add = 'gza',            -- Add surrounding in Normal and Visual modes
          delete = 'gzd',         -- Delete surrounding
          find = 'gzf',           -- Find surrounding (to the right)
          find_left = 'gzF',      -- Find surrounding (to the left)
          highlight = 'gzh',      -- Highlight surrounding
          replace = 'gzr',        -- Replace surrounding
          update_n_lines = 'gzn', -- Update `n_lines`
        },
      })

      require('mini.align').setup()
      require('mini.bracketed').setup({ undo = { suffix = '' } })
      require('mini.operators').setup()
      require('mini.splitjoin').setup()
      require('mini.trailspace').setup()

      require('mini.base16').setup({
        -- `:Inspect` to reverse engineering a colorscheme
        -- `:hi <@treesitter>` to view colors of `:Inspect` output
        -- `:lua require("snacks").picker.highlights()` to view generated colorscheme
        -- https://github.com/NvChad/base46/tree/v2.5/lua/base46/themes for popular colorscheme palettes
        -- https://github.com/echasnovski/mini.nvim/discussions/36 community palettes
        palette = {
          -- nvchad poimandres
          base00 = "#1b1e28", -- default bg, terminal_color_0
          base01 = "#171922", -- line number bg, popup bg
          base02 = "#32384a", -- statusline bg, tabline bg, selection bg
          base03 = "#3b4258", -- line number fg, comments, terminal_color_8
          base04 = "#48506a", -- statusline fg, tabline inactive fg
          base05 = "#A6ACCD", -- default fg, tabline fg, terminal_color_7
          base06 = "#b6d7f4", -- unused
          base07 = "#ffffff", -- terminal_color_15
          base08 = "#A6ACCD", -- return, Diff delete, Diagnostic Error
          base09 = "#D0679D", -- integers, booleans, constants, search
          base0A = "#5DE4C7", -- classes, search, tag signs/attributes
          base0B = "#5DE4C7", -- strings, Diff added
          base0C = "#89DDFF", -- builtins, Diagnostic Info
          base0D = "#ADD7FF", -- functions, Diagnostic Hint
          base0E = "#91B4D5", -- keywords (def, for), Diff changed, Diagnostic Warn
          base0F = "#FFFFFF", -- punctuation, regex, indentscope
        },
        use_cterm = true,     -- required if `vi -c 'Pick files'`
      })

      -- poimandres transparency
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MsgArea", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueBorder", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueTitle", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueDescSingle", { link = "Pmenu" })
      vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = "#1c1c2c" })
      vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#1c1c2c" })
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#506477", bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "Statusline", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatuslineNC", { bg = "NONE" })

      -- poimandres custom colors
      vim.api.nvim_set_hl(0, "Comment", { fg = "#5c5c5c", })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#2c2c2c" })
      vim.api.nvim_set_hl(0, "diffAdded", { fg = "#009900" })
      vim.api.nvim_set_hl(0, "diffChanged", { fg = "#3C3CFf" })
      vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#ff0000" })
      vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#009900" })
      vim.api.nvim_set_hl(0, "DiffChange", { fg = "#3C3CFf" })
      vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#990000" })
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#3C3CFf", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#3C3CFf" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#990000" })

      -- poimandres same as the original
      vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#D0679D" })
      vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#89DDFF" })
      vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#91B4D5" })
      vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#FFFAC2" })
      vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#D0679D" })
      vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#89DDFF" })
      vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#91B4D5" })
      vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#FFFAC2" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#D0679D" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#89DDFF" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#91B4D5" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#FFFAC2" })
      vim.api.nvim_set_hl(0, "Number", { fg = "#5de4c7" })
      vim.api.nvim_set_hl(0, "Constant", { fg = "#5de4c7" })
      vim.api.nvim_set_hl(0, "Boolean", { fg = "#5de4c7" })
      vim.api.nvim_set_hl(0, "Search", { fg = "#FFFFFF", bg = "#506477" })
      vim.api.nvim_set_hl(0, "CurSearch", { fg = "#171922", bg = "#ADD7FF" })
      vim.api.nvim_set_hl(0, "IncSearch", { fg = "#171922", bg = "#ADD7FF" })
      vim.api.nvim_set_hl(0, "Special", { fg = "#767c9d" })
      vim.api.nvim_set_hl(0, "Type", { fg = "#a6accd" })

      local function add_vscode_snippets_to_rtp()
        local extensions_dir = vim.fs.joinpath(vim.env.HOME, '.vscode', 'extensions')

        -- Get all snippet directories using glob
        local snippet_dirs = vim.fn.globpath(
          extensions_dir,
          '*/snippets', -- Matches any extension/snippets directory
          true,         -- recursive
          true          -- return as list
        )

        -- Add to runtimepath (with nil checks)
        for _, dir in ipairs(snippet_dirs) do
          if vim.fn.isdirectory(dir) == 1 then
            -- Normalize the path to handle OS-specific separators
            local normalized_dir = vim.fs.normalize(dir)

            local parent_dir = normalized_dir:gsub("/snippets$", "")
            -- ~/.vscode/extensions/emranweb.daisyui-snippet-1.0.3/snippets/snippetshtml.code-snippets no contains a valid JSON object
            -- ~/.vscode/extensions/imgildev.vscode-nextjs-generator-2.6.0/snippets/trpc.code-snippets no contains a valid JSON object
            vim.opt.rtp:append(parent_dir)
          end
        end
      end

      add_vscode_snippets_to_rtp()
      local gen_loader = require('mini.snippets').gen_loader
      require('mini.snippets').setup({
        snippets = { gen_loader.from_runtime("*") },
        mappings = {
          expand = '<a-.>',
          jump_next = '<a-;>',
          jump_prev = '<a-,>',
        }
      })

      require('mini.cursorword').setup()
      require('mini.extra').setup()
      require('mini.misc').setup_auto_root()
      require('mini.misc').setup_restore_cursor()
      require('mini.pairs').setup()
      require("mini.tabline").setup()
      vim.opt.virtualedit = "all"    -- allow cursor bypass end of line
      vim.opt.relativenumber = false -- normal numbering
      vim.opt.cmdheight = 0          -- more space in the neovim command line for displaying messages
      vim.opt.cursorline = false     -- highlight the current line

      -- ╭────────────╮
      -- │ Navigation │
      -- ╰────────────╯

      local flash = require("flash")
      local gs = require("gitsigns")
      local map = vim.keymap.set

      map({ "i" }, "jk", "<ESC>")
      map({ "i" }, "kj", "<ESC>")
      map({ "n" }, "J", "10gj")
      map({ "n" }, "K", "10gk")
      map({ "n" }, "H", "10h")
      map({ "n" }, "L", "10l")
      map({ "n" }, "<M-j>", "10gj")
      map({ "n" }, "<M-k>", "10gk")
      map({ "n" }, "<M-h>", "10h")
      map({ "n" }, "<M-l>", "10l")
      map({ "n" }, "<M-v>", "V")
      map({ "n" }, "Y", "yg_", { desc = "Yank forward" })  -- "Y" yank forward by default
      map({ "v" }, "Y", "g_y", { desc = "Yank forward" })
      map({ "v" }, "P", "g_P", { desc = "Paste forward" }) -- "P" doesn't change register
      map({ "v" }, "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
      map({ "n" }, "U", "@:", { desc = "repeat `:command`" })
      map({ "v" }, "<", "<gv", { desc = "continious indent" })
      map({ "v" }, ">", ">gv", { desc = "continious indent" })
      map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, desc = "next completion when no lsp" })
      map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]],
        { expr = true, desc = "prev completion when no lsp" })
      map({ "n", "v", "t" }, "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
      map({ "n", "v", "t" }, "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
      map({ "n", "v", "t" }, "<M-Up>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
      map({ "n", "v", "t" }, "<M-Down>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
      map({ "n" }, "<esc>", "<esc><cmd>lua vim.cmd.nohlsearch()<cr>", { desc = "escape and clear search highlight" })
      map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
      map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
      map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
      map({ "t", "n" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window" })
      map({ "t", "n" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window" })
      map({ "t", "n" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window" })
      map({ "t", "n" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window" })
      map({ "t", "n" }, "<C-;>", "<C-\\><C-n><C-6>", { desc = "go to last buffer" })
      map({ "n" }, "<right>", "<cmd>bnext<CR>", { desc = "next buffer" })
      map({ "n" }, "<left>", "<cmd>bprevious<CR>", { desc = "prev buffer" })
      map({ "n" }, "<leader>x", "<cmd>bp | bd! #<CR>", { desc = "Close Buffer" }) -- `bd!` forces closing terminal buffer
      map({ "n" }, "<leader>;", "<cmd>buffer #<cr>", { desc = "Recent buffer" })
      map({ "n" }, "Q", "<cmd>lua vim.cmd('quit')<cr>")
      map({ "n" }, "R", "<cmd>lua vim.lsp.buf.format{ timeout_ms = 5000 } MiniTrailspace.trim() vim.cmd.write() <cr>")

      -- ╭────────────────╮
      -- │ leader keymaps │
      -- ╰────────────────╯

      map("n", "<leader>l", "", { desc = "+LSP" })
      map("n", "<leader>lA", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
      map("n", "<leader>lc", function() vim.lsp.buf.incoming_calls() end, { desc = "Incoming Calls" })
      map("n", "<leader>lC", function() vim.lsp.buf.outcoming_calls() end, { desc = "Outcoming Calls" })
      map("n", "<leader>ld", function() require("snacks").picker.lsp_definitions() end, { desc = "Pick Definition" })
      map("n", "<leader>lD", function() require("snacks").picker.lsp_declarations() end, { desc = "Pick Declaration" })
      map("n", "<leader>lF", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, { desc = "Format" })
      map("n", "<leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "Signature" })
      map("n", "<leader>lH", function() vim.lsp.buf.hover() end, { desc = "Hover" })
      map("n", "<leader>lI", function() require("snacks").picker.lsp_implementations() end,
        { desc = "Pick Implementation" })
      map("n", "<leader>lm", function() vim.cmd("Mason") end, { desc = "Mason" })
      map("n", "<leader>lM", function() vim.cmd("checkhealth vim.lsp") end, { desc = "LspInfo" })
      map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1, float = true }) end,
        { desc = "Next Diagnostic" })
      map("n", "<leader>lo", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostic" })
      map("n", "<leader>lp", function() vim.diagnostic.jump({ count = -1, float = true }) end,
        { desc = "Prev Diagnostic" })
      map("n", "<leader>lq", function() require("snacks").picker.loclist() end, { desc = "Pick LocList" })
      map("n", "<leader>lr", function() require("snacks").picker.lsp_references() end, { desc = "Pick References" })
      map("n", "<leader>lR", function() vim.lsp.buf.rename() end, { desc = "Rename" })
      map("n", "<leader>ls", function() require("snacks").picker.lsp_symbols() end, { desc = "Pick symbols" })
      map("n", "<leader>lt", function() require("snacks").picker.lsp_type_definitions() end,
        { desc = "Pick TypeDefinition" })
      map("n", "<leader>f", "", { desc = "+Find" })
      map("n", "<leader>fb", function() require("snacks").picker.grep() end, { desc = "buffers" })
      map("n", "<leader>fB", function() require("snacks").picker.grep() end, { desc = "ripgrep on buffers" })
      map("n", "<leader>fc", function() require("snacks").picker.colorschemes() end, { desc = "colorscheme" })
      map("n", "<leader>fk", function() require("snacks").picker.keymaps() end, { desc = "keymaps" })
      map("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "files" })
      map(
        "n",
        "<leader>fg",
        function() require("snacks").picker.grep({ layout = "ivy_split", filter = { cwd = true }, }) end,
        { desc = "ripgrep" }
      )
      map("n", "<leader>fp", function() require("snacks").picker.projects() end, { desc = "projects" })
      map("n", "<leader>fq", function() require("snacks").picker.qflist() end, { desc = "quickfix list" })
      map("n", "<leader>fr", function() require("snacks").picker.recent() end, { desc = "recent files" })
      map("n", '<leader>f"', function() require("snacks").picker.registers() end, { desc = "register (:help quote)" })
      map("n", "<leader>f/", function() require("snacks").picker.git_files() end, { desc = "find git (sorted) files" })
      map("n", "<leader>f;", function() require("snacks").picker.jumps() end, { desc = "jumps" })
      map("n", "<leader>f'", function() require("snacks").picker.marks() end, { desc = "marks" })
      map("n", "<leader>f.", function() require("snacks").picker.resume() end, { desc = "resume" })
      map("n", "<leader>g", "", { desc = "+Git" })
      map("n", "<leader>gg", "<cmd>term lazygit<cr><cmd>set ft=terminal<cr>", { desc = "lazygit" })
      map("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", { silent = true, desc = "Preview GitHunk" })
      map("n", "<leader>gr", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "Reset GitHunk" })
      map("n", "<leader>gs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "Stage GitHunk" })
      map("n", "<leader>gS", ":Gitsigns undo_stage_hunk<cr>", { silent = true, desc = "Undo stage GitHunk" })
      map(
        "n",
        "<leader>gd",
        "<cmd>diffthis | vertical new | diffthis | read !git show HEAD^:#<cr>",
        { desc = "git difftool -t nvimdiff" }
      )
      map("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", { desc = "Toggle Explorer" })
      map(
        "n",
        "<leader>o",
        function()
          Snacks.explorer.open({ auto_close = true, layout = { preset = 'default', preview = true } })
        end,
        { desc = "Explorer with preview" }
      )
      map("n", "<leader>u", "", { desc = "+UI toggle" })
      map("n", "<leader>u0", "<cmd>set showtabline=0<cr>", { desc = "Buffer Hide" })
      map("n", "<leader>u2", "<cmd>set showtabline=2<cr>", { desc = "Buffer Show" })
      map("n", "<leader>uf", "<cmd>lua vim.o.foldmethod='indent'<cr>", { desc = "fold by indent" })
      map("n", "<leader>uF", "<cmd>lua vim.o.foldmethod='expr'<cr>", { desc = "fold by lsp" })
      map("n", "<leader>ul", "<cmd>set cursorline!<cr>", { desc = "toggle cursorline" })
      map("n", "<leader>um", "<cmd>SupermavenStop<cr>", { desc = "Supermaven stop" })
      map("n", "<leader>uM", "<cmd>SupermavenStart<cr>", { desc = "Supermaven start" })
      map("n", "<leader>us", "<cmd>set laststatus=0<cr>", { desc = "StatusBar Hide" })
      map("n", "<leader>uS", "<cmd>set laststatus=3<cr>", { desc = "StatusBar Show" })
      map("n", "<leader>t", "", { desc = "+Terminal" })
      map("n", "<leader>tt", "<cmd>terminal <cr>", { desc = "buffer terminal" })
      map("n", "<leader>ty", "<cmd>terminal yazi<cr><cmd>set ft=terminal<cr>", { desc = "yazi" })
      map("n", "<leader>v", "<cmd>vsplit | terminal<cr>", { desc = "vertical terminal" })
      map("n", "<leader>V", "<cmd>split  | terminal<cr>", { desc = "horizontal terminal" })
      map("n", "<leader>w", "", { desc = "+Window" })
      map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "vertical window" })
      map("n", "<leader>wV", "<cmd>split<cr>", { desc = "horizontal window" })
      map("n", "<leader><leader>p", '"*p', { desc = "Paste after (second_clip)" })
      map("n", "<leader><leader>P", '"*P', { desc = "Paste before (second_clip)" })
      map("x", "<leader><leader>p", '"*p', { desc = "Paste (second_clip)" })           -- "Paste after (second_clip)"
      map("x", "<leader><leader>P", 'g_"*P', { desc = "Paste forward (second_clip)" }) -- only works in visual mode
      map("n", "<leader><leader>y", '"*y', { desc = "Yank (second_clip)" })
      map("n", "<leader><leader>Y", '"*yg_', { desc = "Yank forward (second_clip)" })
      map("x", "<leader><leader>y", '"*y', { desc = "Yank (second_clip)" })
      map("x", "<leader><leader>Y", 'g_"*y', { desc = "Yank forward (second_clip)" })

      -- ╭────────────────────╮
      -- │ Operator / Motions │
      -- ╰────────────────────╯

      -- https://vi.stackexchange.com/questions/22570/is-there-a-way-to-move-to-the-beginning-of-the-next-text-object
      map(
        { "n", "x" },
        "gT",
        function()
          local ok1, tobj_id1 = pcall(vim.fn.getcharstr)
          local ok2, tobj_id2 = pcall(vim.fn.getcharstr)
          if not ok1 then return end
          if not ok2 then return end
          local cmd = ":normal v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`<"
          if vim.fn.mode() ~= "n" then
            cmd = "<esc>:normal m'v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`<v`'"
          end
          return cmd
        end,
        { expr = true, desc = "Start of TextObj" }
      )
      map(
        { "n", "x" },
        "gt",
        function()
          local ok1, tobj_id1 = pcall(vim.fn.getcharstr)
          local ok2, tobj_id2 = pcall(vim.fn.getcharstr)
          if not ok1 then return end
          if not ok2 then return end
          local cmd = ":normal v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`>"
          if vim.fn.mode() ~= "n" then
            cmd = ":<c-u>normal m'v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`'v`>"
          end
          return cmd
        end,
        { expr = true, desc = "End of TextObj" }
      )

      map({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
      map({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
      map({ "n", "x", "o" }, "<cr>", function() flash.jump({ continue = true }) end, { desc = "Continue Flash search" })
      map({ "x", "o" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Flash Search" })
      map({ "c" }, "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
      map({ "n", "x" }, "gb", '"_d', { desc = "Blackhole Motion/Selected (dot to repeat)" })
      map({ "n", "x" }, "gB", '"_D', { desc = "Blackhole Linewise (dot to repeat)" })
      map({ "n", "o", "x" }, "g.", "`.", { desc = "go to last change" })
      map({ "n" }, "g,", "g,", { desc = "go forward in :changes" })  -- Formatting will lose track of changes
      map({ "n" }, "g;", "g;", { desc = "go backward in :changes" }) -- Formatting will lose track of changes
      map({ "n" }, "gy", '"1p', { desc = "Redo register (dot to Paste forward the rest of register)" })
      map({ "n" }, "gY", '"1P', { desc = "Redo register (dot to Paste backward the rest of register)" })
      map({ "n" }, "g<Up>", "<c-a>", { desc = "numbers ascending" })
      map({ "n" }, "g<Down>", "<c-x>", { desc = "numbers descending" })
      map({ "x" }, "g<Up>", "g<c-a>", { desc = "numbers ascending" })
      map({ "x" }, "g<Down>", "g<c-x>", { desc = "numbers descending" })
      map({ "n", "x" }, "g+", "<C-a>", { desc = "Increment number (dot to repeat)" })
      map({ "n", "x" }, "g-", "<C-x>", { desc = "Decrement number (dot to repeat)" })
      map({ "o", "x" }, "gh", ":<c-u>Gitsigns select_hunk<cr>", { desc = "Git hunk textobj" })

      -- ╭───────────────────────────────────────╮
      -- │ Text Objects with "g" (dot to repeat) │
      -- ╰───────────────────────────────────────╯

      map({ "n" }, "vgc", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "select BlockComment" })
      map({ "o", "x" }, "gC", function() require('mini.comment').textobject() end, { desc = "BlockComment textobj" })
      map({ "o", "x" }, "g>", "gn", { desc = "Next find textobj" })
      map({ "o", "x" }, "g<", "gN", { desc = "Prev find textobj" })

      -- ╭───────────────────────────────────────╮
      -- │ Text Objects with a/i (dot to repeat) │
      -- ╰───────────────────────────────────────╯

      map({ "o", "x" }, "ii", function() require("mini.ai").select_textobject("i", "i") end, { desc = "indent_noblanks" })
      map({ "o", "x" }, "ai", "<cmd>normal Viik<cr>", { desc = "indent_noblanks" })
      map(
        { "o", "x" },
        "iy",
        function()
          _G.skip_blank_line = true
          require("mini.ai").select_textobject("i", "y")
        end,
        { desc = "same_indent" }
      )
      map(
        { "o", "x" },
        "ay",
        function()
          _G.skip_blank_line = false
          require("mini.ai").select_textobject("i", "y")
        end,
        { desc = "same_indent" }
      )
      map({ "x" }, "iz", ":<c-u>normal! [zjV]z<cr>", { silent = true, desc = "inner fold" })
      map({ "o" }, "iz", ":normal Viz<CR>", { silent = true, desc = "inner fold" })
      map({ "x" }, "az", ":<c-u>normal! [zV]z<cr>", { silent = true, desc = "outer fold" })
      map({ "o" }, "az", ":normal Vaz<cr>", { silent = true, desc = "outer fold" })

      -- ╭──────────────────────────────────────────╮
      -- │ Repeatable Pair - motions using <leader> │
      -- ╰──────────────────────────────────────────╯

      local M = {}
      M.last_move = {}

      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/lua/nvim-treesitter/textobjects/repeatable_move.lua
      M.repeat_last_move = function(opts_extend)
        if M.last_move then
          local opts = vim.tbl_deep_extend("force", {}, M.last_move.opts, opts_extend)
          M.last_move.func(opts, unpack(M.last_move.additional_args))
        end
      end

      map({ "n", "x", "o" }, ";", function() M.repeat_last_move { forward = true } end, { desc = "Next TS textobj" })
      map({ "n", "x", "o" }, ",", function() M.repeat_last_move { forward = false } end, { desc = "Prev TS textobj" })

      M.make_repeatable_move_pair = function(forward_move_fn, backward_move_fn)
        local set_last_move = function(move_fn, opts, ...)
          M.last_move = { func = move_fn, opts = vim.deepcopy(opts), additional_args = { ... } }
        end

        local general_repeatable_move_fn = function(opts, ...)
          if opts.forward then
            forward_move_fn(...)
          else
            backward_move_fn(...)
          end
        end

        local repeatable_forward_move_fn = function(...)
          set_last_move(general_repeatable_move_fn, { forward = true }, ...)
          forward_move_fn(...)
        end

        local repeatable_backward_move_fn = function(...)
          set_last_move(general_repeatable_move_fn, { forward = false }, ...)
          backward_move_fn(...)
        end

        return repeatable_forward_move_fn, repeatable_backward_move_fn
      end

      local next_columnmove, prev_columnmove = M.make_repeatable_move_pair(
        function() M.ColumnMove(1) end,
        function() M.ColumnMove(-1) end
      )
      map({ "n", "x", "o" }, "<leader><leader>j", next_columnmove, { desc = "Next ColumnMove" })
      map({ "n", "x", "o" }, "<leader><leader>k", prev_columnmove, { desc = "Prev ColumnMove" })

      -- ╭──────────────────────────────────────────────────╮
      -- │ Repeatable Pair - textobj navigation using gn/gp │
      -- ╰──────────────────────────────────────────────────╯

      local next_diagnostic, prev_diagnostic = M.make_repeatable_move_pair(
        function() vim.diagnostic.jump({ count = 1, float = true }) end,
        function() vim.diagnostic.jump({ count = -1, float = true }) end
      )
      map({ "n", "x", "o" }, "gnd", next_diagnostic, { desc = "Diagnostic" })
      map({ "n", "x", "o" }, "gpd", prev_diagnostic, { desc = "Diagnostic" })

      local next_hunk_repeat, prev_hunk_repeat = M.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { silent = true, desc = "Next GitHunk" })
      map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { silent = true, desc = "Prev GitHunk" })

      local next_comment, prev_comment = M.make_repeatable_move_pair(
        function() require("mini.bracketed").comment("forward") end,
        function() require("mini.bracketed").comment("backward") end
      )
      map({ "n", "x", "o" }, "gnc", next_comment, { desc = "Comment" })
      map({ "n", "x", "o" }, "gpc", prev_comment, { desc = "Comment" })

      local next_fold, prev_fold = M.make_repeatable_move_pair(
        function() vim.cmd([[ normal ]z ]]) end,
        function() vim.cmd([[ normal [z ]]) end
      )
      map({ "n", "x", "o" }, "gnf", next_fold, { desc = "Fold ending" })
      map({ "n", "x", "o" }, "gpf", prev_fold, { desc = "Fold beginning" })

      local repeat_mini_ai = function(inner_or_around, key, desc)
        local next, prev = M.make_repeatable_move_pair(
          function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "next" }) end,
          function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "prev" }) end
        )
        map({ "n", "x", "o" }, "gn" .. inner_or_around .. key, next, { desc = desc })
        map({ "n", "x", "o" }, "gp" .. inner_or_around .. key, prev, { desc = desc })
      end

      repeat_mini_ai("i", "a", "argument")
      repeat_mini_ai("a", "a", "argument")
      repeat_mini_ai("i", "b", "brace")
      repeat_mini_ai("a", "b", "brace")
      repeat_mini_ai("i", "f", "func_call")
      repeat_mini_ai("a", "f", "func_call")
      repeat_mini_ai("i", "h", "html_atrib")
      repeat_mini_ai("a", "h", "html_atrib")
      repeat_mini_ai("i", "k", "key")
      repeat_mini_ai("a", "k", "key")
      repeat_mini_ai("i", "m", "number")
      repeat_mini_ai("a", "m", "number")
      repeat_mini_ai("i", "o", "whitespace")
      repeat_mini_ai("a", "o", "whitespace")
      repeat_mini_ai("i", "q", "quote")
      repeat_mini_ai("a", "q", "quote")
      repeat_mini_ai("i", "t", "tag")
      repeat_mini_ai("a", "t", "tag")
      repeat_mini_ai("i", "u", "subword")
      repeat_mini_ai("a", "u", "subword")
      repeat_mini_ai("i", "v", "value")
      repeat_mini_ai("a", "v", "value")
      repeat_mini_ai("i", "x", "hexadecimal")
      repeat_mini_ai("a", "x", "hexadecimal")
      repeat_mini_ai("i", "?", "user_prompt")
      repeat_mini_ai("a", "?", "user_prompt")
    end,
  },
}
