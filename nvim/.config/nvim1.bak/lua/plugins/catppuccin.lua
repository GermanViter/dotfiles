return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		transparent_background = true,
		integrations = {
			treesitter = true,
			mason = true,
			neotree = true,
			noice = true,
			notify = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
				inlay_hints = {
					background = true,
				},
			},
		},
		custom_highlights = function(colors)
			return {
				NoiceCmdlinePopup = { bg = "NONE" },
				NoiceCmdlinePopupBorder = { bg = "NONE" },
				NoiceCmdlinePopupTitle = { bg = "NONE" },
				NoiceCmdlineIcon = { bg = "NONE" },
				NoicePopupmenu = { bg = "NONE" },
				NoicePopupmenuBorder = { bg = "NONE" },
				NoicePopupmenuSelected = { bg = colors.surface0 },
				NotifyBackground = { bg = "NONE" },
				AlphaHeader = { fg = colors.red, bg = colors.mauve },
        AlphaShortcut = { fg = colors.red, bg = colors.mauve },
        AlphaHeaderLabel = { fg = colors.red, bg = colors.mauve },
			}
		end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
