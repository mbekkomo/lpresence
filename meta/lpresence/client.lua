---@meta

----
-- TODO: Allow to subscribe to an event (`on`, `off` and `event_emit` methods).
--

---@diagnostic disable-next-line:duplicate-doc-alias
---@alias lpresence.snowflake string

---@class lpresence.Client : lpresence.BaseClient
---@overload fun(params: lpresence.snowflake|lpresence.BaseClient_params): lpresence.Client
--
-- Client class.
-- Used to contact Discord via IPC.
--
local Client = {}

---@see lpresence.Client.handshake
--
-- Start a handshake to the IPC.
-- Equivalent to `Client:handshake`.
--
function Client:connect() end

--
-- Close the connection to the IPC.
--
function Client:close() end

---@param client_id lpresence.snowflake
---@param scopes string[]
---@return string code
--
-- Authorize access to client.
--
function Client:authorize(client_id, scopes) end

---@param token string
---@return table response
---@see lpresence.Client.authorize
--
-- Authenticate to client.
--
function Client:authenticate(token) end

---@see lpresence.Client.get_guilds
---@param guild_id lpresence.snowflake
---@return table response
--
-- Get guild information.
--
function Client:get_guild(guild_id) end

---@see lpresence.Client.get_guild
---@return table[] response
--
-- Get list of guilds information.
--
function Client:get_guilds() end

---@see lpresence.Client.get_channels
---@param channel_id lpresence.snowflake
---@return table response
--
-- Get channel information.
--
function Client:get_channel(channel_id) end

---@see lpresence.Client.get_channel
---@param guild_id lpresence.snowflake
---@return table[] response
--
-- Get list of channels information from guild.
--
function Client:get_channels(guild_id) end

---@param user_id lpresence.snowflake
---@param pan_left number?
---@param pan_right number?
---@param volume number?
---@param mute boolean?
---@return table response
--
-- Set user voice settings.
--
function Client:set_user_voice_settings(user_id, pan_left, pan_right, volume, mute) end

---@param channel_id lpresence.snowflake
---@return table response
--
-- Join a voice channel.
--
function Client:select_voice_channel(channel_id) end

---@return table response
--
-- Get the current voice channel the client is in.
--
function Client:get_selected_voice_channel() end

---@param channel_id lpresence.snowflake
---@return table response
--
-- Join a text channel.
--
function Client:select_text_channel(channel_id) end

---@return table response
--
-- Get client's voice settings.
--
function Client:get_voice_settings() end

---@param voice_settings table
---@return table response
--
-- Set client's voice settings.
--
function Client:set_voice_settings(voice_settings) end

---@see lpresence.RPC.update
---@param activity table
---@param pid integer?
---@return table response
--
-- Update user's Rich Presence.
--
function Client:set_activity(activity, pid) end

---@see lpresence.RPC.clear
---@param pid integer?
---@return table response
--
-- Clear user's Rich Presence.
--
function Client:clear_activity(pid) end

---@param action string
---@return table response
--
-- Capture a screenshot.
--
function Client:capture_screenshot(action) end

---@param user_id string
---@return table response
--
-- Consent to a Rich Presence Ask to Join request.
--
function Client:send_activity_join_invite(user_id) end

---@param user_id string
---@return table response
--
-- Reject a Rich Presence Ask to Join request.
--
function Client:close_activity_request(user_id) end

return Client
