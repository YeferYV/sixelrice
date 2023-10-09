local cmd = vim.api.nvim_create_autocmd
local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set
local opts = { noremap = true, silent = true }


local polishconf = function()
  -- ╭─────────╮
  -- │ Autocmd │
  -- ╰─────────╯

  -- _autostart_EnableAutoNoHighlightSearch
  EnableAutoNoHighlightSearch()

  ------------------------------------------------------------------------------------------------------------------------

  -- _jump_to_last_position_on_reopen
  vim.cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

  ------------------------------------------------------------------------------------------------------------------------

  -- _disable_autocommented_new_lines
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      vim.opt.formatoptions:remove { "c", "r", "o" }
    end,
  })

  ------------------------------------------------------------------------------------------------------------------------

  -- _show_bufferline_if_more_than_two
  cmd({ "BufAdd" }, { command = "set showtabline=2" })

  ------------------------------------------------------------------------------------------------------------------------

  -- _hide_bufferline_if_last_buffer
  cmd({ "BufDelete" }, {
    callback = function()
      if #vim.fn.getbufinfo({ buflisted = true }) == 2 then
        vim.o.showtabline = 0
      end
    end,
  })

  ------------------------------------------------------------------------------------------------------------------------

  -- _show_tabs_if_more_than_two
  cmd({ "TabNew" }, { command = "set showtabline=2" })

  ------------------------------------------------------------------------------------------------------------------------

  -- _show_alpha_if_close_last_tab-terminal
  cmd({ "TermClose" }, {
    callback = function()
      local type = vim.bo.filetype
      if type == "sp-terminal" or type == "vs-terminal" or type == "buf-terminal" or type == "tab-terminal" then
        if #vim.api.nvim_list_tabpages() == 1 then
          vim.cmd [[ Alpha ]]
          vim.cmd [[ bd # ]]
        else
          if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
            vim.cmd [[ call feedkeys("\<Esc>\<Esc>:close\<CR>") ]]
          end
        end
        vim.cmd [[ call feedkeys("") ]]
      end
    end,
  })

  ------------------------------------------------------------------------------------------------------------------------

  -- https://thevaluable.dev/vim-create-text-objects
  -- select indent by the same level:
  function select_indent(check_blank_line)
    local start_indent = vim.fn.indent(vim.fn.line('.'))

    if check_blank_line then
      match_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
    else
      match_blank_line = function(line) return false end
    end

    local prev_line = vim.fn.line('.') - 1
    while vim.fn.indent(prev_line) == start_indent or match_blank_line(prev_line) do
      vim.cmd('-')
      prev_line = vim.fn.line('.') - 1
    end

    vim.cmd('normal! 0V')

    local next_line = vim.fn.line('.') + 1
    while vim.fn.indent(next_line) == start_indent or match_blank_line(next_line) do
      vim.cmd('+')
      next_line = vim.fn.line('.') + 1
    end
  end

  ------------------------------------------------------------------------------------------------------------------------

  -- next/prev same level indent:
  function next_indent(next)
    local start_indent = vim.fn.indent(vim.fn.line('.'))
    local next_line = next and ( vim.fn.line('.') + 1 ) or ( vim.fn.line('.') - 1 )
    local sign = next and '+' or '-'

    while vim.fn.indent(next_line) == start_indent do
      vim.cmd(sign)
      next_line = next and ( vim.fn.line('.') + 1 ) or ( vim.fn.line('.') - 1 )
    end

    while vim.fn.indent(next_line) > start_indent or string.match(vim.fn.getline(next_line), '^%s*$')  do
      vim.cmd(sign)
      next_line = next and ( vim.fn.line('.') + 1 ) or ( vim.fn.line('.') - 1 )
    end

    vim.cmd(sign)
  end

  ------------------------------------------------------------------------------------------------------------------------

  -- _custom_terminal_colors
  local lushwal_path = "~/.cache/wal/colors.json"
  if not vim.loop.fs_stat(lushwal_path) then
    black       =  "#1c1712"
    red         =  "#294e65"
    green       =  "#3b5967"
    yellow      =  "#4b6c74"
    blue        =  "#72817b"
    magenta     =  "#859489"
    cyan        =  "#8e9487"
    white       =  "#838283"
    br_black    =  "#454345"
    br_red      =  "#376887"
    br_green    =  "#4F778A"
    br_yellow   =  "#65919B"
    br_blue     =  "#99ADA5"
    br_magenta  =  "#B2C6B7"
    br_cyan     =  "#BEC6B4"
    br_white    =  "#c1c0c1"
    grey        =  "#565f89"
    br_grey     =  "#565f89"
    amaranth    =  "#376887"
  else
    local colors = require("lushwal").colors
    black       =  string.format("%s",colors.br_white.darken(90) )
    red         =  string.format("%s",colors.red       )
    green       =  string.format("%s",colors.green     )
    yellow      =  string.format("%s",colors.yellow    )
    blue        =  string.format("%s",colors.blue      )
    magenta     =  string.format("%s",colors.magenta   )
    cyan        =  string.format("%s",colors.cyan      )
    white       =  string.format("%s",colors.white     )
    br_black    =  string.format("%s",colors.br_black  )
    br_red      =  string.format("%s",colors.br_red    )
    br_green    =  string.format("%s",colors.br_green  )
    br_yellow   =  string.format("%s",colors.br_yellow )
    br_blue     =  string.format("%s",colors.br_blue   )
    br_magenta  =  string.format("%s",colors.br_magenta)
    br_cyan     =  string.format("%s",colors.br_cyan   )
    br_white    =  string.format("%s",colors.br_white  )
    grey        =  string.format("%s",colors.grey      )
    br_grey     =  string.format("%s",colors.br_grey   )
    amaranth    =  string.format("%s",colors.amaranth  )
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      local custom_themes = {
        tokyonight = {
          custom_colorscheme = {},
          custom_terminal_colors = {
            terminal_color_0  = '#222222',
            terminal_color_1  = '#990000',
            terminal_color_2  = '#009900',
            terminal_color_3  = '#999900',
            terminal_color_4  = '#5555cc',
            terminal_color_5  = '#8855ff',
            terminal_color_6  = '#5FB3A1',
            terminal_color_7  = '#a0a0a0',
            terminal_color_8  = '#6c6c6c',
            terminal_color_9  = '#ff0000',
            terminal_color_10 = '#00ff00',
            terminal_color_11 = '#ffff00',
            terminal_color_12 = '#1c1cff',
            terminal_color_13 = '#8844bb',
            terminal_color_14 = '#5DE4C7',
            terminal_color_15 = '#ffffff',
          }
        },
        poimandres = {
          custom_colorscheme = {},
          custom_terminal_colors = {
            terminal_color_0  = '#222222',
            terminal_color_1  = '#990000',
            terminal_color_2  = '#009900',
            terminal_color_3  = '#999900',
            terminal_color_4  = '#5555cc',
            terminal_color_5  = '#8855ff',
            terminal_color_6  = '#5FB3A1',
            terminal_color_7  = '#a0a0a0',
            terminal_color_8  = '#6c6c6c',
            terminal_color_9  = '#ff0000',
            terminal_color_10 = '#00ff00',
            terminal_color_11 = '#ffff00',
            terminal_color_12 = '#1c1cff',
            terminal_color_13 = '#8844bb',
            terminal_color_14 = '#5DE4C7',
            terminal_color_15 = '#ffffff',
          }
        },
        lushwal = {
          custom_colorscheme = {
            ["@comment"]               = { fg = "#3e4041" },
            ["Comment"]                = { fg = "#3e4041" },
            ["Visual"]                 = { bg = "#1c1c1c" },
            GitSignsAdd                = { fg = br_green  },
            GitSignsChange             = { fg = br_blue   },
            GitSignsDelete             = { fg = amaranth  },
            IndentBlanklineChar        = { fg = grey      },
            IndentBlanklineContextChar = { fg = br_white  },
            IlluminatedWordText        = { bg = "#080811" },
            IlluminatedWordRead        = { bg = "#080811" },
            IlluminatedWordWrite       = { bg = "#080811" },
            NotifyBackground           = { bg = "#000000" },
            LspReferenceRead           = { bg = "#080811" },
            LspReferenceText           = { bg = "#080811" },
            LspReferenceWrite          = { bg = "#080811" },
            PmenuSel                   = { bg = "#1c1c1c" },
            TelescopeSelection         = { bg = "#080811" },
            TelescopeSelectionCaret    = { bg = "#080811" },
            WinSeparator               = { fg = br_grey   },
          },
          custom_terminal_colors = {
            terminal_color_0  = black,
            terminal_color_1  = red,
            terminal_color_2  = green,
            terminal_color_3  = yellow,
            terminal_color_4  = blue,
            terminal_color_5  = magenta,
            terminal_color_6  = cyan,
            terminal_color_7  = white,
            terminal_color_8  = br_black,
            terminal_color_9  = br_red,
            terminal_color_10 = br_green,
            terminal_color_11 = br_yellow,
            terminal_color_12 = br_blue,
            terminal_color_13 = br_magenta,
            terminal_color_14 = br_cyan,
            terminal_color_15 = br_white,
          }
        }
      }

      local selected_colorscheme = custom_themes[vim.g.colors_name]
      if selected_colorscheme then
        -- setting custom_colorscheme
        for group, conf in pairs(selected_colorscheme.custom_colorscheme) do
          vim.api.nvim_set_hl(0, group, conf)
        end

        -- setting custom_terminal_colors
        for group, conf in pairs(selected_colorscheme.custom_terminal_colors) do
          vim.g[group] = conf
        end
      end
    end
  })
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. vim.g.colors_name)
  if not status_ok then
    return
  end

  -- ╭────────────╮
  -- │ Automation │
  -- ╰────────────╯

  -- Resize with arrows
  map({ 'n', 't' }, '<M-Left>', require('smart-splits').resize_left, opts)
  map({ 'n', 't' }, '<M-Down>', require('smart-splits').resize_down, opts)
  map({ 'n', 't' }, '<M-Up>', require('smart-splits').resize_up, opts)
  map({ 'n', 't' }, '<M-Right>', require('smart-splits').resize_right, opts)

  -- Navigate buffers
  keymap("n", "<right>", ":bnext<CR>", opts)
  keymap("n", "<left>", ":bprevious<CR>", opts)
  keymap("n", "<Home>", ":tabprevious<CR>", opts)
  keymap("n", "<End>", ":tabnext<CR>", opts)
  keymap("n", "<Insert>", ":tabnext #<CR>", opts)
  keymap("t", "<Home>", "<C-\\><C-n>:tabprevious<CR>", opts)
  keymap("t", "<End>", "<C-\\><C-n>:tabnext<CR>", opts)
  keymap("t", "<Insert>", "<C-\\><C-n>:tabnext #<CR>", opts)
  keymap("n", "<Tab>", ":bnext<CR>", opts)
  keymap("n", "<S-Tab>", ":bprevious<CR>", opts)
  keymap("n", "<leader>x", ":bp | bd #<CR>", { silent = true, desc = "Close Buffer" })
  keymap("n", "<leader><Tab>", ":tabnext<CR>", opts)
  keymap("n", "<leader><S-Tab>", ":tabprevious<CR>", opts)
  keymap("n", "<leader>X", ":tabclose<CR>", { silent = true, desc = "Close Tab" })
  keymap("n", "g,", "g,", { noremap = true, silent = true, desc = "go forward in :changes" })
  keymap("n", "g;", "g;", { noremap = true, silent = true, desc = "go backward in :changes" })
  keymap("n", "gb;", "<C-6>", { noremap = true, silent = true, desc = "go to last buffer" })
  keymap("n", "<C-;>", "<C-6>", { noremap = true, silent = true, desc = "go to last buffer" })

  -- Macros and :normal <keys> repeatable
  keymap("n", "U", "@:", opts)

  -- Replace all/visual_selected
  map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { silent = true, desc = "Replace in Buffer" })
  map({ "x" }, "<C-s>", ":s//g<Left><Left>", { silent = true, desc = "Replace in Visual_selected" })

  -- _codeium_completion
  -- map('i', '<A-h>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  map('i', '<A-j>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
  map('i', '<A-k>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
  map('i', '<A-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })

  keymap("i", "<C-e>", "<esc><C-e>a", opts)
  keymap("i", "<C-y>", "<esc><C-y>a", opts)
  keymap("i", "<C-n>", "<C-e>", opts) -- completes next line
  keymap("i", "<C-p>", "<C-y>", opts) -- completes previous line
  map('i', '<C-h>', function() require('lsp_signature').toggle_float_win() end, opts)

  map('i', '<C-v>', function()
    if vim.g.diagnosticsEnabled == "on" or vim.g.diagnosticsEnabled == nil then
      vim.g.diagnosticsEnabled = "off"
      vim.diagnostic.config({ virtual_text = false })
      vim.cmd [[
        augroup _toggle_virtualtext_insertmode
        autocmd InsertEnter * lua vim.diagnostic.config({ virtual_text = false })
        autocmd InsertLeave * lua vim.diagnostic.config({ virtual_text = true })
        augroup end
      ]]
    else
      vim.g.diagnosticsEnabled = "on"
      vim.diagnostic.config({ virtual_text = true })
      vim.cmd [[ autocmd! _toggle_virtualtext_insertmode ]]
    end
  end, { silent = true, desc = "Toggle VirtualText (InsertMode Only)" })

  -- ╭──────────────╮
  -- │ Text Objects │
  -- ╰──────────────╯

  -- _goto_textobj_(dotrepeat)
  map('n', "g.", function() return GotoTextObj("") end, { expr = true, silent = true, desc = "StartOf TextObj" })
  map('n', "g:", function() return GotoTextObj(":normal `[v`]<cr><esc>") end,
    { expr = true, silent = true, desc = "EndOf TextObj" })

  -- _last_change_text_object
  map("o", 'gm', "<cmd>normal! `[v`]<Left><cr>", { silent = true, desc = "Last change textobj" })
  map("x", 'gm', "`[o`]<Left>", { silent = true, desc = "Last change textobj" })

  -- _git_hunk_(next/prev_autojump_unsupported)
  map({ 'o', 'x' }, 'gh', ':<C-U>Gitsigns select_hunk<CR>', { silent = true, desc = "Git hunk textobj" })

  -- _jump_to_last_change
  map({ "n", "o", "x" }, "gl", "`.", { silent = true, desc = "Jump to last change" })

-- _mini_comment_(not_showing_desc)_(next/prev_autojump_unsupported)_(gC and gk visual support for gc and gk textobj)
  map({ "o" }, 'gk', '<Cmd>lua MiniComment.textobject()<CR>', { silent = true, desc = "BlockComment textobj" })
  map({ "x" }, 'gk', ':<C-u>normal "zygkgv<cr>', { silent = true, desc = "BlockComment textobj" })
  map({ "x" }, 'gK', '<Cmd>lua MiniComment.textobject()<cr>', { silent = true, desc = "RestOfComment textobj" })
  map({ "x" }, 'gC', ':<C-u>normal "zygcgv<cr>', { silent = true, desc = "WholeComment textobj" })

  -- _search_textobj_(dot-repeat_supported)
  map({ "o", "x" }, "gs", "gn", { silent = true, noremap = true, desc = "Next search textobj" })
  map({ "o", "x" }, "gS", "gN", { silent = true, noremap = true, desc = "Prev search textobj" })

  -- _replace_textobj_(repeable_with_cgs_+_dotrepeat_supported)
  map({ 'x' }, 'g/', '"zy:s/<C-r>z//g<Left><Left>', { silent = true, desc = "Replace textobj" })

  -- _nvim_various_textobjs
  map({ "o", "x" }, "gd", "<cmd>lua require('various-textobjs').diagnostic()<cr>",
    { silent = true, desc = "Diagnostic textobj" })
  map({ "o", "x" }, "gL", "<cmd>lua require('various-textobjs').nearEoL()<cr>",
    { silent = true, desc = "nearEoL textobj" })
  map({ "o", "x" }, "g_", "<cmd>lua require('various-textobjs').lineCharacterwise()<CR>",
    { silent = true, desc = "lineCharacterwise textobj" })
  map({ "o", "x" }, "g|", "<cmd>lua require('various-textobjs').column()<cr>",
    { silent = true, desc = "ColumnDown textobj" })
  map({ "o", "x" }, "gr", "<cmd>lua require('various-textobjs').restOfParagraph()<cr>",
    { silent = true, desc = "RestOfParagraph textobj" })
  map({ "o", "x" }, "gR", "<cmd>lua require('various-textobjs').restOfIndentation()<cr>",
    { silent = true, desc = "restOfIndentation textobj" })
  map({ "o", "x" }, "gG", "<cmd>lua require('various-textobjs').entireBuffer()<cr>",
    { silent = true, desc = "EntireBuffer textobj" })
  map({ "o", "x" }, "gu", "<cmd>lua require('various-textobjs').url()<cr>",
    { silent = true, desc = "Url textobj" })

  map({ "o", "x" }, "am", "<cmd>lua require('various-textobjs').chainMember(false)<CR>",
    { silent = true, desc = "inner chainMember textobj" })
  map({ "o", "x" }, "im", "<cmd>lua require('various-textobjs').chainMember(true)<CR>",
    { silent = true, desc = "inner chainMember textobj" })
  map({ "o", "x" }, "aS", "<cmd>lua require('various-textobjs').subword(false)<cr>",
    { silent = true, desc = "outer Subword textobj" })
  map({ "o", "x" }, "iS", "<cmd>lua require('various-textobjs').subword(true)<cr>",
    { silent = true, desc = "inner Subword textobj" })
  map({ "o", "x" }, "aZ", "<cmd>lua require('various-textobjs').closedFold(false)<CR>",
    { silent = true, desc = "outer ClosedFold textobj" })
  map({ "o", "x" }, "iZ", "<cmd>lua require('various-textobjs').closedFold(true)<CR>",
    { silent = true, desc = "inner ClosedFold textobj" })

  -- _fold_textobj
  keymap("x", 'iz', ":<C-U>silent!normal![zjV]zk<CR>", { silent = true, desc = "inner fold textobj" })
  keymap("o", 'iz', ":normal Vif<CR>", { silent = true, desc = "inner fold textobj" })
  keymap("x", 'az', ":<C-U>silent!normal![zV]z<CR>", { silent = true, desc = "outer fold textobj" })
  keymap("o", 'az', ":normal Vaf<CR>", { silent = true, desc = "outer fold textobj" })

  -- Mini Indent Scope textobj:
  map({ "o", "x" }, "ii", function() require("mini.ai").select_textobject("i","i") end, { silent = true, desc = "MiniIndentscope bordersless blankline_wise" })
  map({ "x" }, "ai", function() require("mini.ai").select_textobject("i","i") vim.cmd [[ normal koj ]] end, { silent = true, desc = "MiniIndentscope borders blankline_wise" })
  map({ "o" }, 'ai', ':<C-u>normal vai<cr>', { silent = true, desc = "MiniIndentscope borders blankline_wise" })
  map({ "o", "x" }, "iI", "<Cmd>lua MiniIndentscope.textobject(false)<CR>", { silent = true, desc = "MiniIndentscope bordersless blankline_skip" })
  map({ "o", "x" }, "aI", "<Cmd>lua MiniIndentscope.textobject(true)<CR>", { silent = true, desc = "MiniIndentscope borders blankline_skip" })

  -- indent same level textobj:
  map({"x","o"}, "iy", function() select_indent(false) end, { silent = true, desc = "indent_samelevel_noblankline textobj" })
  map({"x","o"}, "ay", function() select_indent(true) end, { silent = true, desc = "indent_samelevel_blankline textobj" })

  -- _illuminate_text_objects
  map({ 'n', 'x', 'o' }, '<a-n>', '<cmd>lua require"illuminate".goto_next_reference(wrap)<cr>', opts)
  map({ 'n', 'x', 'o' }, '<a-p>', '<cmd>lua require"illuminate".goto_prev_reference(wrap)<cr>', opts)
  map({ 'n', 'x', 'o' }, '<a-i>', '<cmd>lua require"illuminate".textobj_select()<cr>', opts)

  -- _clipboard_textobj
  vim.g.EasyClipAutoFormat = 1
  vim.g.EasyClipUseCutDefaults = false
  vim.g.EasyClipEnableBlackHoleRedirect = false
  map({ "n", "x" }, "gx", '"_d', { silent = true, desc = "Blackhole Motion/Selected" })
  map({ "n" }, "gxx", '"_dd', { silent = true, desc = "Blackhole line" })
  map({ "n" }, "gX", '"/p', { silent = true, desc = "Search register" })

  vim.g.EasyClipUseYankDefaults = false
  map({ "n" }, "gy", "<plug>SubstituteOverMotionMap", { silent = true, desc = "Substitute Motion" })
  map({ "n" }, "gyy", "<plug>SubstituteLine", { silent = true, desc = "Substitute Line" })
  map({ "x" }, "gy", "<plug>XEasyClipPaste ", { silent = true, desc = "Substitute Selected" })

  vim.g.EasyClipUsePasteDefaults = false
  map({ "n" }, "gY", "<plug>G_EasyClipPasteBefore", { silent = true, desc = "Paste Preserving cursor position" })
  map({ "x" }, "gY", "<plug>XG_EasyClipPaste ", { silent = true, desc = "Paste Preserving cursor position" })

  vim.g.EasyClipUsePasteToggleDefaults = false
  map({ "n" }, "gz", '"1p', { silent = true, desc = "Redo register (dot to Paste forward the rest of register)" })
  map({ "n" }, "gZ", '"1P', { silent = true, desc = "Redo register (dot to Paste backward the rest of register)" })

  -- ╭─────────╮
  -- │ Motions │
  -- ╰─────────╯

  -- _sneak_keymaps
  vim.cmd [[
      let g:sneak#prompt = ''
      map <silent> f <Plug>Sneak_f
      map <silent> F <Plug>Sneak_F
      map <silent> t <Plug>Sneak_t
      map <silent> T <Plug>Sneak_T
      map <silent> <space><space>s <Plug>SneakLabel_s
      map <silent> <space><space>S <Plug>SneakLabel_S
      nmap <silent><expr> <Tab> sneak#is_sneaking() ? '<Plug>SneakLabel_s<cr>' : ':bnext<cr>'
      nmap <silent><expr> <S-Tab> sneak#is_sneaking() ? '<Plug>SneakLabel_S<cr>' : ':bprevious<cr>'
      omap <silent> <Tab> <Plug>SneakLabel_s<cr>
      omap <silent> <S-Tab> <Plug>SneakLabel_S<cr>
      vmap <silent> <Tab> <Plug>SneakLabel_s<cr>
      vmap <silent> <S-Tab> <Plug>SneakLabel_S<cr>
      xmap <silent> <Tab> <Plug>SneakLabel_s<cr>
      xmap <silent> <S-Tab> <Plug>SneakLabel_S<cr>
    ]]

  -- _bufpos.vim
  vim.cmd [[
      function! BufPos_ActivateBuffer(num)
        let l:count = 1
        for i in range(1, bufnr("$"))
          if buflisted(i) && getbufvar(i, "&modifiable")
            if l:count == a:num
              exe "buffer " . i
              return
            endif
            let l:count = l:count + 1
          endif
        endfor
      endfunction

      function! BufPos_Initialize()
        for i in range(1, 9)
          exe "map <Space>" . i . " :call BufPos_ActivateBuffer(" . i . ")<CR>"
        endfor
      endfunction

      autocmd VimEnter * call BufPos_Initialize()
    ]]

  -- ╭────────────╮
  -- │ Repeatable │
  -- ╰────────────╯

  -- _nvim-treesitter-textobjs_repeatable
  -- ensure ; goes forward and , goes backward regardless of the last direction
  local ts_repeat_move_status_ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
  if ts_repeat_move_status_ok then
    map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { silent = true, desc = "Next TS textobj" })
    map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { silent = true, desc = "Prev TS textobj" })

    -- _sneak_repeatable
    vim.cmd [[ command SneakForward execute "normal \<Plug>Sneak_;" ]]
    vim.cmd [[ command SneakBackward execute "normal \<Plug>Sneak_," ]]
    local next_sneak, prev_sneak = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ SneakForward ]] end,
      function() vim.cmd [[ SneakBackward ]] end
    )
    map({ "n", "x", "o" }, "<BS>", next_sneak, { silent = true, desc = "Next SneakForward" })
    map({ "n", "x", "o" }, "<S-BS>", prev_sneak, { silent = true, desc = "Prev SneakForward" })

    -- _goto_next_indent_repeatable
    vim.cmd [[ command NextIndentedParagraph execute "normal \<Plug>(textobj-indentedparagraph-n)" ]]
    vim.cmd [[ command PrevIndentedParagraph execute "normal \<Plug>(textobj-indentedparagraph-p)" ]]
    local next_indentedparagraph, prev_indentedparagraph = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ NextIndentedParagraph ]] end,
      function() vim.cmd [[ PrevIndentedParagraph ]] end
    )
    map({ "n", "x", "o" }, "gni", next_indentedparagraph, { silent = true, desc = "Next IndentedParagraph" })
    map({ "n", "x", "o" }, "gpi", prev_indentedparagraph, { silent = true, desc = "Prev IndentedParagraph" })

    -- _goto_indent_samelevel_blankline_repeatable
    local next_indent, prev_indent = ts_repeat_move.make_repeatable_move_pair(
      function() require("user.autocommands").next_indent(true) end,
      function() require("user.autocommands").next_indent(false) end
    )
    map({ "n", "x", "o" }, "gny", next_indent, { silent = true, desc = "next indent_samelevel_blankline" })
    map({ "n", "x", "o" }, "gpy", prev_indent, { silent = true, desc = "prev indent_samelevel_blankline" })

    -- _goto_diagnostic_repeatable
    local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(
      function() vim.diagnostic.goto_next({ border = "rounded" }) end,
      function() vim.diagnostic.goto_prev({ border = "rounded" }) end
    )
    map({ "n", "x", "o" }, "gnd", next_diagnostic, { silent = true, desc = "Next Diagnostic" })
    map({ "n", "x", "o" }, "gpd", prev_diagnostic, { silent = true, desc = "Prev Diagnostic" })

    -- _goto_function_definition_repeatable
    local next_funcdefinition, prev_funcdefinition = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal vaNf ]] vim.cmd [[ call feedkeys("") ]] end,
      function() vim.cmd [[ normal valf ]] vim.cmd [[ call feedkeys("") ]] end
    )
    map({ "n", "x", "o" }, "gnf", next_funcdefinition, { silent = true, desc = "Next FuncDefinition" })
    map({ "n", "x", "o" }, "gpf", prev_funcdefinition, { silent = true, desc = "Prev FuncDefinition" })

    -- _gitsigns_chunck_repeatable
    local gs = require("gitsigns")
    local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
    map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { silent = true, desc = "Next GitHunk" })
    map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { silent = true, desc = "Prev GitHunk" })

    -- _goto_quotes_repeatable
    local next_quote, prev_quote = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal viNu ]] vim.cmd [[ call feedkeys("") ]] end,
      function() vim.cmd [[ normal vilu ]] vim.cmd [[ call feedkeys("") ]] end
    )
    map({ "n", "x", "o" }, "gnu", next_quote, { silent = true, desc = "Next Quote" })
    map({ "n", "x", "o" }, "gpu", prev_quote, { silent = true, desc = "Prev Quote" })

    -- _columnmove_repeatable
    vim.g.columnmove_strict_wbege = 0 -- skips inner-paragraph whitespaces for wbege
    vim.g.columnmove_no_default_key_mappings = true
    map({ "n", "o", "x" }, "<leader><leader>f", "<Plug>(columnmove-f)", { silent = true })
    map({ "n", "o", "x" }, "<leader><leader>t", "<Plug>(columnmove-t)", { silent = true })
    map({ "n", "o", "x" }, "<leader><leader>F", "<Plug>(columnmove-F)", { silent = true })
    map({ "n", "o", "x" }, "<leader><leader>T", "<Plug>(columnmove-T)", { silent = true })

    local next_columnmove, prev_columnmove = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-;)" ]] end,
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-,)" ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>;", next_columnmove, { silent = true, desc = "Next ColumnMove_;" })
    map({ "n", "x", "o" }, "<leader><leader>,", prev_columnmove, { silent = true, desc = "Prev ColumnMove_," })

    local next_columnmove_w, prev_columnmove_b = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-w)" ]] end,
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-b)" ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>w", next_columnmove_w, { silent = true, desc = "Next ColumnMove_w" })
    map({ "n", "x", "o" }, "<leader><leader>b", prev_columnmove_b, { silent = true, desc = "Prev ColumnMove_b" })

    local next_columnmove_e, prev_columnmove_ge = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-e)" ]] end,
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-ge)" ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>e", next_columnmove_e, { silent = true, desc = "Next ColumnMove_e" })
    map({ "n", "x", "o" }, "<leader><leader>ge", prev_columnmove_ge, { silent = true, desc = "Prev ColumnMove_ge" })

    local next_columnmove_W, prev_columnmove_B = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-W)" ]] end,
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-B)" ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>W", next_columnmove_W, { silent = true, desc = "Next ColumnMove_W" })
    map({ "n", "x", "o" }, "<leader><leader>B", prev_columnmove_B, { silent = true, desc = "Prev ColumnMove_B" })

    local next_columnmove_E, prev_columnmove_gE = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-E)" ]] end,
      function() vim.cmd [[ execute "normal \<Plug>(columnmove-gE)" ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>E", next_columnmove_E, { silent = true, desc = "Next ColumnMove_E" })
    map({ "n", "x", "o" }, "<leader><leader>gE", prev_columnmove_gE, { silent = true, desc = "Prev ColumnMove_gE" })

    -- _jump_blankline_repeatable
    local next_blankline, prev_blankline = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal } ]] end,
      function() vim.cmd [[ normal { ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>}", next_blankline, { silent = true, desc = "Next Blankline" })
    map({ "n", "x", "o" }, "<leader><leader>{", prev_blankline, { silent = true, desc = "Prev Blankline" })

    -- _jump_paragraph_repeatable
    local next_paragraph, prev_paragraph = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal )) ]] end,
      function() vim.cmd [[ normal (( ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>)", next_paragraph, { silent = true, desc = "Next Paragraph" })
    map({ "n", "x", "o" }, "<leader><leader>(", prev_paragraph, { silent = true, desc = "Prev Paragraph" })

    -- _jump_edgeindent_repeatable
    local next_indent, prev_indent = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal g]i ]] end,
      function() vim.cmd [[ normal g[i ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>i", next_indent, { silent = true, desc = "End Indent" })
    map({ "n", "x", "o" }, "<leader><leader>i", prev_indent, { silent = true, desc = "Start Indent" })

    -- _jump_edgefold_repeatable
    local next_fold, prev_fold = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal ]z ]] end,
      function() vim.cmd [[ normal [z ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>]", next_fold, { silent = true, desc = "End Fold" })
    map({ "n", "x", "o" }, "<leader><leader>[", prev_fold, { silent = true, desc = "Start Fold" })

    -- _jump_startofline_repeatable
    local next_startline, prev_startline = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal + ]] end,
      function() vim.cmd [[ normal - ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>+", next_startline, { silent = true, desc = "Next StartLine" })
    map({ "n", "x", "o" }, "<leader><leader>-", prev_startline, { silent = true, desc = "Prev StartLine" })

    -- _number_textobj_(goto_repeatable)
    local next_inner_hex, prev_inner_hex = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'i', 'x', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'i', 'x', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gnx", next_inner_hex, { silent = true, desc = "Next Inner Hex" })
    map({ "n", "x", "o" }, "gpx", prev_inner_hex, { silent = true, desc = "Prev Inner Hex" })

    local next_around_hex, prev_around_hex = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'a', 'x', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'a', 'x', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gNx", next_around_hex, { silent = true, desc = "Next Around Hex" })
    map({ "n", "x", "o" }, "gPx", prev_around_hex, { silent = true, desc = "Prev Around Hex" })

    -- hexadecimalcolor_textobj_(goto_repeatable)
    local next_inner_numeral, prev_inner_numeral = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'i', 'n', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'i', 'n', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gnn", next_inner_numeral, { silent = true, desc = "Next Inner Number" })
    map({ "n", "x", "o" }, "gpn", prev_inner_numeral, { silent = true, desc = "Prev Inner Number" })

    local next_around_numeral, prev_around_numeral = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'a', 'n', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'a', 'n', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gNn", next_around_numeral, { silent = true, desc = "Next Around Number" })
    map({ "n", "x", "o" }, "gPn", prev_around_numeral, { silent = true, desc = "Prev Around Number" })

    -- _vert_horz_incremental_(goto_repeatable)
    local vert_increment, vert_decrement = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal "zyanjvan"zp ]] FeedKeysCorrectly('<C-a>') end,
      function() vim.cmd [[ normal "zyanjvan"zp ]] FeedKeysCorrectly('<C-x>') end
    )
    map({ "n" }, "g+", vert_increment, { silent = true, desc = "Vert Increment" })
    map({ "n" }, "g-", vert_decrement, { silent = true, desc = "Vert Decrement" })

    local horz_increment, horz_decrement = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal "zyanvaNn"zp ]] FeedKeysCorrectly('<C-a>') end,
      function() vim.cmd [[ normal "zyanvaNn"zp ]] FeedKeysCorrectly('<C-x>') end
    )
    map({ "n" }, "gn+", horz_increment, { silent = true, desc = "Horz increment" })
    map({ "n" }, "gn-", horz_decrement, { silent = true, desc = "Horz Decrement" })

    -- _key_textobj_(goto_repeatable)
    local next_inner_key, prev_inner_key = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'i', 'k', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'i', 'k', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gnk", next_inner_key, { silent = true, desc = "Next Inner Key" })
    map({ "n", "x", "o" }, "gpk", prev_inner_key, { silent = true, desc = "Prev Inner Key" })

    local next_around_key, prev_around_key = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'a', 'k', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'a', 'k', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gNk", next_around_key, { silent = true, desc = "Next Around Key" })
    map({ "n", "x", "o" }, "gNk", prev_around_key, { silent = true, desc = "Prev Around Key" })

    -- _value_textobj_(goto_repeatable)
    local next_inner_value, prev_inner_value = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'i', 'v', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'i', 'v', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gnv", next_inner_value, { silent = true, desc = "Next Inner Value" })
    map({ "n", "x", "o" }, "gpv", prev_inner_value, { silent = true, desc = "Prev Inner Value" })

    local next_around_value, prev_around_value = ts_repeat_move.make_repeatable_move_pair(
      function() require("mini.ai").move_cursor('left', 'a', 'v', { search_method = 'next' }) end,
      function() require("mini.ai").move_cursor('left', 'a', 'v', { search_method = 'prev' }) end
    )
    map({ "n", "x", "o" }, "gNv", next_around_value, { silent = true, desc = "Next Around Value" })
    map({ "n", "x", "o" }, "gNv", prev_around_value, { silent = true, desc = "Prev Around Value" })

    -- _comment_(goto_repeatable)
    local next_comment, prev_comment = ts_repeat_move.make_repeatable_move_pair(
      function() require('mini.bracketed').comment('forward') end,
      function() require('mini.bracketed').comment('backward') end
    )
    map({ "n", "x", "o" }, "gnc", next_comment, { silent = true, desc = "Next Comment" })
    map({ "n", "x", "o" }, "gpc", prev_comment, { silent = true, desc = "Prev Comment" })
  end

  -- ╭───────────╮
  -- │ Lspconfig │
  -- ╰───────────╯

  ------------------------------------------------------------------------------------------------------------------------

  -- _load_system_stylua
  local null_sources = {}
  local formatting = require("null-ls").builtins.formatting
  local function stylua_config()
    for _, package in ipairs(require("mason-registry").get_installed_packages()) do
      if package.name == "stylua" then
        table.insert(
          null_sources,
          formatting[package.name].with {
            extra_args = {
              "--indent-width=2",
              "--indent-type=Spaces",
              "--call-parentheses=None",
              "--collapse-simple-statement=Always",
            },
          }
        )
      end
    end
  end

  stylua_config()

  ------------------------------------------------------------------------------------------------------------------------

  -- _manually_lspconfig_setup_using_nix/system_package_manager
  local handle = io.popen("lua-language-server --version 2>/dev/null")
  if handle then --handles "Need check nil" warning
    local output = handle:read("*a")
    if output:match("^3.*") then
      require('lspconfig')['lua_ls'].setup {
        on_attach = astronvim.lsp.on_attach,
        capabilities = astronvim.lsp.capabilities,
        settings = {
          Lua = {
            telemetry = { enable = false },
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            format = { enable = true, }
          }
        }
      }
    end
    handle:close()
  end

  ------------------------------------------------------------------------------------------------------------------------

end

return polishconf
