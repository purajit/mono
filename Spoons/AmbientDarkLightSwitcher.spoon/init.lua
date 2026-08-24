local obj = {}
obj.__index = obj

-- Metadata
obj.name = "AmbientDarkLightSwitcher"
obj.version = "1.0"
obj.author = "purajit"
obj.homepage = ""
obj.license = ""

-- Settings
obj.luxThreshold = 25

obj.lastTheme = ""

obj.timer = hs.timer.doEvery(10, function()
    local lux = hs.brightness.ambient()
    if lux > obj.luxThreshold and obj.lastTheme ~= "light" then
        local success, des, raw = hs.osascript.applescript([[
            tell application "System Events"
                tell appearance preferences
                    set dark mode to false
                end tell
            end tell
        ]])
        obj.lastTheme = "light"
        print("switched toj light")
        print(obj.lastTheme)
        print(obj)
        for i, key in ipairs(obj) do
            print(key)
        end
        print(lux)
    elseif lux <= obj.luxThreshold and obj.lastTheme ~= "dark" then
        local success, des, raw = hs.osascript.applescript([[
            tell application "System Events"
                tell appearance preferences
                    set dark mode to true
                end tell
            end tell
        ]])
        obj.lastTheme = "dark"
        print("switched to dark")
    end
end)

function obj:init()
  print("Initializing AmbientDarkLightSwitcher")
  obj.timer:start()
end

return obj
