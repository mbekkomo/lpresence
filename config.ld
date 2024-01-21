-- vim: ft=lua
---@diagnostic disable

local version

project = "lpresence"
description = "lpresence "..(version or "dev-1")
package = "lpresence"

file = { "./lpresence.lua", "./lpresence/client.lua", "./lpresence/rpc.lua", "./lpresence/love.lua" }
format = "discount"

not_luadoc = true
all = true
