-- TAS Data: 1. Head, 2. Torso, 3-4. Left Arm/Leg, 5-6. Right Arm/Leg, 7. Camera
local BodyParts = {
	"Head",
	"Left Arm",
	"Left Leg",
	"Right Arm",
	"Right Leg",
	"Torso"
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage.CreateGUI.OnServerInvoke = function(player)
	local PlayerGui = player.PlayerGui
	
	local TAS_GUI = Instance.new("ScreenGui", PlayerGui)
	local TAS_textLabel = Instance.new("TextLabel", TAS_GUI)
	TAS_textLabel.BackgroundTransparency = 1
	TAS_textLabel.Position = UDim2.new(.018, 0, .87, 0)
	TAS_textLabel.Size = UDim2.new(.3, 0, .1, 0)
	TAS_textLabel.TextScaled = true
	TAS_textLabel.TextXAlignment = Enum.TextXAlignment.Left
end

ReplicatedStorage.PlayTAS.OnServerInvoke = function(player, TAS, length, sLength, rerecords)
	local frame = 0
	local seconds = 0
	
	local character = player.Character
	for _,partName in pairs(BodyParts) do
		if character:FindFirstChild(partName) then character[partName].Anchored = true end
	end
	
	while wait() do
		frame = frame + 1
		seconds = seconds + 1 / 30
		
		local displayH = math.floor((seconds / 60) / 60)
		if displayH < 10 then
			displayH = "0" .. tostring(displayH)
		end
		local displayM = math.floor(seconds / 60) % 60
		if displayM < 10 then
			displayM = "0" .. tostring(displayM)
		end
		local displayS = (math.floor(seconds * 1000) / 1000) % 60
		if displayS < 10 then
			displayS = "0" .. tostring(displayS)
		end
		local sDisplayH = math.floor((sLength / 60) / 60)
		if sDisplayH < 10 then
			sDisplayH = "0" .. tostring(sDisplayH)
		end
		local sDisplayM = math.floor(sLength / 60) % 60
		if sDisplayM < 10 then
			sDisplayM = "0" .. tostring(sDisplayM)
		end
		local sDisplayS = (math.floor(sLength * 1000) / 1000) % 60
		if sDisplayS < 10 then
			sDisplayS = "0" .. tostring(sDisplayS)
		end
		player.PlayerGui.ScreenGui.TextLabel.Text = "Frame: " .. tostring(frame) .. " / " .. tostring(length) .. "\nTime: " .. displayH .. ":" .. displayM .. ":" .. displayS .. " / " .. sDisplayH .. ":" .. sDisplayM .. ":" .. sDisplayS .. "\nRerecords: " .. tostring(rerecords)
		
		-- if character:FindFirstChild("body part name here") and TAS[frame][body part index] ~= nil then character["BodyPartNameHere"].CFrame = TAS[frame][body part index] end
		if character:FindFirstChild("Head") and TAS[frame][1] ~= nil then character.Head.CFrame = TAS[frame][1] end
		if character:FindFirstChild("Torso") and TAS[frame][2] ~= nil then character.Torso.CFrame = TAS[frame][2] end
		if character:FindFirstChild("Left Arm") and TAS[frame][3] ~= nil then character["Left Arm"].CFrame = TAS[frame][3] end
		if character:FindFirstChild("Left Leg") and TAS[frame][4] ~= nil then character["Left Leg"].CFrame = TAS[frame][4] end
		if character:FindFirstChild("Right Arm") and TAS[frame][5] ~= nil then character["Right Arm"].CFrame = TAS[frame][5] end
		if character:FindFirstChild("Right Leg") and TAS[frame][6] ~= nil then character["Right Leg"].CFrame = TAS[frame][6] end
		
		if frame >= length then
			frame = 0
			seconds = 0
		end
	end
end


