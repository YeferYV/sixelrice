local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  -- shell = "zsh",
  highlights = {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    Normal = { -- text/cursor
      link = 'TerminalNormal'
    },
    NormalFloat = {
      link = 'NormalFloat'
    },
    FloatBorder = {
      link = "FloatBorder"
    },
  },

  float_opts = {
    border = "curved",
    winblend = 0,
  },
  winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc><esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({ cmd = "lazygit", direction = "tab", hidden = true })
function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

local lazygit_float = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
function _LAZYGIT_FLOAT_TOGGLE()
  lazygit_float:toggle()
end

local node = Terminal:new({ cmd = "node", hidden = true })
function _NODE_TOGGLE()
  node:toggle()
end

local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })
function _NCDU_TOGGLE()
  ncdu:toggle()
end

local htop = Terminal:new({ cmd = "htop", hidden = true })
function _HTOP_TOGGLE()
  htop:toggle()
end

local python = Terminal:new({ cmd = "python", hidden = true })
function _PYTHON_TOGGLE()
  python:toggle()
end

local resto = Terminal:new({ cmd = "resto", direction = "tab", hidden = true })
function _RESTO_TOGGLE()
  resto:toggle()
end

-- see https://github.com/akinsho/toggleterm.nvim/issues/66
local temp_path = "/tmp/lfpickerpath"
function _LF_TOGGLE(dir, openmode, filemanager)
  Terminal:new({
    cmd = filemanager .. " " .. temp_path .. " " .. dir,
    on_close = function()
      local file = io.open(temp_path, "r")
      if file ~= nil then
        vim.opt.number = true
        if openmode == 'tabreplace' then
          vim.cmd("tabnew " .. file:read("*a") .. " | tabclose #")
        else
          vim.cmd(openmode .. file:read("*a"))
        end
        file:close()
        os.remove(temp_path)
      end
    end
  }):toggle()
end
