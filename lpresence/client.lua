-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

--- API wrapper for the IPC.
-- @module lpresence.client

--
-- TODO: Allow to subscribe to an event (`on`, `off` and `event_emit` methods).
--

local BaseClient = require("lpresence.baseclient")
local payloads = require("lpresence.payloads")
local utils = require("lpresence.utils")

local class = require("classy")

--- Client constructor.
-- @param[type=string|clientoptions] params [Application ID](https://en.wikipedia.org/wiki/Snowflake_ID) or constructor options
-- @treturn Client
-- @usage local client = Client("64567352374564")
-- @usage local client = Client {
--     client_id = "64567352374564",
--     timeout = 10,
-- }
-- @function constructor

--- Client constructor options.
-- @field[type=string] client_id [Application ID](https://en.wikipedia.org/wiki/Snowflake_ID)
-- @field[type=?integer] timeout TImeout for connection and response (POSIX only)
-- @field[type=?integer] pipe ID for IPC path
-- @table clientoptions

--- Client class, see the @{constructor}.
-- @see constructor
-- @type Client
local Client = class("Client", BaseClient)

function Client:__init(params)
    BaseClient.__init(self, params)
    self._closed = false
    self._registered_events = {}
end

--- Connect to the IPC.
function Client:connect()
    self:handshake()
end

--- Close the IPC connection.
function Client:close()
    self:send(2, { v = 1, client_id = self.client_id })
    if not utils.on_windows then self.sock:shutdown("rw") end
    self.sock:close()
    self._closed = true
end

--- Authorize access to the IPC.
-- @param[type=string] client_id [Application ID](https://en.wikipedia.org/wiki/Snowflake_ID)
-- @param[type=Array(string)] scopes [OAuth2 Scopes](https://discord.com/developers/docs/topics/oauth2#shared-resources-oauth2-scopes)
-- @treturn table Response to payload
function Client:authorize(client_id, scopes)
    local payload = payloads.authorize(client_id, scopes)
    self:send(1, payload)
    return self:read().data.code
end

--- Authenticate to the IPC.
-- @param[type=string] token OAuth2 access token
-- @treturn table Response to payload
function Client:authenticate(token)
    local payload = payloads.authenticate(token)
    self:send(1, payload)
    return self:read().data
end

--- Get guild by ID.
-- @param[type=string] guild_id ID of the guild
-- @treturn table Response to payload
function Client:get_guild(guild_id)
    local payload = payloads.get_guild(guild_id)
    self:send(1, payload)
    return self:read().data
end

--- Get all guilds the client is in.
-- @treturn Array(table) Response to payload
function Client:get_guilds()
    local payload = payloads.get_guilds()
    self:send(1, payload)
    return self:read().data
end

--- Get channel by ID.
-- @return[type=string] channel_id ID of the channel
-- @treturn table Response to payload
function Client:get_channel(channel_id)
    local payload = payloads.get_channel(channel_id)
    self:send(1, payload)
    return self:read().data
end

--- Get channels in guild.
-- @param[type=string] guild_id ID of the guild
-- @treturn Array(table) Response to payload
function Client:get_channels(guild_id)
    local payload = payloads.get_channels(guild_id)
    self:send(1, payload)
    return self:read().data
end

--- Set user voice settings.
-- @param[type=string] user_id ID of the user
-- @param[type=?number] pan_left Pan left
-- @param[type=?number] pan_right Pan right
-- @param[type=?number] volume Volume of the user
-- @param[type=?boolean] mute Mute state of user
-- @treturn table Response to payload
function Client:set_user_voice_settings(user_id, pan_left, pan_right, volume, mute)
    local payload = payloads.set_user_voice_settings(user_id, pan_left, pan_right, volume, mute)
    self:send(1, payload)
    return self:read().data
end

--- Join a voice channel.
-- @param[type=string] channel_id ID of the voice channel
-- @treturn table Response to payload
function Client:select_voice_channel(channel_id)
    local payload = payloads.select_text_channel(channel_id)
    self:send(1, payload)
    return self:read().data
end

--- Get voice channel the client is in.
-- @treturn table Response to payload
function Client:get_selected_voice_channel()
    local payload = payloads.get_selected_voice_channel()
    self:send(1, payload)
    return self:read().data
end

--- Join or leave text channel.
-- @param[type=string] channel_id ID of the text channel
-- @treturn table Response to payload
function Client:select_text_channel(channel_id)
    local payload = payloads.select_text_channel(channel_id)
    self:send(1, payload)
    return self:read().data
end

--- Get voice settings.
-- @treturn table Response to payload
function Client:get_voice_settings()
    local payload = payloads.get_voice_settings()
    self:send(1, payload)
    return self:read().data
end

--- Set voice settings.
-- @param[type=table] voice_settings [Voice settings](https://discord.com/developers/docs/topics/rpc#setvoicesettings-set-voice-settings-argument-and-response-structure)
-- @treturn table Response to payload
function Client:set_voice_settings(voice_settings)
    local payload = payloads.set_voice_settings(voice_settings)
    self:send(1, payload)
    return self:read().data
end

--- Set activity.
-- @param[type=?table] activity [Activity object](https://discord.com/developers/docs/topics/gateway-events#activity-object)
-- @param[type=?number] pid PID of activity
-- @treturn table Response to payload
function Client:set_activity(activity, pid)
    local payload = payloads.set_activity(activity, pid)
    self:send(1, payload)
    return self:read().data
end

--- Clear activity.
-- @param[type=?number] pid PID of activity
-- @treturn table Response to payload
function Client:clear_activity(pid)
    local payload = payloads.set_activity(nil, pid)
    self:send(1, payload)
    return self:read().data
end

--- Capture a screenshot.
-- @param[type=string] action Action for the screenshot
-- @treturn table Response to payload
function Client:capture_screenshot(action)
    local payload = payloads.capture_shortcut(action)
    self:send(1, payload)
    return self:read().data
end

--- Accept an Ask to Join request.
-- @param[type=string] user_id ID of the user
-- @treturn table Response to payload
function Client:send_activity_join_invite(user_id)
    local payload = payloads.send_activity_join_invite(user_id)
    self:send(1, payload)
    return self:read().data
end

--- Reject an Ask to Join request.
-- @param[type=string] user_id ID of the user
-- @treturn table Response to payload
function Client:close_activity_request(user_id)
    local payload = payloads.close_activity_request(user_id)
    self:send(1, payload)
    return self:read().data
end

return Client
