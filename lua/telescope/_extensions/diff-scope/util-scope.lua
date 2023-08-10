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

function util.test_depth(path)
  local pathseparator = package.config:sub(1, 1);
  local _, count = string.gsub(path, pathseparator, "")

  return count
end

function util.is_str_ok(str)
  if type(str) ~= 'string' then
    return false
  end
  return (string.len(string.gsub(str, '%s+', '')) > 0)
end

function util.fetch_path(label, path)
  -- local edit = not util.is_str_ok(path)

  -- vim.ui.select({ 'ACCEPT', 'EDIT' }, {
  --   prompt = label .. ', accept or edit? ' .. path,
  --   format_item = function(item)
  --     return '' .. item
  --   end,
  -- }, function(choice)
  --   edit = (choice == 'EDIT')
  --   -- print('EDIT: ', edit)
  -- end)

  -- if not edit then
  --   return path
  -- end

  vim.ui.input(
    {
      prompt = label .. ': ',
      completion = 'file',
      default = path
    },
    function(i)
      path = i
    end
  )

  return path
end

function util.copy_table(datatable, cache)
  cache = cache or {}
  local tblRes = {}
  if type(datatable) == "table" then
    if cache[datatable] then return cache[datatable] end
    for k, v in pairs(datatable) do
      tblRes[util.copy_table(k, cache)] = util.copy_table(v, cache)
    end
    cache[datatable] = tblRes
  else
    tblRes = datatable
  end
  return tblRes
end

return util
