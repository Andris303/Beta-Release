-- Beta | Emo hub

-- Locals

local bool_use_clickdetector = false -- Use fireclickdetector for equipping gloves
local localplayer = game:GetService("Players").LocalPlayer
local rep_storage = game:GetService("ReplicatedStorage")
local tween_service = game:GetService("TweenService")
local pos_table = { -- Dictionary of all positions and spots ingame
    Arena = {0, -5, 0},
    Lobby = {-997, 328, -2},
    Safespot = {10000, -45, 10000},
    Safespot2 = {-10000, -45, -10000},
    Hitman = {17893, -24, -3548},
    Cannon = {264, 34, 199},
    Slapple = {-403, 51, -15},
    Void = {0, -49999, 0}
}

-- Set hub instance number to break connections

getgenv().BETA_INSTANCE_NUMBER = "BETA_" .. math.random(1000000, 9999999)
local current_instance_number = getgenv().BETA_INSTANCE_NUMBER

-- Load Lib

-- Block instance function

local function block_instance(inst)
    inst.Name = "BlockedInstance_"..math.random(0,500000)
    inst.Parent = game:GetService("LogService")
    inst:Destroy()
end

-- Lib locals

local lib_SPS = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local lib_RS = game:GetService("ReplicatedStorage")
local lib_RF = game:GetService("ReplicatedFirst")

-- Destroy grab function

local function destroy_grab()
    if lib_RF and lib_RF:FindFirstChild("Client") and lib_RF.Client:FindFirstChild("GrabLocal") then
        block_instance(lib_RF.Client.GrabLocal)
    end
end

-- Destroy mobile lib function

local function destroy_mobile_lib()
    if lib_SPS and lib_SPS:FindFirstChild("ClientAnticheat") and lib_SPS.ClientAnticheat:FindFirstChild("AntiMobileExploits") then
        block_instance(lib_SPS.ClientAnticheat.AntiMobileExploits)
        block_instance(lib_SPS.ClientAnticheat)
    end
end

-- Hook block function

local function init_hook(baad_table, baad_insts, bool_sr)
    if hookmetamethod and getnamecallmethod then
        local Namecall
        Namecall = hookmetamethod(game, "__namecall", function(self, ...)
            local t = tostring(self)
            if bool_sr then
                if getnamecallmethod() == "FireServer" and (t == "Ban" or t == "WalkSpeedChanged" or t == "WS" or t == "WS2") then return end
            else
                if getnamecallmethod() == "FireServer" and (t == "Ban" or t == "WalkSpeedChanged" or t == "AdminGUI" or t == "GRAB" or t == "SpecialGloveAccess") then return end
            end
            return Namecall(self, ...)
        end)
    else
        local events = lib_RS.Events
        for _, inst in pairs(baad_table) do
            if baad_insts:FindFirstChild(inst) then
                block_instance(baad_insts[inst])
            end
        end
    end
    destroy_grab()
    destroy_mobile_lib()
end

-- Runs init_hook how it should in each place

if game.PlaceId == 9431156611 then
    init_hook({"Ban", "WS", "AdminGUI", "WS2"}, lib_RS.Events, true)
elseif game.PlaceId == 11520107397 or game.PlaceId == 9015014224 or game.PlaceId == 6403373529 or game.PlaceId == 124596094333302 then
    init_hook({"Ban", "WalkSpeedChanged", "AdminGUI", "GRAB", "SpecialGloveAccess"}, lib_RS, false)
end

-- Load Rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Emo Hub",
   Icon = "banana",
   LoadingTitle = "Emo Hub",
   LoadingSubtitle = "by EmoSad999",
   ShowText = "Emo Hub",
   Theme = "Amethyst",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Beta"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Simply notify the user through rayfield

local function notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 6.5,
        Image = 4483362458,
    })
end

-- Runs functions on a different thread

local function run(...)
    task.spawn(...)
end

-- Reset velocity

local function reset_vel()
    localplayer.Character.PrimaryPart.Velocity = Vector3.zero
	localplayer.Character.PrimaryPart.RotVelocity = Vector3.zero
end

-- Basic root position changing

local function tp(x, y, z)
    if localplayer.Character:FindFirstChild("HumanoidRootPart") then -- if root is present
        local root = localplayer.Character.HumanoidRootPart
        root.CFrame = CFrame.new(x, y, z)
        run(reset_vel)
    end
end

if game.PlaceId == 6403373529 then -- check if were in main slap battles

-- Safespot create function

local function create_safespot(name, bool_bob, posx, posy, posz)
    local Safespot = Instance.new("Part",workspace)
    Safespot.Name = "name"
    Safespot.Position = Vector3.new(posx,posy,posz)
    Safespot.Size = Vector3.new(5000,10,5000)
    Safespot.Anchored = true
    Safespot.CanCollide = true
    Safespot.Transparency = .5
    if bool_bob then Safespot.CollisionGroup = "Bobstuff" end
end

-- Code

-- Checks if NIE is setup, if it isn't, it sets NIE up (Network Instance Equipping)

local function setup_NIE()
    if getgenv().BETA_NIE_INSTANCE then -- checks if NIE is already setup
        notify("NIE setup successful", "NIE setup has been successful")
        return
    end

    workspace.Lobby.Teleport1.Parent = rep_storage
    workspace.Lobby.Teleport2.Parent = rep_storage

    local network_folder
    if rep_storage:FindFirstChild("_NETWORK") then
        network_folder = rep_storage["_NETWORK"]
    else
        for _, inst in pairs(rep_storage:GetChildren()) do
            if string.match(inst.Name, "{") then
                network_folder = inst
            end
        end
    end
    local current_glove = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
    local glove_to_equip = "bus"

    for _, inst in pairs(network_folder:GetChildren()) do
        if string.match(inst.Name, "{") and inst.ClassName == "RemoteEvent" then -- checks if instance is a network instance
            inst:FireServer(glove_to_equip)
            task.wait(.3)
            if localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == glove_to_equip then
                getgenv().BETA_NIE_INSTANCE = inst
                rep_storage.Teleport1.Parent = workspace.Lobby
                rep_storage.Teleport2.Parent = workspace.Lobby
                inst:FireServer(current_glove)
                notify("NIE setup successful", "NIE setup has been successful")
                return
            end
        end
    end
    rep_storage.Teleport1.Parent = workspace.Lobby
    rep_storage.Teleport2.Parent = workspace.Lobby

    bool_use_clickdetector = true

    notify("NIE setup failure", "Features using NIE will not work")
end

-- Main equip function, if fails to equip, then returns

local function equip(glove)
    if localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == glove then return end -- if glove is equipped already, return

    if getgenv().BETA_NIE_INSTANCE and not bool_use_clickdetector then
        getgenv().BETA_NIE_INSTANCE:FireServer(glove)
        task.wait(.1)
        if localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == glove then
            return
        else
            use_NIE = false
        end
    elseif bool_use_clickdetector then
        fireclickdetector(workspace.Lobby:FindFirstChild(glove).ClickDetector)
    else
        notify("NIE not setup", "Features using NIE won\'t work")
    end
end

-- Initialize setup_NIE()

run(function()
    if not localplayer.Character.isInArena.Value or getgenv().BETA_NIE_INSTANCE then
        run(setup_NIE)
        return
    end
    notify("NIE setup halted", "NIE setup will be halted until you are in the lobby")
    workspace.ChildAdded:Connect(function(child)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
        task.wait()
        if child.Name == localplayer.Name then
            repeat task.wait()
            until localplayer.Character.isInArena.Value == false
            run(setup_NIE)
            return
        end
    end)
end)

-- Create Safespot

if workspace:FindFirstChild("Safespot") == nil then
    run(create_safespot, "Safespot", false, 10000, -50, 10000)
    run(create_safespot, "Bobspot", true, 10000, -50, 10000) -- Also create a duplicate so rob doesn't fall through the baseplate :)
end

if workspace:FindFirstChild("Safespot2") == nil then
    run(create_safespot, "Safespot2", false, -10000, -50, -10000)
    run(create_safespot, "Bobspot2", true, -10000, -50, -10000) -- Also create a duplicate so rob doesn't fall through the baseplate :)
end

-- Replace barzil with fake (anti barzil)

for _, inst in pairs(workspace.Lobby.brazil:GetChildren()) do
    inst:Destroy()
end

local fake_barzil = Instance.new("Part", workspace)
fake_barzil.Name = "fake_barzil"
fake_barzil.Position = Vector3.new(-924, 304.53, -1.9)
fake_barzil.Rotation = Vector3.new(-90, 0, 90)
fake_barzil.Size = Vector3.new(24, 28, 4)
fake_barzil.Anchored = true
fake_barzil.CanCollide = true
fake_barzil.Transparency = .5

-- Create Tabs

local Misc = Window:CreateTab("Misc")

local Target = Window:CreateTab("Target")

local Abuse = Window:CreateTab("Abuse")

local Glove = Window:CreateTab("Glove")

local Helper = Window:CreateTab("Helper")

-- Create elements in tabs

-- Misc

Misc:CreateDivider()

-- Text box for equipping gloves

local equip_text_box = Misc:CreateInput({
    Name = "Glove",
    CurrentValue = "",
    PlaceholderText = "Eg: Default",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) end,
})

-- Button for equipping gloves

local equip_button = Misc:CreateButton({
    Name = "Equip Glove",
    Callback = function()
        run(equip, equip_text_box.CurrentValue)
    end,
})

-- Forward declare reset_TP_dropdown

local reset_TP_dropdown

-- TP dropdown

local TP_dropdown = Misc:CreateDropdown({
    Name = "Teleport",
    Options = {"Safespot","Arena","Hitman","Lobby","Cannon","Slapple"},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Options)
        if Options[1] == "None" then return end
        run(tp, table.unpack(pos_table[Options[1]]))
        run(reset_TP_dropdown)
    end,
})

-- reset_TP_dropdown is here now

function reset_TP_dropdown()
    TP_dropdown:Set({"None"})
end

-- Toggle death barriers

local remove_death_barriers_toggle = Misc:CreateToggle({
    Name = "Remove death barriers",
    CurrentValue = false,
    Callback = function(Value)
        local bad_boy_table = {"AntiDefaultArena", "Antidream", "ArenaBarrier", "DEATHBARRIER", "DEATHBARRIER2", "dedBarrier"}
        for _, inst in pairs(bad_boy_table) do
            if Value then
                workspace[inst].Parent = rep_storage
            else
                rep_storage[inst].Parent = workspace
            end
        end
    end,
})

-- Locals for saving between features

local bool_auto_enter = false
local bool_equip_saved_glove_grab = false
local grab_glove_save
local bool_help_kill = false
local target_help

-- Auto enter arena

local auto_enter_arena = Misc:CreateToggle({
    Name = "Auto enter arena",
    CurrentValue = false,
    Callback = function(Value)
        if not localplayer.Character.isInArena.Value then
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        end
        bool_auto_enter = Value
    end,
})

-- Used by auto enter arena watch for change
-- Used by grab barzil to change gloves after reset
-- Used by kill farm help
-- Used by farm run mastery

run(function()
    workspace.ChildAdded:Connect(function(child)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end

        task.wait(.1)

        if child.Name ~= localplayer.Name then return end

        if bool_auto_enter then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value
        end
        if bool_equip_saved_glove_grab then
            task.wait(.5)

            for c = 0, 10, 1 do
                run(equip, grab_glove_save)
                task.wait(.1)

                if localplayer.leaderstats.Glove.Value == grab_glove_save then break end
            end
        end
        if bool_help_kill then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value

            localplayer.Character:WaitForChild("HumanoidRootPart").CFrame = game:GetService("Players")[target_help].Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-4) -- Teleport to target slightly forward
            
            task.wait(.4)

            localplayer.Reset:FireServer()
        end
    end)
end)

-- Descendant added for workspace because rob mas help is very stupid

run(function()
    workspace.DescendantAdded:Connect(function(descendant)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end

        if target_help == nil then return end

        task.wait(.1)

        if workspace:FindFirstChild(target_help) and descendant.Name == "RobTransformed" then
            if descendant.Parent == workspace[target_help] and bool_ready_rob then
                task.wait(2.8)

                local root = workspace[target_help]:WaitForChild("HumanoidRootPart")
                run(tp, root.Position.X, root.Position.Y, root.Position.Z)
            end
        end
    end)
end)

Misc:CreateDivider()

-- Target

Target:CreateDivider()

-- Dynamic playerlist

local playerlist_dropdown = Target:CreateDropdown({
    Name = "Select player",
    Options = {"Loading..."},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Options)
        -- Empty
    end,
})

-- Function to update playerlist

local function update_playerlist()
    local playerlist_table = {}
    local table_counter = 1
    for _, inst in pairs(game:GetService("Players"):GetChildren()) do
        if inst.Name ~= localplayer.Name then
            playerlist_table[table_counter] = inst.DisplayName .. " (" .. inst.Name .. ")"
            table_counter = table_counter + 1
        end
    end
    playerlist_dropdown:Refresh(playerlist_table)
end

-- Initialize playerlist

run(update_playerlist)

-- Watch for change in playerlist

game:GetService("Players").ChildAdded:Connect(function(_unused)
    if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
    run(update_playerlist)
end)

game:GetService("Players").ChildRemoved:Connect(function(_unused)
    if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
    run(update_playerlist)
end)

-- Kill selected player with rob

local molest = Target:CreateButton({
    Name = "Molest™",
    Callback = function()
        local glove_save = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Molest doesn\'t work in arena")
            return
        end

        local _unused, target_name = string.match(playerlist_dropdown.CurrentOption[1], "(.+)%s%((.+)%)")

        if not game:GetService("Players")[target_name].Character:WaitForChild("isInArena").Value then
            notify("Target not in lobby", "Molest doesn\'t work when target is in lobby")
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Safespot)) -- TP to safespot

        run(equip, "rob") -- Equip rob

        task.wait(.05)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "rob" then return end -- If equip failed then return

        rep_storage.rob:FireServer(false) -- Use ability

        task.wait(.05)

        run(equip, glove_save) -- Change back to previous glove

        task.wait(3.5) -- Wait until animation finishes

        if not game:GetService("Players")[target_name].Character.isInArena.Value or game:GetService("Players")[target_name].Character:WaitForChild("Humanoid").Health == 0 then
            notify("Target died", "Target died before rob animation finished")
            localplayer.Reset:FireServer()
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        local target_root = game:GetService("Players")[target_name].Character.HumanoidRootPart
        local target_position = {target_root.Position.X, target_root.Position.Y, target_root.Position.Z}

        run(tp, table.unpack(target_position)) -- Teleports to target's position

        task.wait(.2)

        run(tp, table.unpack(pos_table.Safespot)) -- TP back to safespot

        task.wait(.1)

        run(tp, table.unpack(pos_table.Safespot2)) -- TP to safespot2 to avoid suspicion

        task.wait(.3)

        localplayer.Reset:FireServer() -- Reset

        -- Setup changing gloves when respawning

        bool_equip_saved_glove_grab = true
        grab_glove_save = glove_save
    end,
})

-- Teleport selected player to barzil with grab glove

local grab_barzil = Target:CreateButton({
    Name = "Banish to barzil",
    Callback = function()
        local glove_save = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Grab barzil doesn\'t work in arena")
            return
        end

        local _unused, target_name = string.match(playerlist_dropdown.CurrentOption[1], "(.+)%s%((.+)%)")

        if not game:GetService("Players")[target_name].Character:WaitForChild("isInArena").Value then
            notify("Target not in lobby", "Grab barzil doesn\'t work when target is in lobby")
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Safespot)) -- TP to safespot

        run(equip, "Ghost") -- Equip ghost

        task.wait(.11)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Ghost" then return end -- If equip failed then return

        rep_storage.Ghostinvisibilityactivated:FireServer() -- Become invisible

        task.wait(.1)

        run(equip, "Grab") -- Equip grab

        task.wait(.1)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Grab" then return end -- If equip failed then return

        if not game:GetService("Players")[target_name].Character.isInArena.Value or game:GetService("Players")[target_name].Character:WaitForChild("Humanoid").Health == 0 then
            notify("Target died", "Target died before rob animation finished")
            localplayer.Reset:FireServer()
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Lobby))

        task.wait(.11)

        repeat
            task.wait(.01)
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        until localplayer.Character.isInArena.Value

        task.wait(.05)

        local target_root = game:GetService("Players")[target_name].Character.HumanoidRootPart
        localplayer.Character.HumanoidRootPart.CFrame = target_root.CFrame * CFrame.new(0,0,1) -- Teleport to target slightly behind

        fake_barzil.CanCollide = false -- Disable collision on fake barzil

        task.wait(.08)

        rep_storage.GeneralAbility:FireServer() -- Grab target

        task.wait(.1)

        run(tp, -925, 308, -2) -- TP to barzil portal

        task.wait(.4)

        localplayer.Reset:FireServer() -- Reset

        fake_barzil.CanCollide = true -- Enable collision on fake barzil

        bool_equip_saved_glove_grab = true
        grab_glove_save = glove_save

        task.wait(4.5)

        bool_equip_saved_glove_grab = false
        grab_glove_save = nil
    end,
})

Target:CreateDivider()

-- Abuse

Abuse:CreateDivider()

-- Spam "flamesloop" sounds

sound_spam = Abuse:CreateToggle({
    Name = "Sound spam",
    CurrentValue = false,
    Callback = function(Value)
        -- Empty
    end,
})

run(function()
    while true do
        if sound_spam.CurrentValue then
            rep_storage.PlaySoundRemote:InvokeServer("FlamesLoop", localplayer.Character:WaitForChild("HumanoidRootPart"))
            task.wait()
        else
            task.wait(.1)
        end
    end
end)

-- Lag server by spamming slapstick abilities, reset to stop

local lag_server = Abuse:CreateButton({
    Name = "Lag of doom and destruction",
    Callback = function()
        tp(table.unpack(pos_table.Safespot))

        task.wait(.2)

        -- Don't lag ourself :)

        localplayer.Character.ChildAdded:Connect(function(child)
            if child.Name == "runblur" then
                task.wait(.1)
                child:Destroy()
            end
        end)

        while true do
            if localplayer.Character.Humanoid.Health == 0 then break end

            rep_storage.slapstick:FireServer("runeffect")

            task.wait()
        end
    end,
})

Abuse:CreateDivider()

-- Gloves

Glove:CreateDivider()

-- Auto click your own tycoon

-- locals to trick my own code lmao

local auto_click = {CurrentValue = nil}
local auto_destroy = {CurrentValue = nil}

-- function to auto click specific tycoon

local function auto_click_tycoon(inst)
    task.wait(.2)

    if not inst:FindFirstChild("Click") or not auto_click.CurrentValue then return end

    local clicky = inst:WaitForChild("Click"):WaitForChild("ClickDetector")

    while true do
        task.wait()
        if not inst:FindFirstChild("Click") or not auto_click.CurrentValue then break end
        fireclickdetector(clicky)
    end
end

-- function to destroy specific tycoon

local function destroy_tycoon(inst)
    task.wait(.2)

    if not inst:FindFirstChild("Destruct") or not auto_destroy.CurrentValue then return end

    local destructy = inst:WaitForChild("Destruct"):WaitForChild("ClickDetector")
    local counter = inst:WaitForChild("Counter"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel")

    if tonumber(counter.Text) < 499 then
        fireclickdetector(destructy)
    else
        repeat
            task.wait()
            fireclickdetector(destructy)
        until inst.SDCounter.Counter.SurfaceGui.TextLabel.Text == "100"
    end
end

-- auto click tycoons toggle

auto_click = Glove:CreateToggle({
    Name = "Auto click tycoon",
    CurrentValue = false,
    Callback = function(Value)
        if workspace:FindFirstChild("\195\133Tycoon" .. localplayer.Name) then
            run(auto_click_tycoon, workspace:FindFirstChild("\195\133Tycoon" .. localplayer.Name))
        end
    end,
})

-- Auto destroy tycoons toggle

auto_destroy = Glove:CreateToggle({
    Name = "Auto destroy tycoons",
    CurrentValue = false,
    Callback = function(Value)
        for _, inst in pairs(workspace:GetChildren()) do
            if string.match(inst.Name, "\195\133Tycoon") and inst.Name ~= "\195\133Tycoon" .. localplayer.Name then
                run(destroy_tycoon, inst)
            end
        end
    end,
})

-- Function to find tycoons to click in a good or avery dark and twisted way

run(function()
    workspace.ChildAdded:Connect(function(child)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
        task.wait(.1)
        if child.Name == "\195\133Tycoon" .. localplayer.Name then
            if auto_click.CurrentValue then
                run(auto_click_tycoon, child)
            end
        end
        if string.match(child.Name, "\195\133Tycoon") and child.Name ~= "\195\133Tycoon" .. localplayer.Name  then
            if auto_destroy.CurrentValue then
                run(destroy_tycoon, child)
            end
        end
    end)
end)

-- 100 times more powerful jet ability

jet_powered_fan = Glove:CreateToggle({
    Name = "JET POWERED FAN",
    CurrentValue = false,
    Callback = function(Value)
        if Value then run(equip, "Fan") end
    end,
})

run(function()
    while true do
        if jet_powered_fan.CurrentValue then
            rep_storage:WaitForChild("GeneralAbility"):FireServer()
            task.wait()
        else
            task.wait(.1)
        end
    end
end)

Glove:CreateDivider()

-- Helper

Helper:CreateDivider()

-- Text box to select player

local select_player_textbox = Helper:CreateInput({
    Name = "Player to help",
    CurrentValue = "",
    PlaceholderText = "Eg: BaconHair123",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        target_help = Text
    end,
})

local help_farm_kill_toggle = Helper:CreateToggle({
    Name = "Help player farm kills",
    CurrentValue = false,
    Callback = function(Value)
        bool_help_kill = Value

        if Value and not localplayer.Character.isInArena.Value then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value

            localplayer.Character:WaitForChild("HumanoidRootPart").CFrame = game:GetService("Players")[target_help].Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-4) -- Teleport to target slightly forward
            
            task.wait(.4)

            localplayer.Reset:FireServer()
        end
    end,
})

-- Forward declare reset_bring_dropdown

local reset_bring_dropdown

-- Bring selected player to a location

local bring_location_dropdown = Helper:CreateDropdown({
    Name = "Bring player to location",
    Options = {"Hitman","Void","Cannon","Slapple","Lobby","Arena"},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Options)
        if Options[1] == "None" then return end

        run(reset_bring_dropdown)

        local glove_save = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Grab doesn\'t work in arena")
            return
        end

        local target_name = target_help

        if not game:GetService("Players")[target_name].Character:WaitForChild("isInArena").Value then
            notify("Target not in lobby", "Grab doesn\'t work when target is in lobby")
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Safespot)) -- TP to safespot

        run(equip, "Ghost") -- Equip ghost

        task.wait(.11)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Ghost" then return end -- If equip failed then return

        rep_storage.Ghostinvisibilityactivated:FireServer() -- Become invisible

        task.wait(.1)

        run(equip, "Grab") -- Equip grab

        task.wait(.1)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Grab" then return end -- If equip failed then return

        if not game:GetService("Players")[target_name].Character.isInArena.Value or game:GetService("Players")[target_name].Character:WaitForChild("Humanoid").Health == 0 then
            notify("Target died", "Target died before rob animation finished")
            localplayer.Reset:FireServer()
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Lobby))

        task.wait(.11)

        repeat
            task.wait(.01)
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        until localplayer.Character.isInArena.Value

        task.wait(.05)

        local target_root = game:GetService("Players")[target_name].Character.HumanoidRootPart
        localplayer.Character.HumanoidRootPart.CFrame = target_root.CFrame * CFrame.new(0,0,3) -- Teleport to target slightly behind

        task.wait(.08)

        rep_storage.GeneralAbility:FireServer() -- Grab target

        task.wait(.1)

        run(tp, table.unpack(pos_table[Options[1]])) -- TP to location

        task.wait(.4)

        localplayer.Reset:FireServer() -- Reset

        bool_equip_saved_glove_grab = true
        grab_glove_save = glove_save

        task.wait(4.5)

        bool_equip_saved_glove_grab = false
        grab_glove_save = nil
    end,
})

-- reset_bring_dropdown is here now

function reset_bring_dropdown()
    bring_location_dropdown:Set({"None"})
end

Helper:CreateDivider()

elseif game.PlaceId == 126509999114328 then -- If game is 99 nights in the forst

-- Locals

local bool_kill_aura = false
local bool_auto_eat = false
local bool_loop_ws = false
local bool_instantpp = false
local campfire = workspace.Map.Campground.MainFire
local hitreg_id = "1_" .. math.abs(localplayer.UserId)

-- Litification

run(function()
    local main_fire = workspace.Map.Campground.MainFire.Center
    local fire = main_fire.FireAttach.Fire
    local craft_pp = workspace.Map.Campground.CraftingBench.TouchZone.ProximityAttachment.ProximityInteraction
    local notice_board = workspace.Map.Campground.NoticeBoard

    craft_pp.HoldDuration = 0

    fire.Acceleration = Vector3.new(0, 10, 0)
    fire.Rate = 100
    fire.Speed = NumberRange.new(10, 10)
    fire.SpreadAngle = Vector2.new(180, 180)

    notice_board.Title.SurfaceGui.ItemName.Text = "The humble sign"

    while true do
        main_fire.BillboardGui.Frame.TextLabel.Text = "The humble campfire"
        task.wait()
    end
end)

-- Create Tabs

local Main = Window:CreateTab("Main")

local Items = Window:CreateTab("Items")

local Movement = Window:CreateTab("Movement")

-- Create elements in tabs

-- Main

-- Converts seconds to a readable minute : second format

local function sec_to_min(seconds)
    if seconds == 0 then return "Transitioning..." end

    local sec

    if seconds % 60 < 10 then
        sec = "0" .. seconds % 60
    else
        sec = seconds % 60
    end
    
    return math.floor(seconds / 60) .. ":" .. sec
end

-- Get first part of the string needed for info

local function get_first_string(string)
    if string == "Day" then return "Time left until night: " end
    if string == "Night" then return "Time left until day: " end
end

local function return_icon(string)
    if string == "Day" then return "sun" end
    if string == "Night" then return "moon" end
end

Main:CreateDivider()

local main_label_seconds = Main:CreateLabel(get_first_string(workspace:GetAttribute("State")) .. sec_to_min(workspace:GetAttribute("SecondsLeft")), return_icon(workspace:GetAttribute("State")), Color3.fromRGB(0, 0, 0), false)

local main_label_fire = Main:CreateLabel("Campfire fuel: " .. math.floor(campfire:GetAttribute("FuelRemaining") / campfire:GetAttribute("FuelTarget") * 100) .. "%", "flame-kindling", Color3.fromRGB(0, 0, 0), false)

local items_label_seconds = Items:CreateLabel(get_first_string(workspace:GetAttribute("State")) .. sec_to_min(workspace:GetAttribute("SecondsLeft")), return_icon(workspace:GetAttribute("State")), Color3.fromRGB(0, 0, 0), false)

local items_label_fire = Items:CreateLabel("Campfire fuel: " .. math.floor(campfire:GetAttribute("FuelRemaining") / campfire:GetAttribute("FuelTarget") * 100) .. "%", "flame-kindling", Color3.fromRGB(0, 0, 0), false)

local movement_label_seconds = Movement:CreateLabel(get_first_string(workspace:GetAttribute("State")) .. sec_to_min(workspace:GetAttribute("SecondsLeft")), return_icon(workspace:GetAttribute("State")), Color3.fromRGB(0, 0, 0), false)

local movement_label_fire = Movement:CreateLabel("Campfire fuel: " .. math.floor(campfire:GetAttribute("FuelRemaining") / campfire:GetAttribute("FuelTarget") * 100) .. "%", "flame-kindling", Color3.fromRGB(0, 0, 0), false)

workspace.AttributeChanged:Connect(function(change)
    if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end

    main_label_seconds:Set(get_first_string(workspace:GetAttribute("State")) .. sec_to_min(workspace:GetAttribute("SecondsLeft")), return_icon(workspace:GetAttribute("State")), Color3.fromRGB(0, 0, 0), false)
    items_label_seconds:Set(get_first_string(workspace:GetAttribute("State")) .. sec_to_min(workspace:GetAttribute("SecondsLeft")), return_icon(workspace:GetAttribute("State")), Color3.fromRGB(0, 0, 0), false)
    movement_label_seconds:Set(get_first_string(workspace:GetAttribute("State")) .. sec_to_min(workspace:GetAttribute("SecondsLeft")), return_icon(workspace:GetAttribute("State")), Color3.fromRGB(0, 0, 0), false)
end)

campfire.AttributeChanged:Connect(function(change)
    if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end

    main_label_fire:Set("Campfire fuel: " .. math.floor(campfire:GetAttribute("FuelRemaining") / campfire:GetAttribute("FuelTarget") * 100) .. "%", "flame-kindling", Color3.fromRGB(0, 0, 0), false)
    items_label_fire:Set("Campfire fuel: " .. math.floor(campfire:GetAttribute("FuelRemaining") / campfire:GetAttribute("FuelTarget") * 100) .. "%", "flame-kindling", Color3.fromRGB(0, 0, 0), false)
    movement_label_fire:Set("Campfire fuel: " .. math.floor(campfire:GetAttribute("FuelRemaining") / campfire:GetAttribute("FuelTarget") * 100) .. "%", "flame-kindling", Color3.fromRGB(0, 0, 0), false)
end)

local tp_campfire = Main:CreateButton({
    Name = "Teleport to campfire",
    Callback = function()
        run(tp, 0, 10, 0)
    end
})

local open_chests = Main:CreateButton({
    Name = "Open chests",
    Callback = function()
        -- teleport to all chunks in the world

        local range = 1400 -- workspace:GetAttribute("MapRange")

        local pos1 = range * -1
        local pos2 = range * -1

        local continue = true

        -- Start loading map

        while continue do
            if pos1 >= range and pos2 >= range then
                continue = false
            end

            run(tp, pos1, 60, pos2)

            if pos1 < range then
                pos1 = pos1 + 200
            elseif pos1 >= range then
                pos1 = range * -1
                pos2 = pos2 + 200
            end

            task.wait(.05)

            -- After we loaded some chunks, check for unopened chests again

            for _, inst in pairs(workspace.Items:GetChildren()) do
                if inst then
                    if string.match(inst.Name, "Item Chest") and inst:FindFirstChild("Main") then
                        if inst.Main:FindFirstChild("ProximityAttachment") then
                            run(tp, inst.Main.Position.X, inst.Main.Position.Y, inst.Main.Position.Z)

                            task.wait()

                            fireproximityprompt(inst.Main.ProximityAttachment.ProximityInteraction)
                        end
                    end
                end
            end
        end

        run(tp, 0, 10, 0)
    end
})

local kill_aura = Main:CreateToggle({
    Name = "Cultist kill aura",
    CurrentValue = false,
    Callback = function(Value)
        bool_kill_aura = Value
    end
})

local auto_eat = Main:CreateToggle({
    Name = "Auto eat",
    CurrentValue = false,
    Callback = function(Value)
        bool_auto_eat = Value
    end
})

local no_fog = Main:CreateButton({
    Name = "No fog + Fullbright",
    Callback = function()
        getgenv().beta_bool_no_fog = true
    end
})

Main:CreateDivider()

-- Items

Items:CreateDivider()

local place_fuel = Items:CreateButton({
    Name = "Place fuel",
    Callback = function()
        local sack = localplayer.Inventory:FindFirstChild("Old Sack") or localplayer.Inventory:FindFirstChild("Good Sack") or localplayer.Inventory:FindFirstChild("Giant Sack")
        local target
        local temp_table = {}

        local function foo(target_fuel)
            for _, inst in pairs(workspace.Items:GetChildren()) do
                if inst.Name == target_fuel then
                    table.insert(temp_table, inst)
                end
            end
            target = temp_table[math.random(1, #temp_table)]
        end

        if workspace.Items:FindFirstChild("Oil Barrel") then
            run(foo, "Oil Barrel")
        elseif workspace.Items:FindFirstChild("Fuel Canister") then
            run(foo, "Fuel Canister")
        elseif workspace.Items:FindFirstChild("Coal") then
            run(foo, "Coal")
        else return end

        run(tp, target:GetPivot().X, target:GetPivot().Y, target:GetPivot().Z)

        task.wait(.2)

        rep_storage.RemoteEvents.RequestBagStoreItem:InvokeServer(sack, target)

        task.wait(.05)

        rep_storage.RemoteEvents.RequestBagStoreItem:InvokeServer(sack, target)

        task.wait(.05)

        rep_storage.RemoteEvents.RequestBagStoreItem:InvokeServer(sack, target)

        task.wait(.2)

        run(tp, 0, 10, 0)

        task.wait(.3)

        if target.Parent == workspace.Items then return end

        target:SetAttribute("LastOwner", localplayer.UserId)
        target:SetAttribute("LastDropTime", time())
        target:PivotTo(localplayer.Character.HumanoidRootPart.CFrame)
        target.Parent = workspace.Items

        rep_storage.RemoteEvents.RequestBagDropItem:FireServer(sack, target)
    end
})

local get_armor = Items:CreateButton({
    Name = "Get armor",
    Callback = function()
        local target

        if workspace.Items:FindFirstChild("Thorn Body") then
            target = workspace.Items:FindFirstChild("Thorn Body")
        elseif workspace.Items:FindFirstChild("Iron Body") then
            target = workspace.Items:FindFirstChild("Iron Body")
        elseif workspace.Items:FindFirstChild("Leather Body") then
            target = workspace.Items:FindFirstChild("Leather Body")
        else return end

        run(tp, target:GetPivot().X, target:GetPivot().Y, target:GetPivot().Z)

        task.wait(.2)

        rep_storage.RemoteEvents.RequestEquipArmour:InvokeServer(target)

        task.wait(.05)

        rep_storage.RemoteEvents.RequestEquipArmour:InvokeServer(target)

        task.wait(.05)

        rep_storage.RemoteEvents.RequestEquipArmour:InvokeServer(target)

        task.wait(.2)

        run(tp, 0, 10, 0)
    end
})

local get_melee = Items:CreateButton({
    Name = "Get melee weapon",
    Callback = function()
        local target

        if workspace.Items:FindFirstChild("Morningstar") then
            target = workspace.Items:FindFirstChild("Morningstar")
        elseif workspace.Items:FindFirstChild("Spear") then
            target = workspace.Items:FindFirstChild("Spear")
        elseif workspace.Items:FindFirstChild("Strong Axe") then
            target = workspace.Items:FindFirstChild("Strong Axe")
        elseif workspace.Items:FindFirstChild("Good Axe") then
            target = workspace.Items:FindFirstChild("Good Axe")
        else return end

        run(tp, target:GetPivot().X, target:GetPivot().Y, target:GetPivot().Z)

        task.wait(.2)

        rep_storage.RemoteEvents.PLACEHOLDER:InvokeServer(target)

        task.wait(.05)

        rep_storage.RemoteEvents.PLACEHOLDER:InvokeServer(target)

        task.wait(.05)

        rep_storage.RemoteEvents.PLACEHOLDER:InvokeServer(target)

        task.wait(.2)

        run(tp, 0, 10, 0)
    end
})

Items:CreateDivider()

-- Movement

Movement:CreateDivider()

local loop_ws = Movement:CreateToggle({
    Name = "+ 84 walkspeed",
    CurrentValue = false,
    Callback = function(Value)
        bool_loop_ws = Value
        if not Value then
            localplayer.Character.Humanoid.WalkSpeed = 16
        end
    end,
})

getgenv().beta_bool_no_debuff = false

local no_debuff = Movement:CreateToggle({
    Name = "Sprint without hunger debuff",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().beta_bool_no_debuff = Value
    end,
})

local instantpp = Movement:CreateToggle({
    Name = "Instant Proximity Prompts",
    CurrentValue = false,
    Callback = function(Value)
        bool_instantpp = Value
    end,
})

if current_instance_number == getgenv().BETA_INSTANCE_NUMBER then
    local no_debuff_hook_old
    no_debuff_hook_old = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "FireServer" and self == rep_storage.RemoteEvents.PlayerSprinting and getgenv().beta_bool_no_debuff then
            return nil
        end
        return no_debuff_hook_old(self, ...)
    end)
end

Movement:CreateDivider()

run(function()
    while true do
        if getgenv().beta_bool_no_fog then
            -- fullbright + lighting based no fog

            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)

            -- Destroy fog parts in workspace

            if workspace.Map.Boundaries:FindFirstChild("Part") then
                for _, inst in pairs(workspace.Map.Boundaries:GetChildren()) do
                    if inst.Name == "Part" then
                        inst:Destroy()
                    end
                end
            end
        end

        task.wait()
    end
end)

run(function()
    while true do
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then break end

        if bool_loop_ws then
            localplayer.Character.Humanoid.WalkSpeed = 100
        end

        task.wait()
    end
end)

run(function()
    while true do
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then break end

        if bool_kill_aura then
            local weapon
            local highest_dmg = 0

            for _, inst in pairs(localplayer.Inventory:GetChildren()) do
                if inst:GetAttribute("WeaponDamage") then
                    if highest_dmg < inst:GetAttribute("WeaponDamage") then
                        highest_dmg = inst:GetAttribute("WeaponDamage")
                        weapon = inst
                    end
                end
            end

            for _, inst in pairs(workspace.Characters:GetChildren()) do
                if (inst.Name == "Cultist" or inst.Name == "Crossbow Cultist" or inst.Name == "Juggernaut Cultist") and inst:FindFirstChild("HumanoidRootPart") then
                    if (inst.HumanoidRootPart.Position - localplayer.Character.HumanoidRootPart.Position).Magnitude <= 200 then
                        rep_storage.RemoteEvents.ToolDamageObject:InvokeServer(inst, weapon, hitreg_id, localplayer.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end

        task.wait(.05)
    end
end)

run(function()
    while true do
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then break end

        if bool_auto_eat then
            local missing_hunger = 200 - localplayer:GetAttribute("Hunger")

            local function consume(inst)
                if not (inst:FindFirstChildWhichIsA("MeshPart") or inst:FindFirstChildWhichIsA("Part")) then return end

                local main = inst:FindFirstChildWhichIsA("MeshPart") or inst:FindFirstChildWhichIsA("Part")

                if (main.Position - localplayer.Character.HumanoidRootPart.Position).Magnitude <= 60 then
                    missing_hunger = missing_hunger - inst:GetAttribute("RestoreHunger")

                    rep_storage.RemoteEvents.RequestConsumeItem:InvokeServer(inst)
                end
            end

            for _, inst in pairs(workspace.Items:GetChildren()) do
                if inst:GetAttribute("RestoreHunger") and not inst:GetAttribute("SpeedBoost") then
                    if inst:GetAttribute("RestoreHealth") then
                        if inst:GetAttribute("RestoreHealth") > 0 and inst:GetAttribute("RestoreHunger") < missing_hunger then
                            run(consume, inst)
                        end
                    elseif inst:GetAttribute("RestoreHunger") < missing_hunger then
                        run(consume, inst)
                    end
                end
            end
        end

        task.wait(.1)
    end
end)

game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(inst)
    if bool_instantpp then
	    fireproximityprompt(inst)
    end
end)

else -- If game isn't slap battles

local Main = Window:CreateTab("Main")

Main:CreateDivider()

local tp_main = Main:CreateButton({
    Name = "Habibi what game are you in",
    Callback = function()
        notify("What", "???????")
    end
})

Main:CreateDivider()

end
