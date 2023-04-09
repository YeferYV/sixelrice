return {
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    opts = function()
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

      local button = require("astronvim.utils").alpha_button
      dashboard.section.buttons.val = {
        dashboard.button("p", " " .. " Find Project", ":Telescope projects initial_mode=normal<cr>"),
        dashboard.button("f", " " .. " Find File", ":Telescope find_files initial_mode=normal<cr>"),
        dashboard.button("o", " " .. " Recents", ":Telescope oldfiles initial_mode=normal<cr>"),
        dashboard.button("w", " " .. " Find Word", ":Telescope live_grep  initial_mode=normal<cr>"),
        dashboard.button("n", " " .. " New File", ":enew<cr>"),
        dashboard.button("m", " " .. " Bookmarks", ":Telescope marks initial_mode=normal<cr>"),
        dashboard.button("b", " " .. " File Browser", ":Telescope file_browser initial_mode=normal<cr>"),
        dashboard.button("l", " " .. " Explorer", ":lua _LF_TOGGLE(vim.api.nvim_buf_get_name(0),'tabreplace')<cr>"),
        dashboard.button("t", " " .. " Terminal",
          ":lua vim.cmd[[ tabedit | terminal ]] vim.cmd[[ tabclose # ]] vim.cmd[[ set ft=tab-terminal nonumber laststatus=0 ]]<cr>"),
        dashboard.button("T", " " .. " Tmux",
          ":lua vim.cmd[[ tabnew | terminal tmux ]] vim.cmd[[ tabclose # ]] vim.cmd[[ set ft=tab-terminal nonumber laststatus=0 ]]<cr>"),
        dashboard.button("s", " " .. " Last Session", ":SessionManager load_last_session<cr>"),
      }

      dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.08) }
      dashboard.config.layout[3].val = 3
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
    config = require "plugins.configs.alpha",
  },
  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },
  --
  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  -- {
  --   "L3MON4D3/LuaSnip",
  --   config = function(plugin, opts)
  --     require "plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom luasnip configuration such as filetype extend or custom snippets
  --     local luasnip = require "luasnip"
  --     luasnip.filetype_extend("javascript", { "javascriptreact" })
  --   end,
  -- },
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function(plugin, opts)
  --     require "plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom autopairs configuration such as custom rules
  --     local npairs = require "nvim-autopairs"
  --     local Rule = require "nvim-autopairs.rule"
  --     local cond = require "nvim-autopairs.conds"
  --     npairs.add_rules(
  --       {
  --         Rule("$", "$", { "tex", "latex" })
  --           -- don't add a pair if the next character is %
  --           :with_pair(cond.not_after_regex "%%")
  --           -- don't add a pair if  the previous character is xxx
  --           :with_pair(
  --             cond.not_before_regex("xxx", 3)
  --           )
  --           -- don't move right when repeat character
  --           :with_move(cond.none())
  --           -- don't delete if the next character is xx
  --           :with_del(cond.not_after_regex "xx")
  --           -- disable adding a newline when you press <cr>
  --           :with_cr(cond.none()),
  --       },
  --       -- disable for .vim files, but it work for another filetypes
  --       Rule("a", "a", "-vim")
  --     )
  --   end,
  -- },
  -- By adding to the which-key config and using our helper function you can add more which-key registered bindings
  -- {
  --   "folke/which-key.nvim",
  --   config = function(plugin, opts)
  --     require "plugins.configs.which-key"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- Add bindings which show up as group name
  --     local wk = require "which-key"
  --     wk.register({
  --       b = { name = "Buffer" },
  --     }, { mode = "n", prefix = "<leader>" })
  --   end,
  -- },
}
