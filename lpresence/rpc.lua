-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

local BaseClient = require("lpresence.baseclient")
local payloads = require("lpresence.payloads")
local utils = require("lpresence.utils")

local class = require("classy")

local RPC = class("RPC", BaseClient)

function RPC:__init(params)
    BaseClient.__init(self, params)
end

function RPC:connect()
    self:handshake()
end

function RPC:close()
    self:send(2, { v = 1, client_id = self.client_id })
    if utils.on_windows then self.sock:shutdown("rw") end
    self.sock:close()
end

function RPC:update(activity, pid)
    local payload = payloads.set_activity(activity, pid)
    self:send(1, payload)
    return self:read().data
end

function RPC:clear(pid)
    local payload = payloads.set_activity(nil, pid)
    self:send(1, payload)
    return self:read().data
end

return RPC
