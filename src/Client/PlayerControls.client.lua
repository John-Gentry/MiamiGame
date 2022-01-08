repeat wait() until game.Players.LocalPlayer.Character
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true

--[[ Services ]]
local Players = game:GetService('Players')
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService('Workspace')
local Run = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[ Object Variables ]]
local Player = Players.LocalPlayer

--[[ Dictionary for Player Controls. True means constantly moving, false means stopped ]]
local PlayerControls = {
    Up = {Enum.KeyCode.W,false},
    Down = {Enum.KeyCode.S,false},
    Left = {Enum.KeyCode.A,false},
    Right = {Enum.KeyCode.D,false}
}

--[[ Initialize Player Avatar Properties ]]
local PlayerAvatar = ReplicatedStorage.ClientParts:WaitForChild("PlayerAvatar"):Clone()
PlayerAvatar.Parent = game.Workspace.PlayerAvatars

local BodyPosition = Instance.new("BodyPosition", PlayerAvatar)
BodyPosition.MaxForce = Vector3.new(24000, 0, 24000)
BodyPosition.Position = PlayerAvatar.Position
BodyPosition.P = 50000

--[[ Player Camera ]]
local Camera = Workspace.CurrentCamera

Camera.CameraType = Enum.CameraType.Scriptable
Camera.CameraSubject = PlayerAvatar

local BodyGyro = Instance.new("BodyGyro", PlayerAvatar)
BodyGyro.MaxTorque = Vector3.new(24000, 24000, 24000)


--[[ Player Control functions ]]

UserInputService.InputBegan:Connect(function(Input,gameProcessedEvent)
    if not gameProcessedEvent then --[[ Typing in chat, or doing something with a gui ]]
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            PlayerControls["Up"][2] = true
        elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
            PlayerControls["Down"][2] = true
        elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
            PlayerControls["Left"][2] = true
        elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
            PlayerControls["Right"][2] = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input,gameProcessedEvent)
    if not gameProcessedEvent then --[[ Typing in chat, or doing something with a gui ]]
        if Input.KeyCode == Enum.KeyCode.W then
            PlayerControls["Up"][2] = false
        elseif Input.KeyCode == Enum.KeyCode.S then
            PlayerControls["Down"][2] = false
        elseif Input.KeyCode == Enum.KeyCode.A then
            PlayerControls["Left"][2] = false
        elseif Input.KeyCode == Enum.KeyCode.D then
            PlayerControls["Right"][2] = false
        end
    end
end)

--[[
    Runs after every rendered frame 
    Changes player camera and Avatar movement
]]
--[[ local Reached = false
BodyPosition.ReachedTarget:Connect(function()
    Reached = true
end) ]]

function ChangePosition(AddPos)
    BodyPosition.Position = BodyPosition.Position + AddPos
end

Run.RenderStepped:Connect(function()
    Camera.CFrame = PlayerAvatar.CFrame * CFrame.new(0,50,0) * CFrame.Angles(math.rad(-90),math.rad(0),math.rad(180))
    for i,v in pairs(PlayerControls) do
        if v[2] and v[1] == Enum.KeyCode.W then
            ChangePosition(Vector3.new(0, 0, 0.5))
        elseif v[2] and v[1] == Enum.KeyCode.S then
            ChangePosition(Vector3.new(0, 0, -0.5))
        elseif v[2] and v[1] == Enum.KeyCode.A then
            ChangePosition(Vector3.new(0.5, 0, 0))
        elseif v[2] and v[1] == Enum.KeyCode.D then
            ChangePosition(Vector3.new(-0.5, 0, 0))
        end
    end
    wait()
end)


local ContextActionService = game:GetService("ContextActionService")
local FREEZE_ACTION = "freezeMovement"

ContextActionService:BindAction(
    FREEZE_ACTION,
    function()
        return Enum.ContextActionResult.Sink
    end,
    false,
    unpack(Enum.PlayerActions:GetEnumItems())
)

-- To unfreeze movement:

ContextActionService:UnbindAction(FREEZE_ACTION)


print("Player Camera executed")