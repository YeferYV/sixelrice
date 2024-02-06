local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true,       -- shows a list of your marks on ' and `
    registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      v = true,            -- bindings for prefixed with g
      g = true,            -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>",   -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded",       -- none, single, double, shadow
    position = "bottom",      -- bottom, top
    margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },                                                       -- min and max height of the columns
    width = { min = 20, max = 40 },                                                       -- min and max width of the columns
    spacing = 3,                                                                          -- spacing between columns
    align = "left",                                                                       -- align columns left, center or right
  },
  ignore_missing = false,                                                                 -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "<Plug>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,                                                                       -- show help message on the command line when the popup is visible
  triggers = "auto",                                                                      -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n",     -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

local mappings = {

  ["1"] = "which_key_ignore",
  ["2"] = "which_key_ignore",
  ["3"] = "which_key_ignore",
  ["4"] = "which_key_ignore",
  ["5"] = "which_key_ignore",
  ["6"] = "which_key_ignore",
  ["7"] = "which_key_ignore",
  ["8"] = "which_key_ignore",
  ["9"] = "which_key_ignore",
  ["<Tab>"] = { "which_key_ignore" },
  ["<S-Tab>"] = { "which_key_ignore" },

  ["'"] = { "<Cmd>Telescope marks initial_mode=normal<CR>", "Marks" },
  ["."] = { "<cmd>Telescope resume<cr>", "Telescope resume" },

  ["<space>"] = {
    name = "Motion",
    ["p"] = { '"*p', "Paste after (second_clip)" },
    ["P"] = { '"*P', "Paste before (second_clip)" },
    ["y"] = { '"*y', "Yank (second_clip)" },
    ["Y"] = { '"*yg_', "Yank forward (second_clip)" },
  },

  [";"] = {
    name = "Tab",
    C = { "<cmd>tabonly<cr>", "Close others Tabs" },
    n = { "<cmd>tabnext<cr>", "Next Tab" },
    p = { "<cmd>tabprevious<cr>", "Previous Tab" },
    N = { "<cmd>+tabmove<cr>", "move tab to next tab" },
    P = { "<cmd>-tabmove<cr>", "move tab to previous tab" },
    t = {
      function()
        vim.cmd [[ tabnew ]]
        vim.cmd [[ ShowBufferline ]]
      end,
      "New Tab"
    },
    x = { "<cmd>tabclose<cr>", "Close Tab" },
    -- ["!"] = { "<cmd>tabmove 0<cr>", "move to #1 tab" },
    -- ["("] = { "<cmd>tabmove $<cr>", "move to last tab" },
    -- [":"] = { "<cmd>tabmove #<cr>", "move to recent tab" },
    ["1"] = { "<cmd>tabnext 1<cr>", "go to #1 tab" },
    ["2"] = { "<cmd>tabnext 2<cr>", "go to #2 tab" },
    ["3"] = { "<cmd>tabnext 3<cr>", "go to #3 tab" },
    ["4"] = { "<cmd>tabnext 4<cr>", "go to #4 tab" },
    ["5"] = { "<cmd>tabnext 5<cr>", "go to #5 tab" },
    ["6"] = { "<cmd>tabnext 6<cr>", "go to #6 tab" },
    ["7"] = { "<cmd>tabnext 7<cr>", "go to #7 tab" },
    ["8"] = { "<cmd>tabnext 8<cr>", "go to #8 tab" },
    ["9"] = { "<cmd>tabnext 9<cr>", "go to #9 tab" },
    [";"] = { "<cmd>tabnext #<cr>", "Recent Tab" },
    ["<Tab>"] = { "<cmd>tabprevious<cr>", "Previous Tab" },
    ["<S-Tab>"] = { "<cmd>tabnext<cr>", "Next Tab" },
  },

  b = {
    name = "Buffer",
    b = {
      function()
        require('telescope.builtin').buffers(
          require('telescope.themes').get_cursor {
            previewer = false,
            initial_mode = 'normal'
          })
      end,
      "Telescope Buffer cursor-theme"
    },
    B = {
      function()
        require('telescope.builtin').buffers(
          require('telescope.themes').get_dropdown {
            previewer = false,
            initial_mode = 'normal'
          })
      end,
      "Telescope Buffer dropdown-theme"
    },
    C = { "<cmd>%bd|e#|bd#<cr>", "Close others Buffers" },
    s = { "<cmd>BufferLineCyclePrev<cr>", "Previous Buffer" },
    f = { "<cmd>BufferLineCycleNext<cr>", "Next Buffer" },
    S = { "<cmd>BufferLineMovePrev<cr>", "Move to Previous Buffer" },
    F = { "<cmd>BufferLineMoveNext<cr>", "Move to Next Buffer" },
    t = {
      function()
        vim.cmd [[ enew ]]
        vim.cmd [[ ShowBufferline ]]
      end,
      "New buffer"
    },
    ["<TAB>"] = {
      function()
        vim.cmd [[ setlocal nobuflisted ]]
        vim.cmd [[ bprevious ]]
        vim.cmd [[ tabe # ]]
        vim.cmd [[ ShowBufferline ]]
      end,
      "buffer to Tab"
    },
    -- T = {
    --   function()
    --     vim.cmd [[ bufdo | :setlocal nobuflisted | :b# | :tabe # ]]
    --     vim.cmd [[ ShowBufferline ]]
    --   end,
    --   "buffers to Tab"
    -- },
    v = { "<cmd>vertical ball<cr>", "Buffers to vertical windows" },
    V = { "<cmd>belowright ball<cr>", "Buffers to horizontal windows" },
    x = { "<cmd>:bp | bd #<cr>", "Close Buffer" },
    [";"] = { "<cmd>buffer #<cr>", "Recent buffer" },
  },

  c = {
    name = "Compiler",
    b = { "<cmd>!bash %<cr>", "Exec with bash" },
    c = { "<cmd>w! | !compiler '<c-r>%'<cr>", "Exec with compiler" },
    p = { "<cmd>!python %<cr>", "Exec with python" },
    o = { "<cmd>!$HOME/.local/bin/i3cmds/opout %<cr><cr>", "Output Document" },
  },

  d = {
    name = "Debugger",
    b = { function() WhichkeyRepeat("lua require'dap'.toggle_breakpoint()") end, "Toggle Breakpoint" },
    B = { function() WhichkeyRepeat("lua require'dap'.clear_breakpoints()") end, "Clear Breakpoints" },
    c = { function() WhichkeyRepeat("lua require'dap'.continue()") end, "Start/Continue" },
    h = { function() WhichkeyRepeat("lua require'dap.ui.widgets'.hover()") end, "Debugger Hover" },
    i = { function() WhichkeyRepeat("lua require'dap'.step_into()") end, "Step Into" },
    l = { function() WhichkeyRepeat("lua require'dap'.run_last()") end, "Run last" },
    o = { function() WhichkeyRepeat("lua require'dap'.step_over()") end, "Step Over" },
    O = { function() WhichkeyRepeat("lua require'dap'.step_out()") end, "Step Out" },
    q = { function() require 'dap'.close() end, "Close Session" },
    Q = { function() require 'dap'.terminate() end, "Terminate Session" },
    p = { function() WhichkeyRepeat("lua require'dap'.pause()") end, "Pause" },
    r = { function() WhichkeyRepeat("lua require'dap'.restart_frame()") end, "Restart" },
    R = { function() WhichkeyRepeat("lua require'dap'.repl.toggle()") end, "Toggle REPL" },
    u = { function() WhichkeyRepeat("lua require'dapui'.toggle()") end, "Toggle Debugger UI" },
  },

  ["f"] = {
    function()
      require('telescope.builtin').find_files(
        require('telescope.themes').get_dropdown {
          previewer = false,
          initial_mode = 'insert'
        })
    end,
    "Find Files",
  },

  ["h"] = { "<cmd>noh<cr>", "NoHighlight" },
  ["m"] = {
    function()
      require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
    end,
    "mini files (current file)",
  },
  ["M"] = {
    function()
      require("mini.files").open(vim.loop.cwd(), true)
    end,
    "mini files (cwd)",
  },
  ["e"] = { "<cmd>lua _G.neotree_blend=false<cr><cmd>Neotree toggle last left<cr>", "Neotree Toggle" },
  ["o"] = { "<cmd>lua _G.neotree_blend=true<cr><cmd>Neotree focus last <cr>", "Neotree focus" },
  ["q"] = {
    function()
      _G.neotree_blend = true
      vim.cmd [[ Neotree filesystem reveal float ]]
      vim.cmd [[ hi NeoTreeTabInactive guibg=none ]]
      vim.cmd [[ hi NeoTreeTabSeparatorInactive guibg=none ]]
    end,
    "Neotree float"
  },

  g = {
    name = "Git",
    g = {
      function()
        _LAZYGIT_TOGGLE()
        vim.cmd [[ ShowBufferline ]]
      end,
      "Tab Lazygit"
    },
    G = { function() _LAZYGIT_FLOAT_TOGGLE() end, "Float Lazygit" },
    L = { "<cmd>terminal lazygit<cr><cmd>set ft=tab-terminal<cr>", "Buffer Lazygit" },
    j = { function() WhichkeyRepeat("lua require 'gitsigns'.next_hunk()") end, "Next Hunk" },
    k = { function() WhichkeyRepeat("lua require 'gitsigns'.prev_hunk()") end, "Prev Hunk" },
    l = { function() WhichkeyRepeat("lua require 'gitsigns'.blame_line()") end, "Blame" },
    p = { function() WhichkeyRepeat("lua require 'gitsigns'.preview_hunk()") end, "Preview Hunk" },
    r = { function() WhichkeyRepeat("lua require 'gitsigns'.reset_hunk()") end, "Reset Hunk" },
    R = { function() WhichkeyRepeat("lua require 'gitsigns'.reset_buffer()") end, "Reset Buffer" },
    s = { function() WhichkeyRepeat("lua require 'gitsigns'.stage_hunk()") end, "Stage Hunk" },
    S = { function() WhichkeyRepeat("lua require 'gitsigns'.undo_stage_hunk()") end, "Undo Stage Hunk" },
    o = { function() WhichkeyRepeat("Gitsigns diffthis HEAD") end, "Open Diff (file changes)" },
    O = { "<cmd>Telescope git_status initial_mode=normal<cr>", "Open All Diff (file changes)" },
    b = { "<cmd>Telescope git_branches initial_mode=normal<cr>", "Checkout Branch" },
    c = { "<cmd>Telescope git_commits initial_mode=normal<cr>", "Checkout Commit" },
  },

  l = {
    name = "LSP",
    A = { function() WhichkeyRepeat("lua vim.lsp.buf.code_action()") end, "Code Action" },
    c = { "<cmd>Telescope lsp_incoming_calls initial_mode=normal<cr>", "Telescope incoming calls" },
    C = { "<cmd>Telescope lsp_outgoing_calls initial_mode=normal<cr>", "Telescope outgoing calls" },
    d = { function() WhichkeyRepeat("lua vim.lsp.buf.definition()") end, "Goto Definition" },
    D = { function() WhichkeyRepeat("lua vim.lsp.buf.declaration()") end, "Goto Declaration" },
    F = { function() WhichkeyRepeat("lua vim.lsp.buf.format({ timeout_ms = 5000 })") end, "Format" },
    h = { function() WhichkeyRepeat("lua vim.lsp.buf.signature_help()") end, "Signature" },
    H = { function() WhichkeyRepeat("lua vim.lsp.buf.hover()") end, "Hover" },
    I = { function() WhichkeyRepeat("lua vim.lsp.buf.implementation()") end, "Goto Implementation" },
    l = { function() WhichkeyRepeat("lua vim.lsp.codelens.refresh()") end, "CodeLens refresh" },
    L = { function() WhichkeyRepeat("lua vim.lsp.codelens.run()") end, "CodeLens run" },
    n = { function() WhichkeyRepeat("lua vim.diagnostic.goto_next()") end, "Next Diagnostic", },
    o = { function() WhichkeyRepeat("lua vim.diagnostic.open_float()") end, "Open Diagnostic" },
    p = { function() WhichkeyRepeat("lua vim.diagnostic.goto_prev()") end, "Prev Diagnostic", },
    q = { function() WhichkeyRepeat("lua vim.diagnostic.setloclist()") end, "Diagnostic List" },
    Q = { "<cmd>Telescope loclist initial_mode=normal<cr>", "Telescope QuickFix LocList" },
    r = { function() WhichkeyRepeat("lua vim.lsp.buf.references()") end, "References" },
    R = { function() WhichkeyRepeat("lua vim.lsp.buf.rename()") end, "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols initial_mode=normal<cr>", "Telescope Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols initial_mode=normal<cr>", "Telescope Dynamic Workspace Symbols", },
    T = { "<cmd>Telescope lsp_workspace_symbols initial_mode=normal<cr>", "Telescope Workspace Symbols", },
    t = { function() WhichkeyRepeat("lua vim.lsp.buf.type_definition()") end, "Goto TypeDefinition" },
    v = {
      function()
        require('telescope.builtin').lsp_references({
          show_line = false, -- the previewer already highlights the lsp_reference line
          initial_mode = 'normal'
        })
      end,
      "Telescope View References" },
    V = { "<cmd>Telescope diagnostics initial_mode=normal theme=ivy<cr>", "Telescope View Diagnostics" },
    w = { "<cmd>Telescope lsp_definitions initial_mode=normal show_line=false<cr>", "Telescope View Definitions" },
    W = { "<cmd>Telescope lsp_implementations initial_mode=normal show_line=false<cr>", "Telescope View Definitions" },
  },

  p = {
    name = "Peek LspSaga",
    A = { function() WhichkeyRepeat("Lspsaga code_action") end, "Code Action" },
    b = { function() WhichkeyRepeat("Lspsaga show_buf_diagnostics") end, "Show Buf Diagnostics" },
    c = { function() WhichkeyRepeat("Lspsaga incoming_calls") end, "Incoming Calls" },
    C = { function() WhichkeyRepeat("Lspsaga outgoing_calls") end, "outgoing Calls" },
    d = { function() WhichkeyRepeat("Lspsaga peek_definition") end, "Peek Definition" },
    D = { function() WhichkeyRepeat("Lspsaga goto_definition") end, "Go to Definition" },
    f = { function() WhichkeyRepeat("Lspsaga finder") end, "Finder" },
    h = { function() WhichkeyRepeat("Lspsaga hover_doc") end, "Hover" },
    n = { function() WhichkeyRepeat("Lspsaga diagnostic_jump_next") end, "Next Diagnostics" },
    N = {
      function()
        WhichkeyRepeat("lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })")
      end,
      "Next Error"
    },
    o = { function() WhichkeyRepeat("Lspsaga show_line_diagnostics") end, "Show Line Diagnostics" },
    O = { function() WhichkeyRepeat("Lspsaga show_cursor_diagnostics") end, "Show Cursor Diagnostics" },
    p = { function() WhichkeyRepeat("Lspsaga diagnostic_jump_prev") end, "Prev Diagnostics" },
    P = {
      function()
        WhichkeyRepeat("lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })")
      end,
      "Prev Error"
    },
    r = { function() WhichkeyRepeat("Lspsaga term_toggle ranger") end, "Ranger" },
    R = { function() WhichkeyRepeat("Lspsaga rename") end, "Rename" },
    t = { function() WhichkeyRepeat("Lspsaga term_toggle") end, "Toggle Terminal" },
    z = { function() WhichkeyRepeat("Lspsaga outline") end, "Toggle outline" },
  },

  P = {
    name = "Packages",
    ["C"] = { "<cmd>Lazy clean<cr>", "Lazy Clean" },
    ["i"] = { "<cmd>Lazy install<cr>", "Lazy Install" },
    ["m"] = { "<cmd>Mason<cr>", "Mason Installer" },
    ["L"] = { "<cmd>LspInfo<cr>", "Lsp Info" },
    ["N"] = { "<cmd>NullLsInfo<cr>", "NullLs Info" },
    ["P"] = { "<cmd>Lazy profile<cr>", "Lazy Profile" },
    ["s"] = { "<cmd>Lazy<cr>", "Lazy Status" },
    ["S"] = { "<cmd>Lazy sync<cr>", "Lazy Sync" },
    ["U"] = { "<cmd>Lazy update<cr>", "Lazy Update" },
  },

  s = {
    name = "Search",
    b = { "<cmd>Telescope buffers initial_mode=insert<cr>", "Buffers" },
    B = { "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>", "Ripgrep" },
    c = {
      function()
        require('telescope.builtin').colorscheme({ enable_preview = true, initial_mode = 'normal' })
      end,
      "Colorscheme"
    },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    f = { "<cmd>Telescope grep_string search= theme=ivy<cr>", "Grep string" },
    F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Live Grep" },
    g = { "<cmd>Telescope git_files theme=ivy<cr>", "Git Files (hidden included)" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find Highlights" },
    m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    ["n"] = {
      name = "noice",
      a = { function() require("noice").cmd("all") end, "Noice All" },
      d = { function() require("noice").cmd("dismiss") end, "Noice Dismiss All" },
      h = { function() require("noice").cmd("history") end, "Noice History" },
      l = { function() require("noice").cmd("last") end, "Noice Last Message" },
      t = { "<cmd>Noice telescope<cr>", "Noice Telescope" },
    },
    N = { "<cmd>Telescope neoclip initial_mode=normal<cr>", "NeoClip" },
    o = { "<cmd>Telescope oldfiles initial_mode=normal<cr>", "Open Recent File" },
    O = { "<cmd>Telescope file_browser initial_mode=normal<cr>", "Open File Browser" },
    -- O = {
    --   function()
    --     require 'telescope'.extensions.file_browser.file_browser({ path = vim.fn.expand('%:p:h') })
    --   end,
    --   "Open FileBrowser (cwd)"
    -- },
    p = { "<cmd>Telescope projects<cr>", "Projects" },
    q = { "<cmd>Telescope quickfixhistory initial_mode=normal<cr>", "Telescope QuickFix History" },
    Q = { "<cmd>Telescope quickfix initial_mode=normal<cr>", "Telescope QuickFix" },
    R = { "<cmd>Telescope registers initial_mode=normal<cr>", "Registers" },
    s = { "<cmd>Telescope grep_string<cr>", "Grep string under cursor" },
    y = { "<cmd>Telescope notify initial_mode=normal<cr>", "Telescope Notify(extension)" },
    z = {
      function()
        local aerial_avail, _ = pcall(require, "aerial")
        if aerial_avail then
          require("telescope").extensions.aerial.aerial()
        else
          require("telescope.builtin").lsp_document_symbols()
        end
      end,
      "Search symbols",
    },
    ["+"] = { "<cmd>Telescope builtin previewer=false initial_mode=normal<cr>", "More" },
    ["/"] = { "<cmd>Telescope find_files theme=ivy hidden=true<cr>", "Find files" },
    [";"] = { "<cmd>Telescope jumplist theme=ivy initial_mode=normal<cr>", "Jump List" },
    ["'"] = { "<cmd>Telescope marks theme=ivy initial_mode=normal<cr>", "Marks" },
  },

  S = {
    name = "Session",
    D = { "<cmd>lua require('mini.sessions').select('delete')<cr>", "Delete sessions" },
    F = { "<cmd>lua require('mini.sessions').select('read')<cr>", "Find sessions" },
    L = { "<cmd>lua require('mini.sessions').read('saved_session')<cr>", "Load saved session" },
    l = { "<cmd>lua require('mini.sessions').read(require('mini.sessions').get_latest())<cr>", "Load last session" },
    S = { "<cmd>lua require('mini.sessions').write('saved_session')<cr>", "Save this session" },
  },

  t = {
    name = "Terminal",
    --   n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    --   u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    --   t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    --   p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    ["<TAB>"] = {
      function()
        vim.cmd [[ wincmd T ]]
        vim.cmd [[ ShowBufferline ]]
      end,
      "Terminal to Tab"
    },
    b = {
      function()
        vim.cmd [[ terminal ]]
        vim.cmd [[ startinsert | set ft=buf-terminal nonumber ]]
      end,
      "Buffer terminal (TabSame)"
    },
    B = {
      function()
        vim.cmd [[ tabnew|terminal ]]
        vim.cmd [[ startinsert | set ft=tab-terminal nonumber ]]
        vim.cmd [[ ShowBufferline ]]
      end,
      "Buffer Terminal (TabNew)"
    },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float ToggleTerm" },
    ["ls"] = {
      function()
        _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'vsplit', 'lf -selection-path')
      end,
      "lf (TabSame)"
    },
    ["ln"] = {
      function()
        _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'tabnew', 'lf -selection-path')
        vim.cmd [[ ShowBufferline ]]
      end,
      "lf (TabNew)"
    },
    ["ll"] = {
      function()
        _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'tabreplace', 'lf -selection-path')
      end,
      "lf (TabReplace)"
    },
    ["ys"] = {
      function()
        _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'vsplit', 'yazi --chooser-file')
      end,
      "yazi (TabSame)"
    },
    ["yn"] = {
      function()
        _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'tabnew', 'yazi --chooser-file')
        vim.cmd [[ ShowBufferline ]]
      end,
      "yazi (TabNew)"
    },
    ["yy"] = {
      function()
        _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'tabreplace', 'yazi --chooser-file')
      end,
      "yazi (TabReplace)"
    },
    t = { "<cmd>ToggleTerm <cr>", "Toggle ToggleTerm" },
    T = {
      function()
        vim.cmd [[ ToggleTerm direction=tab ]]
        vim.cmd [[ ShowBufferline ]]
      end,
      "Tab ToggleTerm"
    },
    -- H = { "<cmd>split +te  | resize 10          | setlocal ft=sp-terminal nonumber noruler laststatus=3 cmdheight=0 | startinsert<cr>", "Horizontal terminal (status-hidden)" },
    -- V = { "<cmd>vsplit +te | vertical resize 80 | setlocal ft=vs-terminal nonumber noruler laststatus=0 cmdheight=1 | startinsert<cr>", "Vertical terminal (status-hidden)" },
    H = { "<cmd>split +te | resize 10 | setlocal ft=sp-terminal<cr>", "Horizontal terminal" },
    V = { "<cmd>vsplit +te | vertical resize 80 | setlocal ft=vs-terminal<cr>", "Vertical terminal" },
    h = { "<cmd>ToggleTerm direction=horizontal size=10<cr>", "Horizontal ToggleTerm" },
    v = { "<cmd>ToggleTerm direction=vertical   size=80<cr>", "Vertical ToggleTerm" },
    ["1h"] = { "<cmd>1ToggleTerm direction=vertical   <cr>", "Toggle first horizontal ToggleTerm" },
    ["1v"] = { "<cmd>1ToggleTerm direction=horizontal <cr>", "Toggle first vertical ToggleTerm" },
    ["2h"] = { "<cmd>2ToggleTerm direction=vertical   <cr>", "Toggle second horizontal ToggleTerm" },
    ["2v"] = { "<cmd>2ToggleTerm direction=horizontal <cr>", "Toggle second vertical ToggleTerm" },
    ["3h"] = { "<cmd>3ToggleTerm direction=vertical   <cr>", "Toggle third horizontal ToggleTerm" },
    ["3v"] = { "<cmd>3ToggleTerm direction=horizontal <cr>", "Toggle third vertical ToggleTerm" },
    ["4h"] = { "<cmd>4ToggleTerm direction=vertical   <cr>", "Toggle fourth horizontal ToggleTerm" },
    ["4v"] = { "<cmd>4ToggleTerm direction=horizontal <cr>", "Toggle fourth vertical ToggleTerm" },
    ["5h"] = { "<cmd>5ToggleTerm direction=vertical   <cr>", "Toggle fifth horizontal ToggleTerm" },
    ["5v"] = { "<cmd>5ToggleTerm direction=horizontal <cr>", "Toggle fifth vertical ToggleTerm" },
    ["6h"] = { "<cmd>6ToggleTerm direction=vertical   <cr>", "Toggle sixth horizontal ToggleTerm" },
    ["6v"] = { "<cmd>6ToggleTerm direction=horizontal <cr>", "Toggle sixth vertical ToggleTerm" },
    ["7h"] = { "<cmd>7ToggleTerm direction=vertical   <cr>", "Toggle seventh horizontal ToggleTerm" },
    ["7v"] = { "<cmd>7ToggleTerm direction=horizontal <cr>", "Toggle seventh vertical ToggleTerm" },
    ["8h"] = { "<cmd>8ToggleTerm direction=vertical   <cr>", "Toggle eighth horizontal ToggleTerm" },
    ["8v"] = { "<cmd>8ToggleTerm direction=horizontal <cr>", "Toggle eighth vertical ToggleTerm" },
    ["9h"] = { "<cmd>9ToggleTerm direction=vertical   <cr>", "Toggle ninth horizontal ToggleTerm" },
    ["9v"] = { "<cmd>9ToggleTerm direction=horizontal <cr>", "Toggle ninth vertical ToggleTerm" },
    ["0h"] = { "<cmd>0ToggleTerm direction=vertical   <cr>", "Toggle tenth horizontal ToggleTerm" },
    ["0v"] = { "<cmd>0ToggleTerm direction=horizontal <cr>", "Toggle tenth vertical ToggleTerm" },
  },

  u = {
    name = "UI Toggle",
    ["0"] = { "<cmd>set showtabline=0<cr>", "Hide Buffer" },
    ["1"] = { "<cmd>ShowBufferline<cr>", "Enable Buffer offset" },
    ["2"] = {
      function()
        require('bufferline').setup {
          options = {
            offsets = {},
            show_close_icon = false
          }
        }
      end,
      "Disable Buffer offset"
    },
    a = { "<cmd>Alpha<cr>", "Alpha (TabSame)" },
    A = { "<cmd>tabnew | Alpha<cr>", "Alpha (TabNew)" },
    b = { "<cmd>ShowBufferline<cr>", "Show Buffer" },
    B = {
      function()
        require('bufferline').setup {
          options = {
            offsets = { { filetype = 'neo-tree', padding = 1 } },
            show_close_icon = false,
            always_show_bufferline = false,
          }
        }
      end,
      "Hide Buffer (if < 2)" -- "Reset Buffer"
    },
    -- c = { "<cmd>Codi<cr>", "Codi Start"},
    -- C = { "<cmd>Codi!<cr>", "Codi Stop" },
    c = {
      function()
        local cmdheight = vim.opt.cmdheight:get()
        if cmdheight == 0 then
          vim.opt.cmdheight = 1
        else
          vim.opt.cmdheight = 0
        end
      end
      , "Toggle cmdheight"
    },
    C = { "<cmd>ColorizerToggle<cr>", "Toggle Colorizer" },
    d = { "<cmd>ToggleDiagnostics<cr>", "Toggle Diagnostics" },
    G = {
      function()
        if vim.g.ToggleNormal == nil then
          vim.api.nvim_set_hl(0, "Normal", { bg = "#0b0b0b" })
          vim.g.ToggleNormal = true
        else
          vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
          vim.g.ToggleNormal = nil
        end
      end
      , "Toggle Background"
    },
    h = { "<cmd>EnableAutoNoHighlightSearch<cr>", "Enable AutoNoHighlightSearch" },
    H = { "<cmd>DisableAutoNoHighlightSearch<cr>", "Disable AutoNoHighlightSearch" },
    i = {
      function()
        local input_avail, input = pcall(vim.fn.input, "Set indent value (>0 expandtab, <=0 noexpandtab): ")
        if input_avail then
          local indent = tonumber(input)
          if not indent or indent == 0 then return end
          vim.bo.expandtab = (indent > 0)
          indent = math.abs(indent)
          vim.bo.tabstop = indent
          vim.bo.softtabstop = indent
          vim.bo.shiftwidth = indent
        end
      end,
      "Change Indent Setting"
    },
    I = { "<cmd>IndentBlanklineToggle<cr>", "Toggle IndentBlankline" },
    l = { "<cmd>set cursorline!<cr>", "Toggle Cursorline" },
    L = { "<cmd>setlocal cursorline!<cr>", "Toggle Local Cursorline" },
    -- n = { "<cmd>Neotree show<cr>", "Neotree show" },
    -- N = { "<cmd>Neotree close<cr>", "Neotree close" },
    m = { "<cmd>lua MiniMap.toggle()<cr>", "Toggle MiniMap" },
    p = { "<cmd>popup PopUp<cr>", "Toggle PopUp" },
    P = { function() vim.opt.paste = not vim.opt.paste:get() end, "Toggle Paste Mode" },
    o = { "<cmd>Legendary<cr>", "Open Legendary" },
    r = {
      function()
        _RESTO_TOGGLE()
        vim.cmd [[ ShowBufferline ]]
      end,
      "Rest Client"
    },
    s = {
      function()
        local laststatus = vim.opt.laststatus:get()
        if laststatus == 0 then
          vim.opt.laststatus = 2
        elseif laststatus == 2 then
          vim.opt.laststatus = 3
        elseif laststatus == 3 then
          vim.opt.laststatus = 0
        end
      end
      , "Toggle StatusBar"
    },
    -- u = {
    --   function()
    --     vim.cmd("GoToParentIndent")
    --     vim.call("repeat#set", "0 uu")
    --   end,
    --   "Jump to current_context",
    -- },
    u = {
      function()
        WhichkeyRepeat(
          "normal! 0",
          "lua GoToParentIndent()"
        )
      end,
      "Jump to current_context",
    },
    v = { "<cmd>ToggleVirtualText<cr>", "Toggle VirtualText" },
    -- w = { "<cmd>set winbar=%@<cr>", "enable winbar" },
    -- W = { "<cmd>set winbar=  <cr>", "disable winbar" },
    [";"] = { ":clearjumps<cr>:normal m'<cr>", "Clear and Add jump" }, -- Reset JumpList
  },

  v = { "<Cmd>ToggleTerm direction=vertical   size=70<CR>", "which_key_ignore" },
  V = { "<Cmd>ToggleTerm direction=horizontal size=10<CR>", "which_key_ignore" },

  w = {
    name = "Window",
    b = { "<cmd>lua SwapWindow()<cr>", "SwapWindow (last visited node)" },
    B = { "<cmd>all<cr>", "Windows to buffers" },
    C = { "<C-w>o", "Close Other windows" },
    h = { "<C-w>H", "Move window to Leftmost" },
    j = { "<C-w>J", "Move window to Downmost" },
    k = { "<C-w>K", "Move window to Upmost" },
    l = { "<C-w>L", "Move window to Rightmost" },
    m = { "<C-w>_ | <c-w>|", "Maximize window" },
    n = { "<C-w>w", "Switch to next window CW " },
    N = { "<C-w>w<cmd>lua SwapWindow()<cr>", "move to next window CW" },
    p = { "<C-w>W", "Switch to previous window CCW" },
    P = { "<C-w>W<cmd>lua SwapWindow()<cr>", "Move to previous window CCW" },
    q = { "<cmd>qa<cr>", "Quit all" },
    s = { "<cmd>wincmd x<cr>", "window Swap CW (same parent node)" },
    S = { "<cmd>-wincmd x<cr>", "window Swap CCW (same parent node)" },
    r = { "<C-w>r", "Rotate CW (same parent node)" },
    R = { "<C-w>R", "Rotate CCW (same parent node)" },
    ["<TAB>"] = {
      function()
        vim.cmd [[ setlocal nobuflisted ]]
        vim.cmd [[ wincmd T ]]
        vim.cmd [[ ShowBufferline ]]
      end,
      "window to Tab"
    },
    v = { "<cmd>vsplit<cr>", "Split vertical" },
    V = { "<cmd>split<cr>", "Split horizontal" },
    w = { "<cmd>new<cr>", "New horizontal window" },
    W = { "<cmd>vnew<cr>", "New vertical window" },
    x = { "<cmd>wincmd q<cr>", "Close window" },
    [";"] = { "<C-w>p", "recent window" },
    [":"] = { "<C-w>p<cmd>call SwitchWindow2()<cr>", "Move to recent window" },
    ["="] = { "<C-w>=", "Reset windows sizes" },
  },
  z = {
    name = "folding",
    ["a"] = { "za", "Toggle fold" },
    ["A"] = { "zA", "Toggle folds recursively" },
    ["c"] = { "zc", "Close fold" },
    ["C"] = { "zC", "Close fold recursively" },
    ["j"] = { "zj", "next fold" },
    ["k"] = { "zk", "previous fold" },
    ["J"] = { "]z", "go to bottom of current fold" },
    ["K"] = { "[z", "go to top of current fold" },
    ["d"] = { "zd", "remove fold" },
    ["E"] = { "zE", "remove all fold" },
    ["i"] = { "<cmd>set foldlevel=0 foldlevelstart=-1 foldmethod=indent<cr>", "fold all indentation" },
    ["m"] = { "<cmd>set foldlevel=99 foldlevelstart=99 foldmethod=manual<cr>", "manual fold" },
    -- ["M"] = { "<cmd>lua require('ufo').closeAllFolds()<cr>", "Close All Folds" },
    ["M"] = { "zM", "Close All Folds" },
    ["s"] = { "<cmd>mkview<cr>", "save folds" },
    ["l"] = { "<cmd>loadview<cr>", "load folds" },
    ["p"] = { "zfip", "fold paragraph" },
    ["P"] = { function() require("ufo").peekFoldedLinesUnderCursor() end, "peek FoldedLines" },
    ["o"] = { "zo", "open fold" },
    ["O"] = { "zO", "open fold recursively" },
    ["r"] = { "zr", "fold less" },
    -- ["R"] = { "<cmd>lua require('ufo').openAllFolds()<cr>", "Open All Folds" },
    ["R"] = { "zR", "Open All Folds" },
    ["}"] = { "zfa}", "fold curly-bracket block" },
    ["]"] = { "zfa]", "fold square-bracket block" },
    [")"] = { "zfa)", "fold parenthesis block" },
    [">"] = { "zfa>", "fold greater-than block" },
  },
}

-- require('legendary').setup({ which_key = { auto_register = true } })
which_key.setup(setup)
which_key.register(mappings, opts)

local ai_textobj = {
  ['a'] = 'function args',
  ['A'] = '@assingment',
  ['b'] = 'Alias )]}',
  ["B"] = '@block',
  ["c"] = 'word-column',
  ["C"] = 'WORD-column',
  ["d"] = 'greedyOuterIndentation',
  ["e"] = 'nearEndOfLine',
  ['f'] = 'function call',
  ["F"] = '@function',
  ["g"] = '@comment',
  ["G"] = '@conditional',
  ['h'] = 'html atribute',
  ['i'] = 'indentation noblanks',
  ['I'] = 'Indentation',
  ['j'] = 'cssSelector',
  ['k'] = 'key',
  ["l"] = '+Last',
  ["L"] = '@loop',
  ["m"] = 'chainMember',
  ["M"] = 'mdFencedCodeBlock',
  ['n'] = 'number',
  ['N'] = '+Next',
  ['o'] = 'whitespace',
  ['p'] = 'paragraph',
  ["P"] = '@parameter',
  ["q"] = '@call',
  ["Q"] = '@class',
  ["r"] = 'restOfWindow',
  ["R"] = '@return',
  ['s'] = 'Sentence',
  ['S'] = 'Subword',
  ['t'] = 'tag',
  ['u'] = 'Alias "\'`',
  ['U'] = 'pyTripleQuotes',
  ['v'] = 'value',
  ['w'] = 'word',
  ['W'] = 'WORD',
  ['x'] = 'hex',
  ['y'] = 'same_indent',
  ['z'] = 'fold',
  ['Z'] = 'ClosedFold',
  ["="] = '@assignment.rhs-lhs',
  ["#"] = '@number',
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
  -- `!@#$%^&*()_+-=[]{};'\:"|,./<>?
}

local g_textobj = {
  -- ["Q"] = { "Textsubjects Prev Selection" },
  -- ["K"] = { "Textsubjects Smart" },
  ["$"] = "End of line",
  ["%"] = "Matching character: '()', '{}', '[]'",
  [","] = "Prev TS textobj",
  [";"] = "Next TS textobj",
  ["0"] = "Start of line",
  ["^"] = "Start of line (non-blank)",
  ["{"] = "Previous empty line",
  ["}"] = "Next empty line",
  ["<CR> "] = "Continue Last Flash search",
  ["b"] = "Previous word",
  ["e"] = "Next end of word",
  ["f"] = "Move to next char",
  ["F"] = "Move to previous char",
  ["G"] = "Last line",
  ["R"] = "Treesitter Flash Search",
  ["s"] = "Flash",
  ["S"] = "Flash Treesitter",
  ["t"] = "Move before next char",
  ["T"] = "Move before previous char",
  ["w"] = "Next word",

  -- ["aK"] = { "Textsubjects Container Outer" },
  -- ["iK"] = { "Textsubjects Container Inner" },
  ["i"] = ai_textobj,
  ["il"] = { name = "+Last", ai_textobj },
  ["iN"] = { name = "+Next", ai_textobj },
  ["a"] = ai_textobj,
  ["al"] = { name = "+Last", ai_textobj },
  ["aN"] = { name = "+Next", ai_textobj },

  ["g{"] = { "braces linewise textobj" },
  ["g}"] = { "braces linewise textobj" },
  ["g["] = vim.tbl_extend("force", { name = "+Cursor to Left Around" }, ai_textobj),
  ["g]"] = vim.tbl_extend("force", { name = "+Cursor to Rigth Around" }, ai_textobj),
  -- ["ga"] = { "Align (operator)" },                     -- only visual and normal mode
  -- ["gA"] = { "Preview Align (operator)" },             -- only visual and normal mode
  -- ["gb"] = { "add virtual cursor (select and find)" }, -- only visual and normal mode
  ["gc"] = { "BlockComment textobj" },
  ["gC"] = { "RestOfComment textobj" },
  ["gd"] = { "Diagnostic textobj" },
  ["ge"] = { "Previous end of word textobj" },
  ["gE"] = { "Previous end of WORD textobj" },
  ["gf"] = { "Next find textobj" },
  ["gF"] = { "Prev find textobj" },
  ["gg"] = { "First line textobj" },
  ["gh"] = { "Git hunk textobj" },
  ["gi"] = { "Goto Insert textobj" },
  ["gI"] = { "select reference (under cursor)" },
  ["gj"] = { "GoDown when wrapped textobj" },
  ["gk"] = { "GoUp when wrapped textobj" },
  ["gK"] = { "ColumnDown textobj" },
  ["gl"] = { "Jump toLastChange textobj" },
  ["gL"] = { "Url textobj" },
  ["gm"] = { "Last change textobj" },
  ["gn"] = { name = "+next" },
  -- ["go"] = { "add virtual cursor down" }, -- only visual and normal mode
  -- ["gO"] = { "add virtual cursor up" },   -- only visual and normal mode
  ["gp"] = { name = "+previous" },
  -- ["gq"] = { "SplitJoin comment/lines 80chars (dot to repeat)" }, -- only visual and normal mode (cursor_position at start)
  ["gr"] = { "RestOfWindow textobj" },
  ["gR"] = { "VisibleWindow textobj" },
  ["gs"] = { "Surround textobj" },
  ["gS"] = { "JoinSplit textobj" },
  ["gT"] = { "toNextClosingBracket textobj" },
  ["gt"] = { "toNextQuotationMark textobj" },
  -- ["gu"] = { "to lowercase" },                                                   -- only visual and normal mode
  -- ["gU"] = { "to Uppercase" },                                                   -- only visual and normal mode
  -- ["gv"] = { "last selected" },                                                  -- only visual and normal mode
  -- ["gw"] = { "SplitJoin comments/lines (limited at 80 chars)" },                 -- only visual and normal mode
  -- ["gW"] = { "word-column multicursor" },                                        -- only visual and normal mode
  -- ["gx"] = { "Blackhole register" },                                             -- only visual and normal mode
  -- ["gX"] = { "Blackhole linewise" },                                             -- only visual and normal mode
  -- ["gy"] = { "replace with register" },                                          -- only visual and normal mode
  -- ["gY"] = { "exchange text" },                                                  -- only visual and normal mode
  -- ["gz"] = { "sort" },                                                           -- only visual and normal mode
  -- ["g+"] = { "Increment number (dot to repeat)" },                               -- only visual and normal mode
  -- ["g-"] = { "Decrement number (dot to repeat)" },                               -- only visual and normal mode
  -- ["g|"] = { "same column for all virtual cursors" },                            -- only visual and normal mode
  -- ["g\\"] = { "add virtual cursor at current position (eg after search/jump)" }, -- only visual and normal mode
  -- ["g<Up>"] = { "Numbers ascending" },                                           -- only visual and normal mode
  -- ["g<Down>"] = { "Numbers descending" },                                        -- only visual and normal mode
}

local operator_motion = {
  ["="] = vim.tbl_extend("force", { name = "+autoindent (dot to repeat)" }, g_textobj),
  [">"] = { name = "+indent right (dot to repeat)" },
  ["<"] = { name = "+indent left (dot to repeat)" },
  ["g,"] = { "go forward in :changes" },
  ["g;"] = { "go backward in :changes" },
  ["g<"] = vim.tbl_extend("force", { name = "+goto StarOf textobj (dot to repeat)" }, g_textobj),         -- only visual and normal mode
  ["g>"] = vim.tbl_extend("force", { name = "+goto EndOf textobj (dot to repeat)" }, g_textobj),          -- only visual and normal mode
  ["g["] = vim.tbl_extend("force", { name = "+Cursor to Left Around (mini textobj only)" }, ai_textobj),  -- supports operator pending mode, doesn't reset cursor like "g<a"
  ["g]"] = vim.tbl_extend("force", { name = "+Cursor to Rigth Around (mini textobj only)" }, ai_textobj), -- supports operator pending mode, doesn't reset cursor like "g>a"
  ["ga"] = vim.tbl_extend("force", { name = "+align (dot to repeat)" }, g_textobj),
  ["gA"] = vim.tbl_extend("force", { name = "+preview align (dot to repeat)" }, g_textobj),
  ["gb"] = { "add virtual cursor (select and find)" }, -- only visual and normal mode
  ["gc"] = { name = "+comment (dot to repeat)" },
  ["gd"] = { "goto definition" },
  ["ge"] = { "goto previous endOfWord" },
  ["gE"] = { "goto previous endOfWord" },
  ["gf"] = { "goto file under cursor" },
  ["gg"] = { "goto first line" },
  ["gh"] = { "paste LastSearch register (dot to repeat)" },
  ["gi"] = { "goto insert" },
  ["gI"] = { "select reference (under cursor)" },
  ["gj"] = { "goto Down (when wrapped)" },
  ["gJ"] = { "Join below Line" },
  ["gk"] = { "goto Up (when wrapped)" },
  ["gl"] = { "goto last change" },
  ["gm"] = { "goto mid window" },
  ["gM"] = { "goto mid line" },
  ["gn"] = { name = "+next (;, to repeat)" },
  ["go"] = { "add virtual cursor down (tab to extend/cursor mode)" },                                         -- only visual and normal mode
  ["gO"] = { "add virtual cursor up (tab to extend/cursor mode)" },                                           -- only visual and normal mode
  ["gp"] = { name = "+previous (;, to repeat)" },
  ["gq"] = vim.tbl_extend("force", { name = "+SplitJoin comment/lines 80chars (dot to repeat)" }, g_textobj), -- only visual and normal mode (cursor_position at start)
  ["gr"] = { "Redo register (dot to paste forward)" },
  ["gR"] = { "Redo register (dot to paste backward)" },                                                       -- (overwrites "replace mode")
  ["gs"] = { name = "+Surround (dot to repeat)" },
  ["gS"] = { "SplitJoin args (dot to repeat)" },
  ["gt"] = { "goto next tab" },
  ["gT"] = { "goto prev tab" },
  ["gu"] = { name = "+toLowercase (dot to repeat)" },                                                                 -- only visual and normal mode
  ["gU"] = { name = "+toUppercase (dot to repeat)" },                                                                 -- only visual and normal mode
  ["gv"] = { "last selected" },                                                                                       -- only visual and normal mode
  ["gw"] = vim.tbl_extend("force", { name = "+SplitJoin coments/lines 80chars (keeps cursor position)" }, g_textobj), -- only visual and normal mode (maintains cursor_position)
  ["gW"] = { "word-column multicursor" },                                                                             -- only visual and normal mode
  ["gx"] = vim.tbl_extend("force", { name = "+Blackhole register (dot to repeat)" }, g_textobj),                      -- only visual and normal mode (overwrites "open with system")
  ["gX"] = { "Blackhole linewise (dot to repeat)" },                                                                  -- only visual and normal mode
  ["gy"] = { name = "+replace with register (dot to repeat)" },                                                       -- only visual and normal mode
  ["gY"] = { name = "+exchange text" },                                                                               -- only visual and normal mode
  ["gz"] = { name = "+sort (dot to repeat)" },                                                                        -- only visual and normal mode
  ["g+"] = { "Increment number (dot to repeat)" },                                                                    -- only visual and normal mode
  ["g-"] = { "Decrement number (dot to repeat)" },                                                                    -- only visual and normal mode
  ["g|"] = { "same column for all virtual cursors" },                                                                 -- only visual and normal mode
  ["g\\"] = { "add virtual cursor at current position (eg after search/jump)" },                                      -- only visual and normal mode
  ["g<Up>"] = { "Numbers ascending" },                                                                                -- only visual and normal mode
  ["g<Down>"] = { "Numbers descending" },                                                                             -- only visual and normal mode
}

local visual_action = {
  ["g<"] = { "+goto StarOf textobj (dot to repeat)" },                           -- only visual and normal mode
  ["ga"] = { "Align" },                                                          -- only visual and normal mode
  ["gA"] = { "Preview Align" },                                                  -- only visual and normal mode
  ["gb"] = { "add virtual cursor (find selected)" },                             -- only visual and normal mode
  ["go"] = { "visual select to virtual cursor(n to add forward)" },              -- only visual and normal mode
  ["gO"] = { "visual select to virtual cursor(N to add backward)" },             -- only visual and normal mode
  ["gq"] = { "SplitJoin comments/lines (limited at 80 chars)" },                 -- only visual and normal mode
  ["gu"] = { "to lowercase" },                                                   -- only visual and normal mode
  ["gU"] = { "to Uppercase" },                                                   -- only visual and normal mode
  ["gv"] = { "last selected" },                                                  -- only visual and normal mode
  ["gw"] = { "SplitJoin comments/lines (limited at 80 chars)" },                 -- only visual and normal mode
  ["gW"] = { "word-column multicursor" },                                        -- only visual and normal mode
  ["gx"] = { "Blackhole register" },                                             -- only visual and normal mode
  ["gX"] = { "Blackhole linewise" },                                             -- only visual and normal mode
  ["gy"] = { "replace with register" },                                          -- only visual and normal mode
  ["gY"] = { "exchange text" },                                                  -- only visual and normal mode
  ["gz"] = { "sort" },                                                           -- only visual and normal mode
  ["g+"] = { "Increment number (dot to repeat)" },                               -- only visual and normal mode
  ["g-"] = { "Decrement number (dot to repeat)" },                               -- only visual and normal mode
  ["g|"] = { "same column for all virtual cursors" },                            -- only visual and normal mode
  ["g\\"] = { "add virtual cursor at current position (eg after search/jump)" }, -- only visual and normal mode
  ["g<Up>"] = { "Numbers ascending" },                                           -- only visual and normal mode
  ["g<Down>"] = { "Numbers descending" },                                        -- only visual and normal mode
  ["<leader><leader>p"] = { "Paste (second_clip)" },                             -- only visual and normal mode
  ["<leader><leader>P"] = { "Paste forward (second_clip)" },                     -- only visual and normal mode
  ["<leader><leader>y"] = { "Yank (second_clip)" },                              -- only visual and normal mode
  ["<leader><leader>Y"] = { "Yank forward (second_clip)" },                      -- only visual and normal mode
}

which_key.register({ mode = { "o", "x" }, g_textobj })
which_key.register({ mode = { "n" }, operator_motion })
which_key.register({ mode = { "x" }, visual_action })

-- Disable some operators (like v)
-- make sure to run this code before calling setup()
-- refer to the full lists at https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
-- local presets = require("which-key.plugins.presets")
-- presets.operators["v"] = nil
