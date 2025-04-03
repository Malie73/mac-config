-- ~/.config/nvim/colors/coolnight.lua

-- Setze den Namen und leere vorherige Highlights
vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "coolnight"

local set = vim.api.nvim_set_hl

-- Grundfarben mit Transparenz
set(0, "Normal", { fg = "#CBE0F0", bg = "none" })
set(0, "NormalFloat", { bg = "none" })
set(0, "Cursor", { fg = "#011423", bg = "#47FF9C" })
set(0, "CursorLine", { bg = "#033259" })
set(0, "Visual", { bg = "#033259" })

-- Syntaxfarben
set(0, "Comment", { fg = "#214969", italic = true })
set(0, "Constant", { fg = "#FFE073" })
set(0, "Identifier", { fg = "#0FC5ED" })
set(0, "Statement", { fg = "#E52E2E" })
set(0, "PreProc", { fg = "#44FFB1" })
set(0, "Type", { fg = "#A277FF" })
set(0, "Special", { fg = "#24EAF7" })

-- UI
set(0, "LineNr", { fg = "#214969", bg = "none" })
set(0, "SignColumn", { bg = "none" })
set(0, "StatusLine", { fg = "#011423", bg = "none" })
set(0, "Pmenu", { fg = "#CBE0F0", bg = "none" })
set(0, "FloatBorder", { fg = "#24EAF7", bg = "none" })

-- Extras (für Plugins etc.)
set(0, "TelescopeNormal", { bg = "none" })
set(0, "TelescopeBorder", { bg = "none", fg = "#24EAF7" })
set(0, "WhichKeyFloat", { bg = "none" })
set(0, "NormalNC", { bg = "none" })

-- Treesitter Highlights
set(0, "@comment", { fg = "#214969", italic = true })
set(0, "@string", { fg = "#FFE073" })
set(0, "@string.regex", { fg = "#44FFB1" })
set(0, "@character", { fg = "#FFE073" })
set(0, "@number", { fg = "#FFB454" })
set(0, "@boolean", { fg = "#E52E2E" })
set(0, "@constant", { fg = "#FFB454" })
set(0, "@constant.builtin", { fg = "#A277FF" })
set(0, "@function", { fg = "#0FC5ED" })
set(0, "@function.builtin", { fg = "#24EAF7" })
set(0, "@function.call", { fg = "#0FC5ED" })
set(0, "@method", { fg = "#0FC5ED" })
set(0, "@method.call", { fg = "#0FC5ED" })
set(0, "@parameter", { fg = "#CBE0F0" })
set(0, "@field", { fg = "#44FFB1" })
set(0, "@property", { fg = "#24EAF7" })
set(0, "@variable", { fg = "#CBE0F0" })
set(0, "@variable.builtin", { fg = "#A277FF" })
set(0, "@keyword", { fg = "#E52E2E" })
set(0, "@keyword.function", { fg = "#E52E2E" })
set(0, "@keyword.return", { fg = "#E52E2E" })
set(0, "@type", { fg = "#A277FF" })
set(0, "@type.builtin", { fg = "#A277FF" })
set(0, "@namespace", { fg = "#24EAF7" })
set(0, "@module", { fg = "#24EAF7" })
set(0, "@operator", { fg = "#CBE0F0" })
set(0, "@punctuation", { fg = "#CBE0F0" })
set(0, "@punctuation.delimiter", { fg = "#CBE0F0" })
set(0, "@punctuation.bracket", { fg = "#214969" })

-- Optional: Textobjekte (Markdown, docs, etc.)
set(0, "@text.title", { fg = "#A277FF", bold = true })
set(0, "@text.strong", { fg = "#FFE073", bold = true })
set(0, "@text.emphasis", { fg = "#FFE073", italic = true })
set(0, "@text.underline", { underline = true })
set(0, "@text.uri", { fg = "#24EAF7", underline = true })
