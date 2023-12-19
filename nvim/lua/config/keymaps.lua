local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts) -- whichkey conflicts when lazyload
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- ╭────────────╮
-- │ Automation │
-- ╰────────────╯

-- Quick Escape
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)
-- keymap("v", "jk", "<ESC>", opts) --slow
-- keymap("v", "kj", "<ESC>", opts) --slow

-- Quick Jump
keymap("n", "J", "10gj", opts)
keymap("n", "K", "10gk", opts)
keymap("n", "H", "10h", opts)
keymap("n", "L", "10l", opts)

-- Forward yank/paste
keymap("n", "Y", "yg_", { noremap = true, silent = true, desc = "Yank forward" })  -- "Y" yank forward by default
keymap("v", "Y", "g_y", { noremap = true, silent = true, desc = "Yank forward" })
keymap("v", "P", "g_P", { noremap = true, silent = true, desc = "Paste forward" }) -- "P" doesn't change register

-- Unaltered clipboard
keymap("v", "p", '"_c<c-r>+<esc>', { noremap = true, silent = true, desc = "Paste (dot repeat)(register unchanged)" })

-- Quick quit/write
keymap("n", "<S-q>", "<cmd>lua vim.cmd('quit')<cr>", opts)
keymap("n", "<S-r>", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 }) vim.cmd('silent write') <cr>", opts)

-- Macros and :normal <keys> repeatable
-- keymap("n", "!", "z", opts)
-- keymap("n", "z", "Q", opts)
keymap("n", "U", "@:", opts)

-- Save file as sudo
-- keymap("c","w!!","execute 'silent! write !sudo tee % >/dev/null' <bar> edit!",opts)
keymap("c", "#w", "w !sudo tee %<cr>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Resize with arrows
map({ "n", "t" }, "<M-Left>", require("smart-splits").resize_left, opts)
map({ "n", "t" }, "<M-Down>", require("smart-splits").resize_down, opts)
map({ "n", "t" }, "<M-Up>", require("smart-splits").resize_up, opts)
map({ "n", "t" }, "<M-Right>", require("smart-splits").resize_right, opts)

-- Move text up and down autoindented
-- keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
-- keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
-- keymap("v", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Intellisense
-- map("i", "<A-h>", "<Plug>(copilot-dismiss)", { expr = true, silent = true })
-- map("i", "<A-j>", "<Plug>(copilot-next)", { expr = true, silent = true })
-- map("i", "<A-k>", "<Plug>(copilot-previous)", { expr = tru, silent = true })
-- map("i", "<A-l>", function() return vim.fn['copilot#Accept']() end, { expr = tru, silent = true })
-- map('i', '<A-h>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
map("i", "<A-j>", function()
  return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true })
map("i", "<A-k>", function()
  return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true, silent = true })
map("i", "<A-l>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })

-- position navigation (in wezterm <C-i> outputs Tab)
keymap("n", "<C-I>", "<C-i>", { silent = true, desc = "next cursor position" }) -- <C-UpperCase> is the same as <C-LowerCase>
keymap("n", "<C-O>", "<C-o>", { silent = true, desc = "prev cursor position" }) -- <C-UpperCase> is the same as <C-LowerCase>

-- Replace all/visual_selected
keymap("n", "<C-s>", ":%s//g<Left><Left>", { noremap = true, silent = false, desc = "Replace in Buffer" })
keymap("x", "<C-s>", ":s//g<Left><Left>", { noremap = true, silent = false, desc = "Replace in Visual_selected" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-;>", "<C-6>", { noremap = true, silent = true, desc = "go to last buffer" })

-- complete next/prev line
keymap("i", "<C-e>", "<esc><C-e>a", opts)
keymap("i", "<C-y>", "<esc><C-y>a", opts)
keymap("i", "<C-n>", "<C-e>", opts) -- completes next line
keymap("i", "<C-p>", "<C-y>", opts) -- completes previous line

-- toggle diagnostics
keymap("i", "<C-v>", "<esc>:ToggleVirtualText<cr>a", { silent = true, desc = "Toggle VirtualText (InsertMode Only)" })

-- Navigate buffers
-- keymap("n", "]q", ":cnext<CR>", opts)
-- keymap("n", "[q", ":cprevious<CR>", opts)
-- keymap("n", "]l", ":lnext<CR>", opts)
-- keymap("n", "[l", ":lprevious<CR>", opts)
-- keymap("n", "<Home>", ":tabprevious<CR>", { silent = true, desc = "prev tab" })
-- keymap("n", "<End>", ":tabnext<CR>", { silent = true, desc = "next tab" })
-- keymap("n", "<Insert>", ":tabnext #<CR>", { silent = true, desc = "last tab" })
-- keymap("t", "<Home>", "<C-\\><C-n>:tabprevious<CR>", { silent = true, desc = "prev tab" })
-- keymap("t", "<End>", "<C-\\><C-n>:tabnext<CR>", { silent = true, desc = "next tab" })
-- keymap("t", "<Insert>", "<C-\\><C-n>:tabnext #<CR>", { silent = true, desc = "next tab" })
keymap("n", "<right>", ":bnext<CR>", { silent = true, desc = "next buffer" })
keymap("n", "<left>", ":bprevious<CR>", { silent = true, desc = "prev buffer" })
keymap("n", "<Tab>", ":bnext<CR>", opts)                 -- replaced by <right>
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)           -- replaced by <left>
keymap("n", "<leader><Tab>", ":tabnext<CR>", opts)       -- replaced by "gt"
keymap("n", "<leader><S-Tab>", ":tabprevious<CR>", opts) -- replaced by "gT"
keymap("n", "<leader>x", ":bp | bd #<CR>", { silent = true, desc = "Close Buffer" })
keymap("n", "<leader>X", ":tabclose<CR>", { silent = true, desc = "Close Tab" })

-- ╭────────────────╮
-- │ leader keymaps │
-- ╰────────────────╯

-- Buffer keymaps
keymap("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opts)
keymap("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opts)
keymap("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opts)
keymap("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opts)
keymap("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opts)
keymap("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opts)
keymap("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opts)
keymap("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opts)
keymap("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opts)

-- visual actions:
-- keymap('x', '<leader>g/', '"zy:s/<C-r>z//g<Left><Left>', { silent = true, desc = "Replace selected_text" })
-- keymap("x", "<leader>g|", ":'<,'>!column -t<CR>", { noremap = true, silent = true, desc = "Format Column" }) -- replaced by mini.align
-- keymap("x", "<leader>g\", ":'<,'>fold      <CR>", { noremap = true, silent = true, desc = "Fold selected" })

-- Visual Paste/ForwardPaste from secondary clipboard
-- keymap("x", '<leader>gP', '"*P', { noremap = true, silent = true, desc = "Paste before (second_clip)" }) -- same as "Paste after (second_clip)" in visual mode
keymap("x", "<leader><leader>p", '"*p', { noremap = true, silent = true, desc = "Paste (second_clip)" })           -- "Paste after (second_clip)"
keymap("x", "<leader><leader>P", 'g_"*P', { noremap = true, silent = true, desc = "Paste forward (second_clip)" }) -- only works in visual mode

-- Visual Copy/Append to secondary clipboard
-- keymap("x", '<leader>ya', 'y:let @* .= @0<cr>', { noremap = true, silent = true, desc = "Yank append (second_clip)" }) -- "Redo register" does it better
keymap("x", "<leader><leader>y", '"*y', { noremap = true, silent = true, desc = "Yank (second_clip)" })
keymap("x", "<leader><leader>Y", 'g_"*y', { noremap = true, silent = true, desc = "Yank forward (second_clip)" })

-- ╭─────────╮
-- │ Motions │
-- ╰─────────╯

-- Navigate code with search labels:
map(
  { "n", "x", "o" },
  "s",
  function() require("flash").jump() end,
  { silent = true, desc = "Flash" }
)
map(
  { "n", "x", "o" },
  "S",
  function() require("flash").treesitter() end,
  { silent = true, desc = "Flash Treesitter" }
)
map(
  { "n", "x", "o" },
  "<cr>",
  function() require("flash").jump({ continue = true }) end,
  { silent = true, desc = "Continue Last Flash search" }
)
-- map({ "o" }, "r", function() require("flash").remote() end, { silent = true, desc = "Remote Flash" })
map(
  { "x", "o" },
  "R",
  function() require("flash").treesitter_search() end,
  { silent = true, desc = "Treesitter Flash Search" }
)
map(
  { "c" },
  "<c-s>",
  function() require("flash").toggle() end,
  { desc = "Toggle Flash Search" }
)

-- vim.keymap.set("n", "vg<", _G.__to_start_of_textobj, { expr = true, desc = "Select from startOf TextObj" })
-- vim.keymap.set("n", "vg>", _G.__to_end_of_textobj, { expr = true, desc = "Selcect to endOf TextObj" })

map(
  { "n", "x" },
  "g<",
  -- function() return GotoTextObj("`[", "`[v``", "`[V``", "`[\x16`'") end,
  function() return GotoTextObj("`<", "`<v`'", "`<V`'", "`<\22`'") end,
  { expr = true, silent = true, desc = "StartOf TextObj" }
)

map(
  { "n", "x" },
  "g>",
  -- function() return GotoTextObj("`]", "``v`]", "``V`]", "`'\x16`]") end,
  function() return GotoTextObj("`>", "`'v`>", "`'V`>", "`'\22`>") end,
  { expr = true, silent = true, desc = "EndOf TextObj" }
)

-- goto changes:
keymap("n", "g,", "g,", { noremap = true, silent = true, desc = "go forward in :changes" })  -- Formatting will lose track of changes
keymap("n", "g;", "g;", { noremap = true, silent = true, desc = "go backward in :changes" }) -- Formatting will lose track of changes

-- Multi cursors:
-- keymap("n", "<C-n>", "<Plug>(VM-Find-Under)", { silent = true, desc = "add virtual cursor (select and find)" })
-- keymap("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", { silent = true, desc = "add virtual cursor (find selected)" })
-- keymap("n", "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", { silent = true, desc = "add virtual cursor down (tab to extend mode)" })
-- keymap("n", "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", { silent = true, desc = "add virtual cursor up (tab to extend mode)" })
-- keymap("n", "<A-j>", "<Plug>(VM-Select-Cursor-Down)", { silent = true, desc = "add virtual cursor down (tab to cursor mode)" })
-- keymap("n", "<A-k>", "<Plug>(VM-Select-Cursor-Up)", { silent = true, desc = "add virtual cursor up (tab to cursor mode)" })
keymap(
  "n",
  "gb",
  "<Plug>(VM-Find-Under)",
  { silent = true, desc = "add virtual cursor (select and find)" }
)
keymap(
  "x",
  "gb",
  "<Plug>(VM-Find-Subword-Under)",
  { silent = true, desc = "add virtual cursor (find selected)" }
)
keymap(
  "n",
  "go",
  "<Plug>(VM-Add-Cursor-Down)",
  { silent = true, desc = "add virtual cursor down (tab to extend/cursor mode)" }
)
keymap(
  "n",
  "gO",
  "<Plug>(VM-Add-Cursor-Up)",
  { silent = true, desc = "add virtual cursor up (tab to extend/cursor mode)" }
)
keymap(
  "x",
  "go",
  "<Plug>(VM-Visual-Add)",
  { silent = true, desc = "visual select to virtual cursor(n to add forward)" }
)
keymap(
  "x",
  "gO",
  "<Plug>(VM-Visual-Add)",
  { silent = true, desc = "visual select to virtual cursor(N to add backward)" }
)
keymap(
  "n",
  "g|",
  "<Plug>(VM-Motion-|)",
  { silent = true, desc = "same column for all virtual cursors" }
)
keymap(
  "x",
  "g|",
  "<Plug>(VM-Visual-Add)<Plug>(VM-Motion-|)",
  { silent = true, desc = "same column for all virtual cursors" }
)
keymap(
  "n",
  "g\\",
  "<Plug>(VM-Add-Cursor-At-Pos)",
  { silent = true, desc = "add virtual cursor at current position (eg after search/jump)" }
)
keymap(
  "x",
  "g\\",
  "<esc><Plug>(VM-Add-Cursor-At-Pos)",
  { silent = true, desc = "add virtual cursor at current position (eg after search/jump)" }
)

-- paste LastSearch Register:
keymap("n", "gh", '"/p', { silent = true, desc = "paste lastSearch register" })

-- Redo Register:
keymap("n", "gr", '"1p', { silent = true, desc = "Redo register (dot to Paste forward the rest of register)" })
keymap("n", "gR", '"1P', { silent = true, desc = "Redo register (dot to Paste backward the rest of register)" })

-- Word-Column textobj (with whitespaces)
map(
  { "n", "x" },
  "gW",
  function()
    vim.cmd([[ execute "normal \<c-v>\<Plug>(columnmove-E)" ]])
    vim.cmd([[ execute "normal \<Plug>(VM-Visual-Add)e" ]])
  end,
  { silent = true, desc = "word-column multicursor" }
)

-- Blackhole register:
map({ "n", "x" }, "gx", '"_d', { silent = true, desc = "Blackhole Motion/Selected" })
map({ "n", "x" }, "gX", '"_D', { silent = true, desc = "Blackhole Linewise" })

-- Visual increment/decrement numbers:
map("n", "g<Up>", "<c-a>", { noremap = true, silent = true, desc = "numbers ascending" })
map("n", "g<Down>", "<c-x>", { noremap = true, silent = true, desc = "numbers descending" })
map("x", "g<Up>", "g<c-a>", { noremap = true, silent = true, desc = "numbers ascending" })
map("x", "g<Down>", "g<c-x>", { noremap = true, silent = true, desc = "numbers descending" })
map({ "n", "x" }, "g+", "<C-a>", { noremap = true, silent = true, desc = "Increment number (dot to repeat)" })
map({ "n", "x" }, "g-", "<C-x>", { noremap = true, silent = true, desc = "Decrement number (dot to repeat)" })

-- ╭───────────────────────────────────────╮
-- │ Text Objects with "g" (dot to repeat) │
-- ╰───────────────────────────────────────╯

-- braces linewise textobj:
map("x", "g{", "aB$o0", { silent = true, desc = "braces linewise textobj" })
map("o", "g{", "<cmd>normal! vaB$o0<cr>", { silent = true, desc = "braces linewise textobj" })
map("x", "g}", "aB$o0", { silent = true, desc = "braces linewise textobj" })
map("o", "g}", "<cmd>normal! vaB$o0<cr>", { silent = true, desc = "braces linewise textobj" })

-- _mini_comment_(not_showing_desc)_(next/prev_autojump_unsupported)
-- map({ "o" }, 'gC', '<cmd>lua require("mini.comment").textobject()<cr>', { silent = true, desc = "RestOfComment textobj" })
-- map({ "x" }, 'gC', ':<c-u>normal "zygCgv<cr>', { silent = true, desc = "RestOfComment textobj" })
map(
  { "o" },
  "gc",
  "<cmd>lua require('various-textobjs').multiCommentedLines()<cr>",
  { silent = true, desc = "BlockComment textobj" }
)
map(
  { "n" },
  "vgc",
  "<cmd>lua require('various-textobjs').multiCommentedLines()<cr>",
  { silent = true, desc = "BlockComment textobj" }
)
map(
  { "x" },
  "gC",
  '<cmd>lua require("mini.comment").textobject()<cr>',
  { silent = true, desc = "RestOfComment textobj" }
)
map(
  { "o" },
  "gC",
  ":<c-u>normal vgC<cr>",
  { silent = true, desc = "RestOfComment textobj" }
)

-- _find_textobj_(dot-repeat_supported)
map({ "o", "x" }, "gf", "gn", { noremap = true, silent = true, desc = "Next find textobj" })
map({ "o", "x" }, "gF", "gN", { noremap = true, silent = true, desc = "Prev find textobj" })

-- reference textobj:
map(
  { "n", "x", "o" },
  "gI",
  '<cmd>lua require"illuminate".textobj_select()<cr>',
  { silent = true, desc = "select reference" }
)

-- _git_hunk_(next/prev_autojump_unsupported)
map({ "o", "x" }, "gh", ":<C-U>Gitsigns select_hunk<CR>", { silent = true, desc = "Git hunk textobj" })

-- _jump_to_last_change
map({ "n", "o", "x" }, "gl", "`.", { silent = true, desc = "Jump to last change" })

-- https://www.reddit.com/r/vim/comments/xnuaxs/last_change_text_object
-- map("v", 'gm', '<Esc>u<C-r>vgi', opts)            -- <left> unsupported
-- map("v", 'gm', '<Esc>u<C-r>v`^<Left>', opts)      -- new-lines unsupported
map("o", "gm", "<cmd>normal! `[v`]<cr>", { silent = true, desc = "Last change textobj" })
map("x", "gm", "`[o`]", { silent = true, desc = "Last change textobj" })

-- _nvim_various_textobjs
map(
  { "o", "x" },
  "gd",
  "<cmd>lua require('various-textobjs').diagnostic()<cr>",
  { silent = true, desc = "Diagnostic textobj" }
)
map(
  { "o", "x" },
  "gK",
  "<cmd>lua require('various-textobjs').column()<cr>",
  { silent = true, desc = "ColumnDown textobj" }
)
map(
  { "o", "x" },
  "gL",
  "<cmd>lua require('various-textobjs').url()<cr>",
  { silent = true, desc = "Url textobj" }
)
map(
  { "o", "x" },
  "gr",
  "<cmd>lua require('various-textobjs').restOfWindow()<CR>",
  { silent = true, desc = "RestOfWindow textobj" }
)
map(
  { "o", "x" },
  "gR",
  "<cmd>lua require('various-textobjs').visibleInWindow()<CR>",
  { silent = true, desc = "VisibleWindow textobj" }
)
map(
  { "o", "x" },
  "gt",
  "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>",
  { silent = true, desc = "toNextQuotationMark textobj" }
)
map(
  { "o", "x" },
  "gT",
  "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>",
  { silent = true, desc = "toNextClosingBracket textobj" }
)

-- ╭───────────────────────────────────────╮
-- │ Text Objects with a/i (dot to repeat) │
-- ╰───────────────────────────────────────╯

-- _nvim_various_textobjs: inner-outer
-- map({ "o", "x" }, "g*", "<cmd>lua require('various-textobjs').entireBuffer()<cr>", { silent = true, desc = "EntireBuffer textobj" })
-- map({ "o", "x" }, "aD", "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<cr>")
-- map({ "o", "x" }, "iD", "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<cr>")
-- map({ "o", "x" }, "aH", "<cmd>lua require('various-textobjs').htmlAttribute('outer')<CR>") -- only html, mini.lua supports jsx
-- map({ "o", "x" }, "iH", "<cmd>lua require('various-textobjs').htmlAttribute('inner')<CR>") -- only html, mini.lua supports jsx
-- map({ "o", "x" }, "aK", "<cmd>lua require('various-textobjs').key('outer')<cr>")
-- map({ "o", "x" }, "iK", "<cmd>lua require('various-textobjs').key('inner')<cr>")
-- map({ "o", "x" }, "aV", "<cmd>lua require('various-textobjs').value('outer')<cr>")
-- map({ "o", "x" }, "iV", "<cmd>lua require('various-textobjs').value('inner')<cr>")
-- map({ "o", "x" }, "aM", "<cmd>lua require('various-textobjs').mdlink('outer')<cr>")
-- map({ "o", "x" }, "iM", "<cmd>lua require('various-textobjs').mdlink('inner')<cr>")
-- map({ "o", "x" }, "aN", "<cmd>lua require('various-textobjs').number('outer')<cr>")
-- map({ "o", "x" }, "iN", "<cmd>lua require('various-textobjs').number('inner')<cr>")

map(
  { "o", "x" },
  "ad",
  "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>",
  { silent = true, desc = "outer greddyOuterIndent textobj" }
)
map(
  { "o", "x" },
  "id",
  "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>",
  { silent = true, desc = "inner greddyOuterIndent textobj" }
)
map(
  { "o", "x" },
  "ie",
  "<cmd>lua require('various-textobjs').nearEoL()<cr>",
  { silent = true, desc = "nearEndOfLine textobj" }
)
map(
  { "o", "x" },
  "ae",
  "<cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>",
  { silent = true, desc = "lineCharacterwise textobj" }
)
map(
  { "o", "x" },
  "aj",
  "<cmd>lua require('various-textobjs').cssSelector('outer')<CR>",
  { silent = true, desc = "outer cssSelector textobj" }
)
map(
  { "o", "x" },
  "ij",
  "<cmd>lua require('various-textobjs').cssSelector('inner')<CR>",
  { silent = true, desc = "inner cssSelector textobj" }
)
map(
  { "o", "x" },
  "am",
  "<cmd>lua require('various-textobjs').chainMember('outer')<CR>",
  { silent = true, desc = "outer chainMember textobj" }
)
map(
  { "o", "x" },
  "im",
  "<cmd>lua require('various-textobjs').chainMember('inner')<CR>",
  { silent = true, desc = "inner chainMember textobj" }
)
map(
  { "o", "x" },
  "aM",
  "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<cr>",
  { silent = true, desc = "outer mdFencedCodeBlock textobj" }
)
map(
  { "o", "x" },
  "iM",
  "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<cr>",
  { silent = true, desc = "inner mdFencedCodeBlock textobj" }
)
map(
  { "o", "x" },
  "ir",
  "<cmd>lua require('various-textobjs').restOfParagraph()<cr>",
  { silent = true, desc = "RestOfParagraph textobj" }
)
map(
  { "o", "x" },
  "ar",
  "<cmd>lua require('various-textobjs').restOfIndentation()<cr>",
  { silent = true, desc = "restOfIndentation textobj" }
)
map(
  { "o", "x" },
  "aS",
  "<cmd>lua require('various-textobjs').subword('outer')<cr>",
  { silent = true, desc = "outer Subword textobj" }
)
map(
  { "o", "x" },
  "iS",
  "<cmd>lua require('various-textobjs').subword('inner')<cr>",
  { silent = true, desc = "inner Subword textobj" }
)
map(
  { "o", "x" },
  "aU",
  "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<cr>",
  { silent = true, desc = "inner pyTrippleQuotes textobj" }
)
map(
  { "o", "x" },
  "iU",
  "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<cr>",
  { silent = true, desc = "inner pyTrippleQuotes textobj" }
)
map(
  { "o", "x" },
  "aZ",
  "<cmd>lua require('various-textobjs').closedFold('outer')<CR>",
  { silent = true, desc = "outer ClosedFold textobj" }
)
map(
  { "o", "x" },
  "iZ",
  "<cmd>lua require('various-textobjs').closedFold('inner')<CR>",
  { silent = true, desc = "inner ClosedFold textobj" }
)

-- _fold_textobj
-- https://superuser.com/questions/578432/can-vim-treat-a-folded-section-as-a-motion
map("x", "iz", ":<C-U>silent!normal![zjV]zk<CR>", { silent = true, desc = "inner fold textobj" })
map("o", "iz", ":normal Viz<CR>", { silent = true, desc = "inner fold textobj" })
map("x", "az", ":<C-U>silent!normal![zV]z<CR>", { silent = true, desc = "outer fold textobj" })
map("o", "az", ":normal Vaz<CR>", { silent = true, desc = "outer fold textobj" })

-- -- Mini Indent Scope textobj:
-- map({ "o", "x" }, "ii", function() require("mini.ai").select_textobject("i","i") end, { silent = true, desc = "MiniIndentscope bordersless with_blankline" })
-- map({ "x" }, "ai", function() require("mini.ai").select_textobject("i","i") vim.cmd [[ normal koj ]] end, { silent = true, desc = "MiniIndentscope borders with_blankline" })
-- map({ "o" }, 'ai', ':<C-u>normal vai<cr>', { silent = true, desc = "MiniIndentscope borders with_blankline" })
-- map({ "o", "x" }, "iI", "<Cmd>lua MiniIndentscope.textobject(false)<CR>", { silent = true, desc = "MiniIndentscope bordersless skip_blankline" })
-- map({ "o", "x" }, "aI", "<Cmd>lua MiniIndentscope.textobject(true)<CR>", { silent = true, desc = "MiniIndentscope borders skip_blankline" })

-- _vim_indent_object_(incrementalrepressing_+_visualrepeatable_+_vimrepeat_+_respectingblanklines_+_norespectslastblanklines(selectblanklines is vip))
map(
  { "o", "x" },
  "ii",
  '<cmd>lua require("various-textobjs").indentation("inner", "inner", "noBlanks")<cr>',
  { desc = "inner noblanks indentation textobj" }
)
map(
  { "o", "x" },
  "ai",
  '<cmd>lua require("various-textobjs").indentation("outer", "outer", "noBlanks")<cr>',
  { desc = "outer noblanks indentation textobj" }
)
map(
  { "o", "x" },
  "iI",
  '<cmd>lua require("various-textobjs").indentation("inner", "inner")<cr>',
  { desc = "inner indentation textobj" }
)
map(
  { "o", "x" },
  "aI",
  '<cmd>lua require("various-textobjs").indentation("outer", "outer")<cr>',
  { desc = "outer indentation textobj" }
)

-- indent same level textobj:
map(
  { "x", "o" },
  "iy",
  ":<c-u> lua require('user.autocommands').select_same_indent(true)<cr>",
  { silent = true, desc = "same_indent skip_blankline textobj" }
)
map(
  { "x", "o" },
  "ay",
  ":<c-u> lua require('user.autocommands').select_same_indent(false)<cr>",
  { silent = true, desc = "same_indent with_blankline textobj" }
)

-- ╭──────────────────────────────────────────╮
-- │ Repeatable Pair - motions using <leader> │
-- ╰──────────────────────────────────────────╯

-- _nvim-treesitter-textobjs_repeatable
-- ensure ; goes forward and , goes backward regardless of the last direction
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { silent = true, desc = "Next TS textobj" })
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { silent = true, desc = "Prev TS textobj" })

-- _columnmove_repeatable
vim.g.columnmove_strict_wbege = 0 -- skips inner-paragraph whitespaces for wbege
vim.g.columnmove_no_default_key_mappings = true
map({ "n", "x", "o" }, "<leader><leader>f", "<Plug>(columnmove-f)", { silent = true })
map({ "n", "x", "o" }, "<leader><leader>t", "<Plug>(columnmove-t)", { silent = true })
map({ "n", "x", "o" }, "<leader><leader>F", "<Plug>(columnmove-F)", { silent = true })
map({ "n", "x", "o" }, "<leader><leader>T", "<Plug>(columnmove-T)", { silent = true })

local next_columnmove, prev_columnmove = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-;)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-,)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>;", next_columnmove, { silent = true, desc = "Next ColumnMove_;" })
map({ "n", "x", "o" }, "<leader><leader>,", prev_columnmove, { silent = true, desc = "Prev ColumnMove_," })

-- _jump_indent_repeatable_with_blankline
local next_indent_wb, prev_indent_wb = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal viiV$" ]]) end,
  function() vim.cmd([[ execute "normal viio\<esc>_" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>a", next_indent_wb, { silent = true, desc = "End Indent with_blankline" })
map({ "n", "x", "o" }, "<leader><leader>i", prev_indent_wb, { silent = true, desc = "Start Indent with_blankline" })

-- _jump_indent_repeatable_skip_blankline
local next_indent_sb, prev_indent_sb = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal viIV$" ]]) end,
  function() vim.cmd([[ execute "normal viIo\<esc>_" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>A", next_indent_sb, { silent = true, desc = "End Indent skip_blankline" })
map({ "n", "x", "o" }, "<leader><leader>I", prev_indent_sb, { silent = true, desc = "Start Indent skip_blankline" })

local next_columnmove_w, prev_columnmove_b = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-w)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-b)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>w", next_columnmove_w, { silent = true, desc = "Next ColumnMove_w" })
map({ "n", "x", "o" }, "<leader><leader>b", prev_columnmove_b, { silent = true, desc = "Prev ColumnMove_b" })

local next_columnmove_e, prev_columnmove_ge = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-e)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-ge)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>e", next_columnmove_e, { silent = true, desc = "Next ColumnMove_e" })
map({ "n", "x", "o" }, "<leader><leader>ge", prev_columnmove_ge, { silent = true, desc = "Prev ColumnMove_ge" })

local next_columnmove_W, prev_columnmove_B = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-W)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-B)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>W", next_columnmove_W, { silent = true, desc = "Next ColumnMove_W" })
map({ "n", "x", "o" }, "<leader><leader>B", prev_columnmove_B, { silent = true, desc = "Prev ColumnMove_B" })

local next_columnmove_E, prev_columnmove_gE = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-E)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-gE)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>E", next_columnmove_E, { silent = true, desc = "Next ColumnMove_E" })
map({ "n", "x", "o" }, "<leader><leader>gE", prev_columnmove_gE, { silent = true, desc = "Prev ColumnMove_gE" })

-- _jump_blankline_repeatable
local next_blankline, prev_blankline = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal } ]]) end,
  function() vim.cmd([[ normal { ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>}", next_blankline, { silent = true, desc = "Next Blankline" })
map({ "n", "x", "o" }, "<leader><leader>{", prev_blankline, { silent = true, desc = "Prev Blankline" })

-- _jump_paragraph_repeatable
local next_paragraph, prev_paragraph = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal )) ]]) end,
  function() vim.cmd([[ normal (( ]]) end)
map({ "n", "x", "o" }, "<leader><leader>)", next_paragraph, { silent = true, desc = "Next Paragraph" })
map({ "n", "x", "o" }, "<leader><leader>(", prev_paragraph, { silent = true, desc = "Prev Paragraph" })

-- _jump_edgefold_repeatable
local next_fold, prev_fold = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal ]z ]]) end,
  function() vim.cmd([[ normal [z ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>]", next_fold, { silent = true, desc = "End Fold" })
map({ "n", "x", "o" }, "<leader><leader>[", prev_fold, { silent = true, desc = "Start Fold" })

-- _jump_startofline_repeatable
local next_startline, prev_startline = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal + ]]) end,
  function() vim.cmd([[ normal - ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>+", next_startline, { silent = true, desc = "next startline" })
map({ "n", "x", "o" }, "<leader><leader>-", prev_startline, { silent = true, desc = "Prev StartLine" })

-- ╭──────────────────────────────────────────────────╮
-- │ Repeatable Pair - textobj navigation using gn/gp │
-- ╰──────────────────────────────────────────────────╯

-- _comment_(goto_repeatable)
-- make sure forward function comes first
-- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.
local next_comment, prev_comment = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.bracketed").comment("forward") end,
  function() require("mini.bracketed").comment("backward") end
)
map({ "n", "x", "o" }, "gnc", next_comment, { silent = true, desc = "Next Comment" })
map({ "n", "x", "o" }, "gpc", prev_comment, { silent = true, desc = "Prev Comment" })

-- _goto_diagnostic_repeatable
local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(
  function() vim.diagnostic.goto_next({ border = "rounded" }) end,
  function() vim.diagnostic.goto_prev({ border = "rounded" }) end
)
map({ "n", "x", "o" }, "gnd", next_diagnostic, { silent = true, desc = "Next Diagnostic" })
map({ "n", "x", "o" }, "gpd", prev_diagnostic, { silent = true, desc = "Prev Diagnostic" })

-- _gitsigns_chunck_repeatable
local gs = require("gitsigns")
local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { silent = true, desc = "Next GitHunk" })
map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { silent = true, desc = "Prev GitHunk" })

-- _references_repeatable
local next_reference, prev_reference = ts_repeat_move.make_repeatable_move_pair(
  function() require("illuminate").goto_next_reference(wrap) end,
  function() require("illuminate").goto_prev_reference(wrap) end
)
map({ "n", "x", "o" }, "gnr", next_reference, { silent = true, desc = "Next Reference" })
map({ "n", "x", "o" }, "gpr", prev_reference, { silent = true, desc = "Prev Reference" })

-- _goto_function_definition_repeatable
local next_inner_funccall, prev_inner_funccall = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal viNf" ]]) end,
  function() vim.cmd([[ execute "normal vilf" ]]) end)
map({ "n", "x", "o" }, "gnif", next_inner_funccall, { silent = true, desc = "Next inner function call" })
map({ "n", "x", "o" }, "gpif", prev_inner_funccall, { silent = true, desc = "Prev inner function call" })

-- _goto_function_definition_repeatable
local next_funcdefinition, prev_funcdefinition = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal vaNf" ]]) end,
  function() vim.cmd([[ execute "normal valf" ]]) end)
map({ "n", "x", "o" }, "gnaf", next_funcdefinition, { silent = true, desc = "Next around function call" })
map({ "n", "x", "o" }, "gpaf", prev_funcdefinition, { silent = true, desc = "Prev around function call" })

-- _html_atribute_textobj_(goto_repeatable)
local next_inner_htmlatrib, prev_inner_htmlatrib = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnih", next_inner_htmlatrib, { silent = true, desc = "Next Inner Html Atrib" })
map({ "n", "x", "o" }, "gpih", prev_inner_htmlatrib, { silent = true, desc = "Prev Inner Html Atrib" })

local next_around_htmlatrib, prev_around_htmlatrib = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnah", next_around_htmlatrib, { silent = true, desc = "Next Around Html Atrib" })
map({ "n", "x", "o" }, "gpah", prev_around_htmlatrib, { silent = true, desc = "Prev Around Html Atrib" })

-- _goto_indent_different_level_skip_blankline_repeatable
local next_different_indent, prev_different_indent = ts_repeat_move.make_repeatable_move_pair(
  function() require("user.autocommands").next_indent(true, "different_level") end,
  function() require("user.autocommands").next_indent(false, "different_level") end
)
map({ "n", "x", "o" }, "gnii", next_different_indent, { silent = true, desc = "next different_indent" })
map({ "n", "x", "o" }, "gpii", prev_different_indent, { silent = true, desc = "prev different_indent" })

-- _key_textobj_(goto_repeatable)
local next_inner_key, prev_inner_key = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "k", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "k", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnik", next_inner_key, { silent = true, desc = "Next Inner Key" })
map({ "n", "x", "o" }, "gpik", prev_inner_key, { silent = true, desc = "Prev Inner Key" })

local next_around_key, prev_around_key = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "k", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "k", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnak", next_around_key, { silent = true, desc = "Next Around Key" })
map({ "n", "x", "o" }, "gpak", prev_around_key, { silent = true, desc = "Prev Around Key" })

-- hexadecimalcolor_textobj_(goto_repeatable)
local next_inner_numeral, prev_inner_numeral = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "n", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "n", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnin", next_inner_numeral, { silent = true, desc = "Next Inner Number" })
map({ "n", "x", "o" }, "gpin", prev_inner_numeral, { silent = true, desc = "Prev Inner Number" })

local next_around_numeral, prev_around_numeral = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "n", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "n", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnan", next_around_numeral, { silent = true, desc = "Next Around Number" })
map({ "n", "x", "o" }, "gpan", prev_around_numeral, { silent = true, desc = "Prev Around Number" })

-- _goto_quotes_repeatable
local next_inner_quote, prev_inner_quote = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gniu", next_inner_quote, { silent = true, desc = "Next Inner Quote" })
map({ "n", "x", "o" }, "gpiu", prev_inner_quote, { silent = true, desc = "Prev Inner Quote" })

local next_around_quote, prev_around_quote = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnau", next_around_quote, { silent = true, desc = "Next Around Quote" })
map({ "n", "x", "o" }, "gpau", prev_around_quote, { silent = true, desc = "Prev Around Quote" })

-- _value_textobj_(goto_repeatable)
local next_inner_value, prev_inner_value = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "v", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "v", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gniv", next_inner_value, { silent = true, desc = "Next Inner Value" })
map({ "n", "x", "o" }, "gpiv", prev_inner_value, { silent = true, desc = "Prev Inner Value" })

local next_around_value, prev_around_value = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "v", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "v", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnav", next_around_value, { silent = true, desc = "Next Around Value" })
map({ "n", "x", "o" }, "gnav", prev_around_value, { silent = true, desc = "Prev Around Value" })

-- _number_textobj_(goto_repeatable)
local next_inner_hex, prev_inner_hex = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "x", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "x", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnix", next_inner_hex, { silent = true, desc = "Next Inner Hex" })
map({ "n", "x", "o" }, "gpix", prev_inner_hex, { silent = true, desc = "Prev Inner Hex" })

local next_around_hex, prev_around_hex = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "x", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "x", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnax", next_around_hex, { silent = true, desc = "Next Around Hex" })
map({ "n", "x", "o" }, "gpax", prev_around_hex, { silent = true, desc = "Prev Around Hex" })

-- _goto_indent_same_level_skip_blankline_repeatable
local next_same_indent, prev_same_indent = ts_repeat_move.make_repeatable_move_pair(
  function() require("user.autocommands").next_indent(true, "same_level") end,
  function() require("user.autocommands").next_indent(false, "same_level") end
)
map({ "n", "x", "o" }, "gniy", next_same_indent, { silent = true, desc = "next same_indent" })
map({ "n", "x", "o" }, "gpiy", prev_same_indent, { silent = true, desc = "prev same_indent" })
