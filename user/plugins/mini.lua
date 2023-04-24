return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      local spec_treesitter = require('mini.ai').gen_spec.treesitter
      require('mini.ai').setup({
        custom_textobjects = {
          q = spec_treesitter({ a = '@call.outer', i = '@call.inner', }),
          Q = spec_treesitter({ a = '@class.outer', i = '@class.inner', }),
          g = spec_treesitter({ a = '@comment.outer', i = '@comment.inner', }),
          G = spec_treesitter({ a = '@conditional.outer', i = '@conditional.inner', }),
          B = spec_treesitter({ a = '@block.outer', i = '@block.inner', }),
          F = spec_treesitter({ a = '@function.outer', i = '@function.inner', }),
          L = spec_treesitter({ a = '@loop.outer', i = '@loop.inner', }),
          P = spec_treesitter({ a = '@parameter.outer', i = '@parameter.inner', }),
          R = spec_treesitter({ a = '@return.outer', i = '@return.inner', }),
          ["="] = spec_treesitter({ a = '@assignment.rhs', i = '@assignment.lhs', }),
          ["+"] = spec_treesitter({ a = '@assignment.outer', i = '@assignment.inner', }),
          ["*"] = spec_treesitter({ a = '@number.outer', i = '@number.inner', }),
          a = require('mini.ai').gen_spec.argument({ brackets = { '%b()' } }),
          k = { { '\n.-[=:]', '^.-[=:]' }, '^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]' }, -- .- -> don't be greedy let %s- to exist
          v = { { '[=:]()%s*().-%s*()[;,]()', '[=:]=?()%s*().*()().$' } }, -- Pattern in double curly bracket equals fallback
          u = { { "%b''", '%b""', '%b``' }, '^.().*().$' },
          n = { '[-+]?()%f[%d]%d+()%.?%d*' }, -- %f[%d] to make jumping to next group of number instead of next digit
          x = { '#()%x%x%x%x%x%x()' },
        },
        mappings = {
          around = 'a',
          inside = 'i',
          around_next = 'aN',
          inside_next = 'iN',
          around_last = 'al',
          inside_last = 'il',
          goto_left = 'g[',
          goto_right = 'g]',
        },
      })

      require('mini.align').setup({
        mappings = {
          start = 'ga',
          start_with_preview = 'gA',
        },
      })

      require('mini.bracketed').setup({
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
        mappings = {
          comment = '',
          comment_line = '',
          textobject = '',
        },
        hooks = {
          pre = function() require('ts_context_commentstring.internal').update_commentstring() end,
          post = function()
          end,
        },
      })

      require('mini.indentscope').setup({
        draw = {
          delay = 100,
          animation = nil
        },
        mappings = {
          object_scope = 'iI', -- empty to disable
          object_scope_with_border = 'aI', -- empty to disable
          goto_top = '[ii',
          goto_bottom = ']ii',
        },
        options = {
          border = 'both',
          indent_at_cursor = false,
          try_as_border = false,
        },
        symbol = '',
      })

      require('mini.splitjoin').setup({
        mappings = {
          toggle = 'gS',
          split = '',
          join = '',
        },
        detect = {
          brackets = nil,
          separator = ',',
          exclude_regions = nil,
        },
      })

      require('mini.surround').setup({
        custom_surroundings = nil,
        highlight_duration = 500,
        mappings = {
          add = 'ys', -- Add surrounding in Normal and Visual modes
          delete = 'ds', -- Delete surrounding
          find = 'zf', -- Find surrounding (to the right)
          find_left = 'zF', -- Find surrounding (to the left)
          highlight = 'zh', -- Highlight surrounding
          replace = 'cs', -- Replace surrounding
          update_n_lines = 'zn', -- Update `n_lines`
          suffix_last = 'l', -- Suffix to search with "prev" method
          suffix_next = 'N', -- Suffix to search with "next" method
        },
      })
    end
  },
}
