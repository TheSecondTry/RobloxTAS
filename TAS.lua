repeat wait() until game:IsLoaded()

local TAS = {}
-- TAS Data: 1. Head, 2. Torso, 3-4. Left Arm/Leg, 5-6. Right Arm/Leg, 7. Camera, 8. Velocity
local playback = false

local character = game:GetService("Players").LocalPlayer.Character
local UserInputService = game:GetService("UserInputService")
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
				rerecords = rerecords + 1
				print("Loaded state.")
			else
				print("Cannot load state.")
			end
		end
	end
end)

-- character.Animate.Disabled = true
local GUI = script.ScreenGui:clone()
GUI.Parent = game:GetService("Players").LocalPlayer.PlayerGui

print("Roblox TAS System starting..")
repeat
	wait()
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
	GUI.TextLabel.Text = "Frame: " .. tostring(frame) .. "\nTime: " .. displayH .. ":" .. displayM .. ":" .. displayS .. "\nRerecords: " .. tostring(rerecords)
	if SlowdownEnabled then
		script.Paused.Value = true
		for _,partName in pairs(BodyParts) do
			character[partName].Anchored = true
		end
		if FrameAdvance then
			repeat wait() until UserInputService:IsKeyDown(Enum.KeyCode[FrameAdvanceHotkey])
		else
			wait(Settings.Wait.Value)
		end
		for _,partName in pairs(BodyParts) do
			character[partName].Anchored = false
		end
		script.Paused.Value = false
	end
	table.insert(TAS, frame, {character.Head.CFrame, character.Torso.CFrame, character["Left Arm"].CFrame, character["Left Leg"].CFrame, character["Right Arm"].CFrame, character["Right Leg"].CFrame, workspace.CurrentCamera.CFrame})
until UserInputService:IsKeyDown(Enum.KeyCode[EndTAS])

playback = true

local length = frame
local sLength = seconds
frame = 0
seconds = 0
for _,partName in pairs(BodyParts) do
	character[partName].Anchored = true
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
	character.Head.CFrame = TAS[frame][1]
	character.Torso.CFrame = TAS[frame][2]
	character["Left Arm"].CFrame = TAS[frame][3]
	character["Left Leg"].CFrame = TAS[frame][4]
	character["Right Arm"].CFrame = TAS[frame][5]
	character["Right Leg"].CFrame = TAS[frame][6]
	workspace.CurrentCamera.CFrame = TAS[frame][7]
	if frame >= length then
		frame = 0
		seconds = 0
	end
end
