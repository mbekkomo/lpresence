-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

local class = require("classy")
local copas = require("copas")
local json = require("cjson")
local vstruct = require("lpresence.vstruct")
local winapi = require("lpresence.winapi")
local BaseClient = require("lpresence.baseclient")
local Payloads = require("lpresence.payloads")

---@class lpresence.Client : lpresence.BaseClient
---@overload fun(params: lpresence.BaseClient_params): lpresence.Client
local Client = class("Client", BaseClient)

function Client:__init(params)
    BaseClient.__init(self, params)
    self._closed = false
    self._registered_events = {}
end

function Client:start()
    self:handshake()
end

function Client:close()
    self:send(2, { v = 1, client_id = self.client_id })
    self:_sclose()
    self._closed = true
end

function Client:authorize(client_id, scopes)
    local payload = Payloads:authorize(client_id, scopes)
    self:send(1, payload)
    return self:read()
end

return Client
