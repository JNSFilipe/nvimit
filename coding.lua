-------------------------------------------------------------------------------------------------------------
------------------------------------------------ Code Completion --------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  return
end

local status_ok, snips = pcall(require, "luasnip")
if not status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

-- TODO Get icons from Themes.lua
--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup {
  snippet = {
    expand = function(args)
      snips.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-h>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    -- ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-l>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snips.expandable() then
        snips.expand()
      elseif snips.expand_or_jumpable() then
        snips.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snips.jumpable(-1) then
        snips.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
}


-------------------------------------------------------------------------------------------------------------
------------------------------------------------------ LSP --------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

lsp_installer.setup({
  ensure_installed = {"sumneko_lua", "clangd", "cmake", "ltex", "marksman", "rust_analyzer", "taplo", "pyright"},
  automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
  ui = {
    -- TODO Get Icons form Themes.lua
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

-- TODO Get icons from Themes.lua
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(config)

local function lsp_highlight_document(client)
  -- This function highlights instances of the same word and scope of contexts
  --
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_highlight_document(client)

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- sumneko_lua
require('lspconfig')['sumneko_lua'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- clangd
require('lspconfig')['clangd'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- cmake
require('lspconfig')['cmake'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- ltex
require('lspconfig')['ltex'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- marksman
require('lspconfig')['marksman'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- rust_analyzer
require('lspconfig')['rust_analyzer'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {}
  }
}

-- taplo
require('lspconfig')['taplo'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- pyright"},
require('lspconfig')['pyright'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}


-------------------------------------------------------------------------------------------------------------
-------------------------------------------- Better Syntax Highlight ----------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, tsconfigs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

tsconfigs.setup {
  ensure_installed = { "c", "cpp", "lua", "rust", "latex", "markdown", "python" },
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = false,  -- Required by spellsitter
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  autopairs = {
		enable = true,
	},
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  indent = { enable = true, disable = { "yaml" } },
}

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------- Other Stuff ----------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Atomatically close brackets, parenthesis, etc
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end

npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  return
end
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })


-- Dealing with comments
local status_ok, comment = pcall(require, "nvim_comment")
if not status_ok then
  return
end

comment.setup {
  -- should comment out empty or whitespace only lines
  comment_empty = false,
}


-- Support for todo comments
local status_ok, todo = pcall(require, "todo-comments")
if not status_ok then
  return
end

todo.setup()

