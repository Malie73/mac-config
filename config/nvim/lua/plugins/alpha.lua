return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    -- ASCII-Sonnenaufgang
    dashboard.section.header.val = {
      "         \\   |   /        ",
      "           .-'-._         ",
      "        -- (  ☀️  ) --     ",
      "           `-.-'          ",
      "         /   |   \\        ",
      "                         ",
      "   ~ welcome back, Marko ~",
    }

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button("f", "🔍  Find file", ":FzfLua files<CR>"),
      dashboard.button("r", "🕘  Recent", ":FzfLua oldfiles<CR>"),
      dashboard.button("s", "💾  Last Session", ":SessionRestore<CR>"),
      dashboard.button("c", "⚙️  Config", ":e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("q", "🚪  Quit", ":qa<CR>"),
    }

    -- Dynamischer Footer
    local function get_footer()
      local datetime = os.date("📅 %A, %d %B %Y  🕒 %H:%M:%S")
      local uptime = string.format("⏱ Uptime: %.2f hours", vim.loop.uptime() / 3600)

      return {
        "",
        datetime,
        uptime,
        "\"Each sunrise brings a chance to begin again.\" 🌅",
      }
    end

    dashboard.section.footer.val = get_footer()

    -- Option: Neuladen bei jedem Start (z. B. Uhrzeit immer aktuell)
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        dashboard.section.footer.val = get_footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    require("alpha").setup(dashboard.config)
  end,
}
