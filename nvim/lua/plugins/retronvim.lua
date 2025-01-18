return {

  {
    "folke/flash.nvim",
    version = "v2.1.0",
    event = "VeryLazy",
    opts = { modes = { search = { enabled = true } } },
  },
  {
    "lewis6991/gitsigns.nvim",
    version = "0.9.0",
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "│" },
        topdelete    = { text = "" },
        changedelete = { text = "~" },
        untracked    = { text = '┆' },
      },
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = "v0.9.3",
    event = "VeryLazy",
    build = ":TSUpdate", -- treesitter works with specific versions of language parsers (required if upgrading treesitter)
    dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", commit = "ad8f0a472148c3e0ae9851e26a722ee4e29b1595" } },
    config = function()
      require("nvim-treesitter.configs").setup({
        indent = { enable = true },    -- https://www.reddit.com/r/neovim/comments/14n6iiy/if_you_have_treesitter_make_sure_to_disable_smartindent
        highlight = { enable = true }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5264
      })
    end
  },
  {
    "supermaven-inc/supermaven-nvim",
    commit = "07d20fce48a5629686aefb0a7cd4b25e33947d50",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<A-l>",
        clear_suggestion = "<A-k>",
        accept_word = "<A-j>",
      }
    }
  },
  {
    "echasnovski/mini.nvim",
    commit = "3a3178419ce9947f55708966dabf030eca40735a",
    event = "VeryLazy",
    config = function()
      -- ╭──────╮
      -- │ Mini │
      -- ╰──────╯

      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      local gen_ai_spec = require('mini.extra').gen_ai_spec

      require("mini.ai").setup({
        custom_textobjects = {
          K = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
          q = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
          Q = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
          g = spec_treesitter({ a = "@comment.outer", i = "@comment.inner" }),
          G = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
          F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          L = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
          P = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
          R = spec_treesitter({ a = "@return.outer", i = "@return.inner" }),
          ["A"] = spec_treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
          ["="] = spec_treesitter({ a = "@assignment.rhs", i = "@assignment.lhs" }),
          ["#"] = spec_treesitter({ a = "@number.outer", i = "@number.inner" }),
          d = gen_ai_spec.diagnostic(),                                                                                           -- diagnostic textobj
          e = gen_ai_spec.line(),                                                                                                 -- line textobj
          h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } },       -- html attribute textobj
          k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" },                                             -- key textobj
          v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },                                                        -- value textobj
          N = gen_ai_spec.number(),                                                                                               -- number(inside string) textobj { '[-+]?()%f[%d]%d+()%.?%d*' }
          x = { '#()%x%x%x%x%x%x()' },                                                                                            -- hexadecimal textobj
          o = { "%S()%s+()%S" },                                                                                                  -- whitespace textobj
          S = { { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]', }, '^().*()$' }, -- sub word textobj https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-ai.txt
          u = { { "%b''", '%b""', '%b``' }, '^.().*().$' },                                                                       -- quote textobj

          -- https://thevaluable.dev/vim-create-text-objects
          -- select indent by the same or mayor level delimited by blank-lines
          i = function()
            local start_indent = vim.fn.indent(vim.fn.line('.'))

            local prev_line = vim.fn.line('.') - 1
            while vim.fn.indent(prev_line) >= start_indent do
              prev_line = prev_line - 1
            end

            local next_line = vim.fn.line('.') + 1
            while vim.fn.indent(next_line) >= start_indent do
              next_line = next_line + 1
            end

            return { from = { line = prev_line + 1, col = 1 }, to = { line = next_line - 1, col = 100 }, vis_mode = 'V' }
          end,

          -- select indent by the same level delimited by comment-lines (outer: includes blank-lines)
          y = function()
            local start_indent = vim.fn.indent(vim.fn.line('.'))
            local get_comment_regex = "^%s*" .. string.gsub(vim.bo.commentstring, "%%s", ".*") .. "%s*$"
            local is_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
            local is_comment_line = function(line) return string.find(vim.fn.getline(line), get_comment_regex) end
            local is_out_of_range = function(line) return vim.fn.indent(line) == -1 end

            local prev_line = vim.fn.line('.') - 1
            while vim.fn.indent(prev_line) == start_indent or is_blank_line(prev_line) do
              if is_out_of_range(prev_line) then break end
              if is_comment_line(prev_line) then break end
              if is_blank_line(prev_line) and _G.skip_blank_line then break end
              prev_line = prev_line - 1
            end

            local next_line = vim.fn.line('.') + 1
            while vim.fn.indent(next_line) == start_indent or is_blank_line(next_line) do
              if is_out_of_range(next_line) then break end
              if is_comment_line(next_line) then break end
              if is_blank_line(next_line) and _G.skip_blank_line then break end
              next_line = next_line + 1
            end

            return { from = { line = prev_line + 1, col = 1 }, to = { line = next_line - 1, col = 100 }, vis_mode = 'V' }
          end
        },
        n_lines = 500, -- search range and required by functions less than 500 LOC
      })

      require('mini.surround').setup({
        mappings = {
          add = 'gza',            -- Add surrounding in Normal and Visual modes
          delete = 'gzd',         -- Delete surrounding
          find = 'gzf',           -- Find surrounding (to the right)
          find_left = 'gzF',      -- Find surrounding (to the left)
          highlight = 'gzh',      -- Highlight surrounding
          replace = 'gzr',        -- Replace surrounding
          update_n_lines = 'gzn', -- Update `n_lines`
        },
      })

      require("mini.files").setup({
        windows = {
          max_number = math.huge,
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 60,
        },
      })

      require('mini.base16').setup({
        -- `:Inspect` and `:hi <@treesitter>` to reverse engineering a colorscheme
        -- https://github.com/NvChad/base46/tree/v2.5/lua/base46/themes for popular colorscheme palettes
        palette = {
          -- nvchad tokyonight
          base00 = "#1a1b26", -- default bg
          base01 = "#16161e", -- line number bg
          base02 = "#2f3549", -- statusline bg, selection bg
          base03 = "#444b6a", -- line number fg, comments
          base04 = "#787c99", -- statusline fg
          base05 = "#a9b1d6", -- default fg, delimiters
          base06 = "#cbccd1", -- light fg (not often used)
          base07 = "#d5d6db", -- light bg (not often used)
          base08 = "#7aa2f7", -- variables, tags, Diff delete
          base09 = "#ff9e64", -- integers, booleans, constants, search fg
          base0A = "#0db9d7", -- classes, search bg
          base0B = "#73daca", -- strings, Diff insert
          base0C = "#2ac3de", -- builtins, regex
          base0D = "#7aa2f7", -- functions
          base0E = "#bb9af7", -- keywords, Diff changed
          base0F = "#7aa2f7", -- punctuation, indentscope
        },
        use_cterm = true,     -- required if `vi -c 'Pick files'`
      })

      vim.api.nvim_set_hl(0, "@property", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "@field", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "@keyword", { fg = "#9d7cd8" })
      vim.api.nvim_set_hl(0, "@keyword.function", { fg = "#6e51a2" })
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = "#1c1c2c" })
      vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#1c1c2c" })
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#506477", bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "Statusline", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatuslineNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#3C3CFf" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#990000" })
      vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", bg = "#2c2c2c" })

      require('mini.align').setup()
      require('mini.bracketed').setup({ undo = { suffix = '' } })
      require('mini.completion').setup({ delay = { completion = 10 ^ 7, info = 100, signature = 50 }, })
      require('mini.cursorword').setup()
      require('mini.extra').setup()
      require('mini.misc').setup_auto_root()
      require('mini.operators').setup()
      require('mini.pairs').setup()
      require('mini.pick').setup()
      require('mini.splitjoin').setup()
      vim.opt.cmdheight = 0                                                        -- more space in the neovim command line for displaying messages
      vim.opt.relativenumber = false                                               -- lazyvim uses relativenumber by default
      vim.opt.virtualedit = "all"                                                  -- allow cursor bypass end of line
      if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end -- it should be after require("mini.completion").setup())

      -- ╭────────────╮
      -- │ Navigation │
      -- ╰────────────╯

      local map = vim.keymap.set
      local flash = require("flash")
      local gs = require("gitsigns")
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      map({ "i" }, "jk", "<ESC>")
      map({ "i" }, "kj", "<ESC>")
      map({ "n" }, "J", "10gj")
      map({ "n" }, "K", "10gk")
      map({ "n" }, "H", "10h")
      map({ "n" }, "L", "10l")
      map({ "n" }, "<M-j>", "10gj")
      map({ "n" }, "<M-k>", "10gk")
      map({ "n" }, "<M-h>", "10h")
      map({ "n" }, "<M-l>", "10l")
      map({ "n" }, "<M-v>", "V")
      map({ "n" }, "Y", "yg_", { desc = "Yank forward" })  -- "Y" yank forward by default
      map({ "v" }, "Y", "g_y", { desc = "Yank forward" })
      map({ "v" }, "P", "g_P", { desc = "Paste forward" }) -- "P" doesn't change register
      map({ "v" }, "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
      map({ "n" }, "U", "@:", { desc = "repeat `:command`" })
      map({ "v" }, "<", "<gv", { desc = "continious indent" })
      map({ "v" }, ">", ">gv", { desc = "continious indent" })
      map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, desc = "next completion when no lsp" })
      map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, desc = "prev completion when no lsp" })
      map({ "n", "v", "t" }, "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
      map({ "n", "v", "t" }, "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
      map({ "n", "v", "t" }, "<M-Up>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
      map({ "n", "v", "t" }, "<M-Down>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
      map({ "n" }, "<esc>", "<esc><cmd>lua vim.cmd.nohlsearch()<cr>", { desc = "escape and clear search highlight" })
      map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
      map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
      map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
      map({ "t", "n" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window" })
      map({ "t", "n" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window" })
      map({ "t", "n" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window" })
      map({ "t", "n" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window" })
      map({ "t", "n" }, "<C-;>", "<C-\\><C-n><C-6>", { desc = "go to last buffer" })
      map({ "n" }, "<right>", ":bnext<CR>", { desc = "next buffer" })
      map({ "n" }, "<left>", ":bprevious<CR>", { desc = "prev buffer" })
      map({ "n" }, "<leader>x", ":bp | bd! #<CR>", { desc = "Close Buffer" }) -- `bd!` forces closing terminal buffer
      map({ "n" }, "<leader>;", ":buffer #<cr>", { desc = "Recent buffer" })
      map({ "n" }, "Q", "<cmd>lua vim.cmd('quit')<cr>")
      map({ "n" }, "R", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 }) vim.cmd('silent write') <cr>")

      -- ╭────────────────╮
      -- │ leader keymaps │
      -- ╰────────────────╯

      -- LSP
      require("mason").setup()

      -- https://github.com/NvChad/ui/blob/v3.0/lua/nvchad/mason/names.lua
      local masonames = {
        angularls = "angular-language-server",
        astro = "astro-language-server",
        bashls = "bash-language-server",
        cmake = "cmake-language-server",
        csharp_ls = "csharp-language-server",
        css_variables = "css-variables-language-server",
        cssls = "css-lsp",
        cssmodules_ls = "cssmodules-language-server",
        denols = "deno",
        docker_compose_language_service = "docker-compose-language-service",
        dockerls = "dockerfile-language-server",
        emmet_language_server = "emmet-language-server",
        emmet_ls = "emmet-ls",
        eslint = "eslint-lsp",
        graphql = "graphql-language-service-cli",
        gitlab_ci_ls = "gitlab-ci-ls",
        gopls = "gopls",
        html = "html-lsp",
        htmx = "htmx-lsp",
        java_language_server = "java-language-server",
        jdtls = "jdtls",
        jsonls = "json-lsp",
        lua_ls = "lua-language-server",
        neocmake = "neocmakelsp",
        nginx_language_server = "nginx-language-server",
        omnisharp = "omnisharp",
        prismals = "prisma-language-server",
        pylsp = "python-lsp-server",
        pylyzer = "pylyzer",
        quick_lint_js = "quick-lint-js",
        r_language_server = "r-languageserver",
        ruby_lsp = "ruby-lsp",
        ruff_lsp = "ruff-lsp",
        rust_analyzer = "rust-analyzer",
        svelte = "svelte-language-server",
        tailwindcss = "tailwindcss-language-server",
        ts_ls = "typescript-language-server",
        volar = "vue-language-server",
        vuels = "vetur-vls",
        yamlls = "yaml-language-server",
      }

      -- extract installed lsp servers from mason.nvim
      local servers = {}
      local pkgs = require("mason-registry").get_installed_packages()
      for _, pkgvalue in pairs(pkgs) do
        if pkgvalue.spec.categories[1] == "LSP" then
          table.insert(servers, pkgvalue.name)
        end
      end

      -- update incompatible mason's lsp names according to nvim-lspconfig
      -- https://github.com/NvChad/ui/blob/v3.0/lua/nvchad/mason/init.lua
      for masonkey, masonvalue in pairs(masonames) do
        for serverkey, servervalue in pairs(servers) do
          if masonvalue == servervalue then
            servers[serverkey] = masonkey
          end
        end
      end

      -- autoconfigure lsp servers installed by mason
      for _, server in pairs(servers) do
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        local opts = { capabilities = capabilities }

        require("lspconfig")[server].setup(opts)
      end

      -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/formatters
      -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/linters
      if vim.tbl_contains(servers, "efm") then
        require("lspconfig").efm.setup {
          init_options = { documentFormatting = true },
          settings = {
            rootMarkers = { ".git/" },
            languages = {
              python = { { formatCommand = "black -", formatStdin = true } },
              javascript = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              javascriptreact = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              typescript = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              typescriptreact = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              css = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              html = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              json = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              markdown = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
              yaml = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
            }
          }
        }
      end

      map("n", "<leader>l", "", { desc = "+LSP" })
      map("n", "<leader>lA", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
      map("n", "<leader>lc", function() vim.lsp.buf.incoming_calls() end, { desc = "Incoming Calls" })
      map("n", "<leader>lC", function() vim.lsp.buf.outcoming_calls() end, { desc = "Outcoming Calls" })
      map("n", "<leader>ld", ":Pick lsp scope='definition'<cr>", { desc = "Goto Definition" })
      map("n", "<leader>lD", ":Pick lsp scope='declaration'<cr>", { desc = "Goto Declaration" })
      map("n", "<leader>lF", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, { desc = "Format" })
      map("n", "<leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "Signature" })
      map("n", "<leader>lH", function() vim.lsp.buf.hover() end, { desc = "Hover" })
      map("n", "<leader>lI", ":Pick lsp scope='implementation'<cr>", { desc = "Goto Implementation" })
      map("n", "<leader>lm", ":Mason<cr>", { desc = "Mason" })
      map("n", "<leader>ln", function() vim.diagnostic.jump { count = 1, float = true } end, { desc = "next diagnostic" })
      map("n", "<leader>lo", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostic" })
      map("n", "<leader>lp", function() vim.diagnostic.jump { count = -1, float = true } end, { desc = "prev diagnostc" })
      map("n", "<leader>lq", ":Pick diagnostic<cr>", { desc = "Diagnostic List" })
      map("n", "<leader>lr", ":Pick lsp scope='references'<cr>", { desc = "References" })
      map("n", "<leader>lR", function() vim.lsp.buf.rename() end, { desc = "Rename" })
      map("n", "<leader>ls", ":Pick lsp scope='document_symbol'<cr>", { desc = "Document symbols" })
      map("n", "<leader>ls", ":Pick lsp scope='workspace_symbol'<cr>", { desc = "Workspace symbol" })
      map("n", "<leader>lt", ":Pick lsp scope='type_definition'<cr>", { desc = "Goto TypeDefinition" })
      map("n", "<leader>l0", ":LspStop<cr>", { desc = "lsp stop" })
      map("n", "<leader>o", ":lua MiniFiles.open()<cr>", { desc = "Open Explorer (CWD)" })
      map("n", "<leader>O", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", { desc = "Open Explorer" })
      map("n", "<leader>f", "", { desc = "+Find" })
      map("n", "<leader>ff", ":Pick files<cr>", { desc = "Files (tab to preview)" })
      map("n", "<leader>f/", ":Pick git_files<cr>", { desc = "Git/hidden files (tab to preview)" })
      map("n", "<leader>fg", ":Pick grep_live<cr>", { desc = "Grep (tab to preview)" })
      map("n", "<leader>f'", ":Pick marks<cr>", { desc = "Marks (tab to preview)" })
      map("n", '<leader>f"', ":Pick registers<cr>", { desc = "register (:help quote)" })
      map("n", "<leader>fn", ":lua MiniNotify.show_history()<cr>", { desc = "Notify history" })
      map("n", "<leader>g", "", { desc = "+Git" })
      map("n", "<leader>gg", ":lua vim.cmd[[terminal lazygit]] vim.cmd[[set ft=terminal]]<cr>", { desc = "lazygit" })
      map("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", { silent = true, desc = "Preview GitHunk" })
      map("n", "<leader>gr", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "Reset GitHunk" })
      map("n", "<leader>gs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "Stage GitHunk" })
      map("n", "<leader>gS", ":Gitsigns undo_stage_hunk<cr>", { silent = true, desc = "Undo stage GitHunk" })
      map("n", "<leader>u", "", { desc = "+UI toggle" })
      map("n", "<leader>u0", ":set showtabline=0<cr>", { desc = "Buffer Hide" })
      map("n", "<leader>u2", ":set showtabline=2<cr>", { desc = "Buffer Show" })
      map("n", "<leader>um", ":SupermavenStop<cr>", { desc = "Supermaven stop" })
      map("n", "<leader>uM", ":SupermavenStart<cr>", { desc = "Supermaven start" })
      map("n", "<leader>us", ":set laststatus=0<cr>", { desc = "StatusBar Hide" })
      map("n", "<leader>uS", ":set laststatus=3<cr>", { desc = "StatusBar Show" })
      map("n", "<leader>t", "", { desc = "+Terminal" })
      map("n", "<leader>tt", ":lua vim.cmd [[ terminal ]] <cr>", { desc = "buffer terminal" })
      map("n", "<leader>ty", ":lua vim.cmd [[ terminal yazi]] vim.cmd[[set filetype=terminal]]<cr>", { desc = "yazi" })
      map("n", "<leader>v", ":lua vim.cmd [[ split  | terminal ]] <cr>", { desc = "vertical terminal" })
      map("n", "<leader>V", ":lua vim.cmd [[ vsplit | terminal ]] <cr>", { desc = "horizontal terminal" })
      map("n", "<leader><leader>p", '"*p', { desc = "Paste after (second_clip)" })
      map("n", "<leader><leader>P", '"*P', { desc = "Paste before (second_clip)" })
      map("x", "<leader><leader>p", '"*p', { desc = "Paste (second_clip)" })           -- "Paste after (second_clip)"
      map("x", "<leader><leader>P", 'g_"*P', { desc = "Paste forward (second_clip)" }) -- only works in visual mode
      map("n", "<leader><leader>y", '"*y', { desc = "Yank (second_clip)" })
      map("n", "<leader><leader>Y", '"*yg_', { desc = "Yank forward (second_clip)" })
      map("x", "<leader><leader>y", '"*y', { desc = "Yank (second_clip)" })
      map("x", "<leader><leader>Y", 'g_"*y', { desc = "Yank forward (second_clip)" })

      -- ╭────────────────────╮
      -- │ Operator / Motions │
      -- ╰────────────────────╯

      -- https://vi.stackexchange.com/questions/22570/is-there-a-way-to-move-to-the-beginning-of-the-next-text-object
      map(
        { "n", "x" },
        "gh",
        function()
          local ok1, tobj_id1 = pcall(vim.fn.getcharstr)
          local ok2, tobj_id2 = pcall(vim.fn.getcharstr)
          if not ok1 then return end
          if not ok2 then return end
          local cmd = ":normal v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`<"
          if vim.fn.mode() ~= "n" then
            cmd = "<esc>:normal m'v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`<v`'"
          end
          return cmd
        end,
        { expr = true, desc = "Start of TextObj" }
      )
      map(
        { "n", "x" },
        "gl",
        function()
          local ok1, tobj_id1 = pcall(vim.fn.getcharstr)
          local ok2, tobj_id2 = pcall(vim.fn.getcharstr)
          if not ok1 then return end
          if not ok2 then return end
          local cmd = ":normal v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`>"
          if vim.fn.mode() ~= "n" then
            cmd = ":<c-u>normal m'v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`'v`>"
          end
          return cmd
        end,
        { expr = true, desc = "End of TextObj" }
      )

      map({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
      map({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
      map({ "n", "x", "o" }, "<cr>", function() flash.jump({ continue = true }) end, { desc = "Continue Flash search" })
      map({ "x", "o" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Flash Search" })
      map({ "c" }, "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
      map({ "n", "x" }, "gb", '"_d', { desc = "Blackhole Motion/Selected (dot to repeat)" })
      map({ "n", "x" }, "gB", '"_D', { desc = "Blackhole Linewise (dot to repeat)" })
      map({ "n", "o", "x" }, "g.", "`.", { desc = "go to last change" })
      map({ "n" }, "g,", "g,", { desc = "go forward in :changes" })  -- Formatting will lose track of changes
      map({ "n" }, "g;", "g;", { desc = "go backward in :changes" }) -- Formatting will lose track of changes
      map({ "n" }, "gy", '"1p', { desc = "Redo register (dot to Paste forward the rest of register)" })
      map({ "n" }, "gY", '"1P', { desc = "Redo register (dot to Paste backward the rest of register)" })
      map({ "n" }, "g<Up>", "<c-a>", { desc = "numbers ascending" })
      map({ "n" }, "g<Down>", "<c-x>", { desc = "numbers descending" })
      map({ "x" }, "g<Up>", "g<c-a>", { desc = "numbers ascending" })
      map({ "x" }, "g<Down>", "g<c-x>", { desc = "numbers descending" })
      map({ "n", "x" }, "g+", "<C-a>", { desc = "Increment number (dot to repeat)" })
      map({ "n", "x" }, "g-", "<C-x>", { desc = "Decrement number (dot to repeat)" })

      -- ╭───────────────────────────────────────╮
      -- │ Text Objects with "g" (dot to repeat) │
      -- ╰───────────────────────────────────────╯

      map({ "n" }, "vgc", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "select BlockComment" })
      map({ "o", "x" }, "gC", ":<c-u>lua require('mini.comment').textobject()<cr>", { desc = "BlockComment textobj" })
      map({ "o", "x" }, "gf", "gn", { desc = "Next find textobj" })
      map({ "o", "x" }, "gF", "gN", { desc = "Prev find textobj" })
      map({ "o", "x" }, "gh", ":<c-u>Gitsigns select_hunk<cr>", { desc = "Git hunk textobj" })

      -- ╭───────────────────────────────────────╮
      -- │ Text Objects with a/i (dot to repeat) │
      -- ╰───────────────────────────────────────╯

      map({ "o", "x" }, "iI", function() require("mini.indentscope").textobject(false) end, { desc = "indent blank" })
      map({ "o", "x" }, "aI", function() require("mini.indentscope").textobject(true) end, { desc = "indent blank" })
      map({ "o", "x" }, "ii", function() require("mini.ai").select_textobject("i", "i") end, { desc = "indent" })
      map({ "o", "x" }, "ai", ":normal Viik<cr>", { desc = "indent" })
      map(
        { "o", "x" },
        "iy",
        function()
          _G.skip_blank_line = true
          require("mini.ai").select_textobject("i", "y")
        end,
        { desc = "same_indent" }
      )
      map(
        { "o", "x" },
        "ay",
        function()
          _G.skip_blank_line = false
          require("mini.ai").select_textobject("i", "y")
        end,
        { desc = "same_indent" }
      )
      map({ "x" }, "iz", ":<c-u>normal! [zjV]zk<cr>", { desc = "inner fold" })
      map({ "o" }, "iz", ":normal Viz<CR>", { desc = "inner fold" })
      map({ "x" }, "az", ":<c-u>normal! [zV]z<cr>", { desc = "outer fold" })
      map({ "o" }, "az", ":normal Vaz<cr>", { desc = "outer fold" })

      -- ╭──────────────────────────────────────────────────╮
      -- │ Repeatable Pair - textobj navigation using gn/gp │
      -- ╰──────────────────────────────────────────────────╯

      -- _nvim-treesitter-textobjs_repeatable
      map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { silent = true, desc = "Next TS textobj" })
      map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { silent = true, desc = "Prev TS textobj" })

      local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(
        function() vim.diagnostic.jump({ count = 1, float = true }) end,
        function() vim.diagnostic.jump({ count = -1, float = true }) end
      )
      map({ "n", "x", "o" }, "gnd", next_diagnostic, { desc = "Next Diagnostic" })
      map({ "n", "x", "o" }, "gpd", prev_diagnostic, { desc = "Prev Diagnostic" })

      local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { silent = true, desc = "Next GitHunk" })
      map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { silent = true, desc = "Prev GitHunk" })

      local next_comment, prev_comment = ts_repeat_move.make_repeatable_move_pair(
        function() require("mini.bracketed").comment("forward") end,
        function() require("mini.bracketed").comment("backward") end
      )
      map({ "n", "x", "o" }, "gnc", next_comment, { desc = "Next Comment" })
      map({ "n", "x", "o" }, "gpc", prev_comment, { desc = "Prev Comment" })

      local next_fold, prev_fold = ts_repeat_move.make_repeatable_move_pair(
        function() vim.cmd([[ normal ]z ]]) end,
        function() vim.cmd([[ normal [z ]]) end
      )
      map({ "n", "x", "o" }, "gnf", next_fold, { desc = "Fold ending" })
      map({ "n", "x", "o" }, "gpf", prev_fold, { desc = "Fold beginning" })

      local repeat_mini_ai = function(inner_or_around, key, desc)
        local next, prev = ts_repeat_move.make_repeatable_move_pair(
          function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "next" }) end,
          function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "prev" }) end
        )
        map({ "n", "x", "o" }, "gn" .. inner_or_around .. key, next, { desc = desc })
        map({ "n", "x", "o" }, "gp" .. inner_or_around .. key, prev, { desc = desc })
      end

      repeat_mini_ai("i", "f", "function call")
      repeat_mini_ai("a", "f", "function call")
      repeat_mini_ai("i", "h", "html atrib")
      repeat_mini_ai("a", "h", "html atrib")
      repeat_mini_ai("i", "k", "key")
      repeat_mini_ai("a", "k", "key")
      repeat_mini_ai("i", "n", "number")
      repeat_mini_ai("a", "n", "number")
      repeat_mini_ai("i", "u", "quote")
      repeat_mini_ai("a", "u", "quote")
      repeat_mini_ai("i", "v", "value")
      repeat_mini_ai("a", "v", "value")
      repeat_mini_ai("i", "x", "hexadecimal")
      repeat_mini_ai("a", "x", "hexadecimal")
      repeat_mini_ai("i", "K", "@block.inner")
      repeat_mini_ai("a", "K", "@block.outer")
      repeat_mini_ai("i", "Q", "@call.inner")
      repeat_mini_ai("a", "Q", "@call.outer")
      repeat_mini_ai("i", "g", "@comment.inner")
      repeat_mini_ai("a", "g", "@comment.outer")
      repeat_mini_ai("i", "G", "@conditional.inner")
      repeat_mini_ai("a", "G", "@conditional.outer")
      repeat_mini_ai("i", "F", "@function.inner")
      repeat_mini_ai("a", "F", "@function.outer")
      repeat_mini_ai("i", "L", "@loop.inner")
      repeat_mini_ai("a", "L", "@loop.outer")
      repeat_mini_ai("i", "P", "@parameter.inner")
      repeat_mini_ai("a", "P", "@parameter.outer")
      repeat_mini_ai("i", "R", "@return.inner")
      repeat_mini_ai("a", "R", "@return.outer")
      repeat_mini_ai("i", "A", "@assignment.inner")
      repeat_mini_ai("a", "A", "@assignment.outer")
      repeat_mini_ai("i", "=", "@assignment.lhs")
      repeat_mini_ai("a", "=", "@assignment.rhs")
      repeat_mini_ai("i", "#", "@number.inner")
      repeat_mini_ai("a", "#", "@number.outer")
    end
  },
}
