local status_ok, mini_ai = pcall(require, 'mini.ai')
if not status_ok then
  return
end

local function write_session()
  local session_path = vim.fn.stdpath("data") .. "/session"
  if not vim.loop.fs_stat(session_path) then vim.fn.mkdir(session_path, "p") end

  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name ~= "" then
    local sneakcase = string.gsub(buf_name, "/", '_') .. "_"
    local buf_name_sneakcase = string.gsub(sneakcase, "\\", '_') .. "_" -- fo windows's path
    require("mini.sessions").write(buf_name_sneakcase, { verbose = false })
  end
end

local spec_treesitter = mini_ai.gen_spec.treesitter

--- local gen_ai_spec = require('mini.extra').gen_ai_spec
---   require('mini.ai').setup({
---     custom_textobjects = {
---       B = gen_ai_spec.buffer(),
---       D = gen_ai_spec.diagnostic(),
---       I = gen_ai_spec.indent(),
---       L = gen_ai_spec.line(),
---       N = gen_ai_spec.number(),
---     },
---   })

mini_ai.setup({

  -- Table with textobject id as fields, textobject specification as values.
  -- Also use this to disable builtin textobjects. See |MiniAi.config|.
  custom_textobjects = {

    -- a = mapped to args by mini.ai
    -- A = mapped to @assignment by mini.ai
    -- b = alias to )]} by mini.ai
    -- B = mapped to @block by nvim
    -- c = mapped to word-column by textobj-word-column
    -- C = mapped to Word-Column by textobj-word-column
    -- d = mapped to greedyOuterIndentation by nvim-various-textobjs
    -- e = mapped to nearEoL by nvim-various-textobjs
    -- f = mapped to function.call by mini.ai
    -- F = mapped to @function by mini.ai
    -- g = mapped to @comment by mini.ai
    -- G = mapped to @conditional by mini.ai
    -- h = mapped to html-Attribute by nvim-various-textobjs
    -- i = mapped to indentation by mini.indent
    -- I = mapped to Indentation by mini.indent
    -- j = mapped to cssSelector by nvim-various-textobjs
    -- k = mapped to key by mini.ai
    -- K = mapped to container by textsubjects
    -- l = mapped to +last by mini.ai
    -- L = mapped to @loop by mini.ai
    -- m = mapped to chainMember by nvim-various-textobjs
    -- M = mapped to mdFencedCodeBlock by nvim-various-textobjs
    -- n = mapped to number by nvim-various-textobjs
    -- N = mapped to +next by mini.ai
    -- p = mapped to paragraph by nvim
    -- P = mapped to @parameer by nvim
    -- o = mapped to whitespace by mini.ai
    -- q = mapped to @call by mini.ai
    -- Q = mapped to @class by mini.ai
    -- r = mapped to restOfWindow by mini.ai
    -- R = mapped to @return by mini.ai
    -- s = mapped to sentence by nvim
    -- S = mapped to Subword by nvim-various-textobjs
    -- t = mapped to tag by mini.ai
    -- u = mapped to uotes by mini.ai
    -- U = mapped to pyTripleQuotes by nvim-various-textobjs
    -- v = mapped to value by mini.ai
    -- w = mapped to word by nvim
    -- W = mapped to Word by nvim
    -- x = mapped to hexadecimal by mini.ai
    -- y = mapped to select_same_indent  by keymaps.lua
    -- z = mapped to fold by keymaps.lua
    -- Z = mapped to closefold by nvim-various-textobjs

    B = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
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

    -- pair text object
    -- ['_'] = mini.ai.gen_spec.pair('_', '_', { type = 'greedy' }),
    -- ['<'] = mini.ai.gen_spec.pair('<', '>', { type = 'balanced' }),
    -- ['>'] = mini.ai.gen_spec.pair('<', '>', { type = 'non-balanced' }),

    -- Tweak argument textobject:
    -- a = mini_ai.gen_spec.argument({ brackets = { '%b()', '%b[]', '%b{}' }, separator = '[,;]', exclude_regions = { '%b""', "%b''" } }),

    -- Disable brackets alias in favor of builtin block textobject:
    -- b = false,
    -- b = { { '%b()', '%b[]', '%b{}' }, '^.().*().$' },

    -- Tweak function call to not detect dot in function name
    -- f = mini.ai.gen_spec.function_call({ name_pattern = '[%w_]' }),

    -- html/jsx attribute (first {regex} captures tag, second {regex,regex,regex} filters)
    -- h = { '%f[%s]%s+[^%s<>=]+=[^%s<>]+', '^%s+().*()$' }, -- broked at whitespaces -- https://github.com/echasnovski/mini.nvim/issues/151
    -- h = { { '(%w+=").-(")' }, '^.().*().$' }, -- Pattern in single curly bracket makes the double curly bracket with catpuring group `(some caputure)` work
    h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } }, -- %f[%w]%w+ is equivalent to lua (%w+) since mini.ai is not greedy

    -- key-value textobj :help mini.ai (line 300)
    -- the pattern .- matches any sequence of characters (except newline characters) (including whitespaces)
    k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" }, -- .- -> don't be greedy let %s- to exist while .* is greedy
    v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },            -- Pattern in double curly bracket equals fallback

    -- number/hexadecimalcolor textobj:
    -- the pattern %f[%d]%d+ ensures there is a %d before start matching (non %d before %d+)(useful to stop .*)
    n = { "[-+]?()%f[%d]%d+()%.?%d*" }, -- %f[%d] to make jumping to next group of number instead of next digit
    x = { "#()%x%x%x%x%x%x()" },

    -- _whitespace_textobj:
    o = { "%S()%s+()%S" },

    -- quotes/uotes:
    u = { { "%b''", '%b""', "%b``" }, "^.().*().$" }, -- Pattern in single curly bracket equals filter the double-bracket/left-side

    -- -- Whole buffer:
    -- ["+"] = function()
    --   local from = { line = 1, col = 1 }
    --   local to = {
    --     line = vim.fn.line('$'),
    --     col = math.max(vim.fn.getline('$'):len(), 1)
    --   }
    --   return { from = from, to = to }
    -- end,

    -- -- indent delimited by blanklines textobj:
    -- i = function()
    --   local start_indent = vim.fn.indent(vim.fn.line('.'))
    --   if string.match(vim.fn.getline('.'), '^%s*$') then return { from = nil, to = nil } end
    --
    --   local prev_line = vim.fn.line('.') - 1
    --   while vim.fn.indent(prev_line) >= start_indent do
    --       vim.cmd('-')
    --       prev_line = vim.fn.line('.') - 1
    --   end
    --
    --   from = { line = vim.fn.line('.'), col = 1 }
    --
    --   local next_line = vim.fn.line('.') + 1
    --   while vim.fn.indent(next_line) >= start_indent do
    --       vim.cmd('+')
    --       next_line = vim.fn.line('.') + 1
    --   end
    --
    --   to = { line = vim.fn.line('.'), col = vim.fn.getline(vim.fn.line('.')):len() }
    --   return { from = from, to = to }
    --
    -- end
  },

  user_textobject_id = true,
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Main textobject prefixes
    around = "a",
    inside = "i",

    -- Next/last variants
    around_next = "aN",
    inside_next = "iN",
    around_last = "al",
    inside_last = "il",

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = "g[",
    goto_right = "g]",
  },

  -- Number of lines within which textobject is searched
  n_lines = 50,

  -- How to search for object (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
  search_method = "cover_or_next",

  -- Whether to disable showing non-error feedback
  silent = false,

})

require('mini.align').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    start = 'ga',
    start_with_preview = 'gA',
  },

  -- -- Modifiers changing alignment steps and/or options
  -- modifiers = {
  --   -- Main option modifiers
  --   ['s'] = --<function: enter split pattern>,
  --   ['j'] = --<function: choose justify side>,
  --   ['m'] = --<function: enter merge delimiter>,
  --
  --   -- Modifiers adding pre-steps
  --   ['f'] = --<function: filter parts by entering Lua expression>,
  --   ['i'] = --<function: ignore some split matches>,
  --   ['p'] = --<function: pair parts>,
  --   ['t'] = --<function: trim parts>,
  --
  --   -- Delete some last pre-step
  --   ['<BS>'] = --<function: delete some last pre-step>,
  --
  --   -- Special configurations for common splits
  --   ['='] = --<function: enhanced setup for '='>,
  --   [','] = --<function: enhanced setup for ','>,
  --   [' '] = --<function: enhanced setup for ' '>,
  -- },

  -- Default options controlling alignment process
  options = {
    split_pattern = '',
    justify_side = 'left',
    merge_delimiter = '',
  },

  -- Default steps performing alignment (if `nil`, default is used)
  steps = {
    pre_split = {},
    split = nil,
    pre_justify = {},
    justify = nil,
    pre_merge = {},
    merge = nil,
  },
})

require('mini.bracketed').setup({
  -- First-level elements are tables describing behavior of a target:
  --
  -- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
  --   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
  --   Supply empty string `''` to not create mappings.
  --
  -- - <options> - table overriding target options.
  --
  -- See `:h MiniBracketed.config` for more info.

  buffer     = { suffix = 'b', options = {} },
  comment    = { suffix = 'c', options = {} },
  conflict   = { suffix = 'x', options = {} },
  diagnostic = { suffix = 'd', options = {} },
  file       = { suffix = 'f', options = {} },
  indent     = { suffix = 'n', options = {} },
  jump       = { suffix = 'j', options = {} },
  location   = { suffix = 'l', options = {} },
  oldfile    = { suffix = 'o', options = {} },
  quickfix   = { suffix = 'q', options = {} },
  treesitter = { suffix = 't', options = {} },
  undo       = { suffix = 'u', options = {} },
  window     = { suffix = 'w', options = {} },
  yank       = { suffix = 'y', options = {} },
})

require('mini.comment').setup({
  -- Options which control module behavior
  options = {
    -- Function to compute custom 'commentstring' (optional)
    custom_commentstring = nil,

    -- Whether to ignore blank lines
    ignore_blank_line = false,

    -- Whether to recognize as comment only lines without indent
    start_of_line = false,

    -- Whether to ensure single space pad for comment parts
    pad_comment_parts = true,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = 'gc',

    -- Toggle comment on current line
    comment_line = 'gcc',

    -- Toggle comment on visual selection
    comment_visual = 'gc',

    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    textobject = '', -- mapped as `gc` in keymaps.lua
  },

  -- Hook functions to be executed at certain stage of commenting
  hooks = {
    -- Before successful commenting. Does nothing by default.
    pre = function() end,
    -- After successful commenting. Does nothing by default.
    post = function() end,
  },
})

-- require('mini.completion').setup({
--   -- Delay (debounce type, in ms) between certain Neovim event and action.
--   -- This can be used to (virtually) disable certain automatic actions by
--   -- setting very high delay time (like 10^7).
--   delay = { completion = 10 ^ 7, info = 100, signature = 50 },
--
--   -- Configuration for action windows:
--   -- - `height` and `width` are maximum dimensions.
--   -- - `border` defines border (as in `nvim_open_win()`).
--   window = {
--     info = { height = 25, width = 80, border = 'single' },
--     signature = { height = 25, width = 80, border = 'single' },
--   },
--
--   -- Way of how module does LSP completion
--   lsp_completion = {
--     -- `source_func` should be one of 'completefunc' or 'omnifunc'.
--     source_func = 'completefunc',
--
--     -- `auto_setup` should be boolean indicating if LSP completion is set up
--     -- on every `BufEnter` event.
--     auto_setup = true,
--
--     -- `process_items` should be a function which takes LSP
--     -- 'textDocument/completion' response items and word to complete. Its
--     -- output should be a table of the same nature as input items. The most
--     -- common use-cases are custom filtering and sorting. You can use
--     -- default `process_items` as `MiniCompletion.default_process_items()`.
--     -- process_items = --<function: filters out snippets; sorts by LSP specs>,
--   },
--
--   -- Fallback action. It will always be run in Insert mode. To use Neovim's
--   -- built-in completion (see `:h ins-completion`), supply its mapping as
--   -- string. Example: to use 'whole lines' completion, supply '<C-x><C-l>'.
--   -- fallback_action = --<function: like `<C-n>` completion>,
--
--   -- Module mappings. Use `''` (empty string) to disable one. Some of them
--   -- might conflict with system mappings.
--   mappings = {
--     force_twostep = '<C-Space>',  -- Force two-step completion
--     force_fallback = '<A-Space>', -- Force fallback completion
--   },
--
--   -- Whether to set Vim's settings for better experience (modifies
--   -- `shortmess` and `completeopt`)
--   set_vim_settings = true,
-- })

require("mini.files").setup({
  -- Customization of shown content
  content = {
    -- Predicate for which file system entries to show
    filter = nil,
    -- What prefix to show to the left of file system entry
    prefix = nil,
    -- In which order to show file system entries
    sort = nil,
  },

  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close       = 'q',
    go_in       = 'l',
    go_in_plus  = 'L',
    go_out      = 'h',
    go_out_plus = 'H',
    reset       = '<BS>',
    reveal_cwd  = '@',
    show_help   = 'g?',
    synchronize = '=',
    trim_left   = '<',
    trim_right  = '>',
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = true,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = true,
    -- Width of focused window
    width_focus = 30,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 60,
  },
})

require('mini.indentscope').setup({
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 100,

    -- Animation rule for scope's first drawing. A function which, given
    -- next and total step numbers, returns wait time (in ms). See
    -- |MiniIndentscope.gen_animation| for builtin options. To disable
    -- animation, use `require('mini.indentscope').gen_animation.none()`.
    animation = nil --<function: implements constant 20ms between steps>,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Textobjects
    object_scope = '',
    object_scope_with_border = '',

    -- Motions (jump to respective border line; if not present - body line)
    -- _repressing-incremental works inside visual mode
    goto_top = '[ii',
    goto_bottom = ']ii',
  },

  -- Options which control scope computation
  options = {
    -- Type of scope's border: which line(s) with smaller indent to
    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
    border = 'both',

    -- Whether to use cursor column when computing reference indent.
    -- Useful to see incremental scopes with horizontal cursor movements.
    indent_at_cursor = false,

    -- Whether to first check input line to be a border of adjacent scope.
    -- Use it if you want to place cursor on function header to get scope of
    -- its body.
    try_as_border = false,
  },

  -- Which character to use for drawing scope indicator
  symbol = '',
})

-- require("mini.jump").setup({
--   -- Module mappings. Use `''` (empty string) to disable one.
--   mappings = {
--     forward = 'f',
--     backward = 'F',
--     forward_till = 't',
--     backward_till = 'T',
--     repeat_jump = '<BS>',
--   },
--
--   -- Delay values (in ms) for different functionalities. Set any of them to
--   -- a very big number (like 10^7) to virtually disable.
--   delay = {
--     -- Delay between jump and highlighting all possible jumps
--     highlight = 250,
--
--     -- Delay between jump and automatic stop if idle (no jump is done)
--     idle_stop = 10000000,
--   },
-- })

-- require('mini.jump2d').setup({
--   -- Function producing jump spots (byte indexed) for a particular line.
--   -- For more information see |MiniJump2d.start|.
--   -- If `nil` (default) - use |MiniJump2d.default_spotter|
--   spotter = nil,
--
--   -- Characters used for labels of jump spots (in supplied order)
--   labels = 'abcdefghijklmnopqrstuvwxyz',
--
--   -- Options for visual effects
--   view = {
--     -- Whether to dim lines with at least one jump spot
--     dim = false,
--
--     -- How many steps ahead to show. Set to big number to show all steps.
--     n_steps_ahead = 0,
--   },
--
--   -- Which lines are used for computing spots
--   allowed_lines = {
--     blank = true,         -- Blank line (not sent to spotter even if `true`)
--     cursor_before = true, -- Lines before cursor line
--     cursor_at = true,     -- Cursor line
--     cursor_after = true,  -- Lines after cursor line
--     fold = true,          -- Start of fold (not sent to spotter even if `true`)
--   },
--
--   -- Which windows from current tabpage are used for visible lines
--   allowed_windows = {
--     current = true,
--     not_current = true,
--   },
--
--   -- Functions to be executed at certain events
--   hooks = {
--     before_start = nil, -- Before jump start
--     after_jump = nil,   -- After jump was actually done
--   },
--
--   -- Module mappings. Use `''` (empty string) to disable one.
--   mappings = {
--     start_jumping = '<Tab>',
--   },
--
--   -- Whether to disable showing non-error feedback
--   silent = false,
-- })

require('mini.map').setup({
  -- Highlight integrations (none by default)
  integrations = {
    require('mini.map').gen_integration.builtin_search(),
    require('mini.map').gen_integration.diagnostic(),
    require('mini.map').gen_integration.gitsigns(),
  },

  -- Symbols used to display data
  symbols = {
    -- Encode symbols. See `:h MiniMap.config` for specification and
    -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
    -- Default: solid blocks with 3x2 resolution.
    encode = nil,

    -- Scrollbar parts for view and line. Use empty string to disable any.
    scroll_line = '█',
    scroll_view = '┃',
  },

  -- Window options
  window = {
    -- Whether window is focusable in normal way (with `wincmd` or mouse)
    focusable = true,

    -- Side to stick ('left' or 'right')
    side = 'right',

    -- Whether to show count of multiple integration highlights
    show_integration_count = false,

    -- Total width
    width = 10,

    -- Value of 'winblend' option
    winblend = 25,
  },
})

require('mini.operators').setup({
  -- Each entry configures one operator.
  -- `prefix` defines keys mapped during `setup()`: in Normal mode
  -- to operate on textobject and line, in Visual - on selection.

  -- Evaluate text and replace with output
  evaluate = {
    prefix = '', -- 'g=',

    -- Function which does the evaluation
    func = nil,
  },

  -- Exchange text regions
  exchange = {
    prefix = 'gY',

    -- Whether to reindent new text to match previous indent
    reindent_linewise = true,
  },

  -- Multiply (duplicate) text
  multiply = {
    prefix = '', -- 'gm',

    -- Function which can modify text before multiplying
    func = nil,
  },

  -- Replace text with register
  replace = {
    prefix = 'gy',

    -- Whether to reindent new text to match previous indent
    reindent_linewise = true,
  },

  -- Sort text
  sort = {
    prefix = 'gz',

    -- Function which does the sort
    func = nil,
  }
})

-- require('mini.pairs').setup({
--   -- In which modes mappings from this `config` should be created
--   modes = { insert = true, command = false, terminal = false },
--
--   -- Global mappings. Each right hand side should be a pair information, a
--   -- table with at least these fields (see more in |MiniPairs.map|):
--   -- - <action> - one of "open", "close", "closeopen".
--   -- - <pair> - two character string for pair to be used.
--   -- By default pair is not inserted after `\`, quotes are not recognized by
--   -- `<CR>`, `'` does not insert pair after a letter.
--   -- Only parts of tables can be tweaked (others will use these defaults).
--   mappings = {
--     ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
--     ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
--     ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
--
--     [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
--     [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
--     ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
--
--     ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
--     ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
--     ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
--   },
-- })

require('mini.sessions').setup({
  -- Whether to read latest session if Neovim opened without file arguments
  autoread = false,

  -- Whether to write current session before quitting Neovim
  autowrite = true,

  -- Directory where global sessions are stored (use `''` to disable)
  -- directory = vim.fn.stdpath("data") .. "session",  --<"session" subdir of user data directory from |stdpath()|>,

  -- File for local session (use `''` to disable)
  file = 'Session.vim',

  -- Whether to force possibly harmful actions (meaning depends on function)
  force = { read = false, write = true, delete = true },

  -- Hook functions for actions. Default `nil` means 'do nothing'.
  hooks = {
    -- Before successful action
    pre = {
      read = nil,
      -- write = require("mini.sessions").write(vim.fn.expand('%:t') .. "__"),
      write = write_session(),
      delete = nil
    },
    -- After successful action
    post = {
      read = nil,
      write = nil,
      delete = nil
    },
  },

  -- Whether to print session path after action
  verbose = { read = false, write = false, delete = true },
})

require('mini.splitjoin').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  -- Created for both Normal and Visual modes.
  mappings = {
    toggle = 'gS',
    split = '',
    join = '',
  },

  -- Detection options: where split/join should be done
  detect = {
    -- Array of Lua patterns to detect region with arguments.
    -- Default: { '%b()', '%b[]', '%b{}' }
    brackets = nil,

    -- String Lua pattern defining argument separator
    separator = ',',

    -- Array of Lua patterns for sub-regions to exclude separators from.
    -- Enables correct detection in presence of nested brackets and quotes.
    -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
    exclude_regions = nil,
  },

  -- Split options
  split = {
    hooks_pre = {},
    hooks_post = {},
  },

  -- Join options
  join = {
    hooks_pre = {},
    hooks_post = {},
  },
})

require('mini.surround').setup({
  -- Add custom surroundings to be used on top of builtin ones. For more
  -- information with examples, see `:h MiniSurround.config`.
  custom_surroundings = nil,

  -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
  highlight_duration = 500,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    add = 'gsa',            -- Add surrounding in Normal and Visual modes
    delete = 'gsd',         -- Delete surrounding
    find = 'gsf',           -- Find surrounding (to the right)
    find_left = 'gsF',      -- Find surrounding (to the left)
    highlight = 'gsh',      -- Highlight surrounding
    replace = 'gsr',        -- Replace surrounding
    update_n_lines = 'gsn', -- Update `n_lines`

    suffix_last = 'l',      -- Suffix to search with "prev" method
    suffix_next = 'N',      -- Suffix to search with "next" method
  },

  -- Number of lines within which surrounding is searched
  n_lines = 20,

  -- Whether to respect selection type:
  -- - Place surroundings on separate lines in linewise mode.
  -- - Place surroundings on each line in blockwise mode.
  respect_selection_type = false,

  -- How to search for surrounding (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
  -- see `:h MiniSurround.config`.
  search_method = 'cover',

  -- Whether to disable showing non-error feedback
  silent = false,
})

require('mini.trailspace').setup({
  -- Highlight only in normal buffers (ones with empty 'buftype'). This is
  -- useful to not show trailing whitespace where it usually doesn't matter.
  only_in_normal_buffers = true,
})
