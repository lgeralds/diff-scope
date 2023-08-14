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
local list = {}
local lopts = {}


DiffScope.diff = function(opts)
  -- print('DIFF PICKER RUNNING: ', vim.inspect(opts))
  if #list == 0 then
    if #lopts == 0 then
      lopts = util.copy_table(opts)
    end
    lopts.path_a = util.fetch_path('Left  Path', lopts.path_a)
    print(brak)
    lopts.path_b = util.fetch_path('Right Path', lopts.path_b)

    if not util.is_str_ok(lopts.path_b) then
      lopts.path_b = lopts.path_a
      lopts.path_a = vim.fn.getcwd()
    end

    if not util.is_str_ok(lopts.path_a) then
      lopts.path_a = vim.fn.getcwd()
    end

    if not util.is_str_ok(lopts.path_a) or not util.is_str_ok(lopts.path_b) then
      print('Please enter at least one path')
      return
    end

    if lopts.path_a == lopts.path_b then
      print('Paths cannot be same.')
      return
    end

    print('Left Path: ', lopts.path_a)
    print('Right Path: ', lopts.path_b)
  end

  list = diff.build_diff_list(
    lopts.path_a,
    lopts.path_b,
    lopts.ignore
  )

  -- opts = opts or {}
  lopts.preview_title = 'Local File'

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
    local type_color = opts.colors.file

    if entry.type == 'dir' then
      type_icon = lopts.icons.folder
      type_color = lopts.colors.folder
    end

    local status_color = lopts.colors.unchanged
    local status_icon = lopts.icons.unchanged

    -- local status_color = lopts.colors.changed
    -- local status_icon = lopts.icons.changed

    if entry.status == '-' then
      status_color = lopts.colors.deleted
      status_icon = lopts.icons.deleted
    end

    if entry.status == '+' then
      status_color = lopts.colors.added
      status_icon = lopts.icons.added
    end

    if entry.status == '~' then
      status_color = lopts.colors.changed
      status_icon = lopts.icons.changed
    end

    return displayer {
      { status_icon, status_color },
      { type_icon,   type_color },
      entry.ordinal,
    }
  end
  pickers.new(
    lopts,
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
      sorter = conf.file_sorter(lopts),
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
      previewer = conf.qflist_previewer(lopts),
    }
  ):find()
end

DiffScope.close = function()
  if #list > 0 then
    tab:close_cur_tab()
  end
end

DiffScope.close_all = function()
  if #list > 0 then
    tab:close_all_tab()
  end
end

DiffScope.bail = function()
  tab:bail()
end

DiffScope.new = function()
  print('NEW 00')
  if #list == 0 then
    print('NEW 01')
    vim.api.nvim_command('Telescope diff-scope diff')
    return
  end
  print('NEW 02')
  tab:close_all_tab()
  list = {}
  DiffScope.diff(lopts)
end

return DiffScope
