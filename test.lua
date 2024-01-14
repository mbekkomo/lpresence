local copas = require("copas")
local Client = require("lpresence.client")

copas(function()
    local client = Client("954917214685892620")

    client:connect()

    local token = client:authorize("954917214685892620", {"rpc"})
    print(require("inspect")(client:authenticate("Bearer "..token)))

    client:close()
end)
