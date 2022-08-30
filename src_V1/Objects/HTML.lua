---@meta

--| Classes
---@class HTML
---@field tag fun(tn: string?): HTML.tag
---@field tags HTML.tags
---@field tagCollection fun(...: HTML.tag): HTML.tagCollection
---@field collections HTML.collections

---@class HTML.tag
---@field attributes {[string]: string}
---@field type HTML.tag.type
---@field collection HTML.tagCollection
---@field setAttribute fun(i: string, v: string): HTML.tag
---@field addChild fun(c: HTML.tag.child): HTML.tag
---@field addChildren fun(...: HTML.tag.child): HTML.tag
---@field setType fun(type: HTML.tag.type): HTML.tag
---@field setTagName fun(tn: string): HTML.tag
---@field toString fun(indent: integer?): HTML.tag

---@alias HTML.tag.child string | HTML.tag

---@alias HTML.tag.type "nested" | "singular"

---@class HTML.tags
---@field docHeader HTML.tag

---@class HTML.tagCollection
---@field children {[number]: HTML.tag.child}
---@field addChild fun(c: HTML.tag.child): HTML.tagCollection
---@field addChildren fun(...: HTML.tag.child): HTML.tagCollection
---@field toString fun(indent: integer?): string

---@class HTML.collections
---@field root fun(...: HTML.tag): HTML.root

---@class HTML.tag.constructor.argument
---@field tagName string
---@field type HTML.tag


---@class HTML.root : HTML.tagCollection

--| Enum
-- -  @enum 

---@type HTML
local HTML = {}

---returns html tag superclass
---@param tagName string?
---@return HTML.tag
function HTML.tag(tagName)
	---@type HTML.tag
	local object = {}

	object.attributes = {}
	object.type = "singular"
	object.value = HTML.tagCollection()

	---sets attribute
	---@param i string
	---@param v string
	---@return HTML.tag
	object.setAttribute = function(i, v)
		object.attributes[i] = v
		return object
	end

	---sets child
	---@param c HTML.tag | string
	---@return HTML.tag
	object.addChild = function(c)
		object.value.addChild(c)
		return object
	end

	---sets children
	---@param ... HTML.tag | string
	---@return HTML.tag
	object.addChildren = function (...)
		for i = 1, select("#", ...) do
			object.addChild(select(i, ...))
		end
		return object
	end

	---tag name
	---@param n string
	---@return HTML.tag
	object.setTagName = function(n)
		tagName = n
		return object
	end

	---sets type, nested or singular
	---@param s HTML.tag.type
	---@return HTML.tag
	object.setType = function(s)
		object.type = s
		return object
	end

	---value
	---@param v HTML.tag.child
	---@return HTML.tag
	object.setValue = function(v)
		object.value = v
		return object.setType('nested')
	end

	---return html content
	---@param indent integer
	---@return string
	object.toString = function(indent)
		indent = indent or 0
		-- indent, <, and tag name
		local result = ('%s<%s'):format(
			('\t'):rep(indent),
			tagName
		)

		-- attributes
		for i, v in next, object.attributes do
			result = result
				.. (' %s="%s"'):format(i, v)
		end
		
		-- >
		result = result .. '>'
		
		if object.type == 'nested' then
			if type(object.value) == 'string' then
				result = result .. object.value
			else
				for _, tag in next, object.value do
					result = result
						.. ('%s\n'):format(tag.toString(indent + 1))
				end
			end

			result = result .. ('</%s>\n'):format(tagName)
		end

		return result
	end

	return object.setTagName(tagName or 'NOTAGNAME')
end

---returns collection
---@param ... HTML.tag | string
---@return HTML.tagCollection
function HTML.tagCollection(...)
	---@type HTML.tagCollection
	local object = {}

	object.children = {}

	---adds child
	---@param c HTML.tag.child
	---@return HTML.tagCollection
	object.addChild = function (c)
		table.insert(object.children, c)
		return object
	end

	---adds children
	---@param ... HTML.tag.child
	---@return HTML.tagCollection
	object.addChildren = function (...)
		for i = 1, select('#',...)do
			object.addChild(select(i,...))
		end
		return object
	end
	
	---comment
	---@param indent integer?
	---@return string
	object.toString = function(indent)
		-- pre
		indent = indent or 0

		-- main
		local result = ''

		local allNested = true

		for _, value in next, object.children do
			if type(value) == 'string' then
				allNested = false
				break
			end
		end

		for _, value in next, object.children do
			result = result .. (
					type(value) == 'string'
						and value
						or value.toString(
							indent
						)
				)

			if allNested then
				result = result .. '\n'
			end
		end

		return result
	end

	return object.addChildren(...)
end

---constructor
---@param struct HTML.tag.constructor.argument
function loadHTMLTAG(struct)
	local result = HTML.tag(struct.tagName)


	return result
end

HTML.tags = {
	docHeader = HTML.tag'!DOCTYPE html'
}

HTML.collections = {
	root = function (...)
		return HTML.tagCollection(
			HTML.tags.docHeader,
			...
		)
	end
}

return HTML