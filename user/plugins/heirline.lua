return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require("astronvim.utils.status")

      opts.statuscolumn = { -- statuscolumn
        status.component.foldcolumn(),
        status.component.signcolumn(),
        status.component.fill(),
        status.component.fill(),
        status.component.numbercolumn(),
      }

      return opts
    end,
  },
}
