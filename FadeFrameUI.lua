-- Define the default opacity values
local fadeTime = 1  -- Time in seconds for the fade effect
local opacityNonCombatActionBars = 0.5  -- Opacity for action bars when not in combat
local opacityNonCombatUI = 0.2  -- Opacity for other UI elements when not in combat
local opacityInCombat = 1.0  -- Opacity when in combat
local opacityWithTarget = 1.0  -- Opacity when the player has a target
local opacityNonTarget = 0.2  -- Opacity when the player has no target
local opacityNotFullHealth = 1.0 -- Opacity when not at full health
local opacityFullHealth = 0.2 -- Opacity when at full health
local opacityCasting = 1.0 -- Opacity when the player is casting

local opacityMainActionBar = 0.2  -- Default 20% opacity for the Main Action Bar

local isCasting = false -- Track if the player is casting

-- Function to smoothly fade a frame
local function FadeFrame(frame, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombat)
    local currentOpacity = frame:GetAlpha()
    local targetOpacity
    
    -- Determine the target opacity based on combat state, target status, health, and casting status
    if isCasting then
        targetOpacity = opacityCasting
    elseif isInCombat or hasTarget then
        targetOpacity = opacityInCombat
    elseif isNotFullHealth then
        targetOpacity = opacityNotFullHealth
    else
        targetOpacity = opacityNonCombat
    end
    
    -- If the current opacity is not the target opacity, fade the frame
    if currentOpacity ~= targetOpacity then
        -- If entering combat, acquiring a target, or casting, apply instant opacity change
        if isInCombat or hasTarget or isNotFullHealth or isCasting then
            frame:SetAlpha(targetOpacity)
        else
            UIFrameFadeOut(frame, fadeTime, currentOpacity, targetOpacity)
        end
    end
end

-- Function to fade action bars (Main Action Bar and all MultiBars)
local function FadeActionBars()
    local isInCombat = UnitAffectingCombat("player")
    local hasTarget = UnitExists("target")
    local isNotFullHealth = UnitHealth("player") < UnitHealthMax("player")
    
    -- Fade the Main Action Bar (MainMenuBar and its related frames)
    local mainActionBar = _G["MainMenuBar"]
    if mainActionBar then
        FadeFrame(mainActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityMainActionBar)
    end
    
    -- Fade the Action Buttons (ActionButton1 to ActionButton12)
    for i = 1, 12 do
        local actionButton = _G["ActionButton" .. i]
        if actionButton then
            FadeFrame(actionButton, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
        end
    end
    
    -- Fade the MultiBarRight (Right Action Bar)
    local rightActionBar = _G["MultiBarRight"]
    if rightActionBar then
        FadeFrame(rightActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
    end
    
    -- Fade the Action Buttons for MultiBarRight (MultiBarRightButton1 to MultiBarRightButton12)
    for i = 1, 12 do
        local button = _G["MultiBarRightButton" .. i]
        if button then
            FadeFrame(button, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
        end
    end
    
    -- Fade the MultiBarRight2 (Right Action Bar 2)
    local rightActionBar2 = _G["MultiBarRight2"]
    if rightActionBar2 then
        FadeFrame(rightActionBar2, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
    end
    
    -- Fade the Action Buttons for MultiBarRight2 (MultiBarRight2Button1 to MultiBarRight2Button12)
    for i = 1, 12 do
        local button = _G["MultiBarRight2Button" .. i]
        if button then
            FadeFrame(button, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
        end
    end
    
    -- Fade the MultiBarBottomLeft (Bottom Left Action Bar)
    local bottomLeftActionBar = _G["MultiBarBottomLeft"]
    if bottomLeftActionBar then
        FadeFrame(bottomLeftActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
    end
    
    -- Fade the Action Buttons for MultiBarBottomLeft (MultiBarBottomLeftButton1 to MultiBarBottomLeftButton12)
    for i = 1, 12 do
        local button = _G["MultiBarBottomLeftButton" .. i]
        if button then
            FadeFrame(button, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
        end
    end
    
    -- Fade the MultiBarBottomRight (Bottom Right Action Bar)
    local bottomRightActionBar = _G["MultiBarBottomRight"]
    if bottomRightActionBar then
        FadeFrame(bottomRightActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
    end
    
    -- Fade the Action Buttons for MultiBarBottomRight (MultiBarBottomRightButton1 to MultiBarBottomRightButton12)
    for i = 1, 12 do
        local button = _G["MultiBarBottomRightButton" .. i]
        if button then
            FadeFrame(button, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
        end
    end
    
    -- Fade the MultiBarLeft (Left Action Bar)
    local leftActionBar = _G["MultiBarLeft"]
    if leftActionBar then
        FadeFrame(leftActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
    end
    
    -- Fade the Action Buttons for MultiBarLeft (MultiBarLeftButton1 to MultiBarLeftButton12)
    for i = 1, 12 do
        local button = _G["MultiBarLeftButton" .. i]
        if button then
            FadeFrame(button, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
        end
    end
    
    -- Fade the Pet Action Bar (PetActionBarFrame)
    local petActionBar = _G["PetActionBarFrame"]
    if petActionBar then
        FadeFrame(petActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatActionBars)
    end
end

-- Function to fade non-action bar UI elements
local function FadeNonActionBarUI()
    local isInCombat = UnitAffectingCombat("player")
    local hasTarget = UnitExists("target")
    local isNotFullHealth = UnitHealth("player") < UnitHealthMax("player")
    
    -- Fade the PlayerFrame
    FadeFrame(PlayerFrame, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    
    -- Fade the Minimap
    FadeFrame(Minimap, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    
    -- Fade the MiniMapInstanceDifficulty (Raid Size Icon)
    local raidSizeIcon = _G["MiniMapInstanceDifficulty"]
    if raidSizeIcon then
        FadeFrame(raidSizeIcon, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    end
    
    -- Fade the Minimap Border (MinimapBorder)
    local minimapBorder = _G["MinimapBorder"]
    if minimapBorder then
        FadeFrame(minimapBorder, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    end
    
    -- Fade the Minimap Border Top (MinimapBorderTop)
    local minimapBorderTop = _G["MinimapBorderTop"]
    if minimapBorderTop then
        FadeFrame(minimapBorderTop, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    end
    
    -- Fade the Minimap Zone Text (MinimapZoneTextButton)
    local zoneText = _G["MinimapZoneTextButton"]
    if zoneText then
        FadeFrame(zoneText, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    end
    
    -- Fade the BuffFrame (all buffs)
    if BuffFrame then
        FadeFrame(BuffFrame, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    end
    
    -- Fade the ChatFrameMenuButton (Chat menu button)
    local chatMenuButton = _G["ChatFrameMenuButton"]
    if chatMenuButton then
        FadeFrame(chatMenuButton, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    end
    
    -- Fade the Friends Micro Button (Social Button next to the chat)
    local friendsMicroButton = _G["FriendsMicroButton"]
    if friendsMicroButton then
        FadeFrame(friendsMicroButton, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
    end
    
    -- Fade the Chat Arrows
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            local buttonFrame = _G["ChatFrame" .. i .. "ButtonFrame"]
            if buttonFrame then
                local upButton = _G["ChatFrame" .. i .. "ButtonFrameUpButton"]
                local downButton = _G["ChatFrame" .. i .. "ButtonFrameDownButton"]
                local bottomButton = _G["ChatFrame" .. i .. "ButtonFrameBottomButton"]
                
                -- Fade the chat buttons (up, down, and bottom)
                if upButton then
                    FadeFrame(upButton, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
                end
                if downButton then
                    FadeFrame(downButton, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
                end
                if bottomButton then
                    FadeFrame(bottomButton, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatUI)
                end
            end
        end
    end
end

-- Function to track the casting state
local function OnUpdate(self, elapsed)
    local _, _, _, _, _, _, _, _, _, _ = UnitCastingInfo("player")
    local isCastingNow = (UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil)
    
    -- Update casting state
    if isCastingNow ~= isCasting then
        isCasting = isCastingNow
        FadeActionBars()  -- Reapply fade when casting status changes
        FadeNonActionBarUI()  -- Reapply fade to non-action bar UI
    end
end

-- Create a frame for OnUpdate event
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")  -- Player enters combat
frame:RegisterEvent("PLAYER_REGEN_ENABLED")   -- Player leaves combat
frame:RegisterEvent("PLAYER_TARGET_CHANGED")  -- Player changes target
frame:RegisterEvent("UNIT_HEALTH")            -- Health change event
frame:SetScript("OnEvent", function(self, event)
    FadeActionBars()
    FadeNonActionBarUI()
end)

-- Register the OnUpdate handler for continuous casting check
frame:SetScript("OnUpdate", OnUpdate)

SLASH_FFU1 = "/ffu"
SlashCmdList["FFU"] = function(msg)
    local command, target, value = strsplit(" ", msg)
    
    -- Check if the value ends with '%' and remove it
    if value and value:match("%%$") then
        value = value:sub(1, -2)  -- Remove the '%' character
    end
    
    value = tonumber(value)
    
    if command == "set" and target == "mainbar" and value and value >= 1 and value <= 100 then
        opacityMainActionBar = value / 100  -- Convert 1-100 to 0-1
        FadeActionBars()
        print("|cff00ff00Mainbar|r opacity is now set to |cff00ff00" .. value .. "%\n")  -- Provide feedback with newline
        
    elseif command == "set" and target == "otherbars" and value and value >= 1 and value <= 100 then
        -- Apply scaling: If value is 20, it becomes 50% opacity
        local scaledOpacity = value * 1.3 / 100  -- Scales 20 to 50, 40 to 100, etc.
        opacityNonCombatActionBars = scaledOpacity  -- Set the opacity based on the scaled value
        FadeActionBars()  -- You can create a separate function for fading non-combat action bars if necessary
        print("|cff00ff00Otherbars|r opacity is now set to |cff00ff00" .. value .. "%\n")  -- Print the user's input value
        
    elseif command == "reset" then
        -- Default behavior is to reset the mainbar opacity
        opacityMainActionBar = 0.2  -- Set to 20% opacity
        opacityNonCombatActionBars = 0.5  -- Set non-combat action bar opacity to 50%
        FadeActionBars()
        print("All settings are now |cff00ff00default|r\n")  -- Provide feedback with newline
    
    elseif command == "save" then
        -- Print the save message in red
        print("|cffff0000Save is not possible at the moment. Make sure to use a macro to force the opacity you want everytime you load the game. Sorry for the inconvenience|r")
    
    else
        print("|cff00ff00Usage and available commands:|r \n")
        print("/ffu set mainbar <value> (value between 1 and 100).\n")
        print("/ffu set otherbars <value> (value between 1 and 100).\n")
        print("/ffu reset (default settings).\n")
        print("/ffu save (save settings message).\n")
    end
end















-- Initial fade to set the correct opacity when the addon is loaded
FadeActionBars()
FadeNonActionBarUI()

-- Print a message when the addon is loaded
print("|cff00ff00FadeFrameUI|r is now loaded. Please use |cff00ff00/ffu|r to see more.")
