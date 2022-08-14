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
  },
}

--M.options = {
--  user = function()
--     require "custom.myoptions"
--  end,
--}

M.mappings = require "custom.mappings"
--M.mappings.copilot = {
--    i = {
--     ["<F2>"] = {'copilot#Accept("<CR>")', opts = { expr = true } },
--    },
--}

return M
