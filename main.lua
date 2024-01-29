-- Returns the wrapper, also created `love.rpc` for easy access.
require("lpresence.love")

function love.load()
    -- Initialize the thread.
    love.rpc.init("1197916593200578610") -- Pseudo ID, replace with real one.
    love.rpc.register_event("ready", [[
        print(("Connected as user %s#%s"):format(data.user.username, data.user.discriminator))
    ]])
    -- Connect to the RPC.
    love.rpc.connect()
    -- Set the RPC
    love.rpc.update {
        state = "Hello World!",
        details = "I'm playing a Love2D game!",
        timestamps = {
            start = os.time(),
        },
        assets = {
            large_image = "https://github.com/love2d.png",
            large_text = "Mysterious Mystery",
        }
    }
end

function love.draw()
    love.graphics.print("Hello World!", 400, 300)
end

function love.quit()
    -- Make sure to disconnect and free the thread.
    love.rpc.close()
end

