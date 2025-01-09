-- Define the default opacity values
local fadeTime = 1  -- Time in seconds for the fade effect
local opacityNonCombatMinimap = 1  -- Opacity for the minimap elements when not in combat
local opacityNonCombatPlayerFrame = 1  -- Opacity for the Playerframe elements when not in combat
local opacityNonCombatBuff = 1  -- Opacity for the Buff elements when in combat

local opacityInCombat = 1  -- Opacity when in combat
local opacityWithTarget = 1  -- Opacity when the player has a target
local opacityNotFullHealth = 1 -- Opacity when not at full health
local opacityCasting = 1 -- Opacity when the player is casting

local AllActionBars = 0.2  -- Opacity for action bars when not in combat
local opacityFullHealth = 0.2 -- Opacity when at full health
local opacityNonCombatMinimap = 0.2  -- Default 20% opacity for the Minimap
local opacityNonCombatPlayerFrame = 0.2  -- Default 20% opacity for the Playerframe
local opacityNonCombatBuff = 0.2  -- Opacity for the Buff elements when not in combat

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
        -- Cancel any ongoing fade if acquiring a target or casting
        if hasTarget or isCasting then
            UIFrameFadeRemoveFrame(frame) -- Cancel any ongoing fade
            frame:SetAlpha(targetOpacity) -- Instantly apply the target opacity
        elseif isInCombat or isNotFullHealth then
            frame:SetAlpha(targetOpacity) -- Instantly apply the target opacity
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
        FadeFrame(mainActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, AllActionBars)
    end
    
    -- Fade the MultiBarBottomLeft (Bottom Left Action Bar)
    local bottomLeftActionBar = _G["MultiBarBottomLeft"]
    if bottomLeftActionBar then
        FadeFrame(bottomLeftActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, AllActionBars)
    end
    
    
    -- Fade the MultiBarBottomRight (Bottom Right Action Bar)
    local bottomRightActionBar = _G["MultiBarBottomRight"]
    if bottomRightActionBar then
        FadeFrame(bottomRightActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, AllActionBars)
    end
	
	    -- Fade the MultiBarRight (Bottom Right Action Bar)
    local bottomRightActionBar = _G["MultiBarRight"]
    if bottomRightActionBar then
        FadeFrame(bottomRightActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, AllActionBars)
    end
	   
    -- Fade the MultiBarLeft (Left Action Bar)
    local leftActionBar = _G["MultiBarLeft"]
    if leftActionBar then
        FadeFrame(leftActionBar, isInCombat, hasTarget, isNotFullHealth, isCasting, AllActionBars)
    end
    
end

-- Function to set the chat frame background and input bar opacity to 0%
local function SetChatOpacity()
    -- Loop through all chat frames
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            -- Keep chat frame text at full opacity (1 means no transparency)
            chatFrame:SetAlpha(1)
        end
    end
end

-- Function to reset input bar opacity
local function ResetInputBarOpacity()
    local chatInput = ChatFrame1EditBox  -- Default chat input box (for ChatFrame1)
    if chatInput and not chatInput:HasFocus() then
        chatInput:SetAlpha(0)  -- Reset opacity to 0% if not focused
    end
end

-- Timer to delay opacity reset after typing
local function DelayedOpacityReset()
    local f = CreateFrame("Frame")
    local timer = 0
    f:SetScript("OnUpdate", function(self, elapsed)
        timer = timer + elapsed
        if timer >= 10 then  -- Change delay to 10 seconds
            if ResetInputBarOpacity then  -- Ensure function exists before calling
                ResetInputBarOpacity()  -- Call the opacity reset function
            end
            self:SetScript("OnUpdate", nil)  -- Stop the timer after it's done
        end
    end)
end

-- Function to handle chat-related events
local function InitializeChatOpacity()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGIN")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("CHAT_INPUT_CHANGED")  -- Event for when the text in the chat input box changes
    f:RegisterEvent("CHAT_MSG_CHANNEL")    -- Event for when chat is updated after sending messages

    f:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
            SetChatOpacity()
        elseif event == "CHAT_INPUT_CHANGED" then
            -- No changes needed here if focus hooks handle visibility
        elseif event == "CHAT_MSG_CHANNEL" then
            ResetInputBarOpacity()
        end
    end)

    -- Hook the input box for focus gained/lost
    local chatInput = ChatFrame1EditBox
    if chatInput then
        chatInput:HookScript("OnEditFocusGained", function(self)
            self:SetAlpha(1)  -- Set to fully visible when focused
        end)
        chatInput:HookScript("OnEditFocusLost", function(self)
            self:SetAlpha(0)  -- Reset to 0% opacity when focus is lost
        end)
    end
end

-- Call InitializeChatOpacity during addon load
InitializeChatOpacity()

-- Function to fade non-action bar UI elements
local function FadeNonActionBarUI()
    local isInCombat = UnitAffectingCombat("player")
    local hasTarget = UnitExists("target")
    local isNotFullHealth = UnitHealth("player") < UnitHealthMax("player")
    
    -- Fade the PlayerFrame
    FadeFrame(PlayerFrame, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatPlayerFrame)
    
    -- Fade the Minimap
    FadeFrame(Minimap, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatMinimap)
    
    -- Fade the MiniMapInstanceDifficulty (Raid Size Icon)
    local raidSizeIcon = _G["MiniMapInstanceDifficulty"]
    if raidSizeIcon then
        FadeFrame(raidSizeIcon, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatMinimap)
    end
    
    -- Fade the Minimap Border (MinimapBorder)
    local minimapBorder = _G["MinimapBorder"]
    if minimapBorder then
        FadeFrame(minimapBorder, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatMinimap)
    end
    
    -- Fade the Minimap Border Top (MinimapBorderTop)
    local minimapBorderTop = _G["MinimapBorderTop"]
    if minimapBorderTop then
        FadeFrame(minimapBorderTop, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatMinimap)
    end
    
    -- Fade the Minimap Zone Text (MinimapZoneTextButton)
    local zoneText = _G["MinimapZoneTextButton"]
    if zoneText then
        FadeFrame(zoneText, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatMinimap)
    end
    
    -- Fade the BuffFrame (all buffs)
    if BuffFrame then
        FadeFrame(BuffFrame, isInCombat, hasTarget, isNotFullHealth, isCasting, opacityNonCombatBuff)
    end
    
    -- Fade the ChatFrameMenuButton (Chat menu button)
    local chatMenuButton = _G["ChatFrameMenuButton"]
    if chatMenuButton then
        -- Set Chat Menu Button to always be at 20% opacity
        chatMenuButton:SetAlpha(0.2)
    end
    
    -- Fade the Friends Micro Button (Social Button next to the chat)
    local friendsMicroButton = _G["FriendsMicroButton"]
    if friendsMicroButton then
        -- Set Friends Micro Button to always be at 20% opacity
        friendsMicroButton:SetAlpha(0.2)
    end
    
    -- **Modified Section**: Fade the Chat Arrows to always be at 20% opacity
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            local buttonFrame = _G["ChatFrame" .. i .. "ButtonFrame"]
            if buttonFrame then
                local upButton = _G["ChatFrame" .. i .. "ButtonFrameUpButton"]
                local downButton = _G["ChatFrame" .. i .. "ButtonFrameDownButton"]
                local bottomButton = _G["ChatFrame" .. i .. "ButtonFrameBottomButton"]
                
                -- Set the chat buttons to always be at 20% opacity
                if upButton then
                    upButton:SetAlpha(0.2)  -- Always 20% opacity
                end
                if downButton then
                    downButton:SetAlpha(0.2)  -- Always 20% opacity
                end
                if bottomButton then
                    bottomButton:SetAlpha(0.2)  -- Always 20% opacity
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
    
    if command == "set" and (target == "minimap") and value and value >= 1 and value <= 100 then
        opacityNonCombatMinimap = value / 100  -- Convert 1-100 to 0-1
        FadeNonActionBarUI()  -- Trigger fade for minimap
        print("|cff00ff00Minimap|r opacity is now set to |cff00ff00" .. value .. "%\n") 
        
    elseif command == "set" and (target == "actionbars" or target == "actionbar") and value and value >= 1 and value <= 100 then
        AllActionBars = value / 100  -- Convert 1-100 to 0-1
        FadeActionBars()  -- Trigger fade for action bars
        print("|cff00ff00ActionBars|r opacity is now set to |cff00ff00" .. value .. "%\n")
		
    elseif command == "set" and target == "playerframe" and value and value >= 1 and value <= 100 then
        opacityNonCombatPlayerFrame = value / 100  -- Convert 1-100 to 0-1
        FadeNonActionBarUI()   -- Trigger fade for player frame
        print("|cff00ff00PlayerFrame|r opacity is now set to |cff00ff00" .. value .. "%\n")
		
	elseif command == "set" and (target == "buffs" or target == "buff") and value and value >= 1 and value <= 100 then
        opacityNonCombatBuff = value / 100  -- Convert 1-100 to 0-1
        FadeNonActionBarUI()   -- Trigger fade for buff frame
        print("|cff00ff00Buff|r opacity is now set to |cff00ff00" .. value .. "%\n")
        
    elseif command == "reset" then
        -- Reset all to default values
        opacityNonCombatMinimap = 0.2
        AllActionBars = 0.2
        opacityNonCombatPlayerFrame = 0.2
        opacityNonCombatBuff = 0.2
        FadeActionBars()
        FadeNonActionBarUI()
        print("All settings are now |cff00ff00default|r\ = 20% opacity") 
    
    elseif command == "save" then
        print("|cffff0000Save is not possible at the moment. Use a macro to set opacity each time you load the game.|r")
    
    else
        print("|cff00ff00Usage and available commands:|r \n")
        print("/ffu set |cff00ff00minimap|r <value> (value between 1 and 100).\n")
        print("/ffu set |cff00ff00actionbar|r <value> (value between 1 and 100).\n")
        print("/ffu set |cff00ff00playerframe|r <value> (value between 1 and 100).\n")
		print("/ffu set |cff00ff00buff|r <value> (value between 1 and 100).\n")
        print("/ffu |cff00ff00reset|r (default settings).\n")
        print("/ffu |cff00ff00save|r (save settings message).\n")
    end
end

-- Initial fade to set the correct opacity when the addon is loaded
FadeActionBars()
FadeNonActionBarUI()

-- Print a message when the addon is loaded
print("|cff00ff00FadeFrameUI|r is now loaded. Please use |cff00ff00/ffu|r to see more.")
