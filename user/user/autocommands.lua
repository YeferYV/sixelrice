-- ╭─────────╮
-- │ Autocmd │
-- ╰─────────╯

local M = {}
local autocmd = vim.api.nvim_create_autocmd
local create_command = vim.api.nvim_create_user_command

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

-- _show_tabs_if_more_than_two
autocmd({ "TabNew" }, { command = "set showtabline=2" })

------------------------------------------------------------------------------------------------------------------------

-- _show_bufferline_if_more_than_two
autocmd({ "BufAdd" }, { command = "set showtabline=2" })

------------------------------------------------------------------------------------------------------------------------

-- _hide_bufferline_if_last_buffer
autocmd({ "BufDelete" }, {
  callback = function()
    if #vim.fn.getbufinfo({ buflisted = true }) == 2 then
      vim.o.showtabline = 0
    end
  end,
})

------------------------------------------------------------------------------------------------------------------------

-- select buffer with leader + number
function BufPos_ActivateBuffer(num)
  local count = 1
  for i = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(i) == 1 then
      if count == num then
        vim.cmd("buffer " .. i)
        return
      end
      count = count + 1
    end
  end
end

function BufPos_Initialize()
  for i = 1, 9 do
    vim.cmd("nnoremap <Space>" .. i .. " :lua BufPos_ActivateBuffer(" .. i .. ")<CR>")
  end
end

vim.cmd("autocmd VimEnter * lua BufPos_Initialize()")

------------------------------------------------------------------------------------------------------------------------

function EnableAutoNoHighlightSearch()
  vim.on_key(function(char)
    if vim.fn.mode() == "n" then
      local new_hlsearch = vim.tbl_contains({ "<Up>", "<Down>", "<CR>", "n", "N", "*", "#", "?", "/" },
        vim.fn.keytrans(char))
      if vim.opt.hlsearch:get() ~= new_hlsearch then vim.cmd [[ noh ]] end
    end
  end, vim.api.nvim_create_namespace "auto_hlsearch")
end

create_command("EnableAutoNoHighlightSearch", EnableAutoNoHighlightSearch, {})

function DisableAutoNoHighlightSearch()
  vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])
  vim.cmd [[ set hlsearch ]]
end

create_command("DisableAutoNoHighlightSearch", DisableAutoNoHighlightSearch, {})

EnableAutoNoHighlightSearch() -- autostart

------------------------------------------------------------------------------------------------------------------------

function GoToParentIndent()
  local ok, start = require("indent_blankline.utils").get_current_context(
    vim.g.indent_blankline_context_patterns,
    vim.g.indent_blankline_use_treesitter_scope
  )
  if ok then
    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
    vim.cmd [[normal! _]]
  end
end

create_command("GoToParentIndent", GoToParentIndent, {})

------------------------------------------------------------------------------------------------------------------------

-- swap current window with the last visited window
function SwapWindow()
  local thiswin = vim.fn.winnr()
  local thisbuf = vim.fn.bufnr("%")
  local lastwin = vim.fn.winnr("#")
  local lastbuf = vim.fn.winbufnr(lastwin)
  vim.cmd("buffer " .. lastbuf) -- view lastbuf in current window
  vim.cmd("wincmd p")           -- go to previous window
  vim.cmd("buffer " .. thisbuf) -- view thisbuf in current window
  vim.cmd("wincmd p")           -- go to previous window
end

create_command("SwapWindow", SwapWindow, {})

------------------------------------------------------------------------------------------------------------------------

_G.FeedKeysCorrectly = function(keys)
  local feedableKeys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(feedableKeys, "n", true)
end

------------------------------------------------------------------------------------------------------------------------

function GotoTextObj_Callback()
  FeedKeysCorrectly(vim.g.dotargs)
end

_G.GotoTextObj = function(action)
  vim.g.dotargs = action
  vim.o.operatorfunc = 'v:lua.GotoTextObj_Callback'
  return "g@"
end

------------------------------------------------------------------------------------------------------------------------

function WhichKeyRepeat_Callback()
  if vim.g.dotfirstcmd ~= nil then vim.cmd(vim.g.dotfirstcmd) end
  if vim.g.dotsecondcmd ~= nil then vim.cmd(vim.g.dotsecondcmd) end
  if vim.g.dotthirdcmd ~= nil then vim.cmd(vim.g.dotthirdcmd) end
end

_G.WhichkeyRepeat = function(firstcmd, secondcmd, thirdcmd)
  vim.g.dotfirstcmd = firstcmd
  vim.g.dotsecondcmd = secondcmd
  vim.g.dotthirdcmd = thirdcmd
  vim.o.operatorfunc = 'v:lua.WhichKeyRepeat_Callback'
  vim.cmd.normal { "g@l", bang = true }
end

------------------------------------------------------------------------------------------------------------------------

-- https://thevaluable.dev/vim-create-text-objects
-- select indent by the same level:
M.select_same_indent = function(skip_blank_line)
  local start_indent = vim.fn.indent(vim.fn.line('.'))

  if skip_blank_line then
    match_blank_line = function(line) return false end
  else
    match_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
  end

  local prev_line = vim.fn.line('.') - 1
  while vim.fn.indent(prev_line) == start_indent or match_blank_line(prev_line) do
    vim.cmd('-')
    prev_line = vim.fn.line('.') - 1

    -- exit loop if there's no indentation
    if skip_blank_line then
      if vim.fn.indent(prev_line) == 0 and string.match(vim.fn.getline(prev_line), '^%s*$') then
        break
      end
    else
      if vim.fn.indent(prev_line) < 0 then
        break
      end
    end
  end

  vim.cmd('normal! 0V')

  local next_line = vim.fn.line('.') + 1
  while vim.fn.indent(next_line) == start_indent or match_blank_line(next_line) do
    vim.cmd('+')
    next_line = vim.fn.line('.') + 1

    -- exit loop if there's no indentation
    if skip_blank_line then
      if vim.fn.indent(next_line) == 0 and string.match(vim.fn.getline(next_line), '^%s*$') then
        break
      end
    else
      if vim.fn.indent(prev_line) < 0 then
        break
      end
    end
  end
end

------------------------------------------------------------------------------------------------------------------------

-- goto next/prev same/different level indent:
M.next_indent = function(next, level)
  local start_indent = vim.fn.indent(vim.fn.line('.'))
  local current_line = vim.fn.line('.')
  local next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
  local sign = next and '+' or '-'

  -- scroll no_blanklines (indent = 0) when going down
  if string.match(vim.fn.getline(current_line), '^%s*$') == nil then
    if sign == '+' then
      while vim.fn.indent(next_line) == 0 and string.match(vim.fn.getline(next_line), '^%s*$') == nil do
        vim.cmd('+')
        next_line = vim.fn.line('.') + 1
      end
    end
  end

  -- scroll same indentation (indent != 0)
  if start_indent ~= 0 then
    while vim.fn.indent(next_line) == start_indent do
      vim.cmd(sign)
      next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
    end
  end

  if level == "same_level" then
    -- scroll differrent indentation (supports indent = 0, skip blacklines)
    while vim.fn.indent(next_line) ~= -1 and (vim.fn.indent(next_line) ~= start_indent or string.match(vim.fn.getline(next_line), '^%s*$')) do
      vim.cmd(sign)
      next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
    end
  else -- level == "different_level"
    -- scroll blanklines (indent = -1 is when line is 0 or line is last+1 )
    while vim.fn.indent(next_line) == 0 and string.match(vim.fn.getline(next_line), '^%s*$') do
      vim.cmd(sign)
      next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
    end
  end

  -- scroll to next indentation
  vim.cmd(sign)

  -- scroll to top of indentation noblacklines
  start_indent = vim.fn.indent(vim.fn.line('.'))
  next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
  if sign == '-' then
    -- next_line indent is start_indent, next_line is no_blankline
    while vim.fn.indent(next_line) == start_indent and string.match(vim.fn.getline(next_line), '^%s*$') == nil do
      vim.cmd('-')
      next_line = vim.fn.line('.') - 1
    end
  end
end

------------------------------------------------------------------------------------------------------------------------
return M
