-- local colorscheme = "leet"
-- local colorscheme = "poimandres"
local colorscheme = "tokyonight-night"

local lushwal_path = "~/.cache/wal/colors.json"
if not vim.loop.fs_stat(lushwal_path) then
  -- wal --cols16 -si .config/wallpaper_field_dawn.jpg
  black      = "#1c1712"
  red        = "#294e65"
  green      = "#3b5967"
  yellow     = "#4b6c74"
  blue       = "#72817b"
  magenta    = "#859489"
  cyan       = "#8e9487"
  white      = "#838283"
  br_black   = "#454345"
  br_red     = "#376887"
  br_green   = "#4F778A"
  br_yellow  = "#65919B"
  br_blue    = "#99ADA5"
  br_magenta = "#B2C6B7"
  br_cyan    = "#BEC6B4"
  br_white   = "#c1c0c1"
  grey       = "#565f89"
  br_grey    = "#565f89"
  amaranth   = "#376887"
else
  local colors = require("lushwal").colors
  -- black       =  string.format("%s",colors.black.li(5) )
  black        = string.format("%s", colors.br_white.darken(90))
  red          = string.format("%s", colors.red)
  green        = string.format("%s", colors.green)
  yellow       = string.format("%s", colors.yellow)
  blue         = string.format("%s", colors.blue)
  magenta      = string.format("%s", colors.magenta)
  cyan         = string.format("%s", colors.cyan)
  white        = string.format("%s", colors.white)
  br_black     = string.format("%s", colors.br_black)
  br_red       = string.format("%s", colors.br_red)
  br_green     = string.format("%s", colors.br_green)
  br_yellow    = string.format("%s", colors.br_yellow)
  br_blue      = string.format("%s", colors.br_blue)
  br_magenta   = string.format("%s", colors.br_magenta)
  br_cyan      = string.format("%s", colors.br_cyan)
  br_white     = string.format("%s", colors.br_white)
  grey         = string.format("%s", colors.grey)
  br_grey      = string.format("%s", colors.br_grey)
  amaranth     = string.format("%s", colors.amaranth)
end

-- Transparency
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local hl_groups = {
      "EndOfBuffer",
      "FloatBorder",
      "FoldColumn",
      "MsgArea",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "Normal",
      "NormalNC",
      "NormalFloat",
      "Pmenu",
      "SignColumn",
      "SignColumnSB",
      "SagaBorder",
      "TerminalBorder",
      "TelescopeBorder",
      "TelescopeNormal",
      "WhichKeyBorder",
      "WhichKeyFloat",
    }

    -- setting hl_groups
    for _, name in ipairs(hl_groups) do
      vim.cmd(string.format("highlight %s ctermbg=none guibg=none", name))
    end

    local highlights = {
      TermCursor                  = { fg = "#1a1b26", bg = "#c0caf5" },
      TermCursorNC                = { fg = "#c0caf5", bg = "#3c3c3c" },
      BufferLineBufferSelected    = { fg = "#ffffff", bold = true },
      BufferLineBackground        = { fg = "#565f89" },
      BufferLineIndicatorSelected = { fg = "#ffffff" },
      BufferLineModified          = { fg = "#616161" },
      BufferLineModifiedSelected  = { fg = "#ffffff" },
      BufferLineModifiedVisible   = { fg = "#a1a1ad" },
      BufferLineSeparator         = { fg = "#5c5c5c" },
      BufferLineTabSelected       = { fg = "#80a0ff" },
      BufferLineTab               = { fg = "#5c5c5c" },
      CursorLine                  = { bg = "#0c0c0c" },
      Folded                      = { bg = '#0c0c0c' },
      LspSagaWinbarKey            = { fg = '#495466' },
      LspSagaWinbarSep            = { fg = '#495466' },
      LspSagaWinbarEnum           = { fg = '#495466' },
      LspSagaWinbarFile           = { fg = '#495466' },
      LspSagaWinbarNull           = { fg = '#495466' },
      LspSagaWinbarArray          = { fg = '#495466' },
      LspSagaWinbarClass          = { fg = '#495466' },
      LspSagaWinbarEvent          = { fg = '#495466' },
      LspSagaWinbarField          = { fg = '#495466' },
      LspSagaWinbarMacro          = { fg = '#495466' },
      LspSagaWinbarMethod         = { fg = '#495466' },
      LspSagaWinbarModule         = { fg = '#495466' },
      LspSagaWinbarNumber         = { fg = '#495466' },
      LspSagaWinbarObject         = { fg = '#495466' },
      LspSagaWinbarString         = { fg = '#495466' },
      LspSagaWinbarStruct         = { fg = '#495466' },
      LspSagaWinbarBoolean        = { fg = '#495466' },
      LspSagaWinbarPackage        = { fg = '#495466' },
      LspSagaWinbarConstant       = { fg = '#495466' },
      LspSagaWinbarFunction       = { fg = '#495466' },
      LspSagaWinbarOperator       = { fg = '#495466' },
      LspSagaWinbarProperty       = { fg = '#495466' },
      LspSagaWinbarVariable       = { fg = '#495466' },
      LspSagaWinbarInterface      = { fg = '#495466' },
      LspSagaWinbarNamespace      = { fg = '#495466' },
      LspSagaWinbarParameter      = { fg = '#495466' },
      LspSagaWinbarTypeAlias      = { fg = '#495466' },
      LspSagaWinbarEnumMember     = { fg = '#495466' },
      LspSagaWinbarConstructor    = { fg = '#495466' },
      LspSagaWinbarStaticMethod   = { fg = '#495466' },
      LspSagaWinbarTypeParameter  = { fg = '#495466' },
      MiniTrailspace              = { bg = "#ff0000" },
      NeoTreeCursorLine           = { bg = "#16161e" },
      NeoTreeGitAdded             = { fg = "#495466" },
      NeoTreeGitConflict          = { fg = "#495466" },
      NeoTreeGitDeleted           = { fg = "#495466" },
      NeoTreeGitIgnored           = { fg = "#495466" },
      NeoTreeGitModified          = { fg = "#495466" },
      NeoTreeGitUnstaged          = { fg = "#495466" },
      NeoTreeGitUntracked         = { fg = "#495466" },
      NeoTreeGitStaged            = { fg = "#495466" },
      NeoTreeRootName             = { fg = "#7aa2f7" },
      NeoTreeTabActive            = { fg = "#c0caf5" },
      SagaWinbarSep               = { fg = "#495466" },
      SagaWinbarFilename          = { fg = "#495466" },
      SagaNormal                  = { fg = "NONE", bg = "NONE" },
      TerminalNormal              = { fg = "NONE", bg = "NONE" },
      Normal                      = { fg = "NONE", bg = "NONE" },
      NormalNC                    = { fg = "NONE", bg = "NONE" },
      NormalSB                    = { fg = "NONE", bg = "NONE" },
      TelescopeResultsNormal      = { fg = "#9c9c9c" },
      NormalFloat                 = { fg = "#888888" },
      FloatBorder                 = { fg = "#444444" },
      CmpItemAbbr                 = { fg = "#888888" },
      Pmenu                       = { fg = "#444444" },
      TelescopeBorder             = { fg = "#171922" },
      TelescopeTitle              = { fg = "#303340" },
      WhichKeyBorder              = { fg = "#171922" },
      Winbar                      = { fg = "#495466" },
      WinbarNC                    = { fg = "#495466" },
    }

    -- setting highlights
    for group, conf in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, conf)
    end

    local custom_themes = {
      tokyonight = {
        custom_colorscheme = {
          ["Comment"]                = { fg = "#565f89", italic = false },
          ["Keyword"]                = { fg = "#7dcfff", italic = false },
          ["@keyword"]               = { fg = "#9d7cd8", italic = false },
          ["@keyword.function"]      = { fg = "#6e51a2" },
          ["@field"]                 = { fg = "#7aa2f7" },
          ["@property"]              = { fg = "#7aa2f7" },
          ["@string"]                = { fg = "#73daca" },
          ["@boolean"]               = { fg = "#1cff1c" },
          ["@number"]                = { fg = "#1cff1c" },
          ["@punctuation"]           = { fg = "#e8e8e8" },
          ["@punctuation.bracket"]   = { fg = "#515171" },
          ["@punctuation.delimiter"] = { fg = "#e8e8e8" },
          ["@punctuation.special"]   = { fg = "#515171" },
          ["@parameter"]             = { fg = "#e4f0fb" },
          ["@variable"]              = { fg = "#e4f0fb" },
          ["@tag"]                   = { fg = "#515171" },
          ["@tag.attribute"]         = { fg = "#91b4d5" },
          ["@tag.delimiter"]         = { fg = "#515171" },
          ["@constructor"]           = { fg = "#6e51a2" },
          ["Constant"]               = { fg = "#1cff1c" },
          ["String"]                 = { fg = "#73daca" },
          GitSignsAdd                = { fg = "#1abc9c" },
          GitSignsChange             = { fg = "#3c3cff" },
          GitSignsDelete             = { fg = "#880000" },
          IndentBlanklineChar        = { fg = "#3b4261" },
          IndentBlanklineContextChar = { fg = "#7aa2f7" },
          IlluminatedWordText        = { bg = "#080811" },
          IlluminatedWordRead        = { bg = "#080811" },
          IlluminatedWordWrite       = { bg = "#080811" },
          LspReferenceRead           = { bg = "#080811" },
          LspReferenceText           = { bg = "#080811" },
          LspReferenceWrite          = { bg = "#080811" },
          NotifyBackground           = { bg = "#000000" },
          NotifyDEBUGBody            = { fg = "#c0caf5" },
          NotifyDEBUGBorder          = { fg = "#2c2f44" },
          NotifyERRORBody            = { fg = "#c0caf5" },
          NotifyERRORBorder          = { fg = "#542931" },
          NotifyINFOBody             = { fg = "#c0caf5" },
          NotifyINFOBorder           = { fg = "#164a5b" },
          NotifyTRACEBody            = { fg = "#c0caf5" },
          NotifyTRACEBorder          = { fg = "#41385b" },
          NotifyWARNBody             = { fg = "#c0caf5" },
          NotifyWARNBorder           = { fg = "#55473a" },
          TelescopeSelection         = { bg = "#080811" },
          TelescopeSelectionCaret    = { bg = "#080811" },
          WinSeparator               = { fg = "#565f89" },
        },
        custom_terminal_colors = {
          terminal_color_0  = '#15161e',
          terminal_color_1  = '#990000',
          terminal_color_2  = '#1abc9c',
          terminal_color_3  = '#ffff33',
          terminal_color_4  = '#7aa2f7',
          terminal_color_5  = '#9c6df3',
          terminal_color_6  = '#5FB3A1',
          terminal_color_7  = '#a0a0a0',
          terminal_color_8  = '#414868',
          terminal_color_9  = '#ff0000',
          terminal_color_10 = '#73daca',
          terminal_color_11 = '#ffff66',
          terminal_color_12 = '#a8c2fa',
          terminal_color_13 = '#bb9af7',
          terminal_color_14 = '#5DE4C7',
          terminal_color_15 = '#ffffff',
        }
      },
      poimandres = {
        custom_colorscheme = {
          -- a table of overrides/changes to the poimandres theme
          ["@punctuation"]           = { fg = "#e8e8e8" },
          ["@punctuation.bracket"]   = { fg = "#515171" },
          ["@punctuation.delimiter"] = { fg = "#e8e8e8" },
          ["@punctuation.special"]   = { fg = "#515171" },
          ["@tag"]                   = { fg = "#515171" },
          ["@tag.attribute"]         = { fg = "#91b4d5" },
          ["@tag.delimiter"]         = { fg = "#515171" },
          ["@constructor"]           = { fg = "#5de4c7" },
          ["@comment"]               = { fg = "#3e4041" },
          ["Comment"]                = { fg = "#3e4041" },
          ["Visual"]                 = { bg = "#1c1c1c" },
          GitSignsAdd                = { fg = "#1abc9c" },
          GitSignsChange             = { fg = "#3c3cff" },
          GitSignsDelete             = { fg = "#880000" },
          IndentBlanklineChar        = { fg = "#3b4261" },
          IndentBlanklineContextChar = { fg = "#7aa2f7" },
          IlluminatedWordText        = { bg = "#080811" },
          IlluminatedWordRead        = { bg = "#080811" },
          IlluminatedWordWrite       = { bg = "#080811" },
          NotifyBackground           = { bg = "#000000" },
          LspReferenceRead           = { bg = "#080811" },
          LspReferenceText           = { bg = "#080811" },
          LspReferenceWrite          = { bg = "#080811" },
          PmenuSel                   = { bg = "#1c1c1c" },
          TelescopeSelection         = { bg = "#080811" },
          TelescopeSelectionCaret    = { bg = "#080811" },
          WinSeparator               = { fg = "#565f89" },
        },
        custom_terminal_colors = {
          terminal_color_0  = '#171922',
          terminal_color_1  = '#990000',
          terminal_color_2  = '#1abc9c',
          terminal_color_3  = '#ffff33',
          terminal_color_4  = '#7aa2f7',
          terminal_color_5  = '#9c6df3',
          terminal_color_6  = '#5FB3A1',
          terminal_color_7  = '#a0a0a0',
          terminal_color_8  = '#506477',
          terminal_color_9  = '#ff0000',
          terminal_color_10 = '#73daca',
          terminal_color_11 = '#ffff66',
          terminal_color_12 = '#a8c2fa',
          terminal_color_13 = '#bb9af7',
          terminal_color_14 = '#5DE4C7',
          terminal_color_15 = '#ffffff',
        }
      },
      lushwal = {
        custom_colorscheme = {
          ["@comment"]               = { fg = "#3e4041" },
          ["Comment"]                = { fg = "#3e4041" },
          ["Visual"]                 = { bg = "#1c1c1c" },
          GitSignsAdd                = { fg = br_green },
          GitSignsChange             = { fg = br_blue },
          GitSignsDelete             = { fg = amaranth },
          IndentBlanklineChar        = { fg = grey },
          IndentBlanklineContextChar = { fg = br_white },
          IlluminatedWordText        = { bg = "#080811" },
          IlluminatedWordRead        = { bg = "#080811" },
          IlluminatedWordWrite       = { bg = "#080811" },
          NotifyBackground           = { bg = "#000000" },
          LspReferenceRead           = { bg = "#080811" },
          LspReferenceText           = { bg = "#080811" },
          LspReferenceWrite          = { bg = "#080811" },
          PmenuSel                   = { bg = "#1c1c1c" },
          TelescopeSelection         = { bg = "#080811" },
          TelescopeSelectionCaret    = { bg = "#080811" },
          WinSeparator               = { fg = br_grey },
        },
        custom_terminal_colors = {
          terminal_color_0  = black,
          terminal_color_1  = red,
          terminal_color_2  = green,
          terminal_color_3  = yellow,
          terminal_color_4  = blue,
          terminal_color_5  = magenta,
          terminal_color_6  = cyan,
          terminal_color_7  = white,
          terminal_color_8  = br_black,
          terminal_color_9  = br_red,
          terminal_color_10 = br_green,
          terminal_color_11 = br_yellow,
          terminal_color_12 = br_blue,
          terminal_color_13 = br_magenta,
          terminal_color_14 = br_cyan,
          terminal_color_15 = br_white,
        }
      },
    }

    local selected_colorscheme = custom_themes[vim.g.colors_name]
    if selected_colorscheme then
      -- setting custom_colorscheme
      for group, conf in pairs(selected_colorscheme.custom_colorscheme) do
        vim.api.nvim_set_hl(0, group, conf)
      end

      -- setting custom_terminal_colors
      for group, conf in pairs(selected_colorscheme.custom_terminal_colors) do
        vim.g[group] = conf
      end
    end

    -- DevIcons background
    -- vim.cmd [[ for hl in getcompletion('BufferLineDevIcon', 'highlight') | execute 'hi '.hl.' guibg=#00ff00' | endfor ]]
  end,
})

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  vim.cmd [[ colorscheme leet ]]
end
