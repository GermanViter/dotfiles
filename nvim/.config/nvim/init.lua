vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.wo.relativenumber = true
vim.opt.shortmess:append("atIc")
vim.opt.cmdheight = 2
vim.opt.report = 9999

-- Suppress warnings, only show errors
vim.notify = function(msg, log_level, _)
  if log_level == vim.log.levels.ERROR then
    vim.api.nvim_echo({{tostring(msg), "ErrorMsg"}}, true, {})
  end
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import all plugins from lua/plugins/ directory
    { import = "plugins" },
  },
  install = { colorscheme = { "catppuccin-mocha" } },
  checker = { enabled = true },
})
