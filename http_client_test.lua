
--USE_LUASOCKET = true

local client = require'http_client'
client.http.zlib = require'zlib'
local loop = require(USE_LUASOCKET and 'http_socket_luasec' or 'http_socket2_libtls')
local time = require'time'

local function search_page_url(pn)
	return 'https://luapower.com/'
end

function kbytes(n)
	if type(n) == 'string' then n = #n end
	return n and string.format('%.1fkB', n/1024)
end

function mbytes(n)
	if type(n) == 'string' then n = #n end
	return n and string.format('%.1fmB', n/(1024*1024))
end

local client = client:new{
	loop = loop,
	max_conn = 5,
	max_pipelined_requests = 10,
	debug = true,
}
local n = 0
for i=1,1 do
	loop.newthread(function()
		print('sleep 1')
		loop.sleep(1)
		local res, req, err_class = client:request{
			--host = 'www.websiteoptimization.com', uri = '/speed/tweak/compress/',
			host = 'luapower.com', uri = '/',
			--https = true,
			--host = 'mokingburd.de',
			--host = 'www.google.com', https = true,
			receive_content = 'string',
			debug = {protocol = true, stream = false},
			--max_line_size = 1024,
			--close = true,
			connect_timeout = 0.5,
			request_timeout = 0.5,
			reply_timeout = 0.3,
		}
		if res then
			n = n + (res and res.content and #res.content or 0)
		else
			print('ERROR:', req)
		end
	end)
end
local t0 = time.clock()
loop.start(5)
t1 = time.clock()
print(mbytes(n / (t1 - t0))..'/s')

