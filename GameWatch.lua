-- Replace the value here with your Roblox username
local playerName = "luigidasonic"

local WidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float, -- initialize in floating panel
	true, -- Widget will be initially enabled
	false, -- Don't override the previous enabled state
	200, -- Window default width
	300, -- Window default height
	150, -- Window minimum width
	150  -- Window minimum height
)

local WatchWidget = plugin:CreateDockWidgetPluginGui("GameWatch",WidgetInfo)
WatchWidget.Name = "GameWatch"
WatchWidget.Title = "Game Watch"

local background = Instance.new("Frame")
background.BorderSizePixel = 0
background.BackgroundColor3 = Color3.new(0,0,0)
background.AnchorPoint = Vector2.new(.5,.5)
background.Size = UDim2.new(1,0,1,0)
background.Position = UDim2.new(.5,0,.5,0)
background.ZIndex = 1
background.Parent = WatchWidget

local info = Instance.new("TextLabel")
info.BorderSizePixel = 0
info.BackgroundTransparency = 1
info.AnchorPoint = Vector2.new(0,0)
info.Position = UDim2.new(.1,0,.1,0)
info.Size = UDim2.new(.8,0,.8,0)
info.ZIndex = 2
info.TextColor3 = Color3.new(255,255,255)
info.TextSize = 20
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.SizeConstraint = Enum.SizeConstraint.RelativeYY
info.Parent = background

while(1)do
	wait()
	background.Size = UDim2.new(1,0,1,0)
	info.Size = UDim2.new(.8,0,.8,0)
	local player = workspace:FindFirstChild(playerName)
	if player and player:FindFirstChild("HumanoidRootPart") then
		info.Text = 
			"Player X: " .. tostring(math.floor(player.HumanoidRootPart.Position.X * 1000) / 1000) .. "\n" ..
			"Player Y: " .. tostring(math.floor(player.HumanoidRootPart.Position.Y * 1000) / 1000) .. "\n" ..
			"Player Z: " .. tostring(math.floor(player.HumanoidRootPart.Position.Z * 1000) / 1000) .. "\n" ..
			"Player Direction X: " .. tostring(math.floor(player.Humanoid.MoveDirection.X * 1000000) / 1000) .. "\n" ..
			"Player Direction Y: " .. tostring(math.floor(player.Humanoid.MoveDirection.Y * 1000000) / 1000) .. "\n" ..
			"Player Direction Z: " .. tostring(math.floor(player.Humanoid.MoveDirection.Z * 1000000) / 1000) .. "\n" ..
			"Player Velocity X: " .. tostring(math.floor(player.Torso.Velocity.X * 1000) / 1000) .. "\n" ..
			"Player Velocity Y: " .. tostring(math.floor(player.Torso.Velocity.Y * 1000) / 1000) .. "\n" ..
			"Player Velocity Z: " .. tostring(math.floor(player.Torso.Velocity.Z * 1000) / 1000) .. "\n"
	elseif player then
		info.Text = "Loading.."
	else
		info.Text = "Please start the game."
	end
end



