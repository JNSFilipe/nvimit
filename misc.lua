-------------------------------------------------------------------------------------------------------------
---------------------------------------------- Plugins Loading ----------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, bufferline = pcall(require, "impatient")
if not status_ok then
  return
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------- Sessions Management --------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local status_ok, session = pcall(require, "persisted")
if not status_ok then
  return
end
telescope.load_extension("persisted")

session.setup({
  autosave = false,
  autoload = false,
  before_save = function()
    -- pcall(vim.cmd, "bw minimap") -- Use if minimap.nvim is active
  end,
  after_save = function()
    print("Session was saved!")
  end,
  telescope = {
    before_source = function()
      -- Close all open buffers
      -- Thanks to https://github.com/avently
      vim.api.nvim_input("<ESC>:%bd<CR>")
    end,
    after_source = function(session)
      print("Loaded session " .. session.name)
    end,
  },
})


-------------------------------------------------------------------------------------------------------------
------------------------------------------------ Paste Lists ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, neoclip = pcall(require, "neoclip")
if not status_ok then
  return
end
telescope.load_extension("neoclip")

neoclip.setup({
  enable_persistent_history = true,
  keys = {
    telescope = {
      i = {
        select = "<c-h>",
        paste = {"<c-p>", "<c-l>", "<CR>"},
        paste_behind = "<c-o>",
        replay = "<c-q>",  -- replay a macro
        delete = "<c-d>",  -- delete an entry
        custom = {},
      },
      n = {
        select = "h",
        paste = {"p", "l", "<CR>"},
        paste_behind = "P",
        replay = "q",
        delete = "d",
        custom = {},
      },
    },
  },
})


-------------------------------------------------------------------------------------------------------------
----------------------------------------------- Spell Checker -----------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, spellchecker = pcall(require, "spellsitter")
if not status_ok then
  return
end

spellchecker.setup {
  enable = {"latex", "bibtex", "bib", "tex", "text", "txt", "org", "markdown"},
  debug = false
}


-------------------------------------------------------------------------------------------------------------
-------------------------------------------------- R E P L --------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, iron = pcall(require, "iron.core")
if not status_ok then
  return
end

local status_ok, iview = pcall(require, "iron.view")
if not status_ok then
  return
end



iron.setup {
  config = {
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    repl_open_cmd = iview.right("25%"),
    -- how the REPL window will be opened, the default is opening
    -- a float window of height 40 at the bottom.
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  }
}

-------------------------------------------------------------------------------------------------------------
------------------------------------------------- Debugging -------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
  return
end

dapui.setup()

-- Conifigure Python 
-- NOTE: Requires debugpy installation
dap.adapters.python = {
  type = 'executable';
  command = 'python3';
  args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return 'python3'
      end
    end;
  },
}


-------------------------------------------------------------------------------------------------------------
-------------------------------------------- Projects Management --------------------------------------------
-------------------------------------------------------------------------------------------------------------

local status_ok, projects = pcall(require, "project_nvim")
if not status_ok then
  return
end

projects.setup {
  -- Manual mode doesn't automatically change your root directory, so you have
  -- the option to manually do so using `:ProjectRoot` command.
  manual_mode = false,

  -- Methods of detecting the root directory. **"lsp"** uses the native neovim
  -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
  -- order matters: if one is not detected, the other is used as fallback. You
  -- can also delete or rearangne the detection methods.
  detection_methods = { "lsp", "pattern" },

  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

  -- Table of lsp clients to ignore by name
  -- eg: { "efm", ... }
  ignore_lsp = {},

  -- Don't calculate root dir on specific directories
  -- Ex: { "~/.cargo/*", ... }
  exclude_dirs = {},

  -- Show hidden files in telescope
  show_hidden = false,

  -- When set to false, you will get a message when project.nvim changes your
  -- directory.
  silent_chdir = true,

  -- Path where project.nvim will store the project history for use in
  -- telescope
  datapath = vim.fn.stdpath("data"),
}

require("telescope").load_extension("projects")

