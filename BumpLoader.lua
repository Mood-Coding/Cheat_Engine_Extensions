-- My extension loader. It will try to load all lua files inside "autorun\mrBump\"
-- Inspired by FreeER's Autorun Lua Script Loader for Cheat Engine
-- https://github.com/FreeER/CE-Extensions/blob/master/loader.lua
----------------------------------------------------------------------------------
local EXTENSION_FOLDER = "mrBump"
local SEARCH_MASK = "*.lua" -- Only find file has lua extension

local dirs = getDirectoryList(getAutorunPath())
for _, dirPath in pairs(dirs) do
    if dirPath:find(EXTENSION_FOLDER) then
        local files = getFileList(dirPath, SEARCH_MASK)
        for _, filePath in pairs(files) do dofile(filePath) end
        break
    end
end
