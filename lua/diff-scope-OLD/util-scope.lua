local util = {}


function util.has_item(tab, val)
  -- print('HV: ' .. vim.inspect(tab))
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

function util.is_file(path)
  if vim.fn.getftype(path) == 'file' then
    return true
  end

  return false
end

function util.is_dir(path)
  if vim.fn.getftype(path) == 'dir' then
    return true
  end

  return false
end

function util.concat_tables(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end

  return t1
end

function util.testDepth(path)
  local pathseparator = package.config:sub(1, 1);
  local _, count = string.gsub(path, pathseparator, "")

  return count
end

return util
