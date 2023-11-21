local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  -- ensure_installed can be "all" or a list of languages { "python", "javascript" }
  ensure_installed = { "python", "bash", "javascript", "json", "html", "css", "c", "lua" },

  autopairs = {
    enable = true,
  },
  highlight = {    -- enable highlighting for all file types
    enable = true, -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
    use_languagetree = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "python", "yaml" } },
  -- context_commentstring = {
  --   enable = true,
  --   enable_autocmd = false,
  -- },
  incremental_selection = {
    enable = true, -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
    disable = { "yaml" },
    keymaps = {    -- mappings for incremental selection (visual mappings)
      -- init_selection = "gnn",         -- maps in normal mode to init the node/scope selection
      -- node_incremental = "grn",       -- increment to the upper named parent
      -- scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
      -- node_decremental = "grm",       -- decrement to the previous node
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-]>',
      node_decremental = '<c-[>', -- showkey -a <c-backspace> outputs ^H
    }
  },
  textobjects = {
    -- select = {
    --   enable = true,  -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
    --   include_surrounding_whitespace = false,
    --   lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
    --   keymaps = {
    --     -- You can use the capture groups defined here:
    --     -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/c/textobjects.scm
    --     -- ["aa"] = "@attribute.inner",  -- not supported in c/go/javascript/lua/python/rust
    --     -- ["ia"] = "@attribute.inner",  -- not supported in c/go/javascript/lua/python/rust
    --     ['aq'] = '@call.outer',
    --     ['iq'] = '@call.inner',
    --     ['aQ'] = '@class.outer',         -- not supported in lua
    --     ['iQ'] = '@class.inner',         -- not supported in lua
    --     ['ag'] = '@comment.inner',       -- not supported in javascript
    --     ['ig'] = '@comment.outer',       -- not supported in javascript
    --     ['aG'] = '@conditional.outer',   --     supported in bash
    --     ['iG'] = '@conditional.inner',   --     supported in bash
    --     ["aB"] = "@block.outer",
    --     ["iB"] = "@block.inner",         -- not supported in c
    --     -- ["af"] = "@frame.outer",      -- not supported in c/go/javascript/lua/python/rust
    --     -- ["if"] = "@frame.inner",      -- not supported in c/go/javascript/lua/python/rust
    --     ["aF"] = "@function.outer",      --     supported in bash
    --     ["iF"] = "@function.inner",      --     supported in bash
    --     ['aL'] = '@loop.outer',          --     supported in bash
    --     ['iL'] = '@loop.inner',          --     supported in bash
    --     ['aP'] = '@parameter.outer',
    --     ['iP'] = '@parameter.inner',
    --     -- ["aX"] = "@statement.outer",  -- not supported in c/go/javascript/lua/python/rust
    --     -- ["iX"] = "@scopename.inner",  -- not supported in      javascript/lua
    --     ['a='] = '@assignment.lhs',
    --     ['i='] = '@assignment.rhs',
    --     ['a+'] = '@assignment.outer',
    --     ['i+'] = '@assignment.inner',
    --   },
    --   -- selection_modes = {
    --   --   ['@parameter.outer'] = 'v', -- charwise
    --   --   ['@function.outer'] = 'V', -- linewise
    --   --   ['@class.outer'] = '<c-v>', -- blockwise
    --   -- },
    -- },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_previous_start = {
        ['gpaB'] = '@block.outer',
        ['gpaq'] = '@call.outer',
        ['gpaQ'] = '@class.outer',
        ['gpag'] = '@comment.outer',
        ['gpaG'] = '@conditional.outer',
        ['gpaF'] = '@function.outer',
        ['gpaL'] = '@loop.outer',
        ['gpaP'] = '@parameter.outer',
        ['gpaR'] = '@return.outer',
        ['gpaA'] = '@assignment.outer',
        ['gpa='] = '@assignment.lhs',
        ['gpa#'] = '@number.outer',
        ["gpz"] = { query = "@fold", query_group = "folds", desc = "Previous Start Fold" },
        ["gpZ"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },

        ['gpiB'] = '@block.inner',
        ['gpiq'] = '@call.inner',
        ['gpiQ'] = '@class.inner',
        ['gpig'] = '@comment.inner',
        ['gpiG'] = '@conditional.inner',
        ['gpiF'] = '@function.inner',
        ['gpiL'] = '@loop.inner',
        ['gpiP'] = '@parameter.inner',
        ['gpiR'] = '@return.inner',
        ['gpiA'] = '@assignment.inner',
        ['gpi='] = '@assignment.rhs',
        ['gpi#'] = '@number.inner',
      },
      goto_next_start = {
        ['gnaB'] = '@block.outer',
        ['gnaq'] = '@call.outer',
        ['gnaQ'] = '@class.outer',
        ['gnag'] = '@comment.outer',
        ['gnaG'] = '@conditional.outer',
        ['gnaF'] = '@function.outer',
        ['gnaL'] = '@loop.outer',
        ['gnaP'] = '@parameter.outer',
        ['gnaR'] = '@return.outer',
        ['gnaA'] = '@assignment.outer',
        ['gna='] = '@assignment.lhs',
        ['gna#'] = '@number.outer',
        ["gnz"] = { query = "@fold", query_group = "folds", desc = "Next Start Fold" },
        ["gnZ"] = { query = "@scope", query_group = "locals", desc = "Next scope" },

        ['gniB'] = '@block.inner',
        ['gniq'] = '@call.inner',
        ['gniQ'] = '@class.inner',
        ['gnig'] = '@comment.inner',
        ['gniG'] = '@conditional.inner',
        ['gniF'] = '@function.inner',
        ['gniL'] = '@loop.inner',
        ['gniP'] = '@parameter.inner',
        ['gniR'] = '@return.inner',
        ['gniA'] = '@assignment.inner',
        ['gni='] = '@assignment.rhs',
        ['gni#'] = '@number.inner',
      },
      goto_previous_end = {
        ['gpeaB'] = '@block.outer',
        ['gpeaq'] = '@call.outer',
        ['gpeaQ'] = '@class.outer',
        ['gpeag'] = '@comment.outer',
        ['gpeaG'] = '@conditional.outer',
        ['gpeaF'] = '@function.outer',
        ['gpeaL'] = '@loop.outer',
        ['gpeaP'] = '@parameter.outer',
        ['gpeaR'] = '@return.outer',
        ['gpeaA'] = '@assignment.lhs',
        ['gpea='] = '@assignment.outer',
        ['gpea#'] = '@number.outer',
        ["gpez"] = { query = "@fold", query_group = "folds", desc = "Previous End Fold" },
        ["gpeZ"] = { query = "@scope", query_group = "locals", desc = "Next scope" },

        ['gpeiB'] = '@block.inner',
        ['gpeiq'] = '@call.inner',
        ['gpeiQ'] = '@class.inner',
        ['gpeig'] = '@comment.inner',
        ['gpeiG'] = '@conditional.inner',
        ['gpeiF'] = '@function.inner',
        ['gpeiL'] = '@loop.inner',
        ['gpeiP'] = '@parameter.inner',
        ['gpeiR'] = '@return.inner',
        ['gpeiA'] = '@assignment.inner',
        ['gpei='] = '@assignment.rhs',
        ['gpei#'] = '@number.inner',
      },
      goto_next_end = {
        ['gneaB'] = '@block.outer',
        ['gneaq'] = '@call.outer',
        ['gneaQ'] = '@class.outer',
        ['gneag'] = '@comment.outer',
        ['gneaG'] = '@conditional.outer',
        ['gneaF'] = '@function.outer',
        ['gneaL'] = '@loop.outer',
        ['gneaP'] = '@parameter.outer',
        ['gneaR'] = '@return.outer',
        ['gneaA'] = '@assignment.outer',
        ['gnea='] = '@assignment.lhs',
        ['gnea#'] = '@number.outer',
        ["gnez"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["gneZ"] = { query = "@fold", query_group = "folds", desc = "Next End Fold" },

        ['gneiB'] = '@block.inner',
        ['gneiq'] = '@call.inner',
        ['gneiQ'] = '@class.inner',
        ['gneig'] = '@comment.inner',
        ['gneiG'] = '@conditional.inner',
        ['gneiF'] = '@function.inner',
        ['gneiL'] = '@loop.inner',
        ['gneiP'] = '@parameter.inner',
        ['gneiR'] = '@return.inner',
        ['gneiA'] = '@assignment.inner',
        ['gnei='] = '@assignment.rhs',
        ['gnei#'] = '@number.inner',
      },
    },
    -- selection_modes = {
    --   ['@parameter.outer'] = 'v', -- charwise
    --   ['@function.outer'] = 'V', -- linewise
    --   ['@class.outer'] = '<c-v>', -- blockwise
    -- },
    swap = {
      enable = true,
      swap_next = {
        ['>,'] = '@parameter.inner',
      },
      swap_previous = {
        ['<,'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = 'rounded', --'none', 'single', 'double', 'rounded', 'solid', 'shadow'.
      peek_definition_code = {
        ['<leader>lf'] = '@function.outer',
        ['<leader>lc'] = '@class.outer',
      },
    },
  },
  -- textsubjects = {
  --   enable = true,
  --   prev_selection = 'Q',           -- (Optional) keymap to select the previous selection
  --   keymaps = {
  --     ['K'] = 'textsubjects-smart', -- useful for block of comments
  --     ['aK'] = 'textsubjects-container-outer',
  --     ['iK'] = 'textsubjects-container-inner',
  --   },
  -- },
}

-- vim.api.nvim_exec([[
--     setlocal foldmethod=expr
--     setlocal foldexpr=nvim_treesitter#foldexpr()
-- ]], true)
