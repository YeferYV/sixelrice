local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"

------------------------------------------------------------------------------------------------------------------------

local function fb_actions(action, prompt_bufnr)
  return require "telescope._extensions.file_browser.actions"[action](prompt_bufnr)
end

local function edit_register(prompt_bufnr)
  local selection = require("telescope.actions.state").get_selected_entry()
  local updated_value = vim.fn.input("Edit [" .. selection.value .. "] ❯ ", selection.content)

  vim.fn.setreg(selection.value:lower(), updated_value)
  selection.content = updated_value

  require("telescope.actions").close(prompt_bufnr)
  require("telescope.builtin").resume()
end

------------------------------------------------------------------------------------------------------------------------

return {
  {
    "nvim-telescope/telescope.nvim",
    config = {
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
      extensions = {
        file_browser = {
          auto_depth = true,
          display_stat = {},
          grouped = true,
          hidden = true,
          hide_parent_dir = true,
          path = "%:p:h",
          respect_gitignore = false,
          mappings = {
            ["i"] = {
              ["<A-B>"] = function(prompt_bufnr) fb_actions("toggle_browser", prompt_bufnr) end,
              ["<A-C>"] = function(prompt_bufnr) fb_actions("create", prompt_bufnr) end,
              ["<A-D>"] = function(prompt_bufnr) fb_actions("remove", prompt_bufnr) end,
              ["<A-E>"] = function(prompt_bufnr) fb_actions("goto_home_dir", prompt_bufnr) end,
              ["<c-h>"] = function(prompt_bufnr) fb_actions("toggle_hidden", prompt_bufnr) end,
              ["<A-H>"] = function(prompt_bufnr) fb_actions("goto_parent_dir", prompt_bufnr) end,
              ["<A-M>"] = function(prompt_bufnr) fb_actions("move", prompt_bufnr) end,
              ["<A-O>"] = function(prompt_bufnr) fb_actions("open", prompt_bufnr) end,
              ["<A-R>"] = function(prompt_bufnr) fb_actions("rename", prompt_bufnr) end,
              ["<A-W>"] = function(prompt_bufnr) fb_actions("goto_cwd", prompt_bufnr) end,
              ["<A-Y>"] = function(prompt_bufnr) fb_actions("copy", prompt_bufnr) end,
              ["<A-Z>"] = function(prompt_bufnr) fb_actions("toggle_all", prompt_bufnr) end,
              ["<A-.>"] = function(prompt_bufnr) fb_actions("change_cwd", prompt_bufnr) end,
              ["<S-CR>"] = function(prompt_bufnr) fb_actions("create_from_prompt", prompt_bufnr) end,
            },
            ["n"] = {
              ["B"] = function(prompt_bufnr) fb_actions("toggle_browser", prompt_bufnr) end,
              ["c"] = function(prompt_bufnr) fb_actions("create", prompt_bufnr) end,
              ["D"] = function(prompt_bufnr) fb_actions("remove", prompt_bufnr) end,
              ["e"] = function(prompt_bufnr) fb_actions("goto_home_dir", prompt_bufnr) end,
              ["h"] = function(prompt_bufnr) fb_actions("goto_parent_dir", prompt_bufnr) end,
              ["H"] = function(prompt_bufnr) fb_actions("toggle_hidden", prompt_bufnr) end,
              ["m"] = function(prompt_bufnr) fb_actions("move", prompt_bufnr) end,
              ["o"] = function(prompt_bufnr) fb_actions("open", prompt_bufnr) end,
              ["r"] = function(prompt_bufnr) fb_actions("rename", prompt_bufnr) end,
              ["w"] = function(prompt_bufnr) fb_actions("goto_cwd", prompt_bufnr) end,
              ["y"] = function(prompt_bufnr) fb_actions("copy", prompt_bufnr) end,
              ["z"] = function(prompt_bufnr) fb_actions("toggle_all", prompt_bufnr) end,
              ["."] = function(prompt_bufnr) fb_actions("change_cwd", prompt_bufnr) end,
            }
          }
        }
      }
    }
  }
}
