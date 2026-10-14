vim.pack.add {
  -- 'https://github.com/nvim-orgmode/orgmode',
  -- 'https://github.com/chipsenkbeil/org-roam.nvim',
  -- 'https://github.com/eprislac/org-gcal-sync',
  'https://github.com/xheisenbugx/org.nvim',
}

local bhj_ics_link = os.getenv 'BHJ_ICS_LINK'

if not bhj_ics_link then vim.notify('BHJ_ICS_LINK not set', vim.log.levels.WARN) end

require('org').setup {
  org_directory = '~/org',
  agenda_files = { '~/org/**/*.org' },
  default_notes_file = '~/org/inbox.org',
  agenda = {
    window = 'current',
    save_after_edit = true,
  },
  notifications = {
    enabled = true,
    reminder_time = { 30, 15, 5 },
    single_instance = true,
  },
  mappings = {
    agenda = {
      set_tags = false,
    },
  },
  extensions = {
    roam = true,
    quickadd = true,
    ics = {
      calendars = {
        { name = 'Work', url = bhj_ics_link },
      },
    },
  },
}

-- Setup orgmode
-- require('orgmode').setup {
--   org_agenda_files = '~/org/**/*',
--   org_default_notes_file = '~/org/inbox.org',
--   org_agenda_time_grid = {
--     type = { 'weekly' },
--     times = { 900, 1015, 1230, 1330, 1600, 1800 },
--   },
--   org_agenda_use_time_grid = false,
-- }
--
-- require('org-roam').setup {
--   directory = '~/org',
-- }

-- require('org-gcal-sync').setup {
--   org_dirs = { '~/org' },
--   enable_backlinks = true,
--   auto_sync_on_save = false,
--
--   calendars = { 'glenn.louedec@bhj-soft.com' },
--   sync_reccuring_events = true,
--   conflict_resolution = 'ask',
--   show_sync_status = true,
-- }

-- Experimental LSP support
-- vim.lsp.enable 'org'
