-- example file i.e lua/custom/init.lua
-- load your options globals, autocmds here or anything .__.
-- you can even override default options here (core/options.lua)
--vim.g.copilot_no_tab_map = true
--vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<F2>", 'copilot#Accept("<CR>")', { expr = true, noremap = true })
