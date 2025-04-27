local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ImGuiCheatLib"
screenGui.Parent = PlayerGui

-- Main Window
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 320, 0, 240)
window.Position = UDim2.new(0.5, -160, 0.5, -120)
window.BackgroundColor3 = Color3.fromRGB(30, 37, 37) -- Dark gray like ImGui
window.BorderSizePixel = 0
window.Parent = screenGui

-- Draggable window logic
local dragging, dragInput, dragStart, startPos
local canDrag = true
window.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and canDrag then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
window.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title Bar with Collapse Triangle
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 20, 0, 20)
collapseButton.Position = UDim2.new(0, 0, 0, 0)
collapseButton.BackgroundTransparency = 1
collapseButton.Text = "🔽"
collapseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseButton.TextSize = 14
collapseButton.Font = Enum.Font.Code
collapseButton.Parent = titleBar

collapseButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = false
    end
end)
collapseButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = true
    end
end)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Cheat Menu - ImGui Style"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 14
titleText.Font = Enum.Font.Code
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextYAlignment = Enum.TextYAlignment.Center
titleText.Parent = titleBar

-- Content Frame (with background)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -20)
contentFrame.Position = UDim2.new(0, 0, 0, 20)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 37, 37) -- Ensure background persists
contentFrame.BorderSizePixel = 0
contentFrame.Parent = window

-- Toggle collapse
local isCollapsed = false
collapseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    collapseButton.Text = isCollapsed and "▶" or "🔽"
    contentFrame.Visible = not isCollapsed
    window.Size = isCollapsed and UDim2.new(0, window.Size.X.Offset, 0, 20) or UDim2.new(0, window.Size.X.Offset, 0, window.Size.Y.Offset)
end)

-- Tab System
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 20)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(46, 58, 58)
tabBar.BorderSizePixel = 0
tabBar.Parent = contentFrame

local tabs = {"Main", "Exploits", "Settings"}
local tabButtons = {}
local tabContents = {}
local currentTab = "Main"

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 80, 0, 20)
    tabButton.Position = UDim2.new(0, (i-1) * 80, 0, 0)
    tabButton.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(77, 126, 255) or Color3.fromRGB(46, 58, 58)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Code
    tabButton.Parent = tabBar

    tabButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            canDrag = false
        end
    end)
    tabButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            canDrag = true
        end
    end)

    tabButton.MouseButton1Click:Connect(function()
        currentTab = tabName
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(46, 58, 58)
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(77, 126, 255)
        for _, content in pairs(tabContents) do
            content.Visible = false
        end
        tabContents[tabName].Visible = true
    end)

    tabButtons[tabName] = tabButton

    -- Tab Content Frame
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, -20)
    tabContent.Position = UDim2.new(0, 0, 0, 20)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = tabName == currentTab
    tabContent.Parent = contentFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = tabContent

    tabContents[tabName] = tabContent
end

-- Main Tab Content
local mainTab = tabContents["Main"]

local checkbox = Instance.new("TextButton")
checkbox.Size = UDim2.new(0, 150, 0, 20)
checkbox.BackgroundTransparency = 1
checkbox.Text = "☐ Speed Hack"
checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
checkbox.TextSize = 14
checkbox.Font = Enum.Font.Code
checkbox.TextXAlignment = Enum.TextXAlignment.Left
checkbox.Parent = mainTab

checkbox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = false
    end
end)
checkbox.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = true
    end
end)

local speedHackEnabled = false
checkbox.MouseButton1Click:Connect(function()
    speedHackEnabled = not speedHackEnabled
    checkbox.Text = speedHackEnabled and "☑ Speed Hack" or "☐ Speed Hack"
end)

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0, 150, 0, 20)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Walk Speed: 16"
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.TextSize = 14
sliderLabel.Font = Enum.Font.Code
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = mainTab

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 200, 0, 10)
sliderFrame.BackgroundColor3 = Color3.fromRGB(46, 58, 58)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = mainTab

local sliderHandle = Instance.new("Frame")
sliderHandle.Size = UDim2.new(0, 10, 0, 10)
sliderHandle.BackgroundColor3 = Color3.fromRGB(77, 126, 255)
sliderHandle.BorderSizePixel = 0
sliderHandle.Parent = sliderFrame

local sliderDragging, sliderStart
sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        sliderStart = input.Position
        canDrag = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                sliderDragging = false
                canDrag = true
            end
        end)
    end
end)
sliderHandle.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and sliderDragging then
        local delta = input.Position.X - sliderStart.X
        local newPos = math.clamp(sliderHandle.Position.X.Offset + delta, 0, sliderFrame.Size.X.Offset - 10)
        sliderHandle.Position = UDim2.new(0, newPos, 0, 0)
        sliderStart = input.Position
        local value = math.floor((newPos / (sliderFrame.Size.X.Offset - 10)) * 84 + 16)
        sliderLabel.Text = "Walk Speed: " .. value
    end
end)

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(77, 126, 255)
button.Text = "BUTTON    counter = 0"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14
button.Font = Enum.Font.Code
button.Parent = mainTab

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = false
    end
end)
button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = true
    end
end)

local counter = 0
button.MouseButton1Click:Connect(function()
    counter = counter + 1
    button.Text = "BUTTON    counter = " .. counter
end)

-- Exploits Tab Content
local exploitsTab = tabContents["Exploits"]

local scriptLabel = Instance.new("TextLabel")
scriptLabel.Size = UDim2.new(0, 150, 0, 20)
scriptLabel.BackgroundTransparency = 1
scriptLabel.Text = "Execute Script:"
scriptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptLabel.TextSize = 14
scriptLabel.Font = Enum.Font.Code
scriptLabel.TextXAlignment = Enum.TextXAlignment.Left
scriptLabel.Parent = exploitsTab

local scriptBox = Instance.new("TextBox")
scriptBox.Size = UDim2.new(1, -20, 0, 60)
scriptBox.BackgroundColor3 = Color3.fromRGB(46, 58, 58)
scriptBox.Text = "-- Paste your script here"
scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptBox.TextSize = 14
scriptBox.Font = Enum.Font.Code
scriptBox.MultiLine = true
scriptBox.ClearTextOnFocus = false
scriptBox.Parent = exploitsTab

scriptBox.FocusLost:Connect(function()
    canDrag = true
end)
scriptBox.Focused:Connect(function()
    canDrag = false
end)

local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(0, 100, 0, 20)
runButton.BackgroundColor3 = Color3.fromRGB(77, 126, 255)
runButton.Text = "RUN SCRIPT"
runButton.TextColor3 = Color3.fromRGB(255, 255, 255)
runButton.TextSize = 14
runButton.Font = Enum.Font.Code
runButton.Parent = exploitsTab

runButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = false
    end
end)
runButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        canDrag = true
    end
end)

runButton.MouseButton1Click:Connect(function()
    local scriptText = scriptBox.Text
    pcall(function()
        loadstring(scriptText)()
    end)
end)

-- Settings Tab Content (Placeholder)
local settingsTab = tabContents["Settings"]

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(0, 150, 0, 20)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "Settings Placeholder"
settingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsLabel.TextSize = 14
settingsLabel.Font = Enum.Font.Code
settingsLabel.TextXAlignment = Enum.TextXAlignment.Left
settingsLabel.Parent = settingsTab

-- Resize Triangle
local resizeTriangle = Instance.new("TextButton")
resizeTriangle.Size = UDim2.new(0, 20, 0, 20)
resizeTriangle.Position = UDim2.new(1, -20, 1, -20)
resizeTriangle.BackgroundTransparency = 1
resizeTriangle.Text = "⬊"
resizeTriangle.TextColor3 = Color3.fromRGB(255, 255, 255)
resizeTriangle.TextSize = 14
resizeTriangle.Parent = window

local resizing, resizeStart, startSize
resizeTriangle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = window.Size
        canDrag = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
                canDrag = true
            end
        end)
    end
end)
resizeTriangle.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and resizing then
        local delta = input.Position - resizeStart
        local newWidth = math.clamp(startSize.X.Offset + delta.X, 200, 600)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 100, 400)
        window.Size = UDim2.new(0, newWidth, 0, isCollapsed and 20 or newHeight)
        sliderFrame.Size = UDim2.new(0, math.clamp(newWidth - 120, 100, 400), 0, 10)
    end
end)
