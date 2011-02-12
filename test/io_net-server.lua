local apr = assert(require 'apr')
local server = assert(apr.socket_create())
assert(server:bind('*', arg[1]))
assert(server:listen(1))

-- Signal to the test suite that we've initialized successfully?
if arg[2] then
  local handle = assert(io.open(arg[2], 'w'))
  assert(handle:write 'DONE')
  assert(handle:close())
end

local client = assert(server:accept())
for line in client:lines() do
  assert(client:write(line:upper(), '\n'))
end
assert(client:close())