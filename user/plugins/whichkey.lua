------------------------------------------------------------------------------------------------------------------------

local _, terminal = pcall(require, "toggleterm.terminal")
local temp_path = "/tmp/lfpickerpath"
function _LF_TOGGLE(dir, openmode)
  terminal.Terminal:new({
    cmd = "lf -selection-path " .. temp_path .. " " .. dir,
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

------------------------------------------------------------------------------------------------------------------------

_G.EnableAutoNoHighlightSearch = function()
  vim.on_key(function(char)
    if vim.fn.mode() == "n" then
      local new_hlsearch = vim.tbl_contains({ "<Up>", "<Down>", "<CR>", "n", "N", "*", "#", "?", "/" },
        vim.fn.keytrans(char))
      if vim.opt.hlsearch:get() ~= new_hlsearch then vim.cmd [[ noh ]] end
    end
  end, vim.api.nvim_create_namespace "auto_hlsearch")
end

_G.DisableAutoNoHighlightSearch = function()
  vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])
  vim.cmd [[ set hlsearch ]]
end

------------------------------------------------------------------------------------------------------------------------

_G.FeedKeysCorrectly = function(keys)
  local feedableKeys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(feedableKeys, "n", true)
end

------------------------------------------------------------------------------------------------------------------------

_G.GoToParentIndent = function()
  local ok, start = require("indent_blankline.utils").get_current_context(
    vim.g.indent_blankline_context_patterns,
    vim.g.indent_blankline_use_treesitter_scope
  )
  if ok then
    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
    vim.cmd [[normal! _]]
  end
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

return {
  {
    "folke/which-key.nvim",
    lazy = false,
    dependencies = { "machakann/vim-columnmove" },
    config = function()

      require("which-key").setup({
        plugins = {
          spelling = { enabled = true },
          presets = { operators = true },
        },
        window = {
          border = "rounded",
          padding = { 2, 2, 2, 2 },
        },
        disable = { filetypes = { "TelescopePrompt" } },
      })

      require("which-key").register({
        -- Add bindings which show up as group name
        -- register = {
        -- first key is the mode, n == normal mode
        -- n = {
        ["H"] = { "10h", "Jump 10h" },
        ["J"] = { "10j", "Jump 10j" },
        ["K"] = { "10k", "Jump 10k" },
        ["L"] = { "10l", "Jump 10l" },
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- third key is the key to bring up next level and its displayed
          -- group name in which-key top level menu
          ["."] = { "<cmd>Telescope resume<cr>", "Telescope resume" },
          [";"] = {
            name = "Tabs",
            C = { "<cmd>tabonly<cr>", "Close others Tabs" },
            n = { "<cmd>tabnext<cr>", "Next Tab" },
            p = { "<cmd>tabprevious<cr>", "Previous Tab" },
            N = { "<cmd>+tabmove<cr>", "move tab to next tab" },
            P = { "<cmd>-tabmove<cr>", "move tab to previous tab" },
            t = { "<cmd>tabnew<cr>", "New Tab" },
            x = { "<cmd>tabclose<cr>", "Close Tab" },
            [";"] = { "<cmd>tabnext #<cr>", "Recent Tab" },
            ["<Tab>"] = { "<cmd>tabprevious<cr>", "Previous Tab" },
            ["<S-Tab>"] = { "<cmd>tabnext<cr>", "Next Tab" },
          },
          ["b"] = {
            name = "Buffers",
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
            C = { "<cmd>%bd|e#|bd#<cr>", "Close others Buffers" },
            s = { "<cmd>bprev<cr>", "Previous Buffer" },
            f = { "<cmd>bnext<cr>", "Next Buffer" },
            t = { function() vim.cmd [[ enew ]] end, "New buffer" },
            ["<TAB>"] = {
              function()
                vim.cmd [[ setlocal nobuflisted ]]
                vim.cdm [[ bprevious ]]
                vim.cmd [[ tabe # ]]
              end,
              "buffer to Tab"
            },
            v = { "<cmd>vertical ball<cr>", "Buffers to vertical windows" },
            V = { "<cmd>belowright ball<cr>", "Buffers to horizontal windows" },
            x = { "<cmd>:bp | bd #<cr>", "Close Buffer" },
            [";"] = { "<cmd>buffer #<cr>", "Recent buffer" },
          },
          ["d"] = {
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
          ["g"] = {
            name = "Git",
            g = {
              "<cmd>lua require 'toggleterm.terminal'.Terminal:new({ cmd='lazygit', direction='tab', hidden=true }):toggle()<cr>",
              "Tab Lazygit"
            },
            G = { function() astronvim.toggle_term_cmd "lazygit" end, "Float Lazygit" },
            L = { "<cmd>terminal lazygit<cr><cmd>set ft=tab-terminal<cr>", "Buffer Lazygit" },
            j = { function() WhichkeyRepeat("lua require 'gitsigns'.next_hunk()") end, "Next Hunk" },
            k = { function() WhichkeyRepeat("lua require 'gitsigns'.prev_hunk()") end, "Prev Hunk" },
            l = { function() WhichkeyRepeat("lua require 'gitsigns'.blame_line()") end, "Blame" },
            p = { function() WhichkeyRepeat("lua require 'gitsigns'.preview_hunk()") end, "Preview Hunk" },
            r = { function() WhichkeyRepeat("lua require 'gitsigns'.reset_hunk()") end, "Reset Hunk" },
            R = { function() WhichkeyRepeat("lua require 'gitsigns'.reset_buffer()") end, "Reset Buffer" },
            s = { function() WhichkeyRepeat("lua require 'gitsigns'.stage_hunk()") end, "Stage Hunk" },
            u = { function() WhichkeyRepeat("lua require 'gitsigns'.undo_stage_hunk()") end, "Undo Stage Hunk" },
            d = { function() WhichkeyRepeat("Gitsigns diffthis HEAD") end, "Diff", },
            o = { "<cmd>Telescope git_status initial_mode=normal<cr>", "Open Changed File" },
            b = { "<cmd>Telescope git_branches initial_mode=normal<cr>", "Checkout Branch" },
            c = { "<cmd>Telescope git_commits initial_mode=normal<cr>", "Checkout Commit" },
            ["t"] = { "which_key_ignore" },
          },
          ["p"] = {
            name = "Packages",
            -- C = { "<cmd><cr>", "Packer Clean" },
            L = { "<cmd>LspInfo<cr>", "Lsp Info" },
            N = { "<cmd>NullLsInfo<cr>", "NullLs Info" },
          },
          ["s"] = {
            name = "Search",
            b = { "<cmd>Telescope buffers initial_mode=normal<cr>", "Buffers" },
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
            n = { "<cmd>Telescope neoclip initial_mode=normal<cr>", "NeoClip" },
            N = { "<cmd>Telescope notify initial_mode=normal<cr>", "Search notifications" },
            O = { "<cmd>lua require('notify').history()<cr>", "History notifications" },
            o = { "<cmd>Telescope file_browser initial_mode=normal<cr>", "Open File Browser" },
            p = { "<cmd>Telescope projects<cr>", "Projects" },
            q = { "<cmd>Telescope quickfixhistory initial_mode=normal<cr>", "Telescope QuickFix History" },
            Q = { "<cmd>Telescope quickfix initial_mode=normal<cr>", "Telescope QuickFix" },
            r = { "<cmd>Telescope oldfiles initial_mode=normal<cr>", "Open Recent File" },
            R = { "<cmd>Telescope registers initial_mode=normal<cr>", "Registers" },
            s = { "<cmd>Telescope grep_string<cr>", "Grep string under cursor" },
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
          t = {
            name = "Terminal",
            ["<TAB>"] = { function() vim.cmd [[ wincmd T ]] end, "Terminal to Tab" },
            b = {
              function()
                vim.cmd [[ terminal ]]
                vim.cmd [[ startinsert | set ft=buf-terminal nonumber ]]
              end,
              "Buffer terminal"
            },
            B = {
              function()
                vim.cmd [[ tabnew|terminal ]]
                vim.cmd [[ startinsert | set ft=tab-terminal nonumber ]]
              end,
              "Buffer Terminal (Tab)"
            },
            f = { "<cmd>ToggleTerm direction=float<cr>", "Float ToggleTerm" },
            l = {
              function()
                _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'vsplit')
              end,
              "lf (TabSame)"
            },
            L = {
              function()
                _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'tabnew')
              end,
              "lf (TabNew)"
            },
            r = {
              function()
                _LF_TOGGLE(vim.api.nvim_buf_get_name(0), 'tabreplace')
              end,
              "lf (TabReplace)"
            },
            t = { "<cmd>ToggleTerm <cr>", "Toggle ToggleTerm" },
            T = { "<cmd>ToggleTerm direction=tab <cr>", "Tab ToggleTerm" },
            H = { "<cmd>split +te | resize 10 | setlocal ft=sp-terminal<cr>", "Horizontal terminal" },
            V = { "<cmd>vsplit +te | vertical resize 80 | setlocal ft=vs-terminal<cr>", "Vertical terminal" },
            h = { "<cmd>ToggleTerm direction=horizontal size=10<cr>", "Horizontal ToggleTerm" },
            v = { "<cmd>ToggleTerm direction=vertical   size=80<cr>", "Vertical ToggleTerm" },
            ["2h"] = { "<cmd>2ToggleTerm direction=vertical   <cr>", "Toggle second horizontal ToggleTerm" },
            ["2v"] = { "<cmd>2ToggleTerm direction=horizontal <cr>", "Toggle second vertical ToggleTerm" },
            ["3h"] = { "<cmd>3ToggleTerm direction=vertical   <cr>", "Toggle third horizontal ToggleTerm" },
            ["3v"] = { "<cmd>3ToggleTerm direction=horizontal <cr>", "Toggle third vertical ToggleTerm" },
            ["4h"] = { "<cmd>4ToggleTerm direction=vertical   <cr>", "Toggle fourth horizontal ToggleTerm" },
            ["4v"] = { "<cmd>4ToggleTerm direction=horizontal <cr>", "Toggle fourth vertical ToggleTerm" },
          },
          ["u"] = {
            name = "UI",
            u = { function() WhichkeyRepeat("normal! 0", "lua GoToParentIndent()") end, "Jump to current_context", },
            U = { function() astronvim.ui.toggle_url_match() end, "Toggle URL highlight" },
            [";"] = { ":clearjumps<cr>:normal m'<cr>", "Clear and Add jump" }, -- Reset JumpList
          },
          ["U"] = {
            name = "TUI",
            ["0"] = { "<cmd>set showtabline=0<cr>", "Hide Buffer" },
            ["1"] = { "<cmd>set showtabline=2<cr>", "Show Buffer" },
            a = { "<cmd>Alpha<cr>", "Alpha (TabSame)" },
            A = { "<cmd>tabnew | Alpha<cr>", "Alpha (TabNew)" },
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
            h = { function() EnableAutoNoHighlightSearch() end, "Disable AutoNoHighlightSearch" },
            H = { function() DisableAutoNoHighlightSearch() end, "Enable AutoNoHighlightSearch" },
            I = { "<cmd>IndentBlanklineToggle<cr>", "Toggle IndentBlankline" },
            l = { "<cmd>set cursorline!<cr>", "Toggle Cursorline" },
            L = { "<cmd>setlocal cursorline!<cr>", "Toggle Local Cursorline" },
            o = { "<cmd>Legendary<cr>", "Open Legendary" },
            ["P"] = { function() require("ufo").peekFoldedLinesUnderCursor() end, "peek FoldedLines" },
            r = {
              function()
                require("toggleterm.terminal").Terminal:new({ cmd = "resto", direction = "tab", hidden = true })
                    :toggle()
              end,
              "Rest Client"
            },
          },
          w = {
            name = "Window",
            B = { "<cmd>all<cr>", "Windows to buffers" },
            C = { "<C-w>o", "Close Other windows" },
            h = { "<C-w>H", "Move window to Leftmost" },
            j = { "<C-w>J", "Move window to Downmost" },
            k = { "<C-w>K", "Move window to Upmost" },
            l = { "<C-w>L", "Move window to Rightmost" },
            m = { "<C-w>_ | <c-w>|", "Maximize window" },
            n = { "<C-w>w", "Switch to next window CW " },
            p = { "<C-w>W", "Switch to previous window CCW" },
            q = { "<cmd>qa<cr>", "Quit all" },
            s = { "<cmd>wincmd x<cr>", "window Swap CW (same parent node)" },
            S = { "<cmd>-wincmd x<cr>", "window Swap CCW (same parent node)" },
            r = { "<C-w>r", "Rotate CW (same parent node)" },
            R = { "<C-w>R", "Rotate CCW (same parent node)" },
            ["<TAB>"] = {
              function()
                vim.cmd [[ setlocal nobuflisted ]]
                vim.cmd [[ wincmd T ]]
              end,
              "window to Tab"
            },
            v = { "<cmd>vsplit<cr>", "split vertical" },
            V = { "<cmd>split<cr>", "split horizontal" },
            w = { "<cmd>new<cr>", "New horizontal window" },
            W = { "<cmd>vnew<cr>", "New vertical window" },
            x = { "<cmd>wincmd q<cr>", "Close window" },
            [";"] = { "<C-w>p", "recent window" },
            ["="] = { "<C-w>=", "Reset windows sizes" },
          },

          ["1"] = "which_key_ignore",
          ["2"] = "which_key_ignore",
          ["3"] = "which_key_ignore",
          ["4"] = "which_key_ignore",
          ["5"] = "which_key_ignore",
          ["6"] = "which_key_ignore",
          ["7"] = "which_key_ignore",
          ["8"] = "which_key_ignore",
          ["9"] = "which_key_ignore",
          ["v"] = "which_key_ignore",
          ["V"] = "which_key_ignore",
          ["q"] = "which_key_ignore",
          ["<Tab>"] = { "which_key_ignore" },
          ["<S-Tab>"] = { "which_key_ignore" },
          ["'"] = { "<Cmd>Telescope marks initial_mode=normal<CR>", "Marks" },
        }
        -- }
        -- }
      })
    end
  }
}
