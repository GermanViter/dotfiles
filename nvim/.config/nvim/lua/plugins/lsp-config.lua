return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",       -- Lua
          "pyright",      -- Python
          "ts_ls",        -- JavaScript/TypeScript
          "jdtls",        -- Java
          "rust_analyzer", -- Rust
          "clangd",       -- C/C++
          "omnisharp",    -- C#
          "marksman",     -- Markdown
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.ts_ls.setup({})
      -- Use LspAttach autocmd to set up keymaps globally
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
          vim.keymap.set("n", "<leader>g", vim.lsp.buf.definition, {})
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
      })

      -- Servers to enable (using the new Neovim 0.11+ API)
      local servers = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "jdtls",
        "rust_analyzer",
        "clangd",
        "omnisharp",
        "marksman",
      }

      -- Optional: Override default config for specific servers
      -- For example, to remove "Global vim" warnings in Lua files
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- Enable the servers
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
}
