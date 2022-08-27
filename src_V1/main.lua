--run code below
local Static = require('Static')
local WebServer = require('WebServer')
	.new()
local cURL = require('cURL')


-- sample:
-- let our domain be `https://google.com`

-- client sent http request to home, being `google.com`
WebServer.onRequest('/foo', 'GET', function (client, req, res)
	res.success = true
	res.statusCode = 200
	res.statusMessage = 'OK'
	res.headers.connection = 'close'
	res.body = 'the foo page, welcome'

	Static.table.toString(req)
end)

-- client sent http request to an invalid webpage
--[[
	At the moment, the client connection should always close, but 
	this part is custom so you can actually reroute the client to another webpage if desired
--]]
.onInvalidRequest(function (client, req, res)

	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'bad request idk'

end)

-- always last step
	.launch()
cURL.get('https://test-2.0x2.repl.co/foo', '', {
	['X-FOO'] = 'bar'
})