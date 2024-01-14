local copas = require("copas")
local Client = require("lpresence.client")

copas(function()
    local client = Client(954917214685892620)

    client:connect()

    client:authorize(954917214685892620, {"rpc"})
    client:authenticate("Bearer 3iWxJL4TjRGE8CYEDR8ber4QLowdW6M")

    print(require("inspect")(client:get_guilds()))

    client:close()
end)
