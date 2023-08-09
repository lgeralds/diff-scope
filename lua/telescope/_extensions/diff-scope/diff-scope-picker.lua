-- print('DIFF PICKER LOADING')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local entry_display = require('telescope.pickers.entry_display')
-- local previewers = require('telescope.previewers')
-- local utils = require('telescope.utils')

local diff = require('telescope._extensions.diff-scope.list-scope')
local plat = require('telescope._extensions.diff-scope.plat')
local tab = require('telescope._extensions.diff-scope.diff-win')
local DiffScope = {}

-- return function(opts)
DiffScope.diff = function(opts)
  local list = {}
  print('DIFF PICKER RUNNING: ', vim.inspect(opts))

  -- if true then
  --   return
  -- end

  -- required: input widget - two paths
  -- get one, get two, ask to edit either or submit or cancel
  --

  local d = plat.cmdcomplete({})
  print('D: ', vim.inspect(d))

  list = diff.build_diff_list(
    opts.path_a,
    opts.path_b,
    opts.ignore
  )

  opts = opts or {}
  opts.preview_title = 'Local File'

  local display = function(entry)
    local displayer = entry_display.create {
      separator = ' ',
      items = {
        { width = 1 },
        { width = 2 },
        { remaining = true },
      },
    }

    local icon = ''

    if entry.type == 'dir' then
      icon = ''
    end

    -- local path = entry.path

    -- if opts.transform_file_path then
    --   path = opts.transform_file_path(path)
    -- end
    -- if entry.type == 'dir' then
    --   return displayer {}
    -- end

    return displayer {
      entry.status,
      icon,
      entry.ordinal,
      -- utils.path_smart(entry.path), -- or path_tail
    }
  end
  pickers.new(
    opts,
    {
      prompt_title = 'Diffs',
      finder = finders.new_table {
        results = list,
        entry_maker = function(entry)
          -- opts.preview_title = entry.ordinal
          return {
            value = entry,
            display = display,
            ordinal = entry[1],
            path = entry[2],
            path_b = entry[3],
            type = entry[4],
            status = entry[5],
          }
        end
      },
      sorter = conf.file_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(
          function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            print(vim.inspect(selection))
            tab:create_diff_view(selection.path, selection.path_b)
          end
        )
        return true
      end,
      previewer = conf.qflist_previewer(opts),
    }
  ):find()
end

DiffScope.close = function()
  tab:close_cur_tab()
end

DiffScope.close_all = function()
  tab:close_all_tab()
end

return DiffScope
