vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup({
  transparent_background = false,
	term_colors = false,
  compile = {
		enabled = true,
		path = vim.fn.stdpath("cache") .. "/catppuccin",
	},
	dim_inactive = {
		enabled = true,
		shade = "dark",
		percentage = 0.15,
	},
  integrations = {
    gitsigns = true,
    leap = true,
    neogit = true,
    cmp = true,
    notify = true,
    telescope = true,
    gitgutter = true,
	},
})

vim.cmd [[colorscheme catppuccin]]
