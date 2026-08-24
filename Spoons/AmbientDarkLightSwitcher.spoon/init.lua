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
        print(string.format("Switched to light mode at %f lux", lux))
    elseif lux <= obj.luxThreshold and obj.lastTheme ~= "dark" then
        local success, des, raw = hs.osascript.applescript([[
            tell application "System Events"
                tell appearance preferences
                    set dark mode to true
                end tell
            end tell
        ]])
        obj.lastTheme = "dark"
        print(string.format("Switched to dark mode at %f lux", lux))
   end
end)

function obj:init()
  print("Initializing AmbientDarkLightSwitcher")
  obj.timer:start()
end

return obj
