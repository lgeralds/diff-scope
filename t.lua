-- run using:
-- luafile %

package.path = package.path .. ";" .. os.getenv('HOME') .. '/.config/lvim/projects/diff-scope/?.lua'
DTHM = os.getenv('HOME') .. '/.config/lvim/projects/diff-scope/'

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local entry_display = require 'telescope.pickers.entry_display'
-- local previewers = require 'telescope.previewers'
local utils = require "telescope.utils"

-- print(package.path)
-- local diff = dofile(dthm .. 'scope-diff.lua')
-- print(vim.inspect(diff))
-- local u = dofile(dthm .. 'scope-util.lua')
-- print(vim.inspect(u))
local diff = dofile(DTHM .. 'scope-list.lua')
-- print(vim.inspect(diff))

local ignore = { '.DS_Store' }
-- local list = {}


local this_dir =
-- [[/Users/lgeralds/Projects/t]]
[[/Users/lgeralds/Projects/t/ruby 3.2/r02/code 2/rails7/depot_a]]
local that_dir =
[[/Users/lgeralds/Projects/t/ruby 3.2/r02/code 2/rails7/depot_f]]
-- local this_file =
-- [[/Users/lgeralds/Projects/t/ruby\ 3.2/r02/code\ 2/rails7/depot_a/app/controllers/products_controller.rb]]
-- local that_file =
-- [[/Users/lgeralds/Projects/t/ruby\ 3.2/r02/code\ 2/rails7/depot_b/app/controllers/products_controller.rb]]

local list = diff.build_diff_list(this_dir, that_dir, ignore)
-- print(vim.inspect(list))


local diffs = function(opts)
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
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection[1]))
        actions.select_default:replace(
          function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            print(vim.inspect(selection))
            -- print(vim.inspect(selection['index']))
            -- print(vim.inspect(selection[1]))
            -- print(vim.inspect(selection[2]))
            -- print(vim.inspect(action_state.get_current_line()))
            -- vim.api.nvim_put({ selection.path }, "", false, true)
          end
        )
        return true
      end,
      previewer = conf.qflist_previewer(opts),
    }
  ):find()
end

-- to execute the function
diffs({ layout_config = { prompt_position = 'bottom' } })
-- colors(require("telescope.themes").get_dropdown {
--   -- layout_config = { prompt_position = 'bottom', }
--   layout_config = { prompt_position = 'top', }
-- })
