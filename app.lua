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

local lapis = require("lapis")
local app = lapis.Application()

app:enable("etlua")
app.layout = require("views.layout")

app:get("/", function(self)
	self.page_title = "Home"
	self.page_subtitle = "Hello"
	return { render = "index" }
end)

app:get("/things", function(self)
	self.page_title = "My Favorite Things"
	self.page_subtitle = "Here are my favorite things"
	self.my_favorite_things = {
		"Walking",
		"Books",
		"Computers",
		"Fitness",
	}

	return { render = "things" }
end)

return app
