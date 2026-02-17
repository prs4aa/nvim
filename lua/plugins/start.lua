return {
	"folke/snacks.nvim",
	opts = {
		dashboard = {
			enabled = false,
			preset = {
				header = [[
<leader><leader> :telescope
 ]],
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				},
			},
		},
	},
}
