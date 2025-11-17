-- Beta | Emo Hub
-- REWRITE

-- Locals

print("Loading beta...")

local localplayer = game:GetService("Players").LocalPlayer
local rep_storage = game:GetService("ReplicatedStorage")
local tween_service = game:GetService("TweenService")
local prox_service = game:GetService("ProximityPromptService")
local genv = getgenv()

local rayfield = {} -- Rayfield object
local main = {} -- Main object

-- Basic functions

local function random_string() -- Returns a random 20 character long string
    local characters = {
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "/", "*", "!", "?", "#", "_", "%", ":", "$", "@", ";", ".", ",", "<", ">", "|", "~", "+", "=", "(", ")", "{", "}", "&", "[", "]"
    }
    local output = ""

    for c = 1, 20 do
        output = output .. characters[math.random(1, #characters)]
    end


    return output
end

local function name_icon() -- Gives name and icon for rayfield window based on game
    if game.PlaceId == 126509999114328 then
        return "99 Nights in the Forest", "flame-kindling"
    end

    return "Beta", "crown"
end

local function run(...) -- Runs functions on a different thread
    task.spawn(...)
end

local function reset_vel() -- Reset velocity
    localplayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.zero
	localplayer.Character:WaitForChild("HumanoidRootPart").RotVelocity = Vector3.zero
end

local function tp(x, y, z) -- Teleport by changing root position
    if localplayer.Character:FindFirstChild("HumanoidRootPart") then
        localplayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        run(reset_vel)
    end
end

-- Save the current instance ID, to break existing connections after running the script again
genv.beta_inst_id = "beta_inst_id_" .. random_string()
local local_inst_id = genv.beta_inst_id

-- OOP functions
-- Rayfield functions

function rayfield.start() -- Create rayfield window and define notify function
    local rayfield_lib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local name, icon = name_icon()

    main.window = rayfield_lib:CreateWindow({
        Name = name,
        Icon = icon,
        LoadingTitle = "Beta",
        LoadingSubtitle = "by EmoSad999",
        ShowText = "Beta",
        Theme = "Amethyst",
        ToggleUIKeybind = "K",
        DisableRayfieldPrompts = true,
        DisableBuildWarnings = false,
        ConfigurationSaving = {
            Enabled = false,
            FolderName = nil,
            FileName = "empty"
        },
        Discord = {
            Enabled = false,
            Invite = "empty",
            RememberJoins = false
        },
        KeySystem = false,
        KeySettings = {
            Title = "empty",
            Subtitle = "empty",
            Note = "empty",
            FileName = "empty",
            SaveKey = false,
            GrabKeyFromSite = false,
            Key = {"empty"}
        }
    })

    function rayfield.notify(title, content, icon)
        rayfield_lib:Notify({
            Title = title,
            Content = content,
            Duration = 6.5,
            Image = icon,
        })
    end
end

if game.PlaceId == 126509999114328 then -- if game is 99 nights in the forest

function rayfield.create_tabs() -- Create tabs in the window
    rayfield.main = main.window:CreateTab("Main")
    rayfield.items = main.window:CreateTab("Items")
    rayfield.movement = main.window:CreateTab("Movement")
    rayfield.hooks = main.window:CreateTab("Hooks")
end

function main.litification()
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
end

function main.sec_to_min(seconds) -- Converts seconds into a readable minute : second format
    local sec

    if seconds % 60 < 10 then
        sec = "0" .. seconds % 60
    else
        sec = seconds % 60
    end
    
    return math.floor(seconds / 60) .. ":" .. sec
end

function main.get_topbar_text() -- Returns the text to put on the topbar
    local state = workspace:GetAttribute("State")
    local days = workspace:GetAttribute("StoryDayCounter")
    local sec_left = workspace:GetAttribute("SecondsLeft")
    local fuel = workspace.Map.Campground.MainFire:GetAttribute("FuelRemaining")
    local fuel_max = workspace.Map.Campground.MainFire:GetAttribute("FuelTarget")

    local mult_inst = {"Old Bed", "Regular Bed", "Good Bed", "Giant Bed", "TentDinoKid", "TentKoalaKid", "TentKrakenKid", "TentSquidKid"}
    local temp_mult_c = 1

    for _, inst in pairs(mult_inst) do
        if workspace.Structures:FindFirstChild(inst) then
            temp_mult_c = temp_mult_c + 1
        end
    end

    genv.beta_multiplier = temp_mult_c

    return state .. " " .. days .. " | " .. main.sec_to_min(sec_left) .. " | " .. math.floor(fuel / fuel_max * 100) .. "%" .. " | x" .. genv.beta_multiplier
end

function main.init_topbar() -- Initiate the hook and loop for topbar functionality
    local topbar = localplayer.PlayerGui.Interface.DayCounter
    topbar.TextSize = 45
    topbar.TextScaled = false
    topbar.TextWrapped = false

    local module = getsenv(localplayer.PlayerScripts.Client.Interface.Modules.NextDayUI)

    if not isfunctionhooked(module.DayDisplay) then
        hookfunction(module.DayDisplay, function(...)
            return nil
        end)
    end

    while local_inst_id == genv.beta_inst_id do
        topbar.Text = main.get_topbar_text()
        task.wait()
    end
end

function main.mob_or_cultist(name) -- Returns what name is associated with: mob or cultist
    local mob = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Frog", "FrogBlue", "FrogPurple", "FrogKing", "Arctic Fox", "Mammoth", "Polar Bear"}
    local cultist = {"Cultist", "Crossbow Cultist", "Juggernaut Cultist", "Alien"}

    for _, inst in pairs(mob) do
        if name == inst then return "mob" end
    end
    for _, inst in pairs(cultist) do
        if name == inst then return "cultist" end
    end
end

function main.killaura_check(name) -- Returns boolean based on if killaura should target the given npc
    local result = main.mob_or_cultist(name)

    if genv.beta_bool_cultist_aura then
        if result == "cultist" then return true end
    end
    if genv.beta_bool_mob_aura then
        if result == "mob" then return true end
    end

    return false
end

function main.reset_global_vars() -- Resets all the global variables incase script is ran twice
    genv.beta_bool_cultist_aura = false
    genv.beta_bool_mob_aura = false
    genv.beta_bool_auto_eat = false
    genv.beta_bool_noclip = false
end

function main.open_chests() -- Loads in the entire world and opens all chests during the process
    -- Teleport to all chunks in the world

    local pos1 = -1200
    local pos2 = -1200

    local continue = true

    -- Start loading map

    while continue do
        if pos1 >= 1200 and pos2 >= 1200 then -- If we have reached the end, stop the loop
            continue = false
        end

        for c = 0, 75, 1 do -- Teleport to given position and stay there for appr. 1.25 seconds
            run(tp, pos1, 50, pos2)
            task.wait()
        end

        if pos1 < 1200 then -- Calculate which chunk to go to next
            pos1 = pos1 + 400
        elseif pos1 >= 1200 then
            pos1 = -1200
            pos2 = pos2 + 400
        end 

        -- After we loaded some chunks, check for unopened chests again

        for _, inst in pairs(workspace.Items:GetChildren()) do
            if inst then
                if string.match(inst.Name, "Item Chest") and inst:FindFirstChild("Main") then
                    if inst.Main:FindFirstChild("ProximityAttachment") then
                        fireproximityprompt(inst.Main.ProximityAttachment.ProximityInteraction)
                    end
                end
            end
        end
    end

    for c = 0, 90, 1 do -- Go to campfire and stay there for appr. 1.5 seconds
        run(tp, 0, 10, 0)
        task.wait()
    end
end

function main.cultist_aura(value) -- Function of cultist kill aura toggle
    genv.beta_bool_cultist_aura = value
end

function main.mob_aura(value) -- Function of mob kill aura toggle
    genv.beta_bool_mob_aura = value
end

function main.func_kill_aura() -- Functionality of kill aura
    local hitreg_id = "1_" .. math.abs(localplayer.userId) -- Get the user's hit registration id
    while local_inst_id == genv.beta_inst_id do
        if genv.beta_bool_cultist_aura or genv.beta_bool_mob_aura then -- If kill aura is on
            local weapon
            if localplayer.Character:FindFirstChild("ToolHandle") then -- If holding something
                if localplayer.Character.ToolHandle:FindFirstChild("OriginalItem") then -- If its loaded
                    if localplayer.Character.ToolHandle.OriginalItem.Value then -- If its loaded (another check)
                        weapon = localplayer.Character.ToolHandle.OriginalItem.Value -- Define weapon
                        if weapon:GetAttribute("WeaponDamage") then -- If that weapon does any melee damage
                            for _, inst in pairs(workspace.Characters:GetChildren()) do -- For every npc
                                if main.killaura_check(inst.Name) and inst:FindFirstChild("HumanoidRootPart") then -- If it can be targeted
                                    local range = main.mob_or_cultist(inst.Name) == "mob" and 100 or 200 -- Set the range
                                    if (inst.HumanoidRootPart.Position - localplayer.Character.HumanoidRootPart.Position).Magnitude <= range and inst and weapon then
                                        rep_storage.RemoteEvents.ToolDamageObject:InvokeServer(inst, weapon, hitreg_id, localplayer.Character.HumanoidRootPart.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(.025)
    end
end

function main.auto_eat(value) -- Function of auto eat toggle
    genv.beta_bool_auto_eat = value
end

function main.func_auto_eat() -- Functionality of auto eat
    while local_inst_id == genv.beta_inst_id do
        if genv.beta_bool_auto_eat then
            local missing_hunger = 200 - localplayer:GetAttribute("Hunger")

            local function consume(inst)
                if not (inst:FindFirstChildWhichIsA("MeshPart") or inst:FindFirstChildWhichIsA("Part")) then return end -- If item has no part

                local main = inst:FindFirstChildWhichIsA("MeshPart") or inst:FindFirstChildWhichIsA("Part") -- Define the main part

                if localplayer.Character and (main.Position - localplayer.Character.HumanoidRootPart.Position).Magnitude <= 60 then -- If item is close enough
                    missing_hunger = missing_hunger - inst:GetAttribute("RestoreHunger") -- Calculate new missing hunger

                    rep_storage.RemoteEvents.RequestConsumeItem:InvokeServer(inst)
                end
            end

            for _, inst in pairs(workspace.Items:GetChildren()) do
                if inst:GetAttribute("RestoreHunger") and not inst:GetAttribute("SpeedBoost") then -- If item can be eaten and isn't chili
                    if inst:GetAttribute("RestoreHealth") then -- If item changes health
                        if inst:GetAttribute("RestoreHealth") > 0 and inst:GetAttribute("RestoreHunger") < missing_hunger then -- If item increases health and should be eaten
                            run(consume, inst)
                        end
                    elseif inst:GetAttribute("RestoreHunger") < missing_hunger then -- if item should be eaten
                        run(consume, inst)
                    end
                end
            end
        end

        task.wait(.1)
    end
end

function main.place_fuel() -- Function of place fuel button
    local sack = localplayer.Inventory:FindFirstChild("Old Sack") or localplayer.Inventory:FindFirstChild("Good Sack") or localplayer.Inventory:FindFirstChild("Giant Sack")
    local target
    local temp_table = {}

    local function find_target(target_fuel)
        for _, inst in pairs(workspace.Items:GetChildren()) do
            if inst.Name == target_fuel then -- If item is a fuel that is needed
                table.insert(temp_table, inst)
            end
        end
        target = temp_table[math.random(1, #temp_table)] -- Select a random item from the list of wanted fuel
    end

    if workspace.Items:FindFirstChild("Oil Barrel") then
        run(find_target, "Oil Barrel")
    elseif workspace.Items:FindFirstChild("Fuel Canister") then
        run(find_target, "Fuel Canister")
    elseif workspace.Items:FindFirstChild("Coal") then
        run(find_target, "Coal")
    else
        rayfield.notify("No fuel found", "No fuel was found, make sure to load the map", "circle-off")
        return
    end

    local result = nil
    local timeout = 0

    repeat
        timeout = timeout + 1

        run(tp, target:GetPivot().X, target:GetPivot().Y, target:GetPivot().Z)

        result = rep_storage.RemoteEvents.RequestBagStoreItem:InvokeServer(sack, target)

        task.wait()
    until result ~= nil or timeout == 40 -- Repeat until successfully picked up or too much time has passed

    local counter_2 = 0

    repeat
        counter_2 = counter_2 + 1
        run(tp, 0, 10, 0)
        task.wait(.01)
    until counter_2 == 25 -- Repeat for appr. 0.25 seconds

    if target.Parent == workspace.Items then return end -- If item failed to pick up, return

    target:SetAttribute("LastOwner", localplayer.UserId)
    target:SetAttribute("LastDropTime", time())
    target:PivotTo(localplayer.Character.HumanoidRootPart.CFrame)
    target.Parent = workspace.Items

    rep_storage.RemoteEvents.RequestBagDropItem:FireServer(sack, target)
end

function main.get_armor()
    local target

    if workspace.Items:FindFirstChild("Thorn Body") then
        target = workspace.Items:FindFirstChild("Thorn Body")
    elseif workspace.Items:FindFirstChild("Poison Armour") then
        target = workspace.Items:FindFirstChild("Poison Armour")
    elseif workspace.Items:FindFirstChild("Iron Body") then
        target = workspace.Items:FindFirstChild("Iron Body")
    elseif workspace.Items:FindFirstChild("Leather Body") then
        target = workspace.Items:FindFirstChild("Leather Body")
    else
        rayfield.notify("No armor found", "No armor was found, make sure to load the map", "circle-off")
        return
    end
        
    local inv_armor

    if localplayer.Armour:GetChildren()[1] then
        inv_armor = localplayer.Armour:GetChildren()[1] -- Define the armor that is currently equipped
    end

    if inv_armor then
        if inv_armor:GetAttribute("Armour") >= target:GetAttribute("Armour") then
            rayfield.notify("No better armor found", "No armor with better stats was found", "circle-off")
            return
        end
        if inv_armor.Name == "Poison Armour" and target.Name == "Iron Body" then -- Exception for poison armor
            rayfield.notify("No better armor found", "No armor with better stats was found", "circle-off")
            return
        end
    end

    local result = nil
    local timeout = 0

    repeat
        timeout = timeout + 1

        run(tp, target:GetPivot().X, target:GetPivot().Y, target:GetPivot().Z)

        result = rep_storage.RemoteEvents.RequestEquipArmour:InvokeServer(target)

        task.wait()
    until result ~= nil or timeout == 40 -- Repeat until successfully picked up or too much time has passed

    local counter_2 = 0

    repeat
        counter_2 = counter_2 + 1
        run(tp, 0, 10, 0)
        task.wait(.01)
    until counter_2 == 20 -- Repeat for appr. 0.25 seconds
end

function main.get_melee()
    local target

    if workspace.Items:FindFirstChild("Morningstar") then
        target = workspace.Items:FindFirstChild("Morningstar")
    elseif workspace.Items:FindFirstChild("Spear") then
        target = workspace.Items:FindFirstChild("Spear")
    elseif workspace.Items:FindFirstChild("Strong Axe") then
        target = workspace.Items:FindFirstChild("Strong Axe")
    elseif workspace.Items:FindFirstChild("Good Axe") then
        target = workspace.Items:FindFirstChild("Good Axe")
    else
        rayfield.notify("No melee found", "Make sure to load the map", "circle-off")
        return
    end

    local inv_highest_damage

    for _, inst in pairs(localplayer.Inventory:GetChildren()) do
        if inst:GetAttribute("WeaponDamage") then
            if not inv_highest_damage then -- If no melee weapon assigned yet
                inv_highest_damage = inst:GetAttribute("WeaponDamage")
            elseif inv_highest_damage < inst:GetAttribute("WeaponDamage") then -- If found weapon has higher damage than previous one
                inv_highest_damage = inst:GetAttribute("WeaponDamage")
            end
        end
    end

    if inv_highest_damage then
        if inv_highest_damage >= target:GetAttribute("WeaponDamage") then
            rayfield.notify("No better melee found", "No melee weapon with better stats was found", "circle-off")
            return
        end
    end

    local result = nil
    local timeout = 0

    repeat
        timeout = timeout + 1

        run(tp, target:GetPivot().X, target:GetPivot().Y, target:GetPivot().Z)

        result = rep_storage.RemoteEvents.RequestHotbarItem:InvokeServer(target)

        task.wait()
    until result ~= nil or timeout == 40 -- Repeat until successfully picked up or too much time has passed

    local counter_2 = 0

    repeat
        counter_2 = counter_2 + 1
        run(tp, 0, 10, 0)
        task.wait(.01)
    until counter_2 == 20 -- Repeat for appr. 0.25 seconds
end

main.get_item_text = ""
function main.get_item_by_name(text)
    main.get_item_text = text
end

function main.get_item()
    local target_name = main.get_item_text
    local targets = {}
    local target
    local method

    for _, inst in pairs(workspace.Items:GetChildren()) do
        if inst.Name == target_name then
            if inst:GetAttribute("Interaction") then
                table.insert(targets, inst)
                if not method then
                    method = inst:GetAttribute("Interaction") -- Save method of obtaining item
                end
            end
        end
    end

    if string.match(target_name, "Lost Child") then -- If lost child selected
        if workspace.Characters:FindFirstChild(target_name) then -- If in npc list
            if workspace.Characters[target_name]:GetAttribute("Interaction") then -- If not rescued
                target = workspace.Characters[target_name]
                method = "Item"
            else
                rayfield.notify("Child already rescued", "Child has already been rescued before", "circle-off")
                return
            end
        else
            rayfield.notify("Child not found", "Child is in your or someone else's bag", "circle-off")
            return
        end
    end

    if not method then
        rayfield.notify("Item not found or not valid", "Item or method to get it was not found", "circle-off")
        return
    end

    if not string.match(target_name, "Lost Child") then
        target = targets[math.random(1, #targets)]
    end -- If target isn't a child, then pick a random item from the wanted item list

    if string.match(target_name, "Ammo") then
        method = "Consumeable"
    end -- Fix for ammo, because it can be picked up and also be consumed

    local result = nil
    local timeout = 0

    repeat
        timeout = timeout + 1

        run(tp, target:GetPivot().X, target:GetPivot().Y, target:GetPivot().Z)

        if method == "Item" then
            local sack = localplayer.Inventory:FindFirstChild("Old Sack") or localplayer.Inventory:FindFirstChild("Good Sack") or localplayer.Inventory:FindFirstChild("Giant Sack")
            result = rep_storage.RemoteEvents.RequestBagStoreItem:InvokeServer(sack, target)
        elseif method == "Tool" then
            result = rep_storage.RemoteEvents.RequestHotbarItem:InvokeServer(target)
        elseif method == "Armour" then
            result = rep_storage.RemoteEvents.RequestEquipArmour:InvokeServer(target)
        elseif method == "Consumeable" then
            result = rep_storage.RemoteEvents.RequestConsumeItem:InvokeServer(target)
        end

        task.wait()
    until result ~= nil or timeout == 40 -- Repeat until successfully picked up or too much time has passed

    local counter_2 = 0

    repeat
        counter_2 = counter_2 + 1
        run(tp, 0, 10, 0)
        task.wait(.01)
    until counter_2 == 20 -- Repeat for appr. 0.25 seconds
end

function main.tp_campfire() -- Function of teleport to campfire button
    tp(0, 10, 0)
end

function main.tp_stronghold() -- Function of teleport to stronghold button
    if workspace.Map.Landmarks:FindFirstChild("Stronghold") then
        local sign_pos = workspace.Map.Landmarks.Stronghold.Functional.Sign.CFrame * CFrame.new(0, 0, 5) -- Save position of stronghold entrance
        tp(sign_pos.X, sign_pos.Y, sign_pos.Z)
    else
        rayfield.notify("Stronghold not found", "Stronghold has not been loaded yet", "circle-off")
    end
end

function main.loop_ws(value) -- Function of increase walkspeed toggle
    if value then
        localplayer.Character:WaitForChild("Humanoid").WalkSpeed = 110
        genv.beta_loop_ws_connection = localplayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function() -- If walkspeed changed
            localplayer.Character:WaitForChild("Humanoid").WalkSpeed = 110
        end)
    else
        genv.beta_loop_ws_connection:Disconnect()
        localplayer.Character.Humanoid.WalkSpeed = 16
    end
end

function main.noclip(value) -- Function of noclip toggle
    genv.beta_bool_noclip = value

    localplayer.Character:WaitForChild("Torso").CanCollide = not value
    localplayer.Character:WaitForChild("Head").CanCollide = not value -- Toggles collision of player
end

function main.func_noclip() -- Functionality of noclip
    while local_inst_id == genv.beta_inst_id do -- break loop if script is reexecuted
        if genv.beta_bool_noclip then
            localplayer.Character:WaitForChild("Torso").CanCollide = false
            localplayer.Character:WaitForChild("Head").CanCollide = false -- Disable collision of player
        end

        task.wait()
    end
end

function main.no_fog() -- Function of no fog button
    local module = require(localplayer.PlayerScripts.Client.EffectModules.ColorCorrectionLightingClient)

    if not isfunctionhooked(module.ChangeColorCorrection) then -- If no fog wasn't activated before
        hookfunction(module.ChangeColorCorrection, function(...) -- Disable function that changes fog
            return nil
        end)

        run(function()
            while true do
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").FogEnd = 100000
                game:GetService("Lighting").ClockTime = 14
                game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128) -- Disable fog

                if workspace.Map.Boundaries:FindFirstChild("Part") then
                    for _, inst in pairs(workspace.Map.Boundaries:GetChildren()) do
                        if inst.Name == "Part" then
                            inst:Destroy() -- Destroy all fogblocks in workspace
                        end
                    end
                end

                task.wait()
            end
        end)
    end
end

function main.create_spoof_table() -- Create a table that is used to spoof the client module in the module responsible for sprinting
    local client = require(localplayer.PlayerScripts.Client)

    main.no_debuff_spoof = {}
    main.no_debuff_spoof.Events = {}
    main.no_debuff_spoof.PlayerHandler = {}
    main.no_debuff_spoof.GuiButtonHandler = {}
    if not rep_storage.RemoteEvents:FindFirstChild("spoof_sprint") then
        local spoof_remote = Instance.new("RemoteEvent", rep_storage.RemoteEvents)
        spoof_remote.Name = "spoof_sprint"
    end
    main.no_debuff_spoof.Events.PlayerSprinting = rep_storage.RemoteEvents.spoof_sprint
    main.no_debuff_spoof.PlayerHandler.Alive = true

    function main.no_debuff_spoof.GuiButtonHandler.HideButton(text)
        client.GuiButtonHandler.HideButton(text)
    end
end

function main.no_debuff(value) -- Function of no sprinting debuff toggle
    local module = require(localplayer.PlayerScripts.Client.GameplayModules.WalkspeedController)
    local client = require(localplayer.PlayerScripts.Client)

    if value then
        debug.setupvalue(module.StartSprint, 1, main.no_debuff_spoof)
    else
        debug.setupvalue(module.StartSprint, 1, client)
    end
end

function main.instantpp(value) -- Function of instant proximity prompt toggle
    if value then
        genv.beta_instantpp_connection = prox_service.PromptButtonHoldBegan:Connect(function(inst) -- If a proximity prompt is pressed
            fireproximityprompt(inst)
        end)
    else
        genv.beta_instantpp_connection:Disconnect()
    end
end

function main.skip_cutscenes(value) -- Function of skip cutscenes toggle
    local module = require(localplayer.PlayerScripts.Client.CutsceneModuleClient)

    if value then
        hookfunction(module.RunCutscene, function(...) -- Disable function responsible for running cutscenes
            return nil
        end)
    else
        restorefunction(module.RunCutscene)
    end
end

function main.no_cold(value) -- Function of no coldness toggle
    local module = getsenv(localplayer.PlayerScripts.Client.BiomesModules.TemperatureClient)

    if value then
        hookfunction(module.TemperatureUpdated, function(...) -- Disable function responsible for updating temperature
            return nil
        end)
    else
        restorefunction(module.TemperatureUpdated)
    end
end

function main.reset_hooks() -- Reset all hooks incase script has been run before
    local client = require(localplayer.PlayerScripts.Client)
    local module_cold = getsenv(localplayer.PlayerScripts.Client.BiomesModules.TemperatureClient)
    local module_cutscene = require(localplayer.PlayerScripts.Client.CutsceneModuleClient)
    local module_walkspeed = require(localplayer.PlayerScripts.Client.GameplayModules.WalkspeedController)

    if isfunctionhooked(module_cold.TemperatureUpdated) then -- If function was hooked
        restorefunction(module_cold.TemperatureUpdated)
    end

    if isfunctionhooked(module_cutscene.RunCutscene) then -- If function was hooked
        restorefunction(module_cutscene.RunCutscene)
    end

    debug.setupvalue(module_walkspeed.StartSprint, 1, client)
end

function main.reset_connections() -- Reset all connections incase script has been run before
    if genv.beta_loop_ws_connection then
        genv.beta_loop_ws_connection:Disconnect()
    end
    if genv.beta_instantpp_connection then
        genv.beta_instantpp_connection:Disconnect()
    end
end

function rayfield.create_elements() -- Create all elements in tabs
    -- Main
    rayfield.main:CreateDivider()
    rayfield.main:CreateButton({Name = "Open Chests", Callback = function() main.open_chests() end})
    rayfield.main:CreateToggle({Name = "Cultist kill aura", CurrentValue = false, Callback = function(bool) main.cultist_aura(bool) end})
    rayfield.main:CreateToggle({Name = "Mob kill aura", CurrentValue = false, Callback = function(bool) main.mob_aura(bool) end})
    rayfield.main:CreateToggle({Name = "Auto eat", CurrentValue = false, Callback = function(bool) main.auto_eat(bool) end})
    rayfield.main:CreateDivider()

    -- Items
    rayfield.items:CreateDivider()
    rayfield.items:CreateButton({Name = "Place fuel", Callback = function() main.place_fuel() end})
    rayfield.items:CreateButton({Name = "Get armor", Callback = function() main.get_armor() end})
    rayfield.items:CreateButton({Name = "Get melee", Callback = function() main.get_melee() end})
    rayfield.items:CreateInput({Name = "Get item by name", CurrentValue = "", PlaceholderText = "Eg: Strong Axe", RemoveTextAfterFocusLost = false, Callback = function(text) main.get_item_by_name(text) end})
    rayfield.items:CreateButton({Name = "Get item", Callback = function() main.get_item() end})
    rayfield.items:CreateDivider()

    -- Movement
    rayfield.movement:CreateDivider()
    rayfield.movement:CreateButton({Name = "Teleport to campfire", Callback = function() main.tp_campfire() end})
    rayfield.movement:CreateButton({Name = "Teleport to stronghold", Callback = function() main.tp_stronghold() end})
    rayfield.movement:CreateToggle({Name = "+ 100 walkspeed", CurrentValue = false, Callback = function(bool) main.loop_ws(bool) end})
    rayfield.movement:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(bool) main.noclip(bool) end})
    rayfield.movement:CreateDivider()

    -- Hooks
    rayfield.hooks:CreateDivider()
    rayfield.hooks:CreateButton({Name = "No fog", Callback = function() main.no_fog() end})
    rayfield.hooks:CreateToggle({Name = "Sprint without hunger debuff", CurrentValue = false, Callback = function(bool) main.no_debuff(bool) end})
    rayfield.hooks:CreateToggle({Name = "Instant Proximity Prompts", CurrentValue = false, Callback = function(bool) main.instantpp(bool) end})
    rayfield.hooks:CreateToggle({Name = "Skip cutscenes", CurrentValue = false, Callback = function(bool) main.skip_cutscenes(bool) end})
    rayfield.hooks:CreateToggle({Name = "No coldness", CurrentValue = false, Callback = function(bool) main.no_cold(bool) end})
    rayfield.hooks:CreateDivider()
end

function main.init_feature_funcs() -- Start all functions that are needed to run when the script executes
    run(main.reset_hooks)
    run(main.reset_connections)
    run(main.func_kill_aura)
    run(main.func_auto_eat)
    run(main.func_noclip)
    run(main.create_spoof_table)
end

function main.init_script() -- Start the script
    localplayer.Character:WaitForChild("Humanoid").WalkSpeed = 16 -- reset walkspeed incase walkspeed increase was left on
    localplayer.Character:WaitForChild("Head").CanCollide = true
    localplayer.Character:WaitForChild("Torso").CanCollide = true -- reset collision incase noclip was left
    run(main.litification)
    run(main.init_topbar)
    run(main.reset_global_vars)
    run(main.init_feature_funcs)
    rayfield.start()
    rayfield.create_tabs()
    rayfield.create_elements()
end

elseif game.PlaceId == 3226555017 then -- if game is SCP: Site Roleplay

function rayfield.create_tabs() -- Create tabs in the window
    rayfield.main = main.window:CreateTab("Main")
end

function main.p_esp(value) -- Player ESP with team coloring
    if value then
        for _, player in pairs(workspace:GetChildren()) do -- For every player
            if game:GetService("Players").FindFirstChild(player.Name) then -- If player
                if player:FindFirstChild("Head") and not player:FindFirstChild("ESPHighlight") then -- If character is loaded
                    local highlight_inst = Instance.new("Highlight", player) -- Create highlight
                    highlight_inst.Name = "ESPHighlight"
                    highlight_inst.FillColor = Color3.fromRGB(3, 94, 231)
                    highlight_inst.OutlineColor = Color3.fromRGB(143, 188, 255)
                end
            end
        end
        genv.beta_player_esp_connection = workspace.ChildAdded:Connect(function(player) -- If walkspeed changed
            if game:GetService("Players").FindFirstChild(player.Name) then -- If player
                local highlight_inst = Instance.new("Highlight", player) -- Create highlight
                highlight_inst.Name = "ESPHighlight"
                highlight_inst.FillColor = Color3.fromRGB(3, 94, 231)
                highlight_inst.OutlineColor = Color3.fromRGB(143, 188, 255)
            end
        end)
    else
        genv.beta_player_esp_connection:Disconnect()
        for _, player in pairs(workspace:GetChildren()) do -- For every player
            if game:GetService("Players").FindFirstChild(player.Name) then -- If player
                if player:FindFirstChild("Head") and player:FindFirstChild("ESPHighlight") then -- If character is loaded
                    player:FindFirstChild("ESPHighlight"):Destroy() -- Remove highlight
                end
            end
        end
    end
end

function rayfield.create_elements() -- Create all elements in tabs
    -- Main
    rayfield.main:CreateDivider()
    rayfield.main:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(bool) main.p_esp(bool) end})
    rayfield.main:CreateDivider()
end

function main.init_script() -- Start the script
    rayfield.start()
    rayfield.create_tabs()
    rayfield.create_elements()
end

end

else -- if game isn't supported

function rayfield.create_tabs() -- Create tabs in the window
    rayfield.main = main.window:CreateTab("Main")
end

function main.funni() -- Ask the user very kindly to donate to people in need (EmoSad999)
    rayfield.notify("Pls donate 50$ paypal", "roblox@gmail.com", "banana")
end

function rayfield.create_elements() -- Create all elements in tabs
    -- Main
    rayfield.main:CreateDivider()
    rayfield.main:CreateButton({Name = "This script isn\'t universal habibi", Callback = function() main.funni() end})
    rayfield.main:CreateDivider()
end

function main.init_script() -- Start the script
    rayfield.start()
    rayfield.create_tabs()
    rayfield.create_elements()
end

end

main.init_script() -- Initiate

print("Beta has fully loaded")
