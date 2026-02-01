-- 核心配置：可自定义初始速度、速度步长、快捷键
local CONFIG = {
    INIT_SPEED = 25,       -- 初始移动速度（默认25，Roblox默认约16）
    SPEED_STEP = 5,        -- 每次增减的速度值
    HOTKEY_PLUS = Enum.KeyCode.Equals,    -- 加速快捷键（=键）
    HOTKEY_MINUS = Enum.KeyCode.Minus,    -- 减速快捷键（-键）
    HOTKEY_RESET = Enum.KeyCode.R,        -- 重置速度快捷键（R键）
    HOTKEY_TOGGLE_GUI = Enum.KeyCode.F1   -- 隐藏/显示GUI快捷键（F1键）
}

-- 创建GUI界面
local function createGUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "SpeedControlGUI"
    mainGui.Parent = game.Players.LocalPlayer.PlayerGui
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.ResetOnSpawn = false

    -- 主框架
    local frame = Instance.new("Frame")
    frame.Parent = mainGui
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
    frame.Position = UDim2.new(0.02, 0, 0.8, 0)
    frame.Size = UDim2.new(0, 220, 0, 80)
    frame.Draggable = true
    frame.Active = true

    -- 标题标签
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = Enum.Font.SourceSansBold
    title.Text = "自定义速度控制器（F1隐藏/显示）"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14

    -- 速度显示标签
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = frame
    speedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedLabel.Position = UDim2.new(0.35, 0, 0.35, 0)
    speedLabel.Size = UDim2.new(0, 50, 0, 25)
    speedLabel.Font = Enum.Font.SourceSansBold
    speedLabel.Text = CONFIG.INIT_SPEED
    speedLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    speedLabel.TextSize = 18
    speedLabel.Name = "SpeedDisplay"

    -- 加速按钮
    local plusBtn = Instance.new("TextButton")
    plusBtn.Parent = frame
    plusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    plusBtn.Position = UDim2.new(0.65, 0, 0.35, 0)
    plusBtn.Size = UDim2.new(0, 30, 0, 25)
    plusBtn.Font = Enum.Font.SourceSansBold
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.TextSize = 20
    plusBtn.Name = "PlusBtn"

    -- 减速按钮
    local minusBtn = Instance.new("TextButton")
    minusBtn.Parent = frame
    minusBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    minusBtn.Position = UDim2.new(0.15, 0, 0.35, 0)
    minusBtn.Size = UDim2.new(0, 30, 0, 25)
    minusBtn.Font = Enum.Font.SourceSansBold
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.TextSize = 20
    minusBtn.Name = "MinusBtn"

    -- 重置按钮
    local resetBtn = Instance.new("TextButton")
    resetBtn.Parent = frame
    resetBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
    resetBtn.Position = UDim2.new(0.3, 0, 0.7, 0)
    resetBtn.Size = UDim2.new(0, 70, 0, 20)
    resetBtn.Font = Enum.Font.SourceSansBold
    resetBtn.Text = "重置"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.TextSize = 14
    resetBtn.Name = "ResetBtn"

    return mainGui
end

-- 核心速度控制逻辑
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local currentSpeed = CONFIG.INIT_SPEED
local speedGUI = createGUI()
local frame = speedGUI:FindFirstChild("Frame")
local speedDisplay = frame:FindFirstChild("SpeedDisplay")

-- 更新速度显示与实际速度（取消阈值限制）
local function updateSpeed(newSpeed)
    currentSpeed = newSpeed
    humanoid.WalkSpeed = currentSpeed
    speedDisplay.Text = tostring(currentSpeed)
end

-- GUI按钮绑定
frame:FindFirstChild("PlusBtn").MouseButton1Click:Connect(function()
    updateSpeed(currentSpeed + CONFIG.SPEED_STEP)
end)

frame:FindFirstChild("MinusBtn").MouseButton1Click:Connect(function()
    updateSpeed(currentSpeed - CONFIG.SPEED_STEP)
end)

frame:FindFirstChild("ResetBtn").MouseButton1Click:Connect(function()
    updateSpeed(CONFIG.INIT_SPEED)
end)

-- 快捷键绑定（新增GUI隐藏/显示）
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CONFIG.HOTKEY_PLUS then
        updateSpeed(currentSpeed + CONFIG.SPEED_STEP)
    elseif input.KeyCode == CONFIG.HOTKEY_MINUS then
        updateSpeed(currentSpeed - CONFIG.SPEED_STEP)
    elseif input.KeyCode == CONFIG.HOTKEY_RESET then
        updateSpeed(CONFIG.INIT_SPEED)
    elseif input.KeyCode == CONFIG.HOTKEY_TOGGLE_GUI then
        frame.Visible = not frame.Visible
    end
end)

-- 角色重生时重新绑定
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    updateSpeed(currentSpeed) -- 保持重生后速度不变
end)

-- 初始化速度
updateSpeed(CONFIG.INIT_SPEED)
print("自定义速度脚本加载完成！当前速度：" .. currentSpeed)
