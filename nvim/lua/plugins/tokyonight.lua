return {
  "folke/tokyonight.nvim",
  opts = {
    style = "moon",
    transparent = true,
    on_highlights = function(hl)
      hl.Normal = { bg = "NONE" }
      hl.NormalFloat = { bg = "NONE" }
      hl.FloatBorder = { bg = "NONE" }
      hl.SignColumn = { bg = "NONE" }
      hl.EndOfBuffer = { bg = "NONE" }
    end,
  },
}
