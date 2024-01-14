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
---@overload fun(params: lpresence.discord_id|lpresence.BaseClient_params): lpresence.Client
--
-- Client class.
-- Used to contact Discord via IPC.
--
local Client = class("Client", BaseClient)

function Client:__init(params)
    BaseClient.__init(self, params)
    self._closed = false
    self._registered_events = {}
end

---@see lpresence.Client.handshake
--
-- Start a handshake to the IPC.
-- Equivalent to `Client:handshake`.
--
function Client:connect()
    self:handshake()
end

--
-- Close the connection to the IPC.
--
function Client:close()
    self:send(2, { v = 1, client_id = self.client_id })
    self:_sclose()
    self._closed = true
    copas.removethread(coroutine.running())
end

---@param client_id integer OAuth2 Application ID.
---@param scopes string[] List of [OAuth2 scopes](https://discord.com/developers/docs/topics/oauth2#shared-resources-oauth2-scopes).
---@return string code
--
-- Authorize access to client.
-- This will bring pop up window asking for authorization.
--
function Client:authorize(client_id, scopes)
    local payload = Payloads:authorize(client_id, scopes)
    self:send(1, payload)
    return self:read().data.code
end

---@param token string OAuth2 Token.
---@return table response Data containing the response, see [the response structure](https://discord.com/developers/docs/topics/rpc#authenticate-authenticate-response-structure).
---@see lpresence.Client.authorize
--
-- Authenticate to client with given token produced by the authorization.
--
function Client:authenticate(token)
    local payload = Payloads:authenticate(token)
    self:send(1, payload)
    return self:read().data
end

---@see lpresence.Client.get_guilds
---@param id lpresence.discord_id ID of the guild.
---@return table response Data containing the response, see [the response structure](https://discord.com/developers/docs/topics/rpc#getguild-get-guild-response-structure)
--
-- Get a guild information the client is in.
--
function Client:get_guild(id)
    local payload = Payloads:get_guild(id)
    self:send(1, payload)
    return self:read().data
end

---@see lpresence.Client.get_guild
---@return table response List of data containing the response (which in case guild object), see [guild object](https://discord.com/developers/docs/resources/guild#guild-object).
--
-- Get all guilds the client is in.
--
function Client:get_guilds()
    local payload = Payloads:get_guilds()
    self:send(1, payload)
    return self:read().data
end

return Client
