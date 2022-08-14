-- lua/custom/mappings 
local M = {}

--M.disabled = {
--  i = {
--   ["<C-m"] = "",
--  }
--}

--M.copilot = {
--  i = {
--    ["<F2>"] = {'copilot#Accept("<CR>")', opts = { expr = true }},
--  }
--}
M.general = {
	n = {
		["<leader>q"] = { ":q! <CR>", "  exit nvchad" },
		["<leader>te"] = { ":Telescope <CR>", "  open telescope options" },
		["<leader>mt"] = {
			function()
--        require("nvterm.terminal").send("if [[ $(tmux display-message -p '#S') == 'nvimterm' ]]; then ; else TMUX= tmux new-session -A -D -s nvimterm; fi", "float")
        require("nvterm.terminal").send("TMUX= tmux new-session -A -D -s $PWD/fterm", "float")
        require("nvterm.terminal").send("TMUX= tmux new-session -A -D -s $PWD/hterm", "horizontal")
        require("nvterm.terminal").send("TMUX= tmux new-session -A -D -s $PWD/vterm", "vertical")

        require("nvterm.terminal").send("if [[ $(tmux display-message -p '#S') == $PWD/fterm ]]; then tmux set prefix C-a ; else ; fi", "float")
        require("nvterm.terminal").send("if [[ $(tmux display-message -p '#S') == $PWD/hterm ]]; then tmux set prefix C-a; else ; fi", "horizontal")
        require("nvterm.terminal").send("if [[ $(tmux display-message -p '#S') == $PWD/vterm ]]; then tmux set prefix C-a; else ; fi", "vertical")
			end,
			"   Toggle binding to tmux session",
		},
	},
}

M.nvimtree = {
  n = {
    ["<leader>e"] = {"<cmd> NvimTreeToggle <CR>", "   toggle nvimtree"}
  }
}

return M
