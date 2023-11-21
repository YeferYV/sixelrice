local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local colors = {
  bg       = 'none',
  fg       = '#555555',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#008800',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#5555ff',
  red      = '#ec5f67',
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { 'error', 'warn', 'info', 'hint' },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = false,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local location = {
  "location",
  padding = 0,
}

-- https://github.com/nvim-lualine/lualine.nvim/pull/620
local lspServer = {
  function()
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return 'No Lsp'
    end
    local clientNames = {}
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        -- return client.name
        table.insert(clientNames, client.name)
      end
    end
    if #clientNames == 0 then
      return 'No Lsp'
    end
    local msg = ''
    local maxClientsToPrint = 3
    local separator = '·'
    for i = 1, math.min(maxClientsToPrint, #clientNames) do
      msg = msg .. (i == 1 and '' or separator) .. clientNames[i]
    end
    if #clientNames > maxClientsToPrint then
      msg = msg .. separator .. '+' .. (#clientNames - maxClientsToPrint)
    end
    return msg
  end,
  icon = ' ',
  color = { fg = '#ffffff', gui = 'bold' },
}

local neotree_status = {
  color = { fg = '#ff8800', gui = 'none' },
  function()
    if vim.bo.filetype == "neo-tree" then
      return '󰉓'
    else
      return ''
    end
  end
}

local number_of_lines = {
  function()
    if vim.bo.filetype == "neo-tree" then
      local neo_file = require("user.neo-tree")
      return neo_file.NumberOfLines
    else
      return " " .. vim.api.nvim_buf_line_count(0)
    end
  end
}

-- cool function for progress
local progress = {
  color = { bg = 'none', gui = 'bold' },
  'progress'
  -- function()
  --   local current_line = vim.fn.line(".")
  --   local total_lines = vim.fn.line("$")
  --   local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  --   local line_ratio = current_line / total_lines
  --   local index = math.ceil(line_ratio * #chars)
  --   return chars[index]
  -- end,
}

local show_macro_recording = {
  function()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
      return ""
    else
      return "Recording @" .. recording_register
    end
  end
}

local toggleterm_status = {
  color = { fg = '#31B53E', gui = 'none' },
  function()
    if vim.bo.filetype == "sp-terminal" or vim.bo.filetype == "vs-terminal" then
      return ''
    else
      return ' ' .. vim.b.toggle_number
      -- return ' ' .. vim.b.toggle_number
      -- return ' ' .. vim.b.toggle_number
      -- return ' ' .. vim.b.toggle_number
    end
  end
}

local treesitterIcon = {
  color = { fg = '#224422', gui = 'bold' },
  function() --
    if next(vim.treesitter.highlighter.active) ~= nil then
      return " "
    end
    return ""
  end,
}

local function path() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end
local function spaces() return " " .. vim.api.nvim_buf_get_option(0, "shiftwidth") end
local function codeium() return "{…}" .. vim.fn["codeium#GetStatusString"]() end

local my_extension = {
  sections = {
    lualine_a = { branch },
    -- lualine_b = { 'tabs','mode','filesize'},
    lualine_x = { 'searchcount', neotree_status, toggleterm_status, path, number_of_lines },
    lualine_y = { location },
    lualine_z = { progress }
  },
  filetypes = { 'toggleterm', 'sp-terminal', 'vs-terminal', 'neo-tree' },
  buftypes = { 'terminal' }
}

lualine.setup({
  options = {
    icons_enabled = true,
    -- theme = "auto",
    -- theme = "16color",
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      -- normal = { c = { fg = colors.fg, bg = colors.bg } },
      -- inactive = { c = { fg = colors.fg, bg = colors.bg } },
      normal = {
        a = { fg = colors.blue, bg = colors.bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      inactive = {
        a = { fg = colors.green, bg = colors.bg, gui = "bold" },
        b = { fg = colors.gray1, bg = colors.bg },
        c = { fg = colors.gray1, bg = colors.bg },
      },
    },
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard" },
    -- disabled_buftypes = { 'Outline', 'quickfix', 'prompt','terminal', 'toggleterm', 'TelescopePrompt'}, -- not working
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { branch },
    lualine_b = {},
    lualine_c = {},
    lualine_x = { 'searchcount', show_macro_recording, diagnostics, diff, codeium, treesitterIcon, lspServer, 'filetype',
      spaces,
      number_of_lines }, -- "encoding"
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { my_extension, 'nvim-dap-ui' },
})
