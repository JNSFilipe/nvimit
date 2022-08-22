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

iron.setup {
  config = {
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    repl_open_cmd = require('iron.view').curry.right(65),
    -- how the REPL window will be opened, the default is opening
    -- a float window of height 40 at the bottom.
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  }
}
