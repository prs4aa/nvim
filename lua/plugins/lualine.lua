return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local Util = require("lazyvim.util")
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			vim.o.laststatus = vim.g.lualine_laststatus

			local colors = {
				bg = "#0d0d0d",
				fg = "#d3c6aa",
				yellow = "#dbbc7f",
				cyan = "#7fbbb3",
				darkblue = "#3a566a",
				green = "#a7c080",
				orange = "#e69875",
				violet = "#d699b6",
				magenta = "#d699b6",
				blue = "#7fbbb3",
				red = "#e67e80",
			}

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			return {
				options = {
					theme = {
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
					component_separators = "",
					section_separators = "",
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {
						{
							function()
								return ""
							end,
							color = { fg = colors.blue },
							padding = { left = 0, right = 1 },
						},
						{
							function()
								return "󰅶"
							end,
							color = function()
								local mode_color = {
									n = colors.red,
									i = colors.green,
									v = colors.blue,
									[" "] = colors.blue,
									V = colors.blue,
									c = colors.magenta,
									no = colors.red,
									s = colors.orange,
									S = colors.orange,
									["_"] = colors.orange,
									ic = colors.yellow,
									R = colors.violet,
									Rv = colors.violet,
									cv = colors.red,
									ce = colors.red,
									r = colors.cyan,
									rm = colors.cyan,
									["r?"] = colors.cyan,
									["!"] = colors.red,
									t = colors.red,
								}
								return { fg = mode_color[vim.fn.mode()] }
							end,
							padding = { right = 1 },
						},
						{
							"filesize",
							cond = conditions.buffer_not_empty,
						},
						{
							Util.lualine.pretty_path(),
							cond = conditions.buffer_not_empty,
							color = { fg = colors.magenta, gui = "bold" },
						},
						{ "location" },
						{ "progress", color = { fg = colors.fg, gui = "bold" } },
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " " },
							diagnostics_color = {
								color_error = { fg = colors.red },
								color_warn = { fg = colors.yellow },
								color_info = { fg = colors.cyan },
							},
						},
						{
							function()
								return "%="
							end,
						},
					},
					lualine_x = {
						{
							"branch",
							icon = "",
							color = { fg = colors.violet, gui = "bold" },
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							diff_color = {
								added = { fg = colors.green },
								modified = { fg = colors.orange },
								removed = { fg = colors.red },
							},
							cond = conditions.hide_in_width,
						},
						{
							function()
								return " " .. os.date("%R")
							end,
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
				extensions = { "lazy" },
			}
		end,
	},
}
