-- local openPop = assert(io.popen('/bin/ls -la', 'r'))
-- local output = openPop:read('*all')
-- openPop:close()
-- print(output) -- > Prints the output of the command.


local this_file =
[[/Users/lgeralds/Projects/t/ruby\ 3.2/r02/code\ 2/rails7/depot_a/app/controllers/products_controller.rb]]
local that_file =
[[/Users/lgeralds/Projects/t/ruby\ 3.2/r02/code\ 2/rails7/depot_b/app/controllers/products_controller.rb]]

-- local opts = [[ --ignore-all-space --ignore-trailing-space --ignore-space-change --strip-trailing-cr ]]
local opts = [[ --ignore-space-change --brief ]]
-- local opts = [[ --ignore-space-change ]]

local cmd = 'rdiff' .. opts .. this_file .. ' ' .. this_file

local openPop = assert(io.popen(cmd, 'r'))
local output = openPop:read('*all')
openPop:close()
print()
-- print(cmd)
-- print(output) -- > Prints the output of the command.

if output == '' then
  print('files same')
else
  print(output)
end
