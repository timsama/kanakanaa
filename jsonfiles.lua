local jsonfiles = {}

local JSON = require("rxijson")
local files = require("files")

jsonfiles.read = (function(filename)
    local file = files.new(filename)
    return JSON.decode(file:read())
end)

return jsonfiles
