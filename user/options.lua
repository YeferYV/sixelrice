-- set vim options here (vim.<first_key>.<second_key> = value)
return {
    opt = {
      -- set to true or false etc.
      completeopt = { "menu", "menuone", "noinsert" }, -- mostly just for cmp
      cursorline = false, -- sets vim.opt.cursorline
      number = true, -- sets vim.opt.number
      relativenumber = true, -- sets vim.opt.relativenumber
      scrolloff = 8, -- vertical scrolloff
      sidescrolloff = 8, -- horizontal scrolloff
      signcolumn = "auto", -- sets vim.opt.signcolumn to auto
      showtabline = 0, -- 0) never show; 1) show tabs if more than 2; 2) always show
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
      autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      autopairs_enabled = true, -- enable autopairs at start
      cmp_enabled = true, -- enable completion at start
      codeium_no_map_tab = true, -- disable <tab> codeium completion
      diagnostics_enabled = true, -- enable diagnostics at start
      heirline_bufferline = true, -- enable new heirline based bufferline (requires :PackerSync after changing)
      icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
      mapleader = " ", -- sets vim.g.mapleader
      status_diagnostics_enabled = true, -- enable diagnostics in statusline
      ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    }
}
-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end
