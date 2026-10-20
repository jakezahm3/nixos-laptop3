local options = {
	formatters_by_ft = {
		luau = { "stylua" },
		html = { "prettierd" },
		nix = { "alejandra" },
		json = { "jq" },
		yaml = { "prettierd" },
		javascript = { "prettierd" },
		rust = { "rustfmt" },
		python = { "black" },
		typescript = { "prettierd" },
		sh = { "shfmt" },
		java = { "google-java-format" },
		markdown = { "prettierd" },
		fish = { "fish_indent" },
		latex = { "tex-fmt" },
		typst = { "prettypst" },
		terraform = { "terraform_fmt" },
		opentofu = { "tofu_fmt" },
		lua = { "stylua" },
		css = { "prettier" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return options
