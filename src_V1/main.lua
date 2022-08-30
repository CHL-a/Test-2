--run code below
local Static = require('Static')
local WebServer = require('WebServer')
	.new()
local cURL = require('cURL')
local HTML = require('HTML')

WebServer.onInvalidRequest(function (client, req, res)

	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'bad request idk'

end)

-- always last step
	.launch()
-- wtf why is coroutines not working here