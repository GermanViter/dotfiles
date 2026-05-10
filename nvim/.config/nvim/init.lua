require("config.lazy")
require("config.options")
require("config.keymaps")

-- Force .js files to be treated as javascriptreact for better highlighting
vim.filetype.add({
  extension = {
    js = "javascriptreact",
    jsx = "javascriptreact",
    ts = "typescriptreact",
    tsx = "typescriptreact",
  },
})
