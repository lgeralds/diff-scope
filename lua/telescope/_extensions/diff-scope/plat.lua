local path_separator = package.config:sub(1, 1);
local M = {}

function M.path_concat(left, right)
  local l = left
  local r = right
  if left[#left] == path_separator then
    l = left:sub(1, #left - 1)
  end
  if right[#right] == path_separator then
    r = right:sub(2)
  end

  return l .. path_separator .. r
end

function M.path_parent(path)
  if not path or #path == "" then
    return
  end

  local temp = vim.split(path, path_separator, { trimempty = true })
  if #temp == 1 then
    return ""
  end
  local parent = table.concat(temp, path_separator, 1, #temp - 1)
  return parent
end

M.parse_arg = function(...)
  local others = select(1, ...)
  if not others then
    return { ret = false }
  end
  local mine = select(2, ...)
  if not mine then
    mine = "."
  end
  others = vim.fn.glob(others)
  mine = vim.fn.glob(mine)
  return { ret = true, mine = mine, others = others }
end

M.cmdcomplete = function(A, _, _)
  local cwd = vim.fn.getcwd()
  if #A == 0 then
    return { cwd }
  end
  if cwd == A then
    return
  end
  local paths = vim.fn.glob(A .. "*", false, true)
  if #paths == 0 then
    return
  end
  -- paths = vim.split(paths, "\n")
  local ret = {}
  local pathc = ''
  for _, path in ipairs(paths) do
    pathc = string.gsub(path, " ", "\\ ")
    if vim.fn.getftype(path) == "dir" then
      table.insert(ret, pathc)
    end
  end
  return ret
end

return M
