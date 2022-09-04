--run code below
local Static = require('Static')
local WebServer = require('WebServer')
	.new()
local cURL = require('cURL')
local HTML = require('HTML')
local Enum = require'Enum'

WebServer.onInvalidRequest(function (client, req, res)
	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.headers['Content-Type'] =  Enum.mimeTypes.html
	res.body = HTML.collections.root(
		HTML.tags.title('Cool website title'),
		HTML.collections.discordURLEmbed(
			'test title',
			'test description',
			'https://http.cat/200.jpg'
		),
		HTML.tag('html').addChild(
			HTML.tag('body').addChild(
				'Bro why you lookin? The cat is on the embed not here'
			)
		)
	).toString()

end)

-- always last step
	.launch()
-- wtf why is coroutines not working here

