return {

  {
    "Exafunction/codeium.vim", -- run `:Codeium Auth` then `:Codeium Enable` see: https://github.com/Exafunction/codeium.vim/issues/376
    version = "v1.*.*",
    event = "InsertEnter",
    opts = {}
  },
  {
    "folke/flash.nvim",
    version = "v2.*.*",
    event = "VeryLazy",
    opts = { modes = { search = { enabled = true } } },
  },
  {
    "echasnovski/mini.nvim",
    commit = "04649417dd63f470f74f5ce23f9b39a827de0058",
    event = "VeryLazy",
    config = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter

      require("mini.ai").setup({
        custom_textobjects = {
          B = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
          q = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
          Q = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
          g = spec_treesitter({ a = "@comment.outer", i = "@comment.inner" }),
          G = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
          F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          L = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
          P = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
          R = spec_treesitter({ a = "@return.outer", i = "@return.inner" }),
          ["A"] = spec_treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
          ["="] = spec_treesitter({ a = "@assignment.rhs", i = "@assignment.lhs" }),
          ["#"] = spec_treesitter({ a = "@number.outer", i = "@number.inner" }),
          h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } }, -- html attribute textobj
          k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" },                                       -- key textobj
          v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },                                                  -- value textobj
          n = { '[-+]?()%f[%d]%d+()%.?%d*' },                                                                               -- number(inside string) textobj
          x = { '#()%x%x%x%x%x%x()' },                                                                                      -- hexadecimal textobj
          o = { "%S()%s+()%S" },                                                                                            -- whitespace textobj
          u = { { "%b''", '%b""', '%b``' }, '^.().*().$' },                                                                 -- quote textobj
        },
      })

      require("mini.files").setup({
        windows = {
          max_number = math.huge,
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 60,
        },
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

      require('mini.base16').setup({
        palette = {
          base00 = "#1a1b26", -- default bg
          base01 = "#16161e", -- line number bg
          base02 = "#2f3549", -- statusline bg, selection bg
          base03 = "#444b6a", -- line number fg, comments
          base04 = "#787c99", -- statusline fg
          base05 = "#a9b1d6", -- default fg, delimiters
          base06 = "#cbccd1", -- light fg (not often used)
          base07 = "#d5d6db", -- light bg (not often used)
          base08 = "#7aa2f7", -- variables, tags, Diff delete
          base09 = "#ff9e64", -- integers, booleans, constants, search fg
          base0A = "#0db9d7", -- classes, search bg
          base0B = "#73daca", -- strings, Diff insert
          base0C = "#2ac3de", -- builtins, regex
          base0D = "#7aa2f7", -- functions
          base0E = "#bb9af7", -- keywords, Diff changed
          base0F = "#7aa2f7", -- punctuation, indentscope
        }
      })

      vim.api.nvim_set_hl(0, "@property", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "@field", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "@keyword", { fg = "#9d7cd8" })
      vim.api.nvim_set_hl(0, "@keyword.function", { fg = "#6e51a2" })
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = "#1c1c2c" })
      vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#1c1c2c" })
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#506477", bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "Statusline", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatuslineNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#1abc9c" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#3c3cff" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#880000" })
      vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", bg = "#2c2c2c" })

      require('mini.align').setup()
      require('mini.bracketed').setup()
      require('mini.cursorword').setup()
      require('mini.extra').setup()
      require('mini.operators').setup()
      require('mini.pairs').setup()
      require('mini.pick').setup()
      require('mini.splitjoin').setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "a8535b2329a082c7f4e0b11b91b1792770425eaa",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", commit = "33a17515b79ddb10d750320fa994098bdc3e93ef" },
    event = "VeryLazy",
    opts = {
      textobjects = {
        move = {
          goto_previous_start = {
            ['gpaB'] = '@block.outer',
            ['gpaq'] = '@call.outer',
            ['gpaQ'] = '@class.outer',
            ['gpag'] = '@comment.outer',
            ['gpaG'] = '@conditional.outer',
            ['gpaF'] = '@function.outer',
            ['gpaL'] = '@loop.outer',
            ['gpaP'] = '@parameter.outer',
            ['gpaR'] = '@return.outer',
            ['gpaA'] = '@assignment.outer',
            ['gpa='] = '@assignment.lhs',
            ['gpa#'] = '@number.outer',
            ["gpz"] = { query = "@fold", query_group = "folds", desc = "Previous Start Fold" },
            ["gpZ"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },
            ['gpiB'] = '@block.inner',
            ['gpiq'] = '@call.inner',
            ['gpiQ'] = '@class.inner',
            ['gpig'] = '@comment.inner',
            ['gpiG'] = '@conditional.inner',
            ['gpiF'] = '@function.inner',
            ['gpiL'] = '@loop.inner',
            ['gpiP'] = '@parameter.inner',
            ['gpiR'] = '@return.inner',
            ['gpiA'] = '@assignment.inner',
            ['gpi='] = '@assignment.rhs',
            ['gpi#'] = '@number.inner',
          },
          goto_next_start = {
            ['gnaB'] = '@block.outer',
            ['gnaq'] = '@call.outer',
            ['gnaQ'] = '@class.outer',
            ['gnag'] = '@comment.outer',
            ['gnaG'] = '@conditional.outer',
            ['gnaF'] = '@function.outer',
            ['gnaL'] = '@loop.outer',
            ['gnaP'] = '@parameter.outer',
            ['gnaR'] = '@return.outer',
            ['gnaA'] = '@assignment.outer',
            ['gna='] = '@assignment.lhs',
            ['gna#'] = '@number.outer',
            ["gnz"] = { query = "@fold", query_group = "folds", desc = "Next Start Fold" },
            ["gnZ"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ['gniB'] = '@block.inner',
            ['gniq'] = '@call.inner',
            ['gniQ'] = '@class.inner',
            ['gnig'] = '@comment.inner',
            ['gniG'] = '@conditional.inner',
            ['gniF'] = '@function.inner',
            ['gniL'] = '@loop.inner',
            ['gniP'] = '@parameter.inner',
            ['gniR'] = '@return.inner',
            ['gniA'] = '@assignment.inner',
            ['gni='] = '@assignment.rhs',
            ['gni#'] = '@number.inner',
          },
          goto_previous_end = {
            ['gpeaB'] = '@block.outer',
            ['gpeaq'] = '@call.outer',
            ['gpeaQ'] = '@class.outer',
            ['gpeag'] = '@comment.outer',
            ['gpeaG'] = '@conditional.outer',
            ['gpeaF'] = '@function.outer',
            ['gpeaL'] = '@loop.outer',
            ['gpeaP'] = '@parameter.outer',
            ['gpeaR'] = '@return.outer',
            ['gpeaA'] = '@assignment.lhs',
            ['gpea='] = '@assignment.outer',
            ['gpea#'] = '@number.outer',
            ["gpez"] = { query = "@fold", query_group = "folds", desc = "Previous End Fold" },
            ["gpeZ"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ['gpeiB'] = '@block.inner',
            ['gpeiq'] = '@call.inner',
            ['gpeiQ'] = '@class.inner',
            ['gpeig'] = '@comment.inner',
            ['gpeiG'] = '@conditional.inner',
            ['gpeiF'] = '@function.inner',
            ['gpeiL'] = '@loop.inner',
            ['gpeiP'] = '@parameter.inner',
            ['gpeiR'] = '@return.inner',
            ['gpeiA'] = '@assignment.inner',
            ['gpei='] = '@assignment.rhs',
            ['gpei#'] = '@number.inner',
          },
          goto_next_end = {
            ['gneaB'] = '@block.outer',
            ['gneaq'] = '@call.outer',
            ['gneaQ'] = '@class.outer',
            ['gneag'] = '@comment.outer',
            ['gneaG'] = '@conditional.outer',
            ['gneaF'] = '@function.outer',
            ['gneaL'] = '@loop.outer',
            ['gneaP'] = '@parameter.outer',
            ['gneaR'] = '@return.outer',
            ['gneaA'] = '@assignment.outer',
            ['gnea='] = '@assignment.lhs',
            ['gnea#'] = '@number.outer',
            ["gnez"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["gneZ"] = { query = "@fold", query_group = "folds", desc = "Next End Fold" },
            ['gneiB'] = '@block.inner',
            ['gneiq'] = '@call.inner',
            ['gneiQ'] = '@class.inner',
            ['gneig'] = '@comment.inner',
            ['gneiG'] = '@conditional.inner',
            ['gneiF'] = '@function.inner',
            ['gneiL'] = '@loop.inner',
            ['gneiP'] = '@parameter.inner',
            ['gneiR'] = '@return.inner',
            ['gneiA'] = '@assignment.inner',
            ['gnei='] = '@assignment.rhs',
            ['gnei#'] = '@number.inner',
          }
        }
      }
    }
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    commit = "52343c70e2487095cafd4a5000d0465a2b992b03",
    opts = { useDefaultKeymaps = false, lookForwardSmall = 30, lookForwardBig = 30 },
    event = "VeryLazy",
    config = function()
      -- ╭──────╮
      -- │ Opts │
      -- ╰──────╯

      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = '1'                              -- if '1' will show clickable fold signs
      vim.o.foldlevel = 99                                -- Disable folding at startup
      vim.o.foldmethod = "expr"                           -- "expr" = required by treesitter, "indent" = if no treesitter
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- folding using treesitter (grammar required)
      vim.opt.virtualedit = "all"                         -- allow cursor bypass end of line
      vim.opt.relativenumber = false                      -- set relative numbered lines
      vim.o.statuscolumn =
      '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "▼" : "⏵") : " " }%s%l '

      -- ╭──────────────╮
      -- │ Autocommands │
      -- ╰──────────────╯

      vim.cmd [[

        augroup _general_settings
          autocmd!
          autocmd BufEnter     * :set formatoptions-=cro
          autocmd BufReadPost  * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
          autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
        augroup end

        augroup _hightlight_whitespaces
          autocmd!
          autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
          highlight ExtraWhitespace ctermbg=red guibg=red
          autocmd InsertLeave * redraw!
          match ExtraWhitespace /\s\+$\| \+\ze\t/
          autocmd BufWritePre * :%s/\s\+$//e
        augroup end

      ]]

      ------------------------------------------------------------------------------------------------------------------------

      local M = {}

      -- https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/
      M.EnableAutoNoHighlightSearch = function()
        vim.on_key(function(char)
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<Up>", "<Down>", "<CR>", "n", "N", "*", "#", "?", "/" },
              vim.fn.keytrans(char))
            if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
          end
        end, vim.api.nvim_create_namespace "auto_hlsearch")
      end

      M.DisableAutoNoHighlightSearch = function()
        vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])
        vim.cmd [[ set hlsearch ]]
      end

      M.EnableAutoNoHighlightSearch() -- autostart

      ------------------------------------------------------------------------------------------------------------------------

      function GotoTextObj_Callback()
        vim.api.nvim_feedkeys(vim.g.dotargs, "n", true)
      end

      _G.GotoTextObj = function(motion, selection_char, selection_line, selection_block)
        vim.g.dotargs = motion

        if vim.fn.mode() == "v" then
          vim.g.dotargs = selection_char
        end

        if vim.fn.mode() == "V" then
          vim.g.dotargs = selection_line
        end

        if vim.fn.mode() == "\22" then
          vim.g.dotargs = selection_block
        end

        vim.o.operatorfunc = 'v:lua.GotoTextObj_Callback'
        return "<esc>m'g@"
      end

      ------------------------------------------------------------------------------------------------------------------------

      -- https://thevaluable.dev/vim-create-text-objects
      -- select indent by the same level:
      M.select_same_indent = function(skip_blank_line, skip_comment_line)
        local start_indent = vim.fn.indent(vim.fn.line('.'))
        local get_comment_regex = "^%s*" .. string.gsub(vim.bo.commentstring, "%%s", ".*") .. "%s*$"
        local is_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
        local is_comment_line = function(line) return string.find(vim.fn.getline(line), get_comment_regex) end

        -- go up while having the same indent
        local prev_line = vim.fn.line('.') - 1
        while vim.fn.indent(prev_line) == start_indent or (is_blank_line(prev_line) and vim.fn.indent(prev_line) ~= -1) do
          if skip_blank_line and is_blank_line(prev_line) then break end
          if skip_comment_line and is_comment_line(prev_line) then break end
          vim.cmd('-')
          prev_line = prev_line - 1
        end

        vim.cmd('normal! V')

        -- go down while having the same indent
        local next_line = vim.fn.line('.') + 1
        while vim.fn.indent(next_line) == start_indent or (is_blank_line(next_line) and vim.fn.indent(next_line) ~= -1) do
          if skip_blank_line and is_blank_line(next_line) then break end
          if skip_comment_line and is_comment_line(next_line) then break end
          vim.cmd('+')
          next_line = next_line + 1
        end
      end

      ------------------------------------------------------------------------------------------------------------------------

      -- https://github.com/romgrk/columnMove.vim
      M.ColumnMove = function(direction)
        local lnum = vim.fn.line('.')
        local colnum = vim.fn.virtcol('.')
        local remove_extraline = false
        local pattern1, pattern2
        local match_char = function(lnum, pattern) return vim.fn.getline(lnum):sub(colnum, colnum):match(pattern) end

        if match_char(lnum, '%S') then
          pattern1 = '^$'         -- pattern to stop at empty char
          pattern2 = '%s'         -- pattern to stop at blankspace
          lnum = lnum + direction -- continue (to the blankspace and emptychar conditional) when at end of line
          remove_extraline = true
          -- vim.notify("no_blankspace")
        end

        if match_char(lnum, '%s') then
          pattern1 = '%S'
          pattern2 = nil
          remove_extraline = false
          -- vim.notify("blankspace")
        end

        if match_char(lnum, '^$') then
          pattern1 = '%S'
          pattern2 = nil
          remove_extraline = false
          -- vim.notify("emptychar")
        end

        while lnum >= 0 and lnum <= vim.fn.line('$') do
          if match_char(lnum, pattern1) then
            break
          end

          if pattern2 then
            if match_char(lnum, pattern2) then
              break
            end
          end

          lnum = lnum + direction
        end

        -- If the match was at the end of the line, return the previous line number and the current column number
        if remove_extraline then
          vim.cmd.normal(lnum - direction .. "gg" .. colnum .. "|")
        else
          vim.cmd.normal(lnum .. "gg" .. colnum .. "|")
        end
      end

      --------------------------------------------------------------------------------------------------------------------

      -- ╭────────────╮
      -- │ Navigation │
      -- ╰────────────╯

      local flash = require("flash")
      local gs = require("gitsigns")
      local textobjs = require("various-textobjs")
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local map = vim.keymap.set

      map({ "i" }, "jk", "<ESC>")
      map({ "i" }, "kj", "<ESC>")
      map({ "n" }, "J", "10gj")
      map({ "n" }, "K", "10gk")
      map({ "n" }, "H", "10h")
      map({ "n" }, "L", "10l")
      map({ "n" }, "Y", "yg_", { desc = "Yank forward" })  -- "Y" yank forward by default
      map({ "v" }, "Y", "g_y", { desc = "Yank forward" })
      map({ "v" }, "P", "g_P", { desc = "Paste forward" }) -- "P" doesn't change register
      map({ "v" }, "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
      map({ "n" }, "Q", "<cmd>lua vim.cmd('quit')<cr>")
      map({ "n" }, "R", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 }) vim.cmd('silent write') <cr>")
      map({ "n" }, "U", "@:", { desc = "repeat last command" })
      map({ "v" }, "<", "<gv", { desc = "continious indent" })
      map({ "v" }, ">", ">gv", { desc = "continious indent" })
      map({ "n", "v", "t" }, "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
      map({ "n", "v", "t" }, "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
      map({ "n", "v", "t" }, "<M-Up>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
      map({ "n", "v", "t" }, "<M-Down>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
      map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
      map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
      map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
      map({ "t", "n" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window" })
      map({ "t", "n" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window" })
      map({ "t", "n" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "right window" })
      map({ "t", "n" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window" })
      map({ "t", "n" }, "<C-;>", "<C-\\><C-n><C-6>", { desc = "go to last buffer" })
      map({ "n" }, "<right>", ":bnext<CR>", { desc = "next buffer" })
      map({ "n" }, "<left>", ":bprevious<CR>", { desc = "prev buffer" })
      map({ "n" }, "<leader>x", ":bp | bd! #<CR>", { desc = "Close Buffer" }) -- `bd!` forces closing terminal buffer
      map({ "n" }, "<leader>X", ":tabclose<CR>", { desc = "Close Tab" })

      -- ╭────────────────╮
      -- │ leader keymaps │
      -- ╰────────────────╯

      map("n", "<leader>o", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0),true)<cr>", { desc = "Open Explorer" })
      map("n", "<leader>f/", ":Pick files<cr>", { desc = "Pick Files (tab to preview)" })
      map("n", "<leader>fF", ":Pick grep_live<cr>", { desc = "Pick Grep (tab to preview)" })
      map("n", "<leader>f'", ":Pick marks<cr>", { desc = "Pick Marks (tab to preview)" })
      map("n", "<leader>fR", ":Pick registers<cr>", { desc = "Pick register" })
      map("n", "<leader>u0", ":set showtabline=0<cr>", { desc = "Buffer Hide" })
      map("n", "<leader>u2", ":set showtabline=2<cr>", { desc = "Buffer Show" })
      map("n", "<leader>us", ":set laststatus=0<cr>", { desc = "StatusBar Hide" })
      map("n", "<leader>uS", ":set laststatus=3<cr>", { desc = "StatusBar Show" })
      map("n", "<leader>uh", function() M.EnableAutoNoHighlightSearch() end, { desc = "Enable AutoNoHighlightSearch" })
      map("n", "<leader>uH", function() M.DisableAutoNoHighlightSearch() end, { desc = "Disable AutoNoHighlightSearch" })
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

      map(
        { "n", "x" },
        "g<",
        function() return GotoTextObj("`<", "`<v`'", "`<V`'", "`<\22`'") end,
        { expr = true, desc = "StartOf TextObj (dot to repeat)" }
      )
      map(
        { "n", "x" },
        "g>",
        function() return GotoTextObj("`>", "`'v`>", "`'V`>", "`'\22`>") end,
        { expr = true, desc = "EndOf TextObj (dot to repeat)" }
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

      -- ╭───────────────────────────────────────╮
      -- │ Text Objects with "g" (dot to repeat) │
      -- ╰───────────────────────────────────────╯

      map({ "x" }, "gC", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "BlockComment textobj" })
      map({ "o" }, "gC", ":<c-u>lua require('mini.comment').textobject()<cr>", { desc = "BlockComment textobj" })
      map({ "n" }, "vgc", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "BlockComment textobj" })
      map({ "o", "x" }, "gf", "gn", { desc = "Next find textobj" })
      map({ "o", "x" }, "gF", "gN", { desc = "Prev find textobj" })
      map({ "o", "x" }, "gh", ":<c-u>Gitsigns select_hunk<cr>", { desc = "Git hunk textobj" })
      map({ "o", "x" }, "gd", function() textobjs.diagnostic() end, { desc = "Diagnostic textobj" })
      map({ "o", "x" }, "gK", function() textobjs.column() end, { desc = "ColumnDown textobj" })
      map({ "o", "x" }, "gl", function() textobjs.lastChange() end, { desc = "last modified/yank/paste (noRepeaterKey)" }) -- `vgm` and `dgm` works. `cgm` and `ygm` doesn't work but it notifies
      map({ "o", "x" }, "gL", function() textobjs.url() end, { desc = "Url textobj" })
      map({ "o", "x" }, "go", function() textobjs.restOfWindow() end, { desc = "RestOfWindow textobj" })
      map({ "o", "x" }, "gO", function() textobjs.visibleInWindow() end, { desc = "VisibleWindow textobj" })
      map({ "o", "x" }, "gt", function() textobjs.toNextQuotationMark() end, { desc = "toNextQuotationMark textobj" })
      map({ "o", "x" }, "gT", function() textobjs.toNextClosingBracket() end, { desc = "toNextClosingBracket textobj" })

      -- ╭───────────────────────────────────────╮
      -- │ Text Objects with a/i (dot to repeat) │
      -- ╰───────────────────────────────────────╯

      map({ "o", "x" }, "ad", function() textobjs.greedyOuterIndentation('outer') end, { desc = "greddyOuterIndent" })
      map({ "o", "x" }, "id", function() textobjs.greedyOuterIndentation('inner') end, { desc = "greddyOuterIndent" })
      map({ "o", "x" }, "ie", function() textobjs.nearEoL() end, { desc = "nearEndOfLine textobj" })
      map({ "o", "x" }, "ae", function() textobjs.lineCharacterwise('inner') end, { desc = "lineCharacterwise" })
      map({ "o", "x" }, "ii", function() textobjs.indentation("inner", "inner", "noBlanks") end, { desc = "indent" })
      map({ "o", "x" }, "ai", function() textobjs.indentation("outer", "outer", "noBlanks") end, { desc = "indent" })
      map({ "o", "x" }, "iI", function() textobjs.indentation("inner", "inner") end, { desc = "Indent blanklines" })
      map({ "o", "x" }, "aI", function() textobjs.indentation("outer", "outer") end, { desc = "Indent blanklines" })
      map({ "o", "x" }, "aj", function() textobjs.cssSelector('outer') end, { desc = "cssSelector" })
      map({ "o", "x" }, "ij", function() textobjs.cssSelector('inner') end, { desc = "cssSelector" })
      map({ "o", "x" }, "am", function() textobjs.chainMember('outer') end, { desc = "chainMember" })
      map({ "o", "x" }, "im", function() textobjs.chainMember('inner') end, { desc = "chainMember" })
      map({ "o", "x" }, "aM", function() textobjs.mdFencedCodeBlock('outer') end, { desc = "mdFencedCodeBlock" })
      map({ "o", "x" }, "iM", function() textobjs.mdFencedCodeBlock('inner') end, { desc = "mdFencedCodeBlock" })
      map({ "o", "x" }, "ir", function() textobjs.restOfParagraph() end, { desc = "RestOfParagraph" })
      map({ "o", "x" }, "ar", function() textobjs.restOfIndentation() end, { desc = "restOfIndentation" })
      map({ "o", "x" }, "aS", function() textobjs.subword('outer') end, { desc = "Subword" })
      map({ "o", "x" }, "iS", function() textobjs.subword('inner') end, { desc = "Subword" })
      map({ "o", "x" }, "aU", function() textobjs.pyTripleQuotes('outer') end, { desc = "pyTrippleQuotes" })
      map({ "o", "x" }, "iU", function() textobjs.pyTripleQuotes('inner') end, { desc = "pyTrippleQuotes" })
      map({ "x", "o" }, "iy", function() M.select_same_indent(true, true) end, { desc = "same_indent" })
      map({ "x", "o" }, "ay", function() M.select_same_indent(false, false) end, { desc = "same_indent blank" })
      map({ "o", "x" }, "aZ", function() textobjs.closedFold('outer') end, { desc = "ClosedFold" })
      map({ "o", "x" }, "iZ", function() textobjs.closedFold('inner') end, { desc = "ClosedFold" })
      map({ "x" }, "iz", ":<c-u>normal! [zjV]zk<cr>", { desc = "inner fold" })
      map({ "o" }, "iz", ":normal Viz<CR>", { desc = "inner fold" })
      map({ "x" }, "az", ":<c-u>normal! [zV]z<cr>", { desc = "outer fold" })
      map({ "o" }, "az", ":normal Vaz<cr>", { desc = "outer fold" })

      -- ╭──────────────────────────────────────────╮
      -- │ Repeatable Pair - motions using <leader> │
      -- ╰──────────────────────────────────────────╯

      map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Next TS textobj" })
      map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Prev TS textobj" })

      local next_columnmove, prev_columnmove = ts_repeat_move.make_repeatable_move_pair(
        function() M.ColumnMove(1) end,
        function() M.ColumnMove(-1) end
      )
      map({ "n", "x", "o" }, "<leader><leader>j", next_columnmove, { desc = "Next ColumnMove" })
      map({ "n", "x", "o" }, "<leader><leader>k", prev_columnmove, { desc = "Prev ColumnMove" })

      -- ╭──────────────────────────────────────────────────╮
      -- │ Repeatable Pair - textobj navigation using gn/gp │
      -- ╰──────────────────────────────────────────────────╯

      local next_comment, prev_comment = ts_repeat_move.make_repeatable_move_pair(
        function() require("mini.bracketed").comment("forward") end,
        function() require("mini.bracketed").comment("backward") end
      )
      map({ "n", "x", "o" }, "gnc", next_comment, { desc = "Next Comment" })
      map({ "n", "x", "o" }, "gpc", prev_comment, { desc = "Prev Comment" })

      local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(
        function() vim.diagnostic.jump({ count = 1, float = true }) end,
        function() vim.diagnostic.jump({ count = -1, float = true }) end
      )
      map({ "n", "x", "o" }, "gnd", next_diagnostic, { desc = "Next Diagnostic" })
      map({ "n", "x", "o" }, "gpd", prev_diagnostic, { desc = "Prev Diagnostic" })

      local next_fold, prev_fold = ts_repeat_move.make_repeatable_move_pair(
        function() vim.cmd([[ normal ]z ]]) end,
        function() vim.cmd([[ normal [z ]]) end
      )
      map({ "n", "x", "o" }, "gnf", next_fold, { desc = "Fold ending" })
      map({ "n", "x", "o" }, "gpf", prev_fold, { desc = "Fold beginning" })

      local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { desc = "Next GitHunk" })
      map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { desc = "Prev GitHunk" })

      local repeat_mini_ai = function(inner_or_around, key, desc)
        local next, prev = ts_repeat_move.make_repeatable_move_pair(
          function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "next" }) end,
          function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "prev" }) end
        )
        map({ "n", "x", "o" }, "gn" .. inner_or_around .. key, next, { desc = desc })
        map({ "n", "x", "o" }, "gp" .. inner_or_around .. key, prev, { desc = desc })
      end

      repeat_mini_ai("i", "f", "function call")
      repeat_mini_ai("a", "f", "function call")
      repeat_mini_ai("i", "h", "html atrib")
      repeat_mini_ai("a", "h", "html atrib")
      repeat_mini_ai("i", "k", "key")
      repeat_mini_ai("a", "k", "key")
      repeat_mini_ai("i", "n", "number")
      repeat_mini_ai("a", "n", "number")
      repeat_mini_ai("i", "u", "quote")
      repeat_mini_ai("a", "u", "quote")
      repeat_mini_ai("i", "v", "value")
      repeat_mini_ai("a", "v", "value")
      repeat_mini_ai("i", "x", "hexadecimal")
      repeat_mini_ai("a", "x", "hexadecimal")
    end
  }
}
