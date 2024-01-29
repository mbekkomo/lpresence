local client = require("lpresence.client")(1197916593200578610)

client:register_event("ready", function(d)
    print(require("inspect")(d))
end)

client:connect()

_ = io.read("a")

client:close()
