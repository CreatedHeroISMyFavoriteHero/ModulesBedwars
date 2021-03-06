-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local collectionservice = game:GetService("CollectionService")
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local robloxfriends = {}
local bedwars = {}
local getfunctions
local origC0 = nil
local matchState = 0
local kit = ""
local antivoidypos = 0
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset

local RenderStepTable = {}
local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end
local place = game:GetService("MarketplaceService"):GetProductInfo(6872265039)
if place.Updated ~= "2021-09-01T16:32:56.5999524Z" then
    local textlabel = Instance.new("TextLabel")
    textlabel.Size = UDim2.new(1, 0, 1, 36)
    textlabel.Text = "The script is currently down for testing due to the BedWars update."
	textlabel.TextColor3 = Color3.new(1, 1, 1)
    textlabel.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    textlabel.Position = UDim2.new(0, 0, 0, -36)
    textlabel.TextSize = 30
    textlabel.Parent = GuiLibrary["MainGui"]
local textlabel = Instance.new("TextLabel")
textlabel.Size = UDim2.new(1, 0, 0, 36)
textlabel.Text = "Remember to use alts in this new update, report bans to rent#8392."
textlabel.BackgroundTransparency = 1
textlabel.TextStrokeTransparency = 0
textlabel.TextSize = 30
textlabel.Font = Enum.Font.SourceSans
textlabel.TextColor3 = Color3.new(1, 1, 1)
textlabel.Position = UDim2.new(0, 0, 0, -36)
textlabel.Parent = GuiLibrary["MainGui"]
spawn(function()
	repeat wait() until matchState ~= 0
	textlabel:Remove()
end)


local function getcustomassetfunc(path)
	if not isfile(path) then
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	if not isfile(path) then
		local textlabel = Instance.new("TextLabel")
		textlabel.Size = UDim2.new(1, 0, 0, 36)
		textlabel.Text = "Downloading "..path
		textlabel.BackgroundTransparency = 1
		textlabel.TextStrokeTransparency = 0
		textlabel.TextSize = 30
		textlabel.TextColor3 = Color3.new(1, 1, 1)
		textlabel.Position = UDim2.new(0, 0, 0, -36)
		textlabel.Parent = GuiLibrary["MainGui"]
		repeat wait() until isfile(path)
		textlabel:Remove()
	end
	return getasset(path) 
end

local function getItem(itemName)
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"] == itemName then
			return v5
		end
	end
	return nil
end

local function getSword()
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("sword") or v5["itemType"]:find("blade") then
			return v5, i5
		end
	end
	return nil
end

local function getBaguette()
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("baguette") then
			return v5
		end
	end
	return nil
end

local function getwool()
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:match("wool") then
			return v5["itemType"], v5["amount"]
		end
	end	
	return nil
end

local function getBed(color)
	for i,v in pairs(bedwars["BedTable"]) do
		print(v)
		if v and v:FindFirstChild("Covers") and v.Covers.BrickColor == color then
			return v
		end
	end
	return nil
end

local function teamsAreAlive()
	local alive = false
	for i,v in pairs(game.Teams:GetChildren()) do
		if v.Name ~= "Spectators" and v.Name ~= "Neutral" and v ~= lplr.Team and #v:GetPlayers() > 0 then
			alive = true
		end
	end
	return alive
end

local function scanforbeds()
	local blocktab = game.Workspace.Map.Blocks:GetChildren()
	bedwars["BedTable"] = {}
	for i = 1, #blocktab do
		local obj = blocktab[i]
		if obj.Name == "bed" then
			bedwars["BedTable"][#bedwars["BedTable"] + 1] = obj
			if antivoidypos == 0 then
				antivoidypos = obj.Position.Y
			end
		end
	end  
end

getfunctions = function()
	for i,v in pairs(getgc(true)) do
		if type(v) == "table" then
			if rawget(v, "blocksFolder") then
				bedwars["BlockController"] = v
			end
			if rawget(v, "ClientBlockEngine") then
				bedwars["BlockEngine"] = v["ClientBlockEngine"]
			end
			if rawget(v, "BlockEngine") and rawget(v["BlockEngine"], "store") then
				bedwars["BlockEngine2"] = v["BlockEngine"]
			end
			if rawget(v, "BlockPlacer") then
				bedwars["BlockController2"] = v["BlockPlacer"]
			end
			if rawget(v, "BlockBreaker") then
				bedwars["BlockBreaker"] = v["BlockBreaker"]
			end
			if rawget(v, "calculateBlockDamage") then
				bedwars["BlockController3"] = v
			end
			if rawget(v, "getInventory") then
				bedwars["getInventory"] = function(plr)
					local suc, result = pcall(function() return v["getInventory"](plr) end)
					return (suc and result or {
						["items"] = {},
						["armor"] = {},
						["hand"] = nil
					})
				end
			end
			if rawget(v, "Client") and type(v.Client) == "table" then
				local suc = pcall(function() v.Client:Get("PickupItemEvent") end)
				if suc then
					bedwars["ClientHandler"] = v.Client
				end
				local suc2 = pcall(function() v.Client:Get("SelfReport") end)
				if suc2 then
					local old = getmetatable(v.Client)["Get"]
					getmetatable(v.Client)["Get"] = function(Self, remotename)
						if remotename:match("SelfReport") then
							return nil
						end
						return old(Self, remotename)
					end
				end
			end
			if rawget(v, "ClientStore") and bedwars["ClientStoreHandler"] == nil then
				bedwars["ClientStoreHandler"] = v.ClientStore
			end
			if rawget(v, "VictorySection") then
				bedwars["VictoryScreen"] = v["VictorySection"]
			end
			if rawget(v, "calculateImportantLaunchValues") then
				bedwars["BowTable"] = v
			end
			if rawget(v, "kbDirectionStrength") then
				bedwars["KnockbackTable"] = v
			end
			if rawget(v, "ViewmodelController") then
				bedwars["ViewmodelController"] = v["ViewmodelController"]
			end
			if rawget(v, "BedwarsShop") then
				bedwars["Shop"] = v["BedwarsShop"]
			end
			if rawget(v, "SoundManager") then
				bedwars["SoundManager"] = v["SoundManager"]
			end
			if rawget(v, "SetSelectedShopItem") then
				bedwars["SetSelectedShopItem"] = v["SetSelectedShopItem"]
			end
			if rawget(v, "getItemMeta") then
				bedwars["getItemMetadata"] = v["getItemMeta"]
				bedwars["getIcon"] = function(item, showinv)
					local itemmeta = v["getItemMeta"](item["itemType"])
					if itemmeta and showinv then
						return itemmeta.image
					end
					return ""
				end
			end
			if rawget(v, "equipItem") then
				for i2,v2 in pairs(debug.getconstants(v["equipItem"])) do
					if tostring(v2):match("-") or tostring(v2):match("SetInvItem") then
						bedwars["changeItem"] = v2
					end
				end
			end
			if rawget(v, "ShieldController") and getmetatable(rawget(v, "ShieldController")) then
				for i2,v2 in pairs(debug.getconstants(debug.getprotos(getmetatable(v["ShieldController"])["raiseShield"])[1])) do
					if tostring(v2):match("-") or tostring(v2):match("UseShield") then
						bedwars["raiseShield"] = function()
							game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged[tostring(v2)]:FireServer({
								["raised"] = true
							})
						end
					end
				end
			end
			if rawget(v, "BigmanController") then
				local protos = debug.getconstants(debug.getprotos(debug.getprotos(v["BigmanController"]["KnitStart"])[2])[1])
				for i2,v2 in pairs(protos) do
					if tostring(v2):match("-") or tostring(v2):match("ConsumeTreeOrb") then
						bedwars["TreeRemote"] = v2
					end
				end
			end
			if rawget(v, "performHeal") then
				for i2,v2 in pairs(debug.getconstants(v["performHeal"])) do
					if tostring(v2):match("-") or tostring(v2):match("PlayGuitar") then
						bedwars["GuitarRemote"] = v2
					end
				end
			end
			if rawget(v, "checkForPickup") then
				for i2,v2 in pairs(debug.getconstants(v["checkForPickup"])) do
					if tostring(v2):match("-") or tostring(v2):match("PickupItemDrop") then
						bedwars["PickupRemote"] = v2
					end
				end
			end
			if rawget(v, "updateHealthbar") then
				bedwars["healthBar"] = v
			end
			if rawget(v, "SwordController") then
				bedwars["SwordController"] = v["SwordController"]
			end
			if rawget(v, "BalloonController") then
				bedwars["BalloonController"] = v["BalloonController"]
			end
			if rawget(v, "swingSwordAtMouse") then
				bedwars["SwingSword"] = v["swingSwordAtMouse"]
			end
			if rawget(v, "swingSwordInRegion") then
				bedwars["SwingSwordRegion"] = v["swingSwordInRegion"]
			end
			if rawget(v, "CombatConstant") then
				bedwars["CombatConstant"] = v["CombatConstant"]
			end
			if rawget(v, "attackEntity") then
				bedwars["attackEntity"] = v["attackEntity"]
			end
			if rawget(v, "requestSelfDamage") then
				bedwars["damageTable"] = v
			end
			if rawget(v, "GamePlayerUtil") then
				bedwars["PlayerUtil"] = v["GamePlayerUtil"]
			end
			for i2,v2 in pairs(v) do
				if tostring(i2):match("sprinting") and type(v2) == "boolean" then
					bedwars["sprintTable"] = v
				  end
			end
		end
	end

	if (bedwars["PlayerUtil"] and bedwars["PickupRemote"] and bedwars["Shop"] and bedwars["SoundManager"] and bedwars["SetSelectedShopItem"] and bedwars["ViewmodelController"] and bedwars["GuitarRemote"] and bedwars["BalloonController"] and bedwars["SwingSwordRegion"] and bedwars["CombatConstant"] and bedwars["SwingSword"] and bedwars["BowTable"] and bedwars["getInventory"] and bedwars["raiseShield"] and bedwars["BlockController"] and bedwars["BlockEngine"] and bedwars["BlockController2"] and bedwars["BlockController3"] and bedwars["SwordController"] and bedwars["attackEntity"] and bedwars["damageTable"] and bedwars["sprintTable"]) or (not shared.VapeExecuted) then
		repeat wait() until lplr.Team ~= nil
		local blocktable
		bedwars["placeBlock"] = function(newpos)
			if blocktable == nil and getwool() or getwool():find(lplr.Team.Name:lower()) == nil then
				blocktable = bedwars["BlockController2"].new(bedwars["BlockEngine"], getwool())
			end
			if blocktable and getwool() and getwool():find(lplr.Team.Name:lower()) then
				if getmetatable(bedwars["BlockController"])["isAllowedPlacement"](bedwars["BlockController"], lplr, getwool(), Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3)) and getItem(getwool()) then
					bedwars["BlockController2"].placeBlock(blocktable, Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
				end
			end
		end
		spawn(function()
			bedwars["BedTable"] = {}
			repeat wait() until matchState ~= 0
			if workspace.MapCFrames:FindFirstChild("1_spawn") then
				antivoidypos = workspace.MapCFrames["1_spawn"].Value.p.Y * 3
			end
			scanforbeds()
		end)
		bedwars["ClientStoreHandler"].changed:connect(function(p3, p4)
			if p3.Game ~= p4.Game then
				if p3.Game.matchState ~= p4.Game.matchState then
					matchState = p3.Game.matchState
					if matchState ~= 0 then
						kit = rawget(bedwars["ClientStoreHandler"]:getState()["Bedwars"], "kit")
					end
				end
			end
		end)
		matchState = bedwars["ClientStoreHandler"]:getState().Game.matchState
		if matchState ~= 0 then
			kit = rawget(bedwars["ClientStoreHandler"]:getState()["Bedwars"], "kit")
		end
	else
		wait(1)
	--	print(bedwars["assetTable"],bedwars["ZiplineRemote"],bedwars["HitProjectile"],bedwars["FireProjectile"],bedwars["getInventory"],bedwars["raiseShield"],bedwars["BlockController"],bedwars["BlockEngine"],bedwars["BlockController2"],bedwars["SwordController"],bedwars["attackEntity"],bedwars["damageTable"],bedwars["sprintTable"])
		getfunctions()
	end
end

local function makerandom(min, max)
	return Random.new().NextNumber(Random.new(), min, max)
end

local function getblock(pos)
	return bedwars["BlockEngine2"]:getStore():getBlockAt(bedwars["BlockEngine2"]:getBlockPosition(pos))
end

getfunctions()

local function friendCheck(plr)
	if not robloxfriends[plr.UserId] then
		if lplr:IsFriendsWith(plr.UserId) then
			table.insert(robloxfriends, plr.Name)
			robloxfriends[plr.UserId] = true
		end
	end
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and ((GuiLibrary["ObjectsThatCanBeSaved"]["Use Roblox FriendsToggle"]["Api"]["Enabled"] and table.find(robloxfriends, plr.Name) == nil) and table.find(GuiLibrary["FriendsObject"]["Friends"], plr.Name) == nil) or GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] == false)
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and bedwars["PlayerUtil"].getGamePlayer(lplr):getTeamId() ~= bedwars["PlayerUtil"].getGamePlayer(plr):getTeamId() or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function switchItem(tool)
	lplr.Character.HandInvItem.Value = tool
	bedwars["ClientHandler"]:Get(bedwars["changeItem"]):CallServerAsync({
		hand = tool
	})
end

local function switchToAndUseTool(block)
	local tool = nil
	local blockType = bedwars["getItemMetadata"](block.Name)["block"]["breakType"]
	for i,v in pairs(bedwars["getInventory"](lplr)["items"]) do
		local meta = bedwars["getItemMetadata"](v["itemType"])
		if meta["breakBlock"] and meta["breakBlock"][blockType] then
			tool = v
			break
		end
	end
	if tool and (isAlive() and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool["tool"]) then
		switchItem(tool["tool"])
	end
end

bedwars["breakBlock"] = function(pos)
	spawn(function()
		local block = getblock(pos)
		local lastfound = nil
		local olditem = lplr.Character.HandInvItem.Value
		if block and block.Parent ~= nil then
			for i = 1, 20 do
				local extrablock = getblock(pos + Vector3.new(i * 3, 0, 0))
				if extrablock then
					lastfound = extrablock
				else
					if lastfound then
						switchToAndUseTool(lastfound)
						game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.DamageBlock:InvokeServer({
							blockRef = {
								blockPosition = bedwars["BlockEngine2"]:getBlockPosition(lastfound.Position)
							}, 
							hitPosition = lastfound.Position, 
							hitNormal = Vector3.new(1, 0, 0)
						})
						if olditem then
							switchItem(olditem)
						end
					else
						switchToAndUseTool(block)
						game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.DamageBlock:InvokeServer({
							blockRef = {
								blockPosition = bedwars["BlockEngine2"]:getBlockPosition(pos)
							}, 
							hitPosition = pos, 
							hitNormal = Vector3.new(1, 0, 0)
						})
						if olditem then
							switchItem(olditem)
						end
					end
				end
			end
		end
	end)
end	

local function getEquipped()
	local type = ""
	local obj = (isAlive() and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value or nil)
	if obj then
		if obj.Name:find("sword") or obj.Name:find("blade") or obj.Name:find("baguette") then
			type = "sword"
		end
		if obj.Name:find("wool") then
			type = "block"
		end
		if obj.Name:find("bow") then
			type = "bow"
		end
	end
    return {["Object"] = obj, ["Type"] = type}
end

local function nakedcheck(plr)
	local inventory = bedwars["getInventory"](plr)
	return inventory["armor"][4] ~= nil and inventory["armor"][5] ~= nil and inventory["armor"][6] ~= nil
end

local function isPlayerTargetable(plr, target, friend, team)
    return plr ~= lplr and GuiLibrary["ObjectsThatCanBeSaved"]["PlayersToggle"]["Api"]["Enabled"] and plr and isAlive(plr) and targetCheck(plr, target) and (GuiLibrary["ObjectsThatCanBeSaved"]["Ignore nakedToggle"]["Api"]["Enabled"] and nakedcheck(plr) or GuiLibrary["ObjectsThatCanBeSaved"]["Ignore nakedToggle"]["Api"]["Enabled"] == false) and ((team and plr.Team == lplr.Team) or (team == nil and shared.vapeteamcheck(plr)))
end

local function vischeck(pos, pos2, ignore)
	local vistab = cam:GetPartsObscuringTarget({pos, pos2}, ignore)
	for i,v in pairs(vistab) do
		print(i,v:GetFullName())
	end
	return not unpack(vistab)
end

local function GetAllNearestHumanoidToPosition(distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable(v, true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable(v, true, false) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then
                    closest = mag
                    returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable(v, true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and (checkvis == false or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
                local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = v
                    end
                end
            end
        end
    end
    return returnedplayer
end

GuiLibrary["RemoveObject"]("AimAssistOptionsButton")

GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
local oldenable
local olddisable
local blockplacetable = {}
local blockplaceenabled = false
local autoclickercps = {["GetRandomValue"] = function() return 1 end}
local autoclicker = {["Enabled"] = false}
local autoclickertick = tick()
autoclicker = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton("AutoClicker", function()
	oldenable = bedwars["BlockController2"]["enable"]
	olddisable = bedwars["BlockController2"]["disable"]
	bedwars["BlockController2"]["enable"] = function(Self, tab)
		blockplaceenabled = true
		blockplacetable = Self
		return oldenable(Self, tab)
	end
	bedwars["BlockController2"]["disable"] = function(Self)
		blockplaceenabled = false
		return olddisable(Self)
	end
	BindToRenderStep("AutoClicker", 1, function() 
		if isAlive() and uis:IsMouseButtonPressed(0) and autoclickertick <= tick() and bedwars["ClientStoreHandler"]:getState().App.shownApp <= 0 and GuiLibrary["MainGui"].ClickGui.Visible == false and matchState ~= 0 then
			autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]())
			if getEquipped()["Type"] == "sword" then
				bedwars["SwingSword"](bedwars["SwordController"])
			end
			if blockplaceenabled then
				local mouseinfo = blockplacetable.clientManager:getBlockSelector():getMouseInfo(0)
				if mouseinfo and getmetatable(bedwars["BlockController"])["isAllowedPlacement"](bedwars["BlockController"], lplr, blockplacetable.blockType, mouseinfo.placementPosition, 0) then
					bedwars["BlockController2"]["placeBlock"](blockplacetable, mouseinfo.placementPosition)
				end
			end
		end
	end)
end, function()
	bedwars["BlockController2"]["enable"] = oldenable
	bedwars["BlockController2"]["disable"] = olddisable
	oldenable = nil
	olddisable = nil
	UnbindFromRenderStep("AutoClicker")
end, true, function() return "" end, "Clicks for you")
autoclickercps = autoclicker.CreateTwoSlider("CPS", 1, 20, function(val) end, false, 8, 12)

GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("PhaseOptionsButton")
local velohorizontal = {["Value"] = 100}
local velovertical = {["Value"] = 100}
local oldhori = bedwars["KnockbackTable"]["kbDirectionStrength"]
local oldvert = bedwars["KnockbackTable"]["kbUpwardStrength"]
local Velocity = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton("Velocity", function()
	bedwars["KnockbackTable"]["kbDirectionStrength"] = oldhori * (velohorizontal["Value"] / 100)
	bedwars["KnockbackTable"]["kbUpwardStrength"] = oldvert * (velovertical["Value"] / 100)
end, function() 
	bedwars["KnockbackTable"]["kbDirectionStrength"] = oldhori
	bedwars["KnockbackTable"]["kbUpwardStrength"] = oldvert
end, true, function() return "" end, "Reduces knockback taken")
velohorizontal = Velocity.CreateSlider("Horizontal", 0, 100, function(val) bedwars["KnockbackTable"]["kbDirectionStrength"] = oldhori * (val / 100) end, 100)
velovertical = Velocity.CreateSlider("Vertical", 0, 100, function(val) bedwars["KnockbackTable"]["kbUpwardStrength"] = oldvert * (val / 100) end, 100)

local oldclick
local noclickdelay = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton("NoClickDelay", function()
	oldclick = bedwars["SwordController"]["isClickingTooFast"]
	bedwars["SwordController"]["isClickingTooFast"] = function() return false end
end, function() 
	bedwars["SwordController"]["isClickingTooFast"] = oldclick
	oldclick = nil
end, true, function() return "" end, "Removes Click Delay")

local Sprint = {["Enabled"] = false}
Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton("Sprint", function()
	spawn(function()
		repeat
			wait()
			if bedwars["sprintTable"].sprinting == false then
				getmetatable(bedwars["sprintTable"])["startSprinting"](bedwars["sprintTable"])
			end
		until Sprint["Enabled"] == false
	end)
end, function() end, true, function() return "" end, "Sets your sprinting to true")

GuiLibrary["RemoveObject"]("BlinkOptionsButton")
local Blink = {["Enabled"] = false}
Blink = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("Blink", function() 
	if GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] then
		settings():GetService("NetworkSettings").IncomingReplicationLag = 99999
	else
		Blink["ToggleButton"](false)
	end
end, function()
	if GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] then
		settings():GetService("NetworkSettings").IncomingReplicationLag = 0
	end
end, false, function() return "" end, "Chokes all incoming packets (blatant mode required)\nPlease do not turn this on if you do not know what you are doing.")

local antivoidpart
local antitransparent = {["Enabled"] = false}
local AntiVoid = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton("AntiVoid", function()
	spawn(function()
		repeat wait() until antivoidypos ~= 0
		antivoidpart = Instance.new("Part")
		antivoidpart.CanCollide = true
		antivoidpart.Size = Vector3.new(10000, 1, 10000)
		antivoidpart.Anchored = true
		antivoidpart.Transparency = (antitransparent["Enabled"] and 1 or 0.5)
		antivoidpart.Position = Vector3.new(0, antivoidypos - 20, 0)
		antivoidpart.Touched:connect(function(touchedpart)
			if touchedpart.Parent == lplr.Character and isAlive() then
				lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
			end
		end)
		antivoidpart.Parent = game.Workspace
	end)
end, function() 
	if antivoidpart then
		antivoidpart:Remove() 
	end
end, true, function() return "" end, "Gives you a chance to get on land (Not Perfect)")
antitransparent = AntiVoid.CreateToggle("Invisible", function() 
	if antivoidpart then
		antivoidpart.Transparency = 1
	end
end, function()
	if antivoidpart then
		antivoidpart.Transparency = 0.5
	end
end, true)


local function getScaffold(vec)
    return Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
end

local function scaffoldBlock(newpos)
    bedwars["placeBlock"](newpos)
end

local swords = {
	["wood_sword"] = "stone_sword",
	["stone_sword"] = "iron_sword",
	["iron_sword"] = "diamond_sword",
	["diamond_sword"] = "emerald_sword"
}
local betterswords = {
	["stone_sword"] = 2,
	["iron_sword"] = 3,
	["diamond_sword"] = 4,
	["emerald_sword"] = 5,
}


local function checkallswords()
	local highestsword = 1
	local currentbuyablesword = nil
	for i, v in pairs(betterswords) do
		local NextSwordTable = bedwars["Shop"].getShopItem(i)
		local NextSwordCurrency = getItem(NextSwordTable["currency"])
		if NextSwordCurrency and NextSwordCurrency["amount"] >= NextSwordTable["price"] and highestsword < v then
			highestsword =  v
			currentbuyablesword = i
		end
	end
	return currentbuyablesword
end

local AutoBuy = {["Enabled"] = false}
local AutoBuyArmor = {["Enabled"] = false}
local AutoBuySword = {["Enabled"] = false}
local AutoBuyUpgrades = {["Enabled"] = false}
local AutoBuyGui = {["Enabled"] = false}
local buyingthing = false

local function buyitem(itemtab, sucfunc)
	bedwars["ClientHandler"]:Get("BedwarsPurchaseItem"):CallServerAsync({
		shopItem = itemtab
	}):andThen(function(p11)
		if p11 then
			bedwars["SoundManager"]:playSound(12)
			bedwars["ClientStoreHandler"]:dispatch({
				type = "BedwarsAddItemPurchased", 
				itemType = itemtab.itemType
			});
			if itemtab.itemType == "emerald_sword" then
				local sword, swordnum = getSword()
				if sword.itemType ~= "emerald_sword" then
					sword["tool"]:Remove()
					bedwars["getInventory"](lplr)["items"][swordnum] = nil
				end
			end
			if itemtab.nextTier then
				local ShopItems = bedwars["Shop"].ShopItems;
				local function isNextTier(p12)
					return p12.itemType == NextArmorTable.nextTier;
				end;
				local itemToSelect = nil;
				for itemnum, item in ipairs(ShopItems) do
					if isNextTier(item, itemnum - 1, ShopItems) == true then
						itemToSelect = item;
						break;
					end;
				end;
				bedwars["SetSelectedShopItem"](itemToSelect);
				return;
			elseif itemtab.tiered or itemtab.lockAfterPurchase then

			end
			sucfunc()
		end
	end)
end

local BuyCheck = function() end
BuyCheck = function()
	if AutoBuy["Enabled"] then
			local ExecuteInventory = bedwars["getInventory"](lplr)
			local NextArmor = ExecuteInventory.armor[5] and bedwars["Shop"].getShopItem(ExecuteInventory.armor[5].itemType)["nextTier"] or (ExecuteInventory.armor[5] == nil and "leather_chestplate")
			local NextSword = getSword()
			local ProtectionUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "armor")
			local SharpnessUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "damage")
			if AutoBuySword["Enabled"] and NextSword and kit ~= "barbarian" and (AutoBuyGui["Enabled"] and (bedwars["ClientStoreHandler"]:getState().App.shownApp == 5 or bedwars["ClientStoreHandler"]:getState().App.shownApp == 4) or (not AutoBuyGui["Enabled"])) then
				local buyablesword = checkallswords()
				if buyablesword and NextSword and betterswords[buyablesword] > (NextSword.itemType ~= "wood_sword" and betterswords[NextSword.itemType] or 1) then
					local NextSwordTable = bedwars["Shop"].getShopItem(buyablesword)
					buyitem(NextSwordTable, function()
						NextSword = swords[NextSwordTable["itemType"]]
						print("bought")
						BuyCheck()
					end)
				end
			end
			if AutoBuyArmor["Enabled"] and NextArmor and (AutoBuyGui["Enabled"] and bedwars["ClientStoreHandler"]:getState().App.shownApp == 5 or (not AutoBuyGui["Enabled"])) then
				local NextArmorTable = bedwars["Shop"].getShopItem(NextArmor)
				local NextArmorCurrency = getItem(NextArmorTable["currency"])
				if NextArmorCurrency and NextArmorCurrency["amount"] >= NextArmorTable["price"] then
					buyitem(NextArmorTable, function()
						NextArmor = NextArmorTable["nextTier"]
						BuyCheck()
					end)
				end
			end
			if AutoBuyUpgrades["Enabled"] and (AutoBuyGui["Enabled"] and bedwars["ClientStoreHandler"]:getState().App.shownApp == 4 or (not AutoBuyGui["Enabled"])) then
				local CurrentUpgrades = bedwars["ClientStoreHandler"]:getState()["Bedwars"]["teamUpgrades"]
				local ProtNewTier = ProtectionUpgrade["tiers"][CurrentUpgrades["armor"] and CurrentUpgrades["armor"] + 2 or 1]
				local SharpNewTier = SharpnessUpgrade["tiers"][CurrentUpgrades["damage"] and CurrentUpgrades["damage"] + 2 or 1]
				if ProtNewTier then
				local ProtCurrency = getItem(ProtNewTier["currency"])
					if ProtCurrency and ProtCurrency["amount"] >= ProtNewTier["price"] then
						bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
							upgradeId = "armor", 
							tier = CurrentUpgrades["armor"] and CurrentUpgrades["armor"] + 1 or 0
						}):andThen(function()
							bedwars["SoundManager"]:playSound(11)
						end)
					end
				end
				if SharpNewTier then
					local SharpCurrency = getItem(SharpNewTier["currency"])
					if SharpCurrency and SharpCurrency["amount"] >= SharpNewTier["price"] then
						bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
							upgradeId = "damage", 
							tier = CurrentUpgrades["damage"] and CurrentUpgrades["damage"] + 1 or 0
						}):andThen(function()
							bedwars["SoundManager"]:playSound(11)
						end)
					end
				end
			end
	end
end

local BedNuker = {["Enabled"] = false}
BedNuker = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("BedNuker", function()
	spawn(function()
		repeat
			wait()
			local tab = bedwars["BedTable"]
			for i = 1, #tab do
				local obj = tab[i]
				if isAlive() then
					if obj and obj:FindFirstChild("Covers") and obj.Covers.BrickColor ~= lplr.Team.TeamColor and obj.Parent ~= nil then
						if (lplr.Character.HumanoidRootPart.Position - obj.Position).magnitude <= 20 then
							bedwars["breakBlock"](obj.Position)
						end
					end
				end
			end
		until BedNuker["Enabled"] == false
	end)
end, function() end, true, function()
	return ""
end, "Automatically destroys beds around you.")

bedwars["ClientStoreHandler"].changed:connect(function(p3, p4)
	if p3.Inventory.observedInventory.inventory ~= p4.Inventory.observedInventory.inventory then
		BuyCheck()
	end
end)
bedwars["ClientHandler"]:Get("PickupItemEvent"):Connect(BuyCheck)
AutoBuy = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton("AutoBuy", function() buyingthing = false BuyCheck() end, function() end, true, function() return "" end, "Automatically Buys Swords, Armor, and Team Upgrades.")
AutoBuyArmor = AutoBuy.CreateToggle("Buy Armor", function() end, function() end, true)
AutoBuySword = AutoBuy.CreateToggle("Buy Sword", function() end, function() end, true)
AutoBuyUpgrades = AutoBuy.CreateToggle("Buy Team Upgrades", function() end, function() end, true)
AutoBuyGui = AutoBuy.CreateToggle("Shop GUI Check", function() end, function() end)
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
GuiLibrary["RemoveObject"]("KillauraOptionsButton")

local OpenShop = {["Enabled"] = false}
OpenShop = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton("OpenShop", function()
	bedwars["SoundManager"]:playSound(4)
	bedwars["ClientStoreHandler"]:dispatch({
		type = "SetShownApp", 
		app = 5
	})
	OpenShop["ToggleButton"](false)
end, function() end, true, function() return "" end, "Opens the Shop GUI")

local OpenTeamUpgrades = {["Enabled"] = false}
OpenTeamUpgrades = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton("OpenTeamUpgrades", function()
	bedwars["SoundManager"]:playSound(4)
	bedwars["ClientStoreHandler"]:dispatch({
		type = "SetShownApp", 
		app = 4
	})
	OpenTeamUpgrades["ToggleButton"](false)
end, function() end, true, function() return "" end, "Opens the Team Upgrade GUI")

local killaurabox = Instance.new("BoxHandleAdornment")
killaurabox.Transparency = 0.5
killaurabox.Color3 = Color3.new(1, 0, 0)
killaurabox.Adornee = nil
killaurabox.AlwaysOnTop = true
killaurabox.ZIndex = 11
killaurabox.Parent = GuiLibrary["MainGui"]
local killauraanimmethod = {["Value"] = "Normal"}
local killauraaps = {["GetRandomValue"] = function() return 1 end}
local killaurarange = {["Value"] = 14}
local killauraangle = {["Value"] = 360}
local killauratargets = {["Value"] = 10}
local killauramouse = {["Enabled"] = false}
local killauracframe = {["Enabled"] = false}
local killauraautoblock = {["Enabled"] = false}
local killauragui = {["Enabled"] = false}
local killauratarget = {["Enabled"] = false}
local killaurasound = {["Enabled"] = false}
local killauraswing = {["Enabled"] = false}
local killaurahandcheck = {["Enabled"] = false}
local killaurabaguette = {["Enabled"] = false}
local killauraanimation = {["Enabled"] = false}
local Killaura = {["Enabled"] = false}
local killauradelay = 0
local Killauranear = false
local killauraplaying = false
local oldplay = function() end
local oldsound = function() end
local oldmeta
Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("Killaura", function()
	oldplay = bedwars["ViewmodelController"]["playAnimation"]
	oldsound = bedwars["SoundManager"]["playSound"]
	oldmeta = bedwars["SwordController"]["getHandItem"]
	bedwars["SwordController"]["getHandItem"] = function()
		if (not killaurahandcheck["Enabled"]) then
			if killaurabaguette["Enabled"] and getBaguette() then
				return getBaguette()
			else
				return getSword()
			end
		else
			return oldmeta()
		end
	end
	bedwars["SoundManager"]["playSound"] = function(tab, soundid, ...)
		if (soundid == 13 or soundid == 14) and Killaura["Enabled"] and killaurasound["Enabled"] and killauranear then
			return nil
		end
		return oldsound(tab, soundid, ...)
	end
	bedwars["ViewmodelController"]["playAnimation"] = function(Self, id, ...)
		if id == 5 and killauranear and killauraswing["Enabled"] and isAlive() then
			return nil
		end
		if id == 5 and killauranear and killauraanimation["Enabled"] and isAlive() then
			pcall(function()
				if origC0 == nil then
					origC0 = cam.Viewmodel.RightHand.RightWrist.C0
				end
				if killauraplaying == false then
					killauraplaying = true
					game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new((killauraanimmethod["Value"] == "Normal" and 0.1 or 0.2)), {C0 = origC0 * CFrame.new(0.7, -1, 0.6) * CFrame.Angles(-math.rad(45), math.rad(55), -math.rad(70))}):Play()
					wait((killauraanimmethod["Value"] == "Normal" and 0.05 or 0.1))
					game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new((killauraanimmethod["Value"] == "Normal" and 0.1 or 0.2)), {C0 = origC0 * CFrame.new(0.7, -1, 0.6) * CFrame.Angles(-math.rad(45), math.rad(105), -math.rad(70))}):Play()
					wait((killauraanimmethod["Value"] == "Normal" and 0.05 or 0.1))
					killauraplaying = false
				end
			end)
			return nil
		end
		return oldplay(Self, id, ...)
	end
	BindToRenderStep("Killaura", 1, function() 
		local targettable = {}
		local targetsize = 0
		if (killauradelay <= tick()) and matchState ~= 0 then
			local plrs = GetAllNearestHumanoidToPosition(killaurarange["Value"], killauratargets["Value"])
			if #plrs <= 0 then
				killauranear = false
				killaurabox.Adornee = nil
				pcall(function()
					if origC0 == nil then
						origC0 = cam.Viewmodel.RightHand.RightWrist.C0
					end
					if cam.Viewmodel.RightHand.RightWrist.C0 ~= origC0 then
						game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = origC0}):Play()
					end
				end)
			end
			for i,plr in pairs(plrs) do
				local entitytable = {["instance"] = plr.Character, ["player"] = plr, ["getInstance"] = function() return plr.Character end}
				if isAlive() and (killaurahandcheck["Enabled"] and getEquipped()["Type"] == "sword" or (not killaurahandcheck["Enabled"])) and ((not killaurawall["Enabled"]) and bedwars["SwordController"]["canSee"](bedwars["SwordController"], entitytable) or killaurawall["Enabled"]) and (killauramouse["Enabled"] and uis:IsMouseButtonPressed(0) or (not killauramouse["Enabled"])) and (killauragui["Enabled"] and (bedwars["ClientStoreHandler"]:getState().App.shownApp <= 0 and GuiLibrary["MainGui"].ClickGui.Visible == false) or (not killauragui["Enabled"])) then
					if plr.Character.PrimaryPart and lplr.Character.PrimaryPart then
						killauranear = true
						if killauraautoblock["Enabled"] and kit == "shielder" then
							spawn(bedwars["raiseShield"])
						end
						if killauracframe["Enabled"] then
							lplr.Character:SetPrimaryPartCFrame(CFrame.new(lplr.Character.PrimaryPart.Position, Vector3.new(plr.Character:FindFirstChild("HumanoidRootPart").Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character:FindFirstChild("HumanoidRootPart").Position.Z)))
						end
						if killauratarget["Enabled"] then
							local ori, size = plr.Character:GetBoundingBox()
							killaurabox.Adornee = (killauratarget["Enabled"] and plr.Character or nil)
							killaurabox.Size = size + Vector3.new(.01, .01, .01)
						end
						targettable[plr.Name] = {
							["UserId"] = plr.UserId,
							["Health"] = plr.Character.Humanoid.Health,
							["MaxHealth"] = plr.Character.Humanoid.MaxHealth
						}
						targetsize = targetsize + 1
						killauradelay = tick() + (1 / killauraaps["GetRandomValue"]())
						bedwars["attackEntity"](bedwars["SwordController"], entitytable, Ray.new(cam.CFrame.p, plr.Character.HumanoidRootPart.Position).Unit.Direction)	
					end
				else
					killaurabox.Adornee = nil
					killauranear = false
					pcall(function()
						if origC0 == nil then
							origC0 = cam.Viewmodel.RightHand.RightWrist.C0
						end
						if cam.Viewmodel.RightHand.RightWrist.C0 ~= origC0 then
							game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = origC0}):Play()
						end
					end)
				end
			end
			if getEquipped()["Type"] ~= "bow" then
				targetinfo.UpdateInfo(targettable, targetsize)
			end
		end
	end)
end, function() 
	killauranear = false
	bedwars["ViewmodelController"]["playAnimation"] = oldplay
	bedwars["SoundManager"]["playSound"] = oldsound
	oldplay = nil
	pcall(function()
		cam.Viewmodel.RightHand.RightWrist.C0 = origC0
	end)
	UnbindFromRenderStep("Killaura") 
	bedwars["SwordController"]["getHandItem"] = oldmeta
	oldmeta = nil
end, true, function()
	return ""
end, "Attack players around you\nwithout aiming at them.\nAutoBlock requires Inferno Shielder")
killauraaps = Killaura.CreateTwoSlider("Attacks per Second", 1, 20, function(val) end, false, 8, 12)
killaurarange = Killaura.CreateSlider("Attack range", 1, 14, function(val) end, 14)
killauraangle = Killaura.CreateSlider("Max angle", 1, 360, function(val) end, 360)
killauratargets = Killaura.CreateSlider("Max targets", 1, 10, function(val) end, 10)
killauraanimmethod = Killaura.CreateDropdown("Animation", {"Normal", "Slow"}, function(val) end)
killauraautoblock = Killaura.CreateToggle("AutoBlock", function() end, function() end, true)
killaurawall = Killaura.CreateToggle("Attack through walls", function() end, function() end, true)
killauramouse = Killaura.CreateToggle("Require mouse down", function() end, function() end, false)
killauragui = Killaura.CreateToggle("GUI Check", function() end, function() end)
killauratarget = Killaura.CreateToggle("Show target", function() end, function() end)
killauracframe = Killaura.CreateToggle("Face target", function() end, function() end)
killaurasound = Killaura.CreateToggle("No Swing Sound", function() end, function() end)
killauraswing = Killaura.CreateToggle("No Swing", function() end, function() end)
killaurahandcheck = Killaura.CreateToggle("Limit to items", function() end, function() end)
killaurabaguette = Killaura.CreateToggle("Baguette Aura", function() end, function() end)
killauraanimation = Killaura.CreateToggle("Custom Animation", function() end, function() end)

local FastPickupRange = {["Value"] = 1}
local FastPickup = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("FastPickup", function()
	BindToRenderStep("FastPickup", 1, function()
		local itemdrops = collectionservice:GetTagged("ItemDrop")
		if isAlive() then
			for i,v in pairs(itemdrops) do
				if (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude <= FastPickupRange["Value"] then
					bedwars["ClientHandler"]:Get(bedwars["PickupRemote"]):CallServerAsync({
						itemDrop = v
					}):andThen(function(p14)
						if p14 then
							bedwars["SoundManager"]:playSound(8)
						end
					end)
				end
			end
		end
	end)
end, function() 
	UnbindFromRenderStep("FastPickup")
end, true)
FastPickupRange = FastPickup.CreateSlider("Range", 1, 10, function() end, 10)

local AutoToxic = {["Enabled"] = false}
local AutoToxicGG = {["Enabled"] = false}
local AutoToxicWin = {["Enabled"] = false}
local AutoToxicFinalKill = {["Enabled"] = false}
local AutoToxicWinStreak = {["Enabled"] = false}
local AutoToxicAd = {["Enabled"] = false}
local AutoToxicPhrases = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicOldWin = bedwars["VictoryScreen"].render
local victorysaid = false
bedwars["VictoryScreen"].render = function(winstuff)
    local myTeam = bedwars["ClientStoreHandler"]:getState().Game.myTeam
    if myTeam and myTeam.id == winstuff.props.WinningTeamId and victorysaid == false then
		victorysaid = true
		if AutoToxic["Enabled"] then
			if AutoToxicGG["Enabled"] then
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("gg", "All")
			end
			if AutoToxicWin["Enabled"] then
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(#AutoToxicPhrases["ObjectList"] > 0 and AutoToxicPhrases["ObjectList"][math.random(1, #AutoToxicPhrases["ObjectList"])] or "EZ L TRASH KIDS"..(AutoToxicAd["Enabled"] and " : Sponsored by V????ape V4 :)" or ""), "All")
			end
		end
    end
    return AutoToxicOldWin(winstuff)
end

local clientcrasherenabled = false
local AntiCrash = {["Enabled"] = false}
AntiCrash = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton("AntiCrash", function()
	if clientcrasherenabled == false then
		for i2,v2 in pairs(getconnections(bedwars["ClientHandler"]:Get("LightningStrike")["instance"].OnClientEvent)) do
			v2:Disable()
		end
		clientcrasherenabled = true
	end
end, function() end, true, function() return "" end, "Prevents Lightning Crashing")

local AutoLeave = {["Enabled"] = false}
local autoleaveconnection
bedwars["ClientHandler"]:OnEvent("MatchEndEvent", function(p2)
	if AutoLeave["Enabled"] then
		bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
	end
end)
AutoLeave = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("AutoLeave", function()
	autoleaveconnection = players.PlayerAdded:connect(function(plr)
		if plr:IsInGroup(5774246) and plr:GetRankInGroup(5774246) >= 100 then
			bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
		end
	end)
	for i, plr in pairs(players:GetChildren()) do
		if plr:IsInGroup(5774246) and plr:GetRankInGroup(5774246) >= 100 then
			bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
		end
	end
end, function() 
	autoleaveconnection:Disconnect()
end, true, function() return "" end, "Leaves if a staff member joins your game or when the match ends.")

GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
local fly = {["Enabled"] = false}
local speedval = {["Value"] = 1}
local speedjump = {["Enabled"] = false}
local bodyvelo
local Scaffold = {["Enabled"] = false}
local speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("Speed", function()
	BindToRenderStep("Speed", 1, function(delta)
		if isAlive() and matchState ~= 0 then
			if (bodyvelo == nil or bodyvelo ~= nil and bodyvelo.Parent ~= lplr.Character.HumanoidRootPart) then
				bodyvelo = Instance.new("BodyVelocity")
				bodyvelo.Parent = lplr.Character.HumanoidRootPart
				bodyvelo.MaxForce = Vector3.new(100000, 0, 100000)
			else
				bodyvelo.Velocity = lplr.Character.Humanoid.MoveDirection * (fly["Enabled"] and 0 or speedval["Value"])
			end
			if speedjump["Enabled"] and killauranear and (not Scaffold["Enabled"]) then
				if (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) and lplr.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
					lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 20, lplr.Character.HumanoidRootPart.Velocity.Z)
				end
			end
		end
	end)
end, function() 
	if bodyvelo then
		bodyvelo:Remove()
	end
	UnbindFromRenderStep("Speed")
end, true, function() return "" end, "Increases your movement.")
speedval = speed.CreateSlider("Speed", 1, 26, function(val) end, 26)
speedjump = speed.CreateToggle("AutoJump", function() end, function() end)

local function getziplinepos()
	local tab = game.Workspace:GetChildren()
	local pos2 = Vector3.new(0, 0, 0)
			for i = 1, #tab do
				local obj = tab[i]
				
					if obj.Name:match("zipline") and obj.Name:match("base") and obj:FindFirstChild("ZiplineDestination")  then
						pos2 = obj.Position
					end

			end
			return pos2 / 3
end

GuiLibrary["RemoveObject"]("FlyOptionsButton")
local OldNoFallFunction
local flymethod = {["Value"] = "Balloons"}
local flyspeed = {["Value"] = 40}
local flyverticalspeed = {["Value"] = 40}
local flyupanddown = {["Enabled"] = true}
local flybuyballoon = {["Enabled"] = true}
local olddeflate
local flyposy = 0
local flyrequests = 0
local flytime = 60
local flylimit = false
local flyup = false
local flydown = false
local flypress
local flyendpress

local function buyballoons()
	if isAlive() and fly["Enabled"] then
		if getItem("balloon") == nil and flybuyballoon["Enabled"] then
			bedwars["ClientHandler"]:Get("BedwarsPurchaseItem"):CallServerAsync({
				shopItem = bedwars["Shop"].getShopItem("balloon")
			}):andThen(function(p11)
				if getItem("balloon") then
					bedwars["BalloonController"]["inflateBalloon"]()
				end
			end)
		end
		if getItem("balloon") then
			bedwars["BalloonController"]["inflateBalloon"]()
		end
	end
end

bedwars["ClientHandler"]:WaitFor("BalloonPopped"):andThen(function(p6)
	p6:Connect(function(p7)
		buyballoons()
	end)
end)

fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("Fly", function()
	if flymethod["Value"] == "Balloons" then
		olddeflate = bedwars["BalloonController"]["deflateBalloon"]
		bedwars["BalloonController"]["deflateBalloon"] = function() end
	end
	if isAlive() then
		flyposy = lplr.Character.HumanoidRootPart.Position.Y
		buyballoons()
	end
	flypress = game:GetService("UserInputService").InputBegan:connect(function(input1)
		if flyupanddown["Enabled"] and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
			if input1.KeyCode == Enum.KeyCode.Space then
				flyup = true
			end
			if input1.KeyCode == Enum.KeyCode.LeftShift then
				flydown = true
			end
		end
	end)
	flyendpress = game:GetService("UserInputService").InputEnded:connect(function(input1)
		if input1.KeyCode == Enum.KeyCode.Space then
			flyup = false
		end
		if input1.KeyCode == Enum.KeyCode.LeftShift then
			flydown = false
		end
	end)
	BindToRenderStep("Fly", 1, function(delta) 
		if isAlive() and matchState ~= 0 then
			if (flymethod["Value"] == "Balloons" and (lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0)) then
				if flyup then
					flyposy = flyposy + (1 * (math.clamp(flyverticalspeed["Value"] - 16, 1, 150) * delta))
				end
				if flydown then
					flyposy = flyposy - (1 * (math.clamp(flyverticalspeed["Value"] - 16, 1, 150) * delta))
				end
				local flypos = (lplr.Character.Humanoid.MoveDirection * (math.clamp(flyspeed["Value"] - 16, 1, 150) * delta))
				lplr.Character.HumanoidRootPart.Transparency = 1
				lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(flypos.X, (flyposy - lplr.Character.HumanoidRootPart.CFrame.p.Y), flypos.Z)
				lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
			end
		end
	end)
end, function() 
	flyup = false
	flydown = false
	flypress:Disconnect()
	flyendpress:Disconnect()
	UnbindFromRenderStep("Fly")
	if flymethod["Value"] == "Balloons" then
		if isAlive() and lplr.Character:GetAttribute("InflatedBalloons") then
			for i = 1, lplr.Character:GetAttribute("InflatedBalloons") do
				olddeflate()
			end
		end
		bedwars["BalloonController"]["deflateBalloon"] = olddeflate
		olddeflate = nil
	else

	end
end, true, function() return "" end, "Makes you go zoom (Balloons Required) (Will Buy)\nMake sure to turn off speed (hotkeys can help)")
flymethod = fly.CreateDropdown("Mode", {"Balloons"}, function(val)

end)
flyspeed = fly.CreateSlider("Speed", 1, 40, function(val) end, 40)
flyverticalspeed = fly.CreateSlider("Vertical Speed", 1, 40, function(val) end, 40)
flyupanddown = fly.CreateToggle("Y Level", function() end, function() end, true)
flybuyballoon = fly.CreateToggle("Buy Balloons", function() end, function() end, true)


local oldpos = Vector3.new(0, 0, 0)
local oldpos2 = Vector3.new(0, 0, 0)
local ScaffoldExpand = {["Value"] = 1}
local ScaffoldHandCheck = {["Enabled"] = false}
local ScaffoldBuyBlocks = {["Enabled"] = false}
local scaffoldallowed = true

Scaffold = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("Scaffold", function()
	BindToRenderStep("Scaffold", 1, function(delta)
		if isAlive() and (ScaffoldHandCheck["Enabled"] and getEquipped()["Type"] == "block" or (not ScaffoldHandCheck["Enabled"])) then
			for i = 1, ScaffoldExpand["Value"] do
				local newpos = getScaffold((lplr.Character.Head.Position + (lplr.Character.Humanoid.MoveDirection * (i * 3.5))) + Vector3.new(0, -6, 0))
				if newpos ~= oldpos then
					local wool, woolamount = getwool()
					if ScaffoldBuyBlocks["Enabled"] and (wool and woolamount < 4 or (not wool)) and scaffoldallowed == true then
						if (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) then
							scaffoldallowed = false
							lplr.Character.HumanoidRootPart.Anchored = true
						end
						bedwars["ClientHandler"]:Get("BedwarsPurchaseItem"):CallServerAsync({
							shopItem = bedwars["Shop"].getShopItem("wool_white")
						}):andThen(function(p11)
							scaffoldallowed = true
						end)
					end
					if getwool() then
						lplr.Character.HumanoidRootPart.Anchored = false
						scaffoldBlock(newpos)
						oldpos = newpos
					end
				end
			end
		end
	end)
end, function()
	UnbindFromRenderStep("Scaffold")
	scaffoldallowed = true
	oldpos = Vector3.new(0, 0, 0)
	oldpos2 = Vector3.new(0, 0, 0)
	if isAlive() then
		lplr.Character.HumanoidRootPart.Anchored = false
	end
end, true, function() return "" end, "Helps you make bridges/scaffold walk.")
ScaffoldExpand = Scaffold.CreateSlider("Expand", 1, 8, function(val) end, 1)
ScaffoldBuyBlocks = Scaffold.CreateToggle("Buy Blocks", function() end, function() end)
ScaffoldHandCheck = Scaffold.CreateToggle("Hand Check", function() end, function() end)

if GuiLibrary["Settings"]["ToxicObject"] == nil then
	GuiLibrary["Settings"]["ToxicObject"] = {["Type"] = "Custom", ["List"] = {}}
end

bedwars["ClientHandler"]:WaitFor("EntityDeathEvent"):andThen(function(p6)
	p6:Connect(function(p7)
		if AutoToxic["Enabled"] then
			if p7.fromEntity and p7.fromEntity == game.Players.LocalPlayer.Character then
				local plr = game.Players:GetPlayerFromCharacter(p7.entityInstance)
				if plr and plr.leaderstats.Bed.Value ~= "???" and AutoToxicFinalKill["Enabled"] then
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("L "..(plr.DisplayName or plr.Name)..(AutoToxicWinStreak["Enabled"] and game.Players:GetPlayerFromCharacter(p7.entityInstance):GetAttribute("WinStreak") > 0 and " : "..game.Players:GetPlayerFromCharacter(p7.entityInstance):GetAttribute("WinStreak").." winstreak" or ""), "All")
				end
			end
		end
	end)
end)
AutoToxic = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton("AutoToxic", function() end, function() end, true)
AutoToxicGG = AutoToxic.CreateToggle("AutoGG", function() end, function() end, true)
AutoToxicWin = AutoToxic.CreateToggle("Win", function() end, function() end, true)
AutoToxicFinalKill = AutoToxic.CreateToggle("Final Kill", function() end, function() end, true)
AutoToxicWinStreak = AutoToxic.CreateToggle("WinStreak", function() end, function() end, false)
AutoToxicAd = AutoToxic.CreateToggle("Sponsor", function() end, function() end, false)
AutoToxicPhrases = AutoToxic.CreateTextList("ToxicList", "phrase (win)", function(user) end, function(num) end)

--local BuyArrows = {["Enabled"] = false}
--local BowAura = {["Enabled"] = false}
--local bowaurarange = {["Value"] = 50}
--local BowDelay2 = {["Value"] = 5}
--local BowTargets = {["Value"] = 1}
--BowAura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("BowAura", function()
	--spawn(function()
		--repeat
		--	wait(BowDelay2["Value"] / 10)
		--	if isAlive() and getEquipped()["Type"] == "bow" then
			--	local targettable = {}
			--	local targetsize = 0
			--	local plrs = GetAllNearestHumanoidToPosition(bowaurarange["Value"], BowTargets["Value"])
			--	for i,v in pairs(plrs) do
			--		wait(0.03)
			--		local bowpos = bedwars["ProjectilePosition"]()
				--	if isPlayerTargetable(v, true, true) and v.Character and v.Character:FindFirstChild("Head") and vischeck(bowpos, v.Character.Head.Position, {lplr.Character, v.Character}) then
			--			targettable[v.Name] = {
				--			["UserId"] = v.UserId,
				--			["Health"] = v.Character.Humanoid.Health,
				--			["MaxHealth"] = v.Character.Humanoid.MaxHealth
					--	}
					--	targetsize = targetsize + 1
					--	game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged[bedwars["FireProjectile"]]:InvokeServer(getEquipped()["Object"], bowpos, (bowpos - v.Character.Head.Position))
				--	end
			--	end
			--	targetinfo.UpdateInfo(targettable, targetsize)
		--	end
		--until BowAura["Enabled"] == false
--	end)
--end, function() end, true)
--bowaurarange = BowAura.CreateSlider("Bow Range", 1, 70, function(val) end, 70)
--BowDelay2 = BowAura.CreateSlider("Bow Delay", 1, 20, function(val) end, 5)
--BowTargets = BowAura.CreateSlider("Bow Targets", 1, 20, function(val) end, 1)]]

local NoFall = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("NoFall", function()
	OldNoFallFunction = bedwars["damageTable"]["requestSelfDamage"]
	bedwars["damageTable"]["requestSelfDamage"] = function() end
end, function()
	bedwars["damageTable"]["requestSelfDamage"] = OldNoFallFunction
end, true, function() return "" end, "Prevents taking fall damage.")

local healthColorToPosition = {
	[Vector3.new(Color3.fromRGB(255, 28, 0).r,
  Color3.fromRGB(255, 28, 0).g,
  Color3.fromRGB(255, 28, 0).b)] = 0.1;
	[Vector3.new(Color3.fromRGB(250, 235, 0).r,
  Color3.fromRGB(250, 235, 0).g,
  Color3.fromRGB(250, 235, 0).b)] = 0.5;
	[Vector3.new(Color3.fromRGB(27, 252, 107).r,
  Color3.fromRGB(27, 252, 107).g,
  Color3.fromRGB(27, 252, 107).b)] = 0.8;
}
local min = 0.1
local minColor = Color3.fromRGB(255, 28, 0)
local max = 0.8
local maxColor = Color3.fromRGB(27, 252, 107)

local function HealthbarColorTransferFunction(healthPercent)
	if healthPercent < min then
		return minColor
	elseif healthPercent > max then
		return maxColor
	end


	local numeratorSum = Vector3.new(0,0,0)
	local denominatorSum = 0
	for colorSampleValue, samplePoint in pairs(healthColorToPosition) do
		local distance = healthPercent - samplePoint
		if distance == 0 then
			
			return Color3.new(colorSampleValue.x, colorSampleValue.y, colorSampleValue.z)
		else
			local wi = 1 / (distance*distance)
			numeratorSum = numeratorSum + wi * colorSampleValue
			denominatorSum = denominatorSum + wi
		end
	end
	local result = numeratorSum / denominatorSum
	return Color3.new(result.x, result.y, result.z)
end

local BedESP = {["Enabled"] = false}
local BedESPFolder = Instance.new("Folder")
BedESPFolder.Name = "BedESPFolder"
BedESPFolder.Parent = GuiLibrary["MainGui"]
local BedESPColor = {["Value"] = 0.44}
local BedESPTransparency = {["Value"] = 1}
local BedESPOnTop = {["Enabled"] = true}
BedESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton("BedESP", function() 
	BindToRenderStep("BedESP", 500, function()
		if bedwars["BedTable"] then
			for i,plr in pairs(bedwars["BedTable"]) do
					local thing
					if plr ~= nil and BedESPFolder:FindFirstChild(plr.Name..tostring(plr.Covers.BrickColor)) then
						thing = BedESPFolder[plr.Name..tostring(plr.Covers.BrickColor)]
						for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
							bedesppart.Visible = false
						end
					end
					
					if plr ~= nil and plr.Parent ~= nil and plr.Covers.BrickColor ~= lplr.Team.TeamColor then
						if BedESPFolder:FindFirstChild(plr.Name..tostring(plr.Covers.BrickColor)) == nil then
							local Bedfolder = Instance.new("Folder")
							Bedfolder.Name = plr.Name..tostring(plr.Covers.BrickColor)
							Bedfolder.Parent = BedESPFolder
							thing = Bedfolder
							for bedespnumber, bedesppart in pairs(plr:GetChildren()) do
								local boxhandle = Instance.new("BoxHandleAdornment")
								boxhandle.Size = bedesppart.Size + Vector3.new(.01, .01, .01)
								boxhandle.AlwaysOnTop = true
								boxhandle.ZIndex = 10
								boxhandle.Visible = true
								boxhandle.Color3 = bedesppart.Color
								boxhandle.Name = bedespnumber
								boxhandle.Parent = Bedfolder
							end
						end
						for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
							bedesppart.Visible = true
							if plr:GetChildren()[bedespnumber] then
								bedesppart.Adornee = plr:GetChildren()[bedespnumber]
							else
								bedesppart.Adornee = nil
							end
						end
					end
			end
		end
	end)
end, function() UnbindFromRenderStep("BedESP") BedESPFolder:ClearAllChildren() end, true, function() return "" end, "testing")

GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
local NameTagsFolder = Instance.new("Folder")
NameTagsFolder.Name = "NameTagsFolder"
NameTagsFolder.Parent = GuiLibrary["MainGui"]
players.PlayerRemoving:connect(function(plr)
	if NameTagsFolder:FindFirstChild(plr.Name) then
		NameTagsFolder[plr.Name]:Remove()
	end
end)
local NameTagsColor = {["Value"] = 0.44}
local NameTagsDisplayName = {["Enabled"] = false}
local NameTagsHealth = {["Enabled"] = false}
local NameTagsDistance = {["Enabled"] = false}
local NameTagsShowInventory = {["Enabled"] = false}
local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton("NameTags", function() 
	BindToRenderStep("NameTags", 500, function()
		for i,plr in pairs(players:GetChildren()) do
				local thing
				if NameTagsFolder:FindFirstChild(plr.Name) then
					thing = NameTagsFolder[plr.Name]
					thing.Visible = false
				else
					thing = Instance.new("TextLabel")
					thing.BackgroundTransparency = 0.5
					thing.BackgroundColor3 = Color3.new(0, 0, 0)
					thing.BorderSizePixel = 0
					thing.Visible = false
					thing.RichText = true
					thing.Name = plr.Name
					thing.Font = Enum.Font.SourceSans
					thing.TextSize = 14
					if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
						local rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
						if NameTagsHealth["Enabled"] then
							rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name).." "..math.floor(plr.Character.Humanoid.Health)
						end
						local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
						local modifiedText = (NameTagsDistance["Enabled"] and isAlive() and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
						local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
						thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
						thing.Text = modifiedText
					else
						local nametagSize = game:GetService("TextService"):GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
						thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
						thing.Text = plr.Name
					end
					thing.TextColor3 = tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color or (GuiLibrary["ObjectsThatCanBeSaved"]["Use colorToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["FriendsObject"]["Friends"], plr.Name) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"], 1, 1)) or Color3.fromHSV(NameTagsColor["Value"], 1, 1)
					thing.Parent = NameTagsFolder
					local hand = Instance.new("ImageLabel")
					hand.Size = UDim2.new(0, 30, 0, 30)
					hand.Name = "Hand"
					hand.BackgroundTransparency = 1
					hand.Position = UDim2.new(0, -30, 0, -30)
					hand.Image = ""
					hand.Parent = thing
					local helmet = hand:Clone()
					helmet.Name = "Helmet"
					helmet.Position = UDim2.new(0, 5, 0, -30)
					helmet.Parent = thing
					local chest = hand:Clone()
					chest.Name = "Chestplate"
					chest.Position = UDim2.new(0, 35, 0, -30)
					chest.Parent = thing
					local boots = hand:Clone()
					boots.Name = "Boots"
					boots.Position = UDim2.new(0, 65, 0, -30)
					boots.Parent = thing
				end
				
				if isPlayerTargetable(plr, false, false) then
					local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, plr.Character.Head.Size.Y + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
					headPos = headPos * (1 / GuiLibrary["MainRescale"].Scale)
					
					if headVis then
						local inventory = bedwars["getInventory"](plr)
						if inventory.hand then
							thing.Hand.Image = bedwars["getIcon"](inventory.hand, NameTagsShowInventory["Enabled"])
						end
						if inventory.armor[4] then
							thing.Helmet.Image = bedwars["getIcon"](inventory.armor[4], NameTagsShowInventory["Enabled"])
						end
						if inventory.armor[5] then
							thing.Chestplate.Image = bedwars["getIcon"](inventory.armor[5], NameTagsShowInventory["Enabled"])
						end
						if inventory.armor[6] then
							thing.Boots.Image = bedwars["getIcon"](inventory.armor[6], NameTagsShowInventory["Enabled"])
						end
						local blocksaway = math.floor(((isAlive() and lplr.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)) - plr.Character.HumanoidRootPart.Position).magnitude / 3)
						local rawText = (NameTagsDistance["Enabled"] and isAlive() and "["..blocksaway.."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(plr.Character.Humanoid.Health) or "")
						local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
						local modifiedText = (NameTagsDistance["Enabled"] and isAlive() and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..blocksaway..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
						local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
						thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
						thing.Text = modifiedText
						thing.TextColor3 = tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color or (GuiLibrary["ObjectsThatCanBeSaved"]["Use colorToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["FriendsObject"]["Friends"], plr.Name) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"], 1, 1)) or Color3.fromHSV(NameTagsColor["Value"], 1, 1)
						thing.Visible = headVis
						thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
					end
				end
			end

	end)
end, function() UnbindFromRenderStep("NameTags") NameTagsFolder:ClearAllChildren() end, true)
NameTagsColor = NameTags.CreateColorSlider("Player Color", function(val) end)
NameTagsDisplayName = NameTags.CreateToggle("Use Display Name", function() end, function() end)
NameTagsHealth = NameTags.CreateToggle("Health", function() end, function() end)
NameTagsDistance = NameTags.CreateToggle("Distance", function() end, function() end)
NameTagsShowInventory = NameTags.CreateToggle("Show Inventory", function() end, function() end)
