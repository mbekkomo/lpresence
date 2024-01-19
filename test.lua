local RPC = require("lpresence.rpc")


local rpc = RPC("1197916593200578610")

rpc:connect()

rpc:update({
    type = 0,
    state = "Hey!",
    details = "Purely in Lua!",
})

io.read"a"

rpc:close()
