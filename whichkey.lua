-------------------------------------------------------------------------------------------------------------
---------------------------------- Useful Shortcuts and Dealing with Erros ----------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, which_key = pcall(require, "which-key")

if not status_ok then
  return
end

-------------------------------------------------------------------------------------------------------------
----------------------------------------- General Which Key Setting -----------------------------------------
-------------------------------------------------------------------------------------------------------------

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    ["<leader>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "center", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = false, -- show help message on the command line when the popup is visible
  -- triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local n_opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local v_opts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local m_opts = {
  mode = "n", -- NORMAL mode
  prefix = "m",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}


-------------------------------------------------------------------------------------------------------------
---------------------------------------------- Helper Functions ---------------------------------------------
-------------------------------------------------------------------------------------------------------------

function fibonacci_split()
  -- Splits horizontally if height is bigger than width and vertically otherwise

  -- Get Ratio between total number of columns and lines
  -- Should be about the same as "vim.go.columns / vim.go.lines"
  -- However, it changes when terminal is not full screen, so fixed 4.5 is used instead
  local ratio = 4.5

  -- norm width  = window width          * proportion of resolution (16, if 16:9)
  local nwidth   = vim.fn.winwidth("%")  * 16

  -- norm height = window height         * ratio for normalising aspect ratio * proportion of resolution (9, if 16:9)
  local nheight  = vim.fn.winheight("%") * ratio                              * 9

  if nwidth > nheight then
    vim.cmd("vsp")
  else
    vim.cmd("sp")
  end
end


function toggle_comment_line_or_block()
  if vim.api.nvim_get_mode()['mode'] == "n" then
    require("Comment.api").toggle_current_linewise()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",true,false,true), 'm', true)
  end
end


-------------------------------------------------------------------------------------------------------------
------------------------------------------- Actual Menu Structure -------------------------------------------
-------------------------------------------------------------------------------------------------------------

local mappings = {

  ["<tab>"] = { "<c-w><c-p>", "Previous Pane" },

  f = {
    name = "File/Find",
    s = { ":w<CR>", "Save File" },
    f = { "<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>", "Find within Buffers"},
    F = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Find File"},
    g = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", "Find within Files (Grep)"},
    b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Find Buffers"},
    w = { "<cmd>lua require('telescope.builtin').grep_string(require('telescope.themes').get_cursor())<CR>", "Find Word within Files"},
    t = { "<cmd>TodoTelescope<CR>", "List TODOs"},
  },

  b = {
    name = "Buffer",
    ["<tab>"] = { ":b#<CR>", "Previous Buffer" },
  },

  w = {
    name = "Window",
    s = {
        name = "Split",
        s = {"<cmd>lua fibonacci_split()<CR>", "Fibonncci" },
        h = { ":sp<CR>", "Horizontal" },
        v = { ":vsp<CR>", "Vertical" },
    },
    j = { "<c-w><c-j>", "Focus Down" },
    k = { "<c-w><c-k>", "Focus Up" },
    h = { "<c-w><c-h>", "Focus Left" },
    l = { "<c-w><c-l>", "Focus Right" },
    J = { "<c-w>J", "Move Down" },
    K = { "<c-w>K", "Move Up" },
    H = { "<c-w>H", "Move Left" },
    L = { "<c-w>L", "Move Right" },
    t = { ":Neotree toggle<CR>", "Toggle File Tree" },
    T = { ":Neotree focus<CR>", "Focus File Tree" },
  },

  t = {
    name = "Terminal",
    t = { "<cmd>lua _horizontal_term()<CR>", "Toggle Terminal" },
    T = { "<cmd>lua _horizontal_term();_horizontal_term()<CR>", "Focus Terminal" },
    h = { "<cmd>lua _htop_term()<CR>", "htop" },
    s = { ":ToggleTermSendCurrentLine 1<CR>", "Send Line" },
    S = { ":ToggleTermSendVisualLines 1<CR>", "Send Selected Lines" },
    v = { ":ToggleTermSendVisualSelection 1<CR>", "Send Selection" },
  },

  j = {
    name = "Jump",
    j = { "<cmd>HopPatternMW<CR>", "Jump Pattern"},
    k = { "<cmd>HopChar2MW<CR>", "Jump 2 Chars"},
    h = { "<cmd>HopChar1MW<CR>", "Jump 1 Char"},
    l = { "<cmd>HopLineMW<CR>", "Jump to Line"},
    -- d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Jump to Definition"},
    d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", "Jump to Definition"},
    D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Jump to Declaration"},
  },

  c = {
    name = "Coding",
    H = {"<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show Signature Help"},
    h = {"<cmd>lua vim.lsp.buf.hover()<CR>", "Show Hover Help"},
    -- r = {"<cmd>lua vim.lsp.buf.references()<CR>", "Show List of References"},
    r = {"<cmd>lua require('telescope.builtin').lsp_references()<CR>", "Show List of References"},
    R = {"<cmd>lua vim.lsp.buf.rename()<CR>", "Refactor Rename in Buffer"},
    f = {"<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Code"},
    w = {"<cmd>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('a<M-e>',true,false,true), 't', true)<CR>", "Fast Wrap (<M-e> in Insert)"},  -- TODO get this to work
    c = {"<cmd>lua toggle_comment_line_or_block()<CR>", "Toggle Comments"},
    d = {
      name = "Diagnostics",
      d = {"<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = 'rounded' })<CR>", "Show Current Diagnostic"},
      n = {"<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", "Go to Next Diagnostic"},
      p = {"<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", "Go to Proveious Diagnostic"},
      l = {"<cmd>lua vim.diagnostic.setloclist()<CR>", "Show Diagnostics List"},
    },
  },

  s = {
    name = "Sessions",
    s = {"<cmd>Telescope persisted<CR>", "Search Sessions"},
    S = {"<cmd>SessionSave<CR>", "Save Session"},
    r = {"<cmd>SessionLoad<CR>", "Restore Session in Current Path"},
    l = {"<cmd>SessionLoadLast<CR>", "Restore Last Session"},
    d = {"<cmd>SessionDelete<CR>", "Delete Current Session"},
  },

  q = {
    name = "Quit",
    q = { ":q<CR>", "Quit Window" },
    Q = { ":qa<CR>", "Quit Vim" },
    w = { ":qw<CR>", "Quit Window and Save" },
    W = { ":wqall<CR>", "Quit Vim and Save All" },
    x = { ":q!<CR>", "Quit Window Without Saving" },
    X = { ":qa!<CR>", "Quit Vim Without Saving" },
  },
}


which_key.setup(setup)
which_key.register(mappings, n_opts)
which_key.register(mappings, v_opts)
