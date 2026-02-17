return {
	"saghen/blink.cmp",
	version = "*",
	opts_extend = {
		"sources.completion.enabled_providers",
		"sources.compat",
		"sources.default",
	},
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"saghen/blink.compat",
			optional = true,
			opts = {},
			version = "*",
		},
	},
	event = { "InsertEnter", "CmdlineEnter" },

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		snippets = {
			expand = function(snippet, _)
				return LazyVim.cmp.expand(snippet)
			end,
		},

		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},

		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = false,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = false,
			},
		},

		sources = {
			compat = {},
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},

		cmdline = {
			enabled = true,
			keymap = {
				preset = "cmdline",
				["<Right>"] = {},
				["<Left>"] = {},
			},
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},
				ghost_text = { enabled = true },
			},
		},

		keymap = {
			preset = "super-tab",
		},
	},

	---@param opts blink.cmp.Config | { sources: { compat: string[] } }
	config = function(_, opts)
		-- setup compat sources
		local enabled = opts.sources.default
		for _, source in ipairs(opts.sources.compat or {}) do
			opts.sources.providers[source] = vim.tbl_deep_extend(
				"force",
				{ name = source, module = "blink.compat.source" },
				opts.sources.providers[source] or {}
			)
			if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
				table.insert(enabled, source)
			end
		end

		-- Unset custom prop to pass blink.cmp validation
		opts.sources.compat = nil

		-- check if we need to override symbol kinds
		for _, provider in pairs(opts.sources.providers or {}) do
			---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
			if provider.kind then
				local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
				local kind_idx = #CompletionItemKind + 1

				CompletionItemKind[kind_idx] = provider.kind
				---@diagnostic disable-next-line: no-unknown
				CompletionItemKind[provider.kind] = kind_idx

				---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
				local transform_items = provider.transform_items
				---@param ctx blink.cmp.Context
				---@param items blink.cmp.CompletionItem[]
				provider.transform_items = function(ctx, items)
					items = transform_items and transform_items(ctx, items) or items
					for _, item in ipairs(items) do
						item.kind = kind_idx or item.kind
						item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
					end
					return items
				end

				-- Unset custom prop to pass blink.cmp validation
				provider.kind = nil
			end
		end

		require("blink.cmp").setup(opts)
	end,
}
