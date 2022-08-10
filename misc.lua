-------------------------------------------------------------------------------------------------------------
------------------------------------------------ Plugin Loading ------------------------------------------------
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


