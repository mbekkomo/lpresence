-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

----
-- TODO: Allow to subscribe to an event (`on`, `off` and `event_emit` methods).
--

local BaseClient = require("lpresence.baseclient")
local payloads = require("lpresence.payloads")
local utils = require("lpresence.utils")

local class = require("classy")

---@class lpresence.Client : lpresence.BaseClient
---@overload fun(params: lpresence.snowflake|lpresence.BaseClient_params): lpresence.Client
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
    if not utils.on_windows then self.sock:shutdown("rw") end
    self.sock:close()
    self._closed = true
end

---@param client_id lpresence.snowflake
---@param scopes string[]
---@return string code
function Client:authorize(client_id, scopes)
    local payload = payloads.authorize(client_id, scopes)
    self:send(1, payload)
    return self:read().data.code
end

---@param token string
---@return table response
---@see lpresence.Client.authorize
function Client:authenticate(token)
    local payload = payloads.authenticate(token)
    self:send(1, payload)
    return self:read().data
end

---@see lpresence.Client.get_guilds
---@param id lpresence.snowflake
---@return table response
function Client:get_guild(id)
    local payload = payloads.get_guild(id)
    self:send(1, payload)
    return self:read().data
end

---@see lpresence.Client.get_guild
---@return table[] response
function Client:get_guilds()
    local payload = payloads.get_guilds()
    self:send(1, payload)
    return self:read().data
end

---@see lpresence.Client.get_channels
---@param id lpresence.snowflake
---@return table response
function Client:get_channel(id)
    local payload = payloads.get_channel(id)
    self:send(1, payload)
    return self:read().data
end

---@see lpresence.Client.get_channel
---@param id lpresence.snowflake
---@return table[] response
function Client:get_channels(id)
    local payload = payloads.get_channels(id)
    self:send(1, payload)
    return self:read().data
end

---@param user_id lpresence.snowflake
---@param pan_left number?
---@param pan_right number?
---@param volume number?
---@param mute boolean?
---@return table response
function Client:set_user_voice_settings(user_id, pan_left, pan_right, volume, mute)
    local payload = payloads.set_user_voice_settings(user_id, pan_left, pan_right, volume, mute)
    self:send(1, payload)
    return self:read().data
end

---@param id lpresence.snowflake
---@return table response
function Client:select_voice_channel(id)
    local payload = payloads.select_text_channel(id)
    self:send(1, payload)
    return self:read().data
end

---@return table response
function Client:get_selected_voice_channel()
    local payload = payloads.get_selected_voice_channel()
    self:send(1, payload)
    return self:read().data
end

---@param id lpresence.snowflake
---@return table response
function Client:select_text_channel(id)
    local payload = payloads.select_text_channel(id)
    self:send(1, payload)
    return self:read().data
end

---@return table response
function Client:get_voice_settings()
    local payload = payloads.get_voice_settings()
    self:send(1, payload)
    return self:read().data
end

---@param voice_settings table
---@return table response
function Client:set_voice_settings(voice_settings)
    local payload = payloads.set_voice_settings(voice_settings)
    self:send(1, payload)
    return self:read().data
end

---@param activity table
---@param pid integer?
---@return table response
function Client:set_activity(activity, pid)
    local payload = payloads.set_activity(activity, pid)
    self:send(1, payload)
    return self:read().data
end

---@param pid integer?
---@return table response
function Client:clear_activity(pid)
    local payload = payloads.set_activity(nil, pid)
    self:send(1, payload)
    return self:read().data
end

---@param action string
---@return table response
function Client:capture_screenshot(action)
    local payload = payloads.capture_shortcut(action)
    self:send(1, payload)
    return self:read().data
end

---@param id string
---@return table response
function Client:send_activity_join_invite(id)
    local payload = payloads.send_activity_join_invite(id)
    self:send(1, payload)
    return self:read().data
end

---@param id string
---@return table response
function Client:close_activity_request(id)
    local payload = payloads.close_activity_request(id)
    self:send(1, payload)
    return self:read().data
end

return Client
