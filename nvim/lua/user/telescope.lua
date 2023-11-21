local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local fb_actions = require "telescope._extensions.file_browser.actions"

-- FIXED: actions.edit_register
local function edit_register(prompt_bufnr)
  local selection = require("telescope.actions.state").get_selected_entry()
  local updated_value = vim.fn.input("Edit [" .. selection.value .. "] ❯ ", selection.content)

  vim.fn.setreg(selection.value:lower(), updated_value)
  selection.content = updated_value

  require("telescope.actions").close(prompt_bufnr)
  require("telescope.builtin").resume()
end

telescope.setup {
  defaults = {
    -- vimgrep_arguments = {
    --   "rg",
    --   "--color=never",
    --   "--no-heading",
    --   "--with-filename",
    --   "--line-number",
    --   "--column",
    --   "--smart-case",
    --   "--hidden",
    --   "--glob=!.git/",
    -- },
    -- wrap_results = true,
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    file_ignore_patterns = {
      "node_modules", "!.git/",
    },
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    mappings = {
      i = {
        ["<A-R>"] = edit_register,

        ["<Tab>"] = function(prompt_bufnr)
          actions.toggle_selection(prompt_bufnr)
          actions.move_selection_next(prompt_bufnr)
        end,
        ["<S-Tab>"] = function(prompt_bufnr)
          actions.toggle_selection(prompt_bufnr)
          actions.move_selection_previous(prompt_bufnr)
        end,

        ["<C-a>"] = function(prompt_bufnr)
          actions.add_selected_to_qflist(prompt_bufnr)
          actions.open_qflist(prompt_bufnr)
        end,
        ["<A-A>"] = function(prompt_bufnr)
          actions.add_selected_to_loclist(prompt_bufnr)
          actions.open_loclist(prompt_bufnr)
        end,

        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-u>"] = actions.preview_scrolling_up,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-l>"] = actions.select_default,
        ["<A-J>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, 10) end,
        ["<A-K>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, -10) end,

        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-g>"] = actions.move_to_top,
        ["<A-G>"] = actions.move_to_bottom,
        ["<C-;>"] = actions.move_to_middle,

        ["<C-c>"] = actions.close,

        ["<C-s>"] = function(prompt_bufnr)
          actions.send_selected_to_qflist(prompt_bufnr)
          actions.open_qflist(prompt_bufnr)
        end,
        ["<A-S>"] = function(prompt_bufnr)
          actions.send_selected_to_loclist(prompt_bufnr)
          actions.open_loclist(prompt_bufnr)
        end,

        ["<C-v>"] = actions.select_vertical,
        ["<A-V>"] = actions.select_horizontal,
        ["<A-T>"] = actions.select_tab,

        ["<A-P>"] = require("telescope.actions.layout").toggle_preview,
        ["<A-Z>"] = require("telescope.actions.layout").cycle_layout_next,
        ["<C-z>"] = actions.toggle_all,

        ["<C-_>"] = actions.complete_tag, -- keys from pressing <C-/>
        ["<C-?>"] = actions.which_key,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
      },
      n = {
        ["R"] = edit_register,

        ["<Tab>"] = function(prompt_bufnr)
          actions.toggle_selection(prompt_bufnr)
          actions.move_selection_next(prompt_bufnr)
        end,
        ["<S-Tab>"] = function(prompt_bufnr)
          actions.toggle_selection(prompt_bufnr)
          actions.move_selection_previous(prompt_bufnr)
        end,

        ["a"] = function(prompt_bufnr)
          actions.add_selected_to_qflist(prompt_bufnr)
          actions.open_qflist(prompt_bufnr)
        end,
        ["A"] = function(prompt_bufnr)
          actions.add_selected_to_loclist(prompt_bufnr)
          actions.open_loclist(prompt_bufnr)
        end,

        ["d"] = actions.preview_scrolling_down,
        ["u"] = actions.preview_scrolling_up,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["l"] = actions.select_default,
        ["J"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, 10) end,
        ["K"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, -10) end,

        ["n"] = actions.cycle_history_next,
        ["p"] = actions.cycle_history_prev,

        ["g"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        [";"] = actions.move_to_middle,

        ["q"] = actions.close,
        ["<esc>"] = actions.close,

        ["s"] = function(prompt_bufnr)
          actions.send_selected_to_qflist(prompt_bufnr)
          actions.open_qflist(prompt_bufnr)
        end,
        ["S"] = function(prompt_bufnr)
          actions.send_selected_to_loclist(prompt_bufnr)
          actions.open_loclist(prompt_bufnr)
        end,

        ["t"] = actions.select_tab,
        ["v"] = actions.select_vertical,
        ["V"] = actions.select_horizontal,

        ["P"] = require("telescope.actions.layout").toggle_preview,
        ["Z"] = require("telescope.actions.layout").cycle_layout_next,
        ["z"] = actions.toggle_all,

        ["/"] = actions.complete_tag,
        ["?"] = actions.which_key,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
      },
    },
  },
  pickers = {
    find_files = {
      mappings = {
        n = {
          ["h"] = function(prompt_bufnr)
            local finders = require "telescope.finders"
            local make_entry = require "telescope.make_entry"
            local action_state = require "telescope.actions.state"
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            local opts = {
              entry_maker = make_entry.gen_from_file(),
              default_text = current_picker:_get_prompt()
            }

            local cmd = { "rg", "--files", "--hidden", "--glob", "!.git/" }
            current_picker:refresh(finders.new_oneshot_job(cmd, opts), {})
          end,
          ["l"] = function(prompt_bufnr)
            local finders = require "telescope.finders"
            local make_entry = require "telescope.make_entry"
            local action_state = require "telescope.actions.state"
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            local opts = {
              entry_maker = make_entry.gen_from_file(),
              default_text = current_picker:_get_prompt()
            }

            local cmd = { "rg", "--files" }
            current_picker:refresh(finders.new_oneshot_job(cmd, opts), {})
          end,
        },
      },
    },
    live_grep = {
      mappings = {
        i = { ["<c-f>"] = actions.to_fuzzy_refine },
        n = {
          ["h"] = function(prompt_bufnr)
            local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local opts = {
              default_text = current_picker:_get_prompt(),
              additional_args = function()
                return { "--hidden" }
              end
            }
            require('telescope.builtin').live_grep(require('telescope.themes').get_ivy(opts))
          end,
          ["l"] = function(prompt_bufnr)
            local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local opts = {
              default_text = current_picker:_get_prompt(),
            }
            require('telescope.builtin').live_grep(require('telescope.themes').get_ivy(opts))
          end,
        },
      },
    },
    grep_string = {
      mappings = {
        i = { ["<c-f>"] = actions.to_fuzzy_refine },
        n = {
          ["h"] = function(prompt_bufnr)
            local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local opts = {
              default_text = current_picker:_get_prompt(),
              vimgrep_arguments = { 'rg', '--hidden', '--no-heading', '--with-filename', '--line-number', '--column',
                '--smart-case', "--glob", "!.git/" },
            }
            require('telescope.builtin').grep_string(require('telescope.themes').get_ivy(opts))
          end,
          ["l"] = function(prompt_bufnr)
            local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local opts = {
              default_text = current_picker:_get_prompt(),
              vimgrep_arguments = { 'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
            }
            require('telescope.builtin').grep_string(require('telescope.themes').get_ivy(opts))
          end,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    file_browser = {
      -- theme = "ivy",
      auto_depth = true, -- finder unlimited depth
      depth = 1,         -- telescope show depth
      default_selection_index = 1,
      display_stat = {}, -- { date = true, size = true },
      grouped = true,
      hidden = true,
      hide_parent_dir = true,
      path = "%:p:h",
      respect_gitignore = false,
      mappings = {
        ["i"] = {
          ["<A-B>"] = fb_actions.toggle_browser,
          ["<A-C>"] = fb_actions.create,
          ["<A-D>"] = fb_actions.remove,
          ["<A-E>"] = fb_actions.goto_home_dir,
          ["<c-h>"] = fb_actions.toggle_hidden,
          ["<A-H>"] = fb_actions.goto_parent_dir,
          ["<A-M>"] = fb_actions.move,
          ["<A-O>"] = fb_actions.open,
          ["<A-R>"] = fb_actions.rename,
          ["<A-W>"] = fb_actions.goto_cwd,
          ["<A-Y>"] = fb_actions.copy,
          ["<A-Z>"] = fb_actions.toggle_all,
          ["<A-.>"] = fb_actions.change_cwd,
          ["<S-CR>"] = fb_actions.create_from_prompt,
        },
        ["n"] = {
          ["B"] = fb_actions.toggle_browser,
          ["c"] = fb_actions.create,
          ["D"] = fb_actions.remove,
          ["e"] = fb_actions.goto_home_dir,
          ["h"] = fb_actions.goto_parent_dir,
          ["H"] = fb_actions.toggle_hidden,
          ["m"] = fb_actions.move,
          ["o"] = fb_actions.open,
          ["r"] = fb_actions.rename,
          ["w"] = fb_actions.goto_cwd,
          ["y"] = fb_actions.copy,
          ["z"] = fb_actions.toggle_all,
          ["."] = fb_actions.change_cwd,
        },
      },
    }
  },
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("file_browser")
require("telescope").load_extension("neoclip")

-- local M = {}
-- function M.find_configs()
--   require("telescope.builtin").find_files {
--     prompt_title = " NVim & Term Config Find",
--     results_title = "Config Files Results",
--     path_display = { "smart" },
--     search_dirs = {
--       "~/.config/nvim",
--     },
--     layout_strategy = "horizontal",
--     layout_config = { preview_width = 0.65, width = 0.75 },
--   }
-- end
-- return M
