return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      prompts = {
        Rename = {
          prompt = "Please rename the variable considering the context and the code style",
          selection = function(source)
            local select = require("CopilotChat.select")
            return select.visual(source)
          end,
        }
      }
    },
    keys = {
      {
        "<leader>Pn", ":CopilotChatRename<CR>", mode = "v", desc = "Rename variable",
      },
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
    }
  },
}
