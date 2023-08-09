-- DTHM = os.getenv('HOME') .. '/.config/lvim/projects/diff-scope/'

local diff = require('telescope._extensions.diff-scope.diff-scope')
-- local diff = require('diff-scope')
local u = require('telescope._extensions.diff-scope.util-scope')


local m = {
  added = '+',
  deleted = '-',
  changed = '~'
}

m.init = function(added, deleted, changed)
  m.added = added
  m.deleted = deleted
  m.changed = changed
end

m.build_diff_list = function(path_a, path_b, ignore)
  if u.has_item(ignore, path_a) then
    return {}
  end

  local todo = diff.diff_dir(path_a, path_b, true)

  return m.build_sub_list(
    path_a,
    path_b,
    todo,
    ignore,
    string.len(path_a) + 2,
    string.len(path_b) + 2
  )
end

m.build_sub_list = function(path_a, path_b, todo, ignore, trim_a, trim_b)
  -- print(vim.inspect(todo))
  local list = {}

  for _, item in ipairs({
    { todo.diff.add,    m.added },
    { todo.diff.delete, m.deleted },
    { todo.diff.change, m.changed }
  }) do
    -- print('ITEM: ', vim.inspect(item))
    -- print(vim.inspect(sign))
    for _, f in ipairs(item[1]) do
      -- print('F: ', vim.inspect(f))
      local path_a_f = path_a .. '/' .. f
      local path_b_f = path_b .. '/' .. f
      local typef = 'file'

      -- print('PONE_F: ', vim.inspect(pone_f))
      if u.has_item(ignore, f) then
        goto continue
      end

      if u.is_dir(path_a_f) then
        local todo_f = diff.diff_dir(path_a_f, path_b_f, true)
        u.concat_tables(
          list,
          m.build_sub_list(
            path_a_f,
            path_b_f,
            todo_f,
            ignore,
            trim_a,
            trim_b
          )
        )
        typef = 'dir'
      end

      table.insert(
        list, {
          string.sub(path_a_f, trim_a, -1),
          path_a_f,
          path_b_f,
          typef,
          item[2]
        }
      )

      ::continue::
    end
  end

  return list
end

return m
