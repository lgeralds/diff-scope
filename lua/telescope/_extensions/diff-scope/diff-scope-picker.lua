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
local tab = require('telescope._extensions.diff-scope.diff-win')
local util = require('telescope._extensions.diff-scope.util-scope')
local DiffScope = {}
local brak = '  DONE\n'


-- return function(opts)
DiffScope.diff = function(opts)
  local list = {}
  -- print('DIFF PICKER RUNNING: ', vim.inspect(opts))

  opts.path_a = util.fetch_path('Left  Path', opts.path_a)
  print(brak)
  opts.path_b = util.fetch_path('Right Path', opts.path_b)

  if not util.is_str_ok(opts.path_b) then
    opts.path_b = opts.path_a
    opts.path_a = vim.fn.getcwd()
  end

  if not util.is_str_ok(opts.path_a) then
    opts.path_a = vim.fn.getcwd()
  end

  if not util.is_str_ok(opts.path_a) or not util.is_str_ok(opts.path_b) then
    print('Please enter at least one path')
    return
  end

  if opts.path_a == opts.path_b then
    print('Paths cannot be same.')
    return
  end

  print('Left Path: ', opts.path_a)
  print('Right Path: ', opts.path_b)

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

    local type_icon = opts.icons.file
    -- local type_color = 'TelescopeResultsOperator'
    local type_color = opts.colors.file

    if entry.type == 'dir' then
      type_icon = opts.icons.folder
      -- type_color = 'TelescopeResultsDiffUntracked'
      type_color = opts.colors.folder
    end

    -- local status_color = 'TelescopeResultsConstant'
    local status_color = opts.colors.changed
    -- local status_icon = 'ﲋ'
    local status_icon = opts.icons.changed

    if entry.status == '-' then
      -- status_color = 'TelescopeResultsDiffDelete'
      status_color = opts.colors.deleted
      status_icon = opts.icons.deleted
    end

    if entry.status == '+' then
      -- status_color = 'TelescopeResultsStruct'
      status_color = opts.colors.added
      status_icon = opts.icons.added
    end

    return displayer {
      { status_icon, status_color },
      { type_icon,   type_color },
      entry.ordinal,
    }
  end
  pickers.new(
    opts,
    {
      prompt_title = 'Diffs',
      finder = finders.new_table {
        results = list,
        entry_maker = function(entry)
          return {
            value = entry,
            display = display,
            ordinal = entry[5] .. ' ' .. entry[1],
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
            local selection = action_state.get_selected_entry()
            -- print(vim.inspect(selection))
            if selection.type == 'file' then
              actions.close(prompt_bufnr)
              tab:create_diff_view(selection.path, selection.path_b)
            else
              print('Selection is not a file.')
              print(' ')
            end
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

DiffScope.bail = function()
  tab:bail()
end

return DiffScope
