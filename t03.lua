local path_a = ''
local path_b = ''

path_a =
[[/Users/lgeralds/Projects/t/ruby 3.2/r02/code 2/rails7/depot_a]]
path_b =
[[/Users/lgeralds/Projects/t/ruby 3.2/r02/code 2/rails7/depot_f]]

local is_str_ok = function(str)
	return (string.len(string.gsub(str, '%s+', '')) > 0)
end

local fetch_path = function(label, path)
	local edit = not is_str_ok(path)

	vim.ui.select({ 'ACCEPT', 'EDIT' }, {
		prompt = label .. ', accept or edit? ' .. path,
		format_item = function(item)
			return '' .. item
		end,
	}, function(choice)
		edit = (choice == 'EDIT')
		-- print('EDIT: ', edit)
	end)

	if not edit then
		return path
	end

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

local brak = '  DONE\n'

local e = fetch_path('Empty Path', '')
print(brak)
local a = fetch_path('Path A', path_a)
print(brak)
local b = fetch_path('Path B', path_b)

print('E: ' .. e, is_str_ok(e))
print('A: ' .. a, is_str_ok(a))
print('B: ' .. b, is_str_ok(b))

if is_str_ok(a) and is_str_ok(b) then
	print('DOING IT!!')
end
