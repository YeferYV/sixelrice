local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require "alpha.themes.dashboard"
dashboard.section.header.val = {
  "██████  ███████ ████████ ██████   ██████",
  "██   ██ ██         ██    ██   ██ ██    ██",
  "██████  ███████    ██    ██████  ██    ██",
  "██   ██ ██         ██    ██   ██ ██    ██",
  "██   ██ ███████    ██    ██   ██  ██████",
  " ",
  "    ███    ██ ██    ██ ██ ███    ███",
  "    ████   ██ ██    ██ ██ ████  ████",
  "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
  "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
  "    ██   ████   ████   ██ ██      ██",
}
dashboard.section.header.opts.hl = "DashboardHeader"

dashboard.section.buttons.val = {
  dashboard.button("p", " " .. " Find Project", ":Telescope projects initial_mode=normal<cr>"),
  dashboard.button("f", " " .. " Find File", ":Telescope find_files initial_mode=normal<cr>"),
  dashboard.button("o", "󰈙 " .. " Recents", ":Telescope oldfiles initial_mode=normal<cr>"),
  dashboard.button("w", "󰈭 " .. " Find Word", ":Telescope live_grep  initial_mode=normal<cr>"),
  dashboard.button("n", " " .. " New File", ":enew<cr>"),
  dashboard.button("b", " " .. " Bookmarks", ":Telescope marks initial_mode=normal<cr>"),
  dashboard.button("m", " " .. " Mini Files", ":lua require('mini.files').open(vim.api.nvim_buf_get_name(0), true) <cr>"),
  dashboard.button("q", " " .. " Neotree",
    ":lua _G.neotree_blend = true; vim.cmd [[ Neotree filesystem reveal float ]] <cr>"),
  dashboard.button("r", "󰉖 " .. " File Browser", ":Telescope file_browser initial_mode=normal<cr>"),
  dashboard.button("l", " " .. " LF Explorer", ":lua _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'tabreplace') <cr>"),
  dashboard.button("t", " " .. " Terminal",
    ":lua vim.cmd [[ tabedit | terminal ]] vim.cmd [[ tabclose # ]] vim.cmd [[ set ft=tab-terminal nonumber laststatus=0 ]] <cr>"),
  dashboard.button("s", " " .. " Last Session",
    "<cmd>lua require('mini.sessions').read(require('mini.sessions').get_latest(), { verbose = false })<cr>"),
  dashboard.button("x", " " .. " Lazy Extras", "<cmd> LazyExtras <cr>"),
  dashboard.button("<space>", " " .. " More", ":WhichKey \\<leader> <cr>"),
  dashboard.button("Q", "󰅙 " .. " Quit", ":quit! <cr>"),
}

dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.08) }
dashboard.config.layout[3].val = 3
dashboard.config.opts.noautocmd = true

alpha.setup(dashboard.opts)
