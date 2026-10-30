local playersService = game:GetService('Players')
local replicatedStorage = game:GetService('ReplicatedStorage')
local runService = game:GetService('RunService')

-- clean system for multiple executions
if shared.garbageCan then
    for _, obj in shared.garbageCan do
        pcall(function() obj:Disconnect() end)
        pcall(function() obj:Destroy() end)
    end
end
shared.garbageCan = {}
local function clean(obj)
    table.insert(shared.garbageCan, obj)
    return obj
end

local lplr = playersService.LocalPlayer
local camera = workspace.CurrentCamera

local cmdRemote = replicatedStorage:WaitForChild('01_server')

local function runCmd(cmd, repDur, expected)
    cmd = '-'..cmd:gsub('-','')
    local start = os.clock()
    local function run()
        cmdRemote:FireServer('cmd', cmd)
    end
    run()
    repeat
        if os.clock() - start > repDur then
            start = os.clock()
            run()
        end
        task.wait()
    until expected()
    task.wait(0.25)
end

local function setR6()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    local humanoid = char:WaitForChild('Humanoid')

    if humanoid.RigType == Enum.HumanoidRigType.R15 then
        runCmd('-r6', 0.6, function()
            return humanoid.RigType == Enum.HumanoidRigType.R6
        end)
    end
end

local function permaDeath()
    runCmd('-pd', 1, function() return true end)
end

local function runNet()
    runCmd('-net', 1, function() return true end)
end

local function resetPlr()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    runCmd('-rs', 0.6, function()
        return char ~= lplr.Character
    end)
end

local function loadReanimation()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    local url = 'https://raw.githubusercontent.com/notlucklumen/LumensLerping/refs/heads/main/MyWorldsReanimate.lua'
    loadstring(game:HttpGet(url))()
    char:WaitForChild('MoonConvertRealChar')
end

local function stopAnims()
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    char:WaitForChild('Animate'):Destroy()
    for _, anim in char:WaitForChild('Humanoid'):WaitForChild('Animator'):GetPlayingAnimationTracks() do
        anim:Stop()
    end
end



-- self.currentAnimation: What animation is playing right now
-- self.Animations: List of character animations
-- self.defaultAnimation: Fallback animation if a animation is empty (empty table)
-- self.Hats (id, name): Hats required for the animation, if you are going to use this, set "id" to the hat's id, and "name" to the hats name on your character!
-- more self.Hats: To check this, you can use dex, check your character instance, do -ch then -gh <your-hat-id>, and get the newest accessory added onto your character
-- animations: Idle, Falling, Walking, Jumping, Climbing, Sitting

local Characters = {
    Teto = function()
        local self = {}
        self.currentAnimation = 'Idle' -- No need for modifying =)
        self.defaultAnimation = 'Idle'
        self.isRig = true -- Only turn this on when you are considering about making your player using accessory limbs (/custom rig)
        self.cameraSubject = nil -- Recommended for rigs! Set to nil for the default camera

        self.Settings = {
            WalkSpeed = 30
        }

        self.Animations = {
            Idle = {
                RootJoint={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=5,yrot=0,zrot=0,xrotsine=-2,yrotsine=0,zrotsine=0,xrotsinespd=2,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Left Shoulder"]={xpos=0,ypos=-0.4,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-7,yrot=-10,zrot=-100,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=1,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=5,yrot=0,zrot=0,xrotsine=-7,yrotsine=0,zrotsine=0,xrotsinespd=2,yrotsinespd=1,zrotsinespd=1,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0},
                ["Right Shoulder"]={xpos=0,ypos=-0.6,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-16,yrot=-10,zrot=100,xrotsine=16,yrotsine=0,zrotsine=8,xrotsinespd=2,yrotsinespd=1,zrotsinespd=2,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Accessory (teto!!)"]={xpos=0.3,ypos=0.9,zpos=-1.4,xpossine=0,ypossine=0.5,zpossine=0,xpossinespd=1,ypossinespd=2,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=9,yrot=0,zrot=80,xrotsine=5,yrotsine=0,zrotsine=-20,xrotsinespd=2,yrotsinespd=1,zrotsinespd=2,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Accessory (teto anime)"]={xpos=2,ypos=2,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=10,xrotsine=0,yrotsine=0,zrotsine=22,xrotsinespd=0,yrotsinespd=1,zrotsinespd=2,xrotsineoff=0,yrotsineoff=0,zrotsineoff=2},
                ["Accessory (teto)"]={xpos=0,ypos=1.9,zpos=-0.25,xpossine=0,ypossine=0.04,zpossine=0.1,xpossinespd=1,ypossinespd=2,zpossinespd=2,xpossineoff=0,ypossineoff=0,zpossineoff=2,xrot=-16,yrot=0,zrot=0,xrotsine=3,yrotsine=0,zrotsine=0,xrotsinespd=2,yrotsinespd=1,zrotsinespd=1,xrotsineoff=2,yrotsineoff=0,zrotsineoff=0}
            },
            Falling = {},
            Walking = {
                ["Left Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=0,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=40,xrotsinespd=1,yrotsinespd=0,zrotsinespd=8,xrotsineoff=0,yrotsineoff=0,zrotsineoff=2},
                ["Left Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0.2,zpossine=0,xpossinespd=1,ypossinespd=8,zpossinespd=0,xpossineoff=0,ypossineoff=-2,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=45,xrotsinespd=1,yrotsinespd=0,zrotsinespd=8,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                Neck={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=0,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=0,xrotsinespd=1,yrotsinespd=1,zrotsinespd=0,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Right Shoulder"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0,xpossinespd=1,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=-10,zrot=-60,xrotsine=0,yrotsine=0,zrotsine=4,xrotsinespd=1,yrotsinespd=1,zrotsinespd=8,xrotsineoff=0,yrotsineoff=0,zrotsineoff=4},
                ["Right Hip"]={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0.2,zpossine=0,xpossinespd=1,ypossinespd=8,zpossinespd=1,xpossineoff=0,ypossineoff=-2,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=45,xrotsinespd=1,yrotsinespd=1,zrotsinespd=8,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                RootJoint={xpos=0,ypos=0,zpos=0,xpossine=0,ypossine=0,zpossine=0.2,xpossinespd=1,ypossinespd=1,zpossinespd=8,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=9,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=9,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=2},
                ["Accessory (teto!!)"]={xpos=0,ypos=-0.2,zpos=1.5,xpossine=0,ypossine=0.4,zpossine=0.2,xpossinespd=1,ypossinespd=8,zpossinespd=-8,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=30,yrot=10,zrot=100,xrotsine=0,yrotsine=0,zrotsine=-9,xrotsinespd=1,yrotsinespd=1,zrotsinespd=4,xrotsineoff=0,yrotsineoff=0,zrotsineoff=2},
                ["Accessory (teto anime)"]={xpos=3,ypos=2,zpos=0,xpossine=1,ypossine=0,zpossine=0,xpossinespd=10,ypossinespd=1,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=0,yrot=0,zrot=0,xrotsine=0,yrotsine=0,zrotsine=90,xrotsinespd=1,yrotsinespd=1,zrotsinespd=10,xrotsineoff=0,yrotsineoff=0,zrotsineoff=0},
                ["Accessory (teto)"]={xpos=0,ypos=1.8,zpos=-0.25,xpossine=0,ypossine=0.2,zpossine=0,xpossinespd=1,ypossinespd=8,zpossinespd=1,xpossineoff=0,ypossineoff=0,zpossineoff=0,xrot=-10,yrot=0,zrot=0,xrotsine=4,yrotsine=8,zrotsine=0,xrotsinespd=8,yrotsinespd=4,zrotsinespd=1,xrotsineoff=0,yrotsineoff=2,zrotsineoff=0}
            },
            Jumping = {},
            Climbing = {},
            Sitting = {}
        }
        self.getHatsString = '-gh 98854887116928 108227558791920 116737343586142' -- Not important but maybe you should keep it
        self.Hats = {
            { id = 98854887116928, name = 'Accessory (teto!!)' },
            { id = 108227558791920, name = 'Accessory (teto anime)' },
            { id = 116737343586142, name = 'Accessory (teto)' },
        }
        return self
    end
}



local function RunChar(char) -- You shouldn't need to worry about this function, it's basically a character handler, unless you are adding more stuff it doesn't already have
    local loadedCharacter = char

    local character = assert(Characters[loadedCharacter], 'unknown character: ' .. tostring(loadedCharacter))()
    
    local function getHats()
        local char = lplr.Character or lplr.CharacterAdded:Wait()
        local ids = {}
        local names = {}
        for _, hat in character.Hats do
            table.insert(ids, hat.id)
            table.insert(names, hat.name)
        end
        if #ids == 0 then
            return
        end
        local started = os.clock()
        runCmd('-gh ' .. table.concat(ids, ' '), 5, function()
            if os.clock() - started > 15 then
                return true
            end
            for _, name in names do
                if not char:FindFirstChild(name) then
                    return false
                end
            end
            return true
        end)
    end
    
    local function setupPlayer()
        setR6()
        resetPlr()
        lplr.Character:WaitForChild('Humanoid').WalkSpeed = character.Settings.WalkSpeed
        getHats()
        task.wait(0.05)
        loadReanimation()
        task.wait(0.05)
        stopAnims()
        runNet()
        if character.isRig then
            task.wait(1)
            permaDeath()
            task.wait(0.8)
            task.delay(1, function()
                if character.cameraSubject then
                    camera.CameraSubject = character.cameraSubject
                end
                lplr.Character.Humanoid.Health = 0
            end)
        end
    end
    
    setupPlayer()
    
    local origins = {}
    
    local function wave(d, k, t)
        return (d[k] or 0) + math.sin(t * (d[k .. 'sinespd'] or 0) + (d[k .. 'sineoff'] or 0)) * (d[k .. 'sine'] or 0)
    end

    local riseSpeed = 2

    local function pickAnimation(humanoid, root)
        if humanoid.Sit then
            return 'Sitting'
        end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Climbing then
            return 'Climbing'
        end
        if state == Enum.HumanoidStateType.Jumping then
            return 'Jumping'
        end
        if state == Enum.HumanoidStateType.Freefall then
            if root.AssemblyLinearVelocity.Y > riseSpeed then
                return 'Jumping'
            end
            return 'Falling'
        end
        if humanoid.MoveDirection.Magnitude > 0.1 then
            return 'Walking'
        end
        return 'Idle'
    end
    
    local freed = setmetatable({}, {__mode = 'k'})
    
    local smooth = setmetatable({}, {__mode = 'k'})
    local seen = {}
    local blendSpeed = 12
    
    clean(runService.Heartbeat:Connect(function(dt)
        local char = lplr.Character
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if not root then return end

        if character.autoAnimate ~= false then
            local humanoid = char:FindFirstChildOfClass('Humanoid')
            if humanoid then
                character.currentAnimation = pickAnimation(humanoid, root)
            end
        end

        local pose = character.Animations[character.currentAnimation]
        if not pose or next(pose) == nil then
            pose = character.Animations[character.defaultAnimation]
        end
        pose = pose or {}

        table.clear(seen)
        local t = os.clock()
        local alpha = 1 - math.exp(-dt * blendSpeed)
        for name, d in pose do
            local inst = char:FindFirstChild(name, true)
            if inst then
                seen[inst] = true
                local cf = CFrame.new(wave(d, 'xpos', t), wave(d, 'ypos', t), wave(d, 'zpos', t))
                    * CFrame.Angles(math.rad(wave(d, 'xrot', t)), math.rad(wave(d, 'yrot', t)), math.rad(wave(d, 'zrot', t)))
                local prev = smooth[inst] or (inst:IsA('Motor6D') and CFrame.identity)
                if prev then
                    cf = prev:Lerp(cf, alpha)
                end
                smooth[inst] = cf
                if inst:IsA('Motor6D') then
                    origins[inst] = origins[inst] or inst.C0
                    inst.C0 = origins[inst] * cf
                elseif inst:IsA('Accessory') then
                    local handle = inst:FindFirstChild('Handle')
                    if handle then
                        if not freed[handle] then
                            freed[handle] = true
                            local weld = handle:FindFirstChild('AccessoryWeld')
                            if weld then
                                weld:Destroy()
                            end
                            handle.CanCollide = false
                            handle.Massless = true
                        end
                        handle.CFrame = root.CFrame * cf
                        handle.AssemblyLinearVelocity = Vector3.zero
                        handle.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end

        for inst, prev in smooth do
            if not seen[inst] and inst.Parent and inst:IsA('Motor6D') and origins[inst] then
                local cf = prev:Lerp(CFrame.identity, alpha)
                smooth[inst] = cf
                inst.C0 = origins[inst] * cf
            end
        end
    end))
end

RunChar('Teto') -- Replace this with your actual character!
