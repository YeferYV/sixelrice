-- https://docs.astronvim.com/recipes/cmp/#advanced-setup-for-filetype-and-cmdline

local cmp = require "cmp"

cmp.setup {

  mapping = {
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<C-l>"] = cmp.mapping(cmp.mapping.confirm { select = true }, { "i", "c" }),
  },

  completion = {
    completeopt = 'menu,menuone,noinsert' -- autoselect to show the completion preview
  }

}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
