--[[
local lapis = require("lapis")
local respond_to = lapis.respond_to
local sqlite = require("sqlite") -- Changed from lsqlite3

local app = lapis.Application()

app:match(
	"hello",
	respond_to({
		GET = function()
			local db = sqlite.open("test.db")
			db:exec("CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, name TEXT)")
			db:exec("INSERT INTO test (name) VALUES ('World')")
			local result = db:exec("SELECT name FROM test WHERE id = 1")
			db:close()
			return "Hello, " .. result[1].name .. " from Lapis + SQLite!"
		end,
	})
)
]]
--[[
local lapis = require("lapis")
local app = lapis.Application()

app:enable("etlua") -- Optional, if using ETLua templates

app:match("/", function(self)
	return self:respond_to({
		GET = function(self)
			return "Welcome to Lapis! (GET)"
		end,
		POST = function(self)
			return "Welcome to Lapis! (POST)"
		end,
	})
end)

return app
]]

local lapis = require("lapis")
local app = lapis.Application()

app:get("/", function(self)
	return { body = "Hello world!", status = 200 }
end)

return app
