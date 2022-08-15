-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
  theme = "vscode_dark",
}

M.plugins = {
  user = {
    ["goolord/alpha-nvim"] = {
      disable = false,
    },
    ['folke/which-key.nvim'] = { 
      disable = false  
    },
    ["neovim/nvim-lspconfig"] = {
      config = function()
        require "plugins.configs.lspconfig"
        require "custom.plugins.lspconfig"
      end,
    },
    ["github/copilot.vim"] = {},
  },
  override = {
    ["NvChad/nvterm"] = {
      terminals = {
        type_opts = {
          float = {
            row = 0,
            col = 0,
            width = 1,
            height = 1,
          },
        },
      },
    },
    ["williamboman/mason.nvim"] = {
      ensure_installed = {
        "omnisharp",
      },
    },
  },
}

M.mappings = require "custom.mappings"

return M
