repeat wait() until game:IsLoaded()

local TAS = {}
-- TAS Data: 1. Head, 2. Torso, 3-4. Left Arm/Leg, 5-6. Right Arm/Leg, 7. Camera
local playback = false

local player = game:GetService("Players").LocalPlayer
local character = player.Character
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = script.Settings
local Hotkeys = Settings.Hotkeys
local Savestates = script.TAS.Savestates
local savestate = Savestates.Save
local BodyParts = {
	"Head",
	"Left Arm",
	"Left Leg",
	"Right Arm",
	"Right Leg",
	"Torso"
}

local SlowdownToggle = Hotkeys.SlowdownToggle.Value
local FrameAdvanceToggle = Hotkeys.FrameAdvanceToggle.Value
local FrameAdvanceHotkey = Hotkeys.FrameAdvanceHotkey.Value
local SaveState = Hotkeys.SaveState.Value
local LoadState = Hotkeys.LoadState.Value
local EndTAS = Hotkeys.EndTAS.Value

local FrameAdvance = Settings.FrameAdvanceEnabled.Value
local SlowdownEnabled = Settings.SlowdownEnabled.Value

local frame = 0
local seconds = 0
local rerecords = 0

-- Savestates
UserInputService.InputBegan:connect(function(input)
	if not playback then
		if input.KeyCode == Enum.KeyCode[FrameAdvanceToggle] then
			FrameAdvance = not FrameAdvance
			if FrameAdvance then
				print("Frame advance enabled.")
			else
				print("Frame advance disabled.")
			end
		elseif input.KeyCode == Enum.KeyCode[SlowdownToggle] then
			SlowdownEnabled = not SlowdownEnabled
			if SlowdownEnabled then
				print("Slowdown enabled.")
			else
				print("Slowdown disabled.")
			end
		elseif input.KeyCode == Enum.KeyCode[SaveState] then
			if not savestate.Value then savestate.Value = true end
			Savestates.Camera.Value = workspace.CurrentCamera.CFrame
			for _,partName in pairs(BodyParts) do
				Savestates[partName].Value = character[partName].CFrame
			end
			Savestates.Velocity.Value = character.Torso.Velocity
			Savestates.Speed.Value = character.Humanoid.WalkSpeed
			Savestates.JumpPower.Value = character.Humanoid.JumpPower
			Savestates.Gravity.Value = workspace.Gravity
			Savestates.Frame.Value = frame
			Savestates.Seconds.Value = seconds
			print("Saved state.")
		elseif input.KeyCode == Enum.KeyCode[LoadState] then
			if savestate.Value then
				frame = Savestates.Frame.Value
				seconds = Savestates.Seconds.Value
				for x = Savestates.Frame.Value,#TAS,1 do
					table.remove(TAS,x)
				end
				workspace.CurrentCamera.CFrame = Savestates.Camera.Value
				for _,partName in pairs(BodyParts) do
					character[partName].CFrame = Savestates[partName].Value
				end
				character.Torso.Velocity = Savestates.Velocity.Value
				character.Humanoid.WalkSpeed = Savestates.Speed.Value
				character.Humanoid.JumpPower = Savestates.JumpPower.Value
				workspace.Gravity = Savestates.Gravity.Value
				rerecords = rerecords + 1
				print("Loaded state.")
			else
				print("Cannot load state.")
			end
		end
	end
end)

-- Add GUI
ReplicatedStorage.CreateGUI:InvokeServer()
local GUI = player.PlayerGui:WaitForChild("ScreenGui")

print("Roblox TAS System starting..")
repeat
	wait()
	-- CFrame variables
	local headC = nil
	local torsoC = nil
	local leftArmC = nil
	local rightArmC = nil
	local leftLegC = nil
	local rightLegC = nil
	-- Timer
	frame = frame + 1
	seconds = seconds + 1 / 30
	-- On screen timer
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
	GUI.TextLabel.Text = "Frame: " .. tostring(frame) .. "\nTime: " .. displayH .. ":" .. displayM .. ":" .. displayS .. "\nRerecords: " .. tostring(rerecords)
	-- Slowdown
	if SlowdownEnabled then
		script.Paused.Value = true
		for _,partName in pairs(BodyParts) do
			if character:FindFirstChild(partName) then
				character[partName].Anchored = true
			end
		end
		if FrameAdvance then
			repeat wait() until UserInputService:IsKeyDown(Enum.KeyCode[FrameAdvanceHotkey])
		else
			wait(Settings.Wait.Value)
		end
		for _,partName in pairs(BodyParts) do
			if character:FindFirstChild(partName) then
				character[partName].Anchored = false
			end
		end
		script.Paused.Value = false
	end
	if character:FindFirstChild("Head") then headC = character.Head.CFrame end
	if character:FindFirstChild("Torso") then torsoC = character.Torso.CFrame end
	if character:FindFirstChild("Left Arm") then leftArmC = character["Left Arm"].CFrame end
	if character:FindFirstChild("Left Leg") then leftLegC = character["Left Leg"].CFrame end
	if character:FindFirstChild("Right Arm") then rightArmC = character["Right Arm"].CFrame end
	if character:FindFirstChild("Right Leg") then rightLegC = character["Right Leg"].CFrame end
	table.insert(TAS, frame, {headC, torsoC, leftArmC, leftLegC, rightArmC, rightLegC, workspace.CurrentCamera.CFrame})
until UserInputService:IsKeyDown(Enum.KeyCode[EndTAS])

-- Playback
playback = true

--[[
local length = frame
local sLength = seconds
frame = 0
seconds = 0
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
	GUI.TextLabel.Text = "Frame: " .. tostring(frame) .. " / " .. tostring(length) .. "\nTime: " .. displayH .. ":" .. displayM .. ":" .. displayS .. " / " .. sDisplayH .. ":" .. sDisplayM .. ":" .. sDisplayS .. "\nRerecords: " .. tostring(rerecords)
	if character:FindFirstChild("Head") and TAS[frame][1] ~= nil then character.Head.CFrame = TAS[frame][1] end
	if character:FindFirstChild("Torso") and TAS[frame][2] ~= nil then character.Torso.CFrame = TAS[frame][2] end
	if character:FindFirstChild("Left Arm") and TAS[frame][3] ~= nil then character["Left Arm"].CFrame = TAS[frame][3] end
	if character:FindFirstChild("Left Leg") and TAS[frame][4] ~= nil then character["Left Leg"].CFrame = TAS[frame][4] end
	if character:FindFirstChild("Right Arm") and TAS[frame][5] ~= nil then character["Right Arm"].CFrame = TAS[frame][5] end
	if character:FindFirstChild("Right Leg") and TAS[frame][6] ~= nil then character["Right Leg"].CFrame = TAS[frame][6] end
	workspace.CurrentCamera.CFrame = TAS[frame][7]
	if frame >= length then
		frame = 0
		seconds = 0
	end
end
--]]

local length = frame
local sLength = seconds
ReplicatedStorage.PlayTAS:InvokeServer(TAS, length, sLength, rerecords)
frame = 0
seconds = 0


