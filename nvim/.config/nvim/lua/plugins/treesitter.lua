return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
      require("nvim-ts-autotag").setup()
    end,
  },
}
