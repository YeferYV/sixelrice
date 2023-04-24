-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  n = {
    ["Q"] = { function() vim.cmd("quit") end, desc = "Quit" },
    ["R"] = { function()
      vim.lsp.buf.format()
      vim.cmd("silent write")
    end, desc = "Save" },
    ["Y"] = { "yg_", desc = "Forward yank" },
    ["<leader>v"] = { "<Cmd>ToggleTerm direction=vertical   size=70<CR>", desc = "ToggleTerm vertical" },
    ["<leader>V"] = { "<Cmd>ToggleTerm direction=horizontal size=10<CR>", desc = "ToggleTerm horizontal" },
    ["<leader>gh"] = false, -- disable Reset Git hunk
  },
  t = {
    ["<esc><esc>"] = { [[<C-\><C-n>]], desc = "Normal Mode" },
  },
  v = {
    ["p"] = { '"_c<c-r>+<esc>', desc = "Paste unaltered" },
    ["P"] = { 'g_P', desc = "Forward Paste" },
    ["<leader>p"] = { '"*p', desc = "Paste unaltered (second_clip)" },
    ["<leader>P"] = { 'g_"*P', desc = "Forward Paste (second_clip)" },
    ["<leader>y"] = { '"*y', desc = "Copy (second_clip)" },
    ["<leader>Y"] = { 'y:let @* .= @0<cr>', desc = "Copy Append (second_clip)" },
    ["<leader>z"] = { ":'<,'>fold<CR>", desc = "fold" },
    ["<leader>Z"] = { ":'<,'>!column -t<CR>", desc = "Format Column" },
    ["<leader>gw"] = { "gw", desc = "Format Comment" },
    ["<leader>gi"] = { "g<C-a>", desc = "Increment numbers" },
    ["<leader>gd"] = { "g<C-x>", desc = "Decrement numbers" },
  },
  c = {
    ["w!!"] = { "w !sudo tee %", desc = "save as sudo" },
  }
}
