local utils = {}

utils.on_windows = package.config:sub(1, 1) == "\\"

return utils
