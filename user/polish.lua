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

  -- _jump_to_last_position_on_reopen
  vim.cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

  -- _disable_autocommented_new_lines
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      vim.opt.formatoptions:remove { "c", "r", "o" }
    end,
  })

  -- _show_bufferline_if_more_than_two
  cmd({ "BufAdd" }, { command = "set showtabline=2" })

  -- _hide_bufferline_if_last_buffer
  cmd({ "BufDelete" }, {
    callback = function()
      if #vim.fn.getbufinfo({ buflisted = true }) == 2 then
        vim.o.showtabline = 0
      end
    end,
  })

  -- _show_tabs_if_more_than_two
  cmd({ "TabNew" }, { command = "set showtabline=2" })

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

  -- _custom_terminal_colors
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      local custom_themes = {
        tokyonight = {
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
      }
      local selected_colorscheme = custom_themes[vim.g.colors_name]
      if selected_colorscheme then
        for k, v in pairs(selected_colorscheme.custom_terminal_colors) do
          vim.g[k] = v
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
  keymap("n", "gb;", "<C-6>", { noremap = true, silent = true, desc = "go to last buffer" })

  -- _codeium_completion
  -- map('i', '<A-h>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  map('i', '<A-j>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
  map('i', '<A-k>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
  map('i', '<A-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })

  -- Replace all/visual_selected
  map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { silent = true, desc = "Replace in Buffer" })
  map({ "x" }, "<C-s>", ":s//g<Left><Left>", { silent = true, desc = "Replace in Visual_selected" })

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

  -- _mini_comment_(not_showing_desc)_(next/prev_autojump_unsupported)
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

  map({ "o", "x" }, "aS", "<cmd>lua require('various-textobjs').subword(false)<cr>",
    { silent = true, desc = "outer Subword textobj" })
  map({ "o", "x" }, "iS", "<cmd>lua require('various-textobjs').subword(true)<cr>",
    { silent = true, desc = "inner Subword textobj" })

  -- _vim_indent_object_(visualrepeatable_+_vimrepeat)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "*",
    callback = function()
      map({ "o", "x" }, "iI", "<Cmd>lua MiniIndentscope.textobject(false)<CR>",
        { silent = true, desc = "MiniIndentscope_iI" })
      map({ "o", "x" }, "aI", "<Cmd>lua MiniIndentscope.textobject(true)<CR>",
        { silent = true, desc = "MiniIndentscope_aI" })
    end
  })

  -- _vim-textobj-space
  vim.g.textobj_space_no_default_key_mappings = true
  map({ "o", "x" }, "ir", "<Plug>(textobj-space-i)", { silent = true, desc = "Space textobj" })
  map({ "o", "x" }, "ar", "<Plug>(textobj-space-a)", { silent = true, desc = "Space textobj" })

  -- _illuminate_text_objects
  map({ 'n', 'x', 'o' }, '<a-n>', '<cmd>lua require"illuminate".goto_next_reference(wrap)<cr>', opts)
  map({ 'n', 'x', 'o' }, '<a-p>', '<cmd>lua require"illuminate".goto_prev_reference(wrap)<cr>', opts)
  map({ 'n', 'x', 'o' }, '<a-i>', '<cmd>lua require"illuminate".textobj_select()<cr>', opts)

  -- _clipboard_textobj
  vim.cmd [[
      let g:EasyClipUseCutDefaults = 0
      let g:EasyClipEnableBlackHoleRedirect = 0
      nmap <silent> gx "_d
      nmap <silent> gxx "_dd
      xmap <silent> gx "_d

      let g:EasyClipUseYankDefaults = 0
      nmap <silent> gy <plug>SubstituteOverMotionMap
      nmap <silent> gyy <plug>SubstituteLine
      xmap <silent> gy <plug>XEasyClipPaste

      let g:EasyClipUsePasteDefaults = 0
      nmap <silent> gY <plug>G_EasyClipPasteBefore
      xmap <silent> gY <Plug>XG_EasyClipPaste

      let g:EasyClipUsePasteToggleDefaults = 0
      nmap <silent> gz <plug>EasyClipSwapPasteForward
      nmap <silent> gZ <plug>EasyClipSwapPasteBackwards

    ]]

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

    -- _jump_indent_repeatable
    local next_indent, prev_indent = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal vii_ ]] vim.cmd [[ call feedkeys("") ]] end,
      function() vim.cmd [[ normal viio_ ]] vim.cmd [[ call feedkeys("") ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>]", next_indent, { silent = true, desc = "Next Indent" })
    map({ "n", "x", "o" }, "<leader><leader>[", prev_indent, { silent = true, desc = "Prev Indent" })

    -- _jump_paragraph_repeatable
    local next_paragraph, prev_paragraph = ts_repeat_move.make_repeatable_move_pair(
      function() vim.cmd [[ normal ) ]] end,
      function() vim.cmd [[ normal ( ]] end
    )
    map({ "n", "x", "o" }, "<leader><leader>)", next_paragraph, { silent = true, desc = "Next Paragraph" })
    map({ "n", "x", "o" }, "<leader><leader>(", prev_paragraph, { silent = true, desc = "Prev Paragraph" })

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

  -- ╭──────────╮
  -- │ WhichKey │
  -- ╰──────────╯

  local mini_textobj = {
    q = '@call',
    Q = '@class',
    g = '@comment',
    G = '@conditional',
    B = '@block',
    F = '@function',
    L = '@loop',
    P = '@parameter',
    R = '@return',
    ["="] = '@assignment.side',
    ["+"] = '@assignment.whole',
    ['a'] = 'Function Parameters',
    ['A'] = 'Whole Buffer',
    ['b'] = 'Alias )]}',
    ['f'] = 'Function Definition',
    ['k'] = 'Key',
    ['n'] = 'Number',
    ['p'] = 'Paragraph',
    ['s'] = 'Sentence',
    ['t'] = 'Tag',
    ['u'] = 'Alias "\'`',
    ['v'] = 'Value',
    ['w'] = 'Word',
    ['x'] = 'Hex',
    ['?'] = 'Prompt',
    ['('] = 'Same as )',
    ['['] = 'Same as ]',
    ['{'] = 'Same as }',
    ['<'] = 'Same as >',
    ['"'] = 'punctuations...',
    ["'"] = 'punctuations...',
    ["`"] = 'punctuations...',
    ['.'] = 'punctuations...',
    [','] = 'punctuations...',
    [';'] = 'punctuations...',
    ['-'] = 'punctuations...',
    ['_'] = 'punctuations...',
    ['/'] = 'punctuations...',
    ['|'] = 'punctuations...',
    ['&'] = 'punctuations...',
  }

  require("which-key").register({
    mode = { "o", "x" },
    ["i"] = mini_textobj,
    ["il"] = { name = "+Last", mini_textobj },
    ["iN"] = { name = "+Next", mini_textobj },
    ["a"] = mini_textobj,
    ["al"] = { name = "+Last", mini_textobj },
    ["aN"] = { name = "+Next", mini_textobj },
    ["Q"] = { "Textsubjects Prev Selection" },
    ["K"] = { "Textsubjects Smart" },
    ["aK"] = { "Textsubjects Container Outer" },
    ["iK"] = { "Textsubjects Container Inner" },
  })

  require("which-key").register({
    mode = { "n" },
    ["g["] = vim.tbl_extend("force", { name = "+Cursor to Left Around" }, mini_textobj),
    ["g]"] = vim.tbl_extend("force", { name = "+Cursor to Rigth Around" }, mini_textobj),
  })

end

return polishconf
