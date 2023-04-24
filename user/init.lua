return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },
  -- Set colorscheme to use
  colorscheme = "tokyonight-night",
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    mappings = {
      n = {
        ["<leader>lF"] = { function() vim.lsp.buf.format(astronvim.lsp.format_opts) end, desc = "Format buffer" },
        ["K"] = false, -- disable Hover symbol
        ["gh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover Symbol" },
        ["go"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Hover Diagnostics" },
        ["gl"] = { "`.", desc = "Jump to Last change" }, -- Overwrites Hover Diagnostics
      }
    },
  },
  ["config"] = {
    jsonls = {
      settings = {
        json = {
          schemas = function() require("schemastore").json.schemas() end,
          validate = { enable = true },
          keepLines = { enable = true },
        },
      },
    },
  },
  heirline = {
    -- separators = { tab = { "", "" } },
    separators = { tab = { "▎", " " } },
    colors = function(colors)
      -- colors.bg                      = astronvim.get_hlgroup("Normal").bg
      colors.bg = "NONE" -- Status line
      colors.section_bg = "NONE" -- Status icons
      colors.buffer_bg = "#000000" -- Inactive buffer
      colors.buffer_fg = "#3b4261" -- Inactive buffer
      colors.buffer_path_fg = "#3b4261" -- Inactive buffer
      colors.buffer_close_fg = "#3b4261" -- Inactive buffer
      colors.buffer_active_fg = "#ffffff" -- Active buffer
      colors.buffer_active_path_fg = "#ffffff" -- Active buffer path
      colors.buffer_active_close_fg = "#ffffff" -- Active buffer close button
      colors.buffer_visible_fg = "NONE" -- Unfocus buffer
      colors.buffer_visible_path_fg = "NONE" -- Unfocus buffer path
      colors.buffer_visible_close_fg = "NONE" -- Unfocus buffer close button
      colors.tab_close_fg = "#5c5c5c" -- Tab close button
      colors.tabline_bg = "NONE" -- buffer line
      return colors
    end,
  },
  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },
}
