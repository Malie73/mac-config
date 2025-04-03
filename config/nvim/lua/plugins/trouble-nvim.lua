local diagnostic_signs = require("util.icons").diagnostic_signs
local maplazykey = require("util.keymapper").maplazykey

return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		signs = {
			-- icons / text used for a diagnostic
			error = diagnostic_signs.Error,
			warning = diagnostic_signs.Warn,
			hint = diagnostic_signs.Hint,
			information = diagnostic_signs.Info,
			other = diagnostic_signs.Info,
		},
	},
	lazy = false,
	keys = {
		maplazykey("<leader>xx", function()
			require("trouble").toggle()
		end, "Toggle Trouble"), -- Öffnet/schließt die Trouble-Ansicht (letzter Zustand)
		maplazykey("<leader>xw", function()
			require("trouble").toggle("diagnostics")
		end, "Show Workspace Diagnostics"), -- Zeigt alle Diagnosen im Workspace
		maplazykey("<leader>xd", function()
			require("trouble").toggle("diagnostics", { filter = { buf = 0 } })
		end, "Show Document Diagnostics"), -- Zeigt Diagnosen des aktuellen Dokuments
		maplazykey("<leader>xq", function()
			require("trouble").toggle("quickfix")
		end, "Toggle Quickfix List"), -- Öffnet/schließt die Quickfix-Liste in Trouble
		maplazykey("<leader>xl", function()
			require("trouble").toggle("loclist")
		end, "Toggle Location List"), -- Öffnet/schließt die Location List in Trouble
		maplazykey("gR", function()
			require("trouble").toggle("lsp_references")
		end, "Toggle LSP References"), -- Zeigt Referenzen zur aktuellen Position via LSP
	},
}
