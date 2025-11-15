return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"

    -- Customize the statusline
    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      -- Left side: mode, file info
      status.component.mode {
        mode_text = {
          padding = { left = 1, right = 1 },
        },
      },
      status.component.git_branch(),
      status.component.git_diff(),
      status.component.file_info(),

      -- Middle: fill
      status.component.fill(),

      -- Right side: minimal info
      status.component.cmd_info(),
      -- status.component.nav(), -- line/col numbers
      -- Remove these to save space:
      -- status.component.lsp(),
      -- status.component.diagnostics(),
      -- status.component.treesitter(),
    }

    return opts
  end,
}
