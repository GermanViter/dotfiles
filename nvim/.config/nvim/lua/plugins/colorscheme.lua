return {
  {
    "catppuccin/nvim",
    name = "catppuccin",

    lazy = false, -- 🔴 THIS IS THE KEY LINE
    priority = 1000, -- load before all other plugins

    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      float = {
        transparent = true,
        solid = true,
      },
    },

    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
