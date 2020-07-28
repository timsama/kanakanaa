local jsonfiles = {}

local JSON = require("rxijson")
local files = require("files")

jsonfiles.read = (function(filename)
    local file = files.new(filename)
    return JSON.decode(file:read())
end)

jsonfiles.write = (function(filename, lua_object)
    local file = files.new(filename)
    return file:write(JSON.encode(lua_object), true)
end)

return jsonfiles
