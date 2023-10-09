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
          k = { { '\n.-[=:]', '^.-[=:]' }, '^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]' },
          v = { { '[=:]()%s*().-%s*()[;,]()', '[=:]=?()%s*().*()().$' } },
          u = { { "%b''", '%b""', '%b``' }, '^.().*().$' },
          n = { '[-+]?()%f[%d]%d+()%.?%d*' },
          x = { '#()%x%x%x%x%x%x()' },
          r = { '%S()%s+()%S' },
          A = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1)
            }
            return { from = from, to = to }
          end,
          i = function()
            local start_indent = vim.fn.indent(vim.fn.line('.'))
            if string.match(vim.fn.getline('.'), '^%s*$') then return { from = nil, to = nil } end

            local prev_line = vim.fn.line('.') - 1
            while vim.fn.indent(prev_line) >= start_indent do
                vim.cmd('-')
                prev_line = vim.fn.line('.') - 1
            end

            from = { line = vim.fn.line('.'), col = 1 }

            local next_line = vim.fn.line('.') + 1
            while vim.fn.indent(next_line) >= start_indent do
                vim.cmd('+')
                next_line = vim.fn.line('.') + 1
            end

            to = { line = vim.fn.line('.'), col = vim.fn.getline(vim.fn.line('.')):len() }
            return { from = from, to = to }
          end
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
        options = {
          split_pattern = '',
          justify_side = 'left',
          merge_delimiter = '',
        },
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
        options = {
          custom_commentstring = nil,
          ignore_blank_line = false,
          start_of_line = false,
          pad_comment_parts = true,
        },
        mappings = {
          comment = 'gc',
          comment_line = 'gcc',
          textobject = 'gc',
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
          object_scope = '',
          object_scope_with_border = '',
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
        n_lines = 20,
        search_method = 'cover',
      })
    end
  },
}
