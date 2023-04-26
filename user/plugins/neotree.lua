return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    config = {
      window = {
        mappings = {
          ["F"] = "filter_on_submit",
          ["v"] = function(state)
            state.commands["open_vsplit"](state)
            vim.cmd("Neotree close")
          end,
          ["V"] = function(state)
            state.commands["open_split"](state)
            vim.cmd("Neotree close")
          end,
          ["0"] = "focus_preview",
          ["s"] = false,
          ["S"] = false,
          ["f"] = false,
          ["fa"] = function() vim.cmd [[normal 0]] vim.cmd [[/ a]] vim.cmd [[normal n]] end,
          ["fb"] = function() vim.cmd [[normal 0]] vim.cmd [[/ b]] vim.cmd [[normal n]] end,
          ["fc"] = function() vim.cmd [[normal 0]] vim.cmd [[/ c]] vim.cmd [[normal n]] end,
          ["fd"] = function() vim.cmd [[normal 0]] vim.cmd [[/ d]] vim.cmd [[normal n]] end,
          ["fe"] = function() vim.cmd [[normal 0]] vim.cmd [[/ e]] vim.cmd [[normal n]] end,
          ["ff"] = function() vim.cmd [[normal 0]] vim.cmd [[/ f]] vim.cmd [[normal n]] end,
          ["fg"] = function() vim.cmd [[normal 0]] vim.cmd [[/ g]] vim.cmd [[normal n]] end,
          ["fh"] = function() vim.cmd [[normal 0]] vim.cmd [[/ h]] vim.cmd [[normal n]] end,
          ["fi"] = function() vim.cmd [[normal 0]] vim.cmd [[/ i]] vim.cmd [[normal n]] end,
          ["fj"] = function() vim.cmd [[normal 0]] vim.cmd [[/ j]] vim.cmd [[normal n]] end,
          ["fk"] = function() vim.cmd [[normal 0]] vim.cmd [[/ k]] vim.cmd [[normal n]] end,
          ["fl"] = function() vim.cmd [[normal 0]] vim.cmd [[/ l]] vim.cmd [[normal n]] end,
          ["fm"] = function() vim.cmd [[normal 0]] vim.cmd [[/ m]] vim.cmd [[normal n]] end,
          ["fn"] = function() vim.cmd [[normal 0]] vim.cmd [[/ n]] vim.cmd [[normal n]] end,
          ["fo"] = function() vim.cmd [[normal 0]] vim.cmd [[/ o]] vim.cmd [[normal n]] end,
          ["fp"] = function() vim.cmd [[normal 0]] vim.cmd [[/ p]] vim.cmd [[normal n]] end,
          ["fq"] = function() vim.cmd [[normal 0]] vim.cmd [[/ q]] vim.cmd [[normal n]] end,
          ["fr"] = function() vim.cmd [[normal 0]] vim.cmd [[/ r]] vim.cmd [[normal n]] end,
          ["fs"] = function() vim.cmd [[normal 0]] vim.cmd [[/ s]] vim.cmd [[normal n]] end,
          ["ft"] = function() vim.cmd [[normal 0]] vim.cmd [[/ t]] vim.cmd [[normal n]] end,
          ["fu"] = function() vim.cmd [[normal 0]] vim.cmd [[/ u]] vim.cmd [[normal n]] end,
          ["fv"] = function() vim.cmd [[normal 0]] vim.cmd [[/ v]] vim.cmd [[normal n]] end,
          ["fw"] = function() vim.cmd [[normal 0]] vim.cmd [[/ w]] vim.cmd [[normal n]] end,
          ["fx"] = function() vim.cmd [[normal 0]] vim.cmd [[/ x]] vim.cmd [[normal n]] end,
          ["fy"] = function() vim.cmd [[normal 0]] vim.cmd [[/ y]] vim.cmd [[normal n]] end,
          ["fz"] = function() vim.cmd [[normal 0]] vim.cmd [[/ z]] vim.cmd [[normal n]] end,
          ["f/"] = function() vim.cmd [[normal 0]] vim.cmd [[/\v( | )]] vim.cmd [[normal n]] end,
          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",
        },
      },
      filesystem = {
        commands = {
          getparent_closenode = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' and node:is_expanded() then
              require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
            else
              require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
            end
          end,
          open_unfocus = function(state)
            state.commands["open"](state)
            vim.cmd("Neotree reveal")
          end,
          quit_on_open = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' then
              if not node:is_expanded() then
                require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
              elseif node:has_children() then
                require 'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
              end
            else
              state.commands['open'](state)
              state.commands["close_window"](state)
              vim.cmd('normal! M')
            end
          end,
        },
        window = {
          mappings = {
            ["h"] = "getparent_closenode",
            ["H"] = "toggle_hidden",
            ["l"] = "quit_on_open",
            ["L"] = "open_unfocus",
          }
        }
      }
    }
  }
}
