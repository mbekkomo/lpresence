# lpresence
A Lua wrapper for Discord IPC and RPC.

## Installation

### Via Luarocks

lpresence is installable through Luarocks.
```bash
luarocks install lpresence
```

### Via manual installation

lpresence requires this dependencies to get it working:
 * [lua-cjson](https://luarocks.org/modules/openresty/lua-cjson)
 * [luafilesystem](https://lunarmodules.github.io/luafilesystem/)
 * [classy](https://github.com/siffiejoe/lua-classy/)
 * On Windows:
   * [winapi](https://github.com/stevedonovan/winapi/)
 * On POSIX platforms (i.e Linux and MacOS):
   * [cqueues](https://github.com/wahern/cqueues/)
 * If you're Lua environment does not have `string.pack` and `string.unpack` (i.e Lua before 5.3):
   * [vstruct](https://github.com/toxicfrog/vstruct/)

After the dependencies are installed, move `lpresence/` directory and `lpresence.lua` to your Lua path.

## Documentation

> [!WARNING]
> 
> lpresence is only tested on Linux (EndavourOS), and I'm not sure if it's working properly on Windows.<br>
> If anyone wanted to volunteer on testing it, please refer to issue [#1](https://github.com/komothecat/lpresence/issues/1).
>

Check the [documentation](https://komothecat.github.io/lpresence) for usages about lpresence.

### Integration for Love2D

lpresence provides a wrapper for Love2D to ease Discord integration in your Love2D games. It runs behind a thread so it won't block the main loop, which basically it runs asynchronously.
```lua
-- Returns the wrapper, also created `love.rpc` for easy access.
require("lpresence.love")

function love.load()
    -- Initialize the thread.
    love.rpc.init("123123123123") -- Pseudo ID, replace with real one.
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
```
