local servers = {
	html = {},
	cssls = {},
	lua_ls = {},
	luau_ls = {},
	bashls = {},
	rust_analyzer = {},
	yamlls = {},
	texlab = {},
	tinymist = {},
	jsonls = {},
	tombi = {},
	taplo = {},
	terraform_lsp = {},
	tufu_ls = {},
	nixd = {},
	nil_ls = {},
	pyright = {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					typeCheckingMode = "basic",
				},
			},
		},
	},
}

-- 1. Standard loop for all regular languages (using the new native configuration)
for name, opts in pairs(servers) do
	vim.lsp.config(name, opts)
	vim.lsp.enable(name)
end
