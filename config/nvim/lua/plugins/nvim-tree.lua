local diagnostic_signs = require("util.icons").diagnostic_signs
return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	config = function()
		vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
		require("nvim-tree").setup({
			filters = {
				dotfiles = false,
			},
			view = {
				adaptive_size = true,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true, -- Fehler auch an Ordnern anzeigen
				show_on_open_dirs = true, -- nur aufklappen, wenn geöffnet
				icons = {
					hint = diagnostic_signs.Hint,
					info = diagnostic_signs.Info,
					warning = diagnostic_signs.Warn,
					error = diagnostic_signs.Error,
				}, -- deine eigenen Icons
			},
		})
	end,
}
