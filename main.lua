local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")


local Player = Players.LocalPlayer
local Character, Humanoid, HRP

local function LoadCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end

LoadCharacter(Player.Character or Player.CharacterAdded:Wait())
Player.CharacterAdded:Connect(LoadCharacter)


task.spawn(function()

    local gui = Instance.new("ScreenGui")
    gui.Name = "DiscordPrompt"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game.CoreGui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,300,0,140)
    frame.Position = UDim2.new(0.5,-150,0,40) -- TOP CENTER
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BorderSizePixel = 0
    frame.ZIndex = 10


    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)


    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(60,60,60)


    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,40)
    title.BackgroundTransparency = 1
    title.Text = "Join Discord for Key"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.ZIndex = 11


    local copy = Instance.new("TextButton", frame)
    copy.Size = UDim2.new(0.8,0,0,40)
    copy.Position = UDim2.new(0.1,0,0.45,0)
    copy.BackgroundColor3 = Color3.fromRGB(45,45,45)
    copy.Text = "Copy Invite"
    copy.TextColor3 = Color3.new(1,1,1)
    copy.Font = Enum.Font.Gotham
    copy.TextScaled = true
    copy.ZIndex = 11
    Instance.new("UICorner", copy).CornerRadius = UDim.new(0,10)

    copy.MouseButton1Click:Connect(function()
        setclipboard("discord.gg/9uRWRnmNyF")
    end)


    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0.5,0,0,28)
    close.Position = UDim2.new(0.25,0,0.8,0)
    close.BackgroundColor3 = Color3.fromRGB(60,60,60)
    close.Text = "Close"
    close.TextColor3 = Color3.new(1,1,1)
    close.Font = Enum.Font.Gotham
    close.TextScaled = true
    close.ZIndex = 11
    Instance.new("UICorner", close).CornerRadius = UDim.new(0,10)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

end)


local Window = Rayfield:CreateWindow({
   Name = "KattHub | Escape Tsunami for Fruits",
   Icon = 0,
   LoadingTitle = "KattHub",
   LoadingSubtitle = "Welcome",
   ShowText = "KattHub",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "KattHub"
   },

   Discord = {
      Enabled = true,
      Invite = "9uRWRnmNyF",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "Katthub Key System",
      Subtitle = "Key in Discord",
      Note = "Join Discord Server for Key",
      FileName = "KatthubSystem",
      SaveKey = false,
      GrabKeyFromSite = true,
      Key = {"https://pastebin.com/raw/AkahKMG9"}
   }
})


local DefaultWalkSpeed = Humanoid.WalkSpeed
local DefaultJumpPower = Humanoid.JumpPower


local MainTab = Window:CreateTab("Main", 4483362458)
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)
local FarmTab = Window:CreateTab("Auto Farm (PATCHED)", 4483362458)


MainTab:CreateSlider({
Name="WalkSpeed",
Range={DefaultWalkSpeed,500},
Increment=1,
CurrentValue=DefaultWalkSpeed,
Callback=function(v) Humanoid.WalkSpeed=v end
})

MainTab:CreateSlider({
Name="JumpPower",
Range={DefaultJumpPower,500},
Increment=1,
CurrentValue=DefaultJumpPower,
Callback=function(v) Humanoid.JumpPower=v end
})


local Locations={
["Common safe area"]=Vector3.new(-7.868587,-3.717562,80.02859),
["Uncommon safe area"]=Vector3.new(5.521365,-4.775556,178.629486),
["Rare safe area"]=Vector3.new(3.410951,-6.073877,514.424255),
["Epic safe area"]=Vector3.new(26.894218,-6.073876,1288.272217),
["Legendary safe area"]=Vector3.new(17.530193,-6.073877,1954.585815),
["Mythical/Secret safe area"]=Vector3.new(8.921096,-6.073876,2196.627441),
["Exclusive safe area"]=Vector3.new(6.623554,-4.960921,2575.783936)
}

local SelectedLocation

TeleportsTab:CreateDropdown({
Name="Teleports",
Options={
"Common safe area","Uncommon safe area","Rare safe area",
"Epic safe area","Legendary safe area",
"Mythical/Secret safe area","Exclusive safe area"},
Callback=function(opt)
SelectedLocation=Locations[opt[1]]
end})

TeleportsTab:CreateButton({
Name="Teleport to Selected",
Callback=function()
if SelectedLocation then
HRP.CFrame=CFrame.new(SelectedLocation)
end end})

TeleportsTab:CreateButton({
Name="Tween to Selected",
Callback=function()
if SelectedLocation then
local dist=(HRP.Position-SelectedLocation).Magnitude
local t=dist/350
TweenService:Create(HRP,TweenInfo.new(t,Enum.EasingStyle.Linear),
{CFrame=CFrame.new(SelectedLocation)}):Play()
end end})


local Farming=false
local SelectedRarity=nil
local ReturnPos=Vector3.new(1.062164,3.028028,13.636787)

local rarities={
"Common","Uncommon","Rare","Epic",
"Legendary","Mythical","Secret","Exclusive"
}

FarmTab:CreateDropdown({
Name="Select Rarity",
Options=rarities,
Callback=function(opt)
SelectedRarity=opt[1]
end})

-- FIND CLOSEST FRUIT
local function FindClosestFruit()
    if not SelectedRarity or not HRP then return end

    local closest=nil
    local dist=math.huge

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local m=v.Parent
            if m and string.find(string.lower(m.Name),string.lower(SelectedRarity)) then
                local part=m:IsA("BasePart") and m or m:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d=(HRP.Position-part.Position).Magnitude
                    if d<dist then
                        dist=d
                        closest={part=part,prompt=v}
                    end
                end
            end
        end
    end
    return closest
end


local function TweenTo(pos)
    local d=(HRP.Position-pos).Magnitude
    local t=d/300
    local tw=TweenService:Create(HRP,TweenInfo.new(t,Enum.EasingStyle.Linear),{CFrame=CFrame.new(pos)})
    tw:Play()
    tw.Completed:Wait()
end


FarmTab:CreateToggle({
Name="AutoFarm",
CurrentValue=false,
Callback=function(v)
Farming=v

if not v then
TweenTo(ReturnPos)
return
end

task.spawn(function()
while Farming do
local data=FindClosestFruit()

if data then
TweenTo(data.part.Position+Vector3.new(0,2,0))
task.wait(0.5)

if data.prompt then
fireproximityprompt(data.prompt)
end

local t=0
while data.prompt.Parent and t<5 and Farming do
task.wait(0.2)
t+=0.2
end

task.wait(1)
else
TweenTo(ReturnPos)
task.wait(2)
end
end
end)

end})
