repeat task.wait() until game:IsLoaded()

local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

-- ===== LOAD SCREEN 10S =====
local loadGui = Instance.new("ScreenGui", plr.PlayerGui)
loadGui.IgnoreGuiInset = true
loadGui.ResetOnSpawn = false

local bg = Instance.new("Frame", loadGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.new(0,0,0)

local txt = Instance.new("TextLabel", bg)
txt.Size = UDim2.new(1,0,0.4,0)
txt.Position = UDim2.new(0,0,0.2,0)
txt.BackgroundTransparency = 1
txt.Text = "KEN HUB LOADING..."
txt.TextScaled = true
txt.Font = Enum.Font.GothamBlack
txt.TextColor3 = Color3.new(1,1,1)

local note = Instance.new("TextLabel", bg)
note.Size = UDim2.new(1,0,0.1,0)
note.Position = UDim2.new(0,0,0.45,0)
note.BackgroundTransparency = 1
note.Text = "nếu m bị lỗi j bấm reset stat"
note.TextScaled = true
note.Font = Enum.Font.Gotham
note.TextColor3 = Color3.fromRGB(180,180,180)

local barBg = Instance.new("Frame", bg)
barBg.Size = UDim2.new(0.6,0,0,18)
barBg.Position = UDim2.new(0.2,0,0.6,0)
barBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", barBg)

local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(0,255,120)
Instance.new("UICorner", barFill)

local percent = Instance.new("TextLabel", bg)
percent.Size = UDim2.new(1,0,0.1,0)
percent.Position = UDim2.new(0,0,0.63,0)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextScaled = true
percent.Font = Enum.Font.GothamBold
percent.TextColor3 = Color3.new(1,1,1)

for i = 1,100 do
	barFill.Size = UDim2.new(i/100,0,1,0)
	percent.Text = i.."%"
	task.wait(0.1)
end

loadGui:Destroy()

-- ===== MAIN GUI =====
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,380)
main.Position = UDim2.new(0.5,-150,0.5,-190)
main.BackgroundTransparency = 0.15
Instance.new("UICorner", main)

-- ===== RAINBOW MENU =====
RunService.RenderStepped:Connect(function()
	local t = tick()
	main.BackgroundColor3 = Color3.fromRGB(
		math.sin(t)*127+128,
		math.sin(t+2)*127+128,
		math.sin(t+4)*127+128
	)
end)

local holder = Instance.new("ScrollingFrame", main)
holder.Size = UDim2.new(1,0,1,0)
holder.CanvasSize = UDim2.new(0,0,0,950)
holder.BackgroundTransparency = 1
holder.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", holder)
layout.Padding = UDim.new(0,5)

-- ===== TOGGLE BUTTON =====
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,90,0,32)
toggle.Position = UDim2.new(0,10,0.5,-16)
toggle.Text = "KEN HUB"
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBold
toggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- ===== VARS =====
local speed = 16
local jump = 50
local infJump = false
local noclip = false

local function hum()
	local c = plr.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

RunService.Heartbeat:Connect(function()
	local h = hum()
	if h then
		h.WalkSpeed = speed
		h.UseJumpPower = true
		h.JumpPower = jump
	end

	if noclip and plr.Character then
		for _,v in pairs(plr.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

UIS.JumpRequest:Connect(function()
	if infJump then
		local h = hum()
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ===== LANGUAGE SYSTEM =====
local currentLang = "VI"
local allButtons = {}

local function register(btn, vi, en)
	table.insert(allButtons, {btn=btn, vi=vi, en=en})
end

local function refreshLang()
	for _,b in pairs(allButtons) do
		b.btn.Text = (currentLang=="VI") and b.vi or b.en
	end
end

local function Button(vi, en, cb)
	local b = Instance.new("TextButton", holder)
	b.Size = UDim2.new(0.95,0,0,30)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.Text = (currentLang=="VI") and vi or en
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(cb)

	register(b, vi, en)
end

-- ===== LANGUAGE DROPDOWN =====
local langMain = Instance.new("TextButton", holder)
langMain.Size = UDim2.new(0.95,0,0,30)
langMain.BackgroundColor3 = Color3.fromRGB(40,40,40)
langMain.Text = "Language"
langMain.TextScaled = true
langMain.Font = Enum.Font.Gotham
langMain.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", langMain)

local drop = Instance.new("Frame", holder)
drop.Size = UDim2.new(0.95,0,0,0)
drop.BackgroundTransparency = 1
drop.ClipsDescendants = true

local viBtn = Instance.new("TextButton", drop)
viBtn.Size = UDim2.new(1,0,0,28)
viBtn.Text = "Vietnamese"
viBtn.TextScaled = true
viBtn.Font = Enum.Font.Gotham
viBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
viBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", viBtn)

local enBtn = Instance.new("TextButton", drop)
enBtn.Size = UDim2.new(1,0,0,28)
enBtn.Position = UDim2.new(0,0,0,30)
enBtn.Text = "English"
enBtn.TextScaled = true
enBtn.Font = Enum.Font.Gotham
enBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
enBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", enBtn)

local opened = false
langMain.MouseButton1Click:Connect(function()
	opened = not opened
	drop.Size = opened and UDim2.new(0.95,0,0,62) or UDim2.new(0.95,0,0,0)
end)

viBtn.MouseButton1Click:Connect(function()
	currentLang = "VI"
	refreshLang()
end)

enBtn.MouseButton1Click:Connect(function()
	currentLang = "EN"
	refreshLang()
end)

-- ===== SLIDERS =====
local function Slider(name, min, max, def, cb)
	local frame = Instance.new("Frame", holder)
	frame.Size = UDim2.new(0.95,0,0,42)
	frame.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1,0,0,18)
	label.BackgroundTransparency = 1
	label.Text = name..": "..def
	label.TextScaled = true
	label.Font = Enum.Font.Gotham
	label.TextColor3 = Color3.new(1,1,1)

	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(1,0,0,14)
	bar.Position = UDim2.new(0,0,0,24)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((def-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(0,255,120)
	Instance.new("UICorner", fill)

	local dragging = false
	bar.InputBegan:Connect(function() dragging=true end)
	UIS.InputEnded:Connect(function() dragging=false end)

	UIS.InputChanged:Connect(function(i)
		if dragging then
			local pos = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			fill.Size = UDim2.new(pos,0,1,0)
			local val = math.floor(min+(max-min)*pos)
			label.Text = name..": "..val
			cb(val)
		end
	end)
end

Slider("Speed",16,500,16,function(v) speed=v end)
Slider("Jump",50,300,50,function(v) jump=v end)

-- ===== 20 BUTTONS =====
Button("Nhảy Vô Hạn", "Infinite Jump", function() infJump = not infJump end)
Button("Xuyên Tường", "Noclip", function() noclip = not noclip end)
Button("Reset Stat", "Reset Stats", function() speed=16 jump=50 end)
Button("Vào Lại", "Rejoin", function() TeleportService:Teleport(game.PlaceId, plr) end)
Button("Sáng Tối Đa", "Full Bright", function() Lighting.Brightness = 3 end)
Button("Sáng Bình Thường", "Normal Bright", function() Lighting.Brightness = 1 end)
Button("Ngồi", "Sit", function() local h=hum() if h then h.Sit=true end end)
Button("Ép Nhảy", "Force Jump", function() local h=hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
Button("Boost Lên", "Spin Boost", function()
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.Velocity = Vector3.new(0,60,0) end
end)
Button("Zoom Camera", "Zoom Camera", function() workspace.CurrentCamera.FieldOfView = 120 end)
Button("Camera Thường", "Normal Camera", function() workspace.CurrentCamera.FieldOfView = 70 end)
Button("Anti Lag", "Anti Lag", function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then v.Material = Enum.Material.Plastic end
	end
end)
Button("Trọng Lực Thấp", "Low Gravity", function() workspace.Gravity = 50 end)
Button("Trọng Lực Thường", "Normal Gravity", function() workspace.Gravity = 196 end)
Button("Speed 100", "Speed 100", function() speed = 100 end)
Button("Jump 150", "Jump 150", function() jump = 150 end)
Button("Speed 200", "Speed 200", function() speed = 200 end)
Button("Jump 250", "Jump 250", function() jump = 250 end)
Button("Dừng Di Chuyển", "Stop Movement", function() speed = 0 end)
Button("Tắt GUI", "Destroy GUI", function() gui:Destroy() end)
