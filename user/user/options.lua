local options = {
  autoindent = true,                               -- auto indent new lines
  backup = false,                                  -- creates a backup file
  clipboard = "unnamedplus",                       -- allows neovim to access the system clipboard
  cmdheight = 0,                                   -- more space in the neovim command line for displaying messages
  completeopt = { "menu", "menuone", "noinsert" }, -- mostly just for cmp
  conceallevel = 0,                                -- so that `` is visible in markdown files
  copyindent = true,                               -- Copy the previous indentation on autoindenting
  cursorline = false,                              -- highlight the current line
  expandtab = true,                                -- convert tabs to spaces
  fileencoding = "utf-8",                          -- the encoding written to a file
  -- fileencoding = "utf-16",                      -- the encoding written to a file
  -- guicursor = a,
  guifont = "monospace:h17", -- the font used in graphical neovim applications
  hlsearch = true,           -- highlight all matches on previous search pattern
  ignorecase = true,         -- ignore case in search patterns
  lazyredraw = true,         -- lazily redraw screen
  laststatus = 3,            -- laststatus=3 global status line (line between splits)
  mouse = "a",               -- allow the mouse to be used in neovim
  number = true,             -- set numbered lines
  numberwidth = 4,           -- set number column width to 2 {default 4}
  -- paste = true,           -- (conflictswith/overrides nvim-cmp) allow auto-indenting pasted text
  preserveindent = true,     -- Preserve indent structure as much as possible
  pumheight = 10,            -- pop up menu height
  relativenumber = false,    -- set relative numbered lines
  scrolloff = 8,             -- vertical scrolloff
  shiftwidth = 2,            -- the number of spaces inserted for each indentation
  showmode = false,          -- we don't need to see things like -- INSERT -- anymore
  showtabline = 1,           -- 0) never show; 1) show tabs if more than 2; 2) always show
  sidescrolloff = 8,         -- horizontal scrolloff
  signcolumn = "yes",        -- always show the sign column, otherwise it would shift the text each time
  smartcase = true,          -- smart case
  smartindent = true,        -- make indenting smarter again
  splitbelow = true,         -- force all horizontal splits to go below current window
  splitright = true,         -- force all vertical splits to go to the right of current window
  swapfile = true,           -- creates a swapfile
  tabstop = 2,               -- insert 2 spaces for a tab
  termguicolors = true,      -- set term gui colors (most terminals support this)
  timeoutlen = 500,          -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = false,          -- enable persistent undo
  updatetime = 300,          -- faster completion (4000ms default)
  virtualedit = "all",       -- allow cursor bypass end of line
  visualbell = true,         -- visual bell instead of beeping
  -- whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
  wrap = false,              -- display lines as one long line
  writebackup = false,       -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- _append/remove_option
vim.opt.shortmess:append "c"                    -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"                    -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.

-- _global_options
vim.g.codeium_no_map_tab = true
vim.g.indent_object_ignore_blank_line = false
vim.g.diagnostics_enabled = true -- enable diagnostics at start

-- _nvim_ufo
vim.o.foldcolumn = "1"    -- '0' is not bad
vim.o.foldlevel = 99      -- Start Outline without folding it
vim.o.foldlevelstart = 99 -- Start Outline without folding it
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- neovide
if vim.g.neovide == true then
  vim.opt.guifont = { "FiraCode Nerd Font:h10" }
  vim.api.nvim_set_keymap("n", "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { silent = true })
  vim.api.nvim_set_keymap("n", "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { silent = true })
  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })
  -- vim.g.neovide_cursor_vfx_mode = "railgun"
  -- vim.g.neovide_cursor_vfx_opacity = 200.0
  -- vim.g.neovide_cursor_vfx_particle_density = 7.0
  -- vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  -- vim.g.neovide_cursor_vfx_particle_speed = 10.0
  -- vim.g.neovide_floating_blur_amount_x = 3.0
  -- vim.g.neovide_floating_blur_amount_y = 3.0
  vim.g.neovide_transparency            = 0.7
  vim.g.airline_powerline_fonts         = 1
  vim.g.neovide_confirm_quit            = true
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_antialiasing     = true
  vim.g.neovide_cursor_trail_size       = 0.8
  vim.g.neovide_hide_mouse_when_typing  = true
  vim.g.neovide_no_idle                 = true
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_padding_top             = 5
  vim.g.neovide_padding_left            = 5
  vim.g.neovide_padding_right           = 5
  vim.g.neovide_padding_bottom          = 1
end
