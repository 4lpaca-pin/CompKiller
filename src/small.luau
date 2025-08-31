--[[
	Compkiller - Mini UI
	
	Author: 4lpaca
	Github: https://github.com/4lpaca-pin/CompKiller
]]

export type cloneref = (target: Instance) -> Instance;

local cloneref: cloneref = cloneref or function(f) return f end;
local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer: Player = Players.LocalPlayer;
local CoreGui: PlayerGui = (gethui and gethui()) or cloneref(game:FindFirstChild('CoreGui')) or LocalPlayer.PlayerGui;
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera? = workspace.CurrentCamera;

local Compkiller = {
	Version = 'mini.1.0',
	Logo = "rbxassetid://120245531583106",
	ArcylicParent = CurrentCamera,
	ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end,
};

function Compkiller:_RandomString() : string
	return "CK="..string.char(math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102));	
end;

function Compkiller:GetCalculatePosition(planePos: number, planeNormal: number, rayOrigin: number, rayDirection: number) : number
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function Compkiller:_Animation(Self: Instance , Info: TweenInfo , Property :{[K] : V})
	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);

	Tween:Play();

	return Tween;
end;

function Compkiller:_Blur(element : Frame , Caller) : RBXScriptSignal
	local Part = Instance.new('Part',Compkiller.ArcylicParent);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");
	local userSettings = UserSettings():GetService("UserGameSettings");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = Compkiller:_RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);
	
	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = Compkiller:_RandomString();

	Part.Name = Compkiller:_RandomString();
	
	local IsWindowActive = true;
	
	local UpdateFunction = function()
		if Caller then
			IsWindowActive = Caller:GetValue();	
		end;
		
		if IsWindowActive then

			Compkiller:_Animation(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 1
			})

			Compkiller:_Animation(Part,TweenInfo.new(0.1),{
				Transparency = 0.97,
				Size = Vector3.new(1, 1, 1) * 0.01;
			})
		else
			Compkiller:_Animation(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 0
			})

			Compkiller:_Animation(Part,TweenInfo.new(0.1),{
				Size = Vector3.zero,
				Transparency = 1.5,
			})

			return false;
		end;

		if IsWindowActive then
			local corner0 = element.AbsolutePosition;
			local corner1 = corner0 + element.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = Compkiller:GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = Compkiller:GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction)
	local loopThread = UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end);

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	element.Destroying:Connect(function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end);

	return rbxsignal;
end;

function Compkiller:Drag(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed);

	local function updateInput(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		Compkiller:_Animation(MoveFrame,Tween,{
			Position = position
		});
	end;

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = MoveFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;
					Compkiller.IS_DRAG_MOVE = false;
				end
			end)
		end

		if not Compkiller.IsDrage and dragToggle then
			Compkiller.LastDrag = tick();
		end;

		Compkiller.IaDrag = dragToggle;
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				Compkiller.IS_DRAG_MOVE = true;
				updateInput(input)
			else
				Compkiller.IS_DRAG_MOVE = false;
			end
		end

		Compkiller.IaDrag = dragToggle;
	end);
end;

function Compkiller:_Input(Frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;

	if Callback then
		Button.MouseButton1Click:Connect(Callback);
	end;

	return Button;
end;

function Compkiller.new(WindowName: string , WindowIcon: string)
	WindowName = WindowName or "COMPKILLER";
	WindowIcon = WindowIcon or Compkiller.Logo;
	
	local WindowPayback = {
		IsOpen = true,	
	};
	
	local CKMiniMenu = Instance.new("ScreenGui")
	local ContainerFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local HeaderFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local HeaderIcon = Instance.new("ImageLabel")
	local Line = Instance.new("Frame")
	local HeaderLabel = Instance.new("TextLabel")
	local HoldButton = Instance.new("ImageLabel")

	CKMiniMenu.Name = "CKMiniMenu"
	CKMiniMenu.Parent = CoreGui
	CKMiniMenu.Enabled = true
	CKMiniMenu.ResetOnSpawn = false
	CKMiniMenu.IgnoreGuiInset = true
	CKMiniMenu.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	
	ContainerFrame.Active = true;
	ContainerFrame.Name = "ContainerFrame"
	ContainerFrame.Parent = CKMiniMenu
	ContainerFrame.AnchorPoint = Vector2.new(0.5, 0)
	ContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ContainerFrame.BackgroundTransparency = 1.000
	ContainerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ContainerFrame.BorderSizePixel = 0
	ContainerFrame.ClipsDescendants = true
	ContainerFrame.Position = UDim2.new(0.5, 0, 0, 50)
	ContainerFrame.Size = UDim2.new(0, 250, 0, 40)

	UIListLayout.Parent = ContainerFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	HeaderFrame.Name = "HeaderFrame"
	HeaderFrame.Parent = ContainerFrame
	HeaderFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 29)
	HeaderFrame.BackgroundTransparency = 0.150
	HeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderFrame.BorderSizePixel = 0
	HeaderFrame.Size = UDim2.new(1, -5, 0, 40)
	
	Compkiller:Drag(HeaderFrame,ContainerFrame,.15);
	Compkiller:_Blur(HeaderFrame);
	
	UICorner.CornerRadius = UDim.new(0, 3)
	UICorner.Parent = HeaderFrame

	HeaderIcon.Name = "HeaderIcon"
	HeaderIcon.Parent = HeaderFrame
	HeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
	HeaderIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderIcon.BackgroundTransparency = 1.000
	HeaderIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderIcon.BorderSizePixel = 0
	HeaderIcon.Position = UDim2.new(0, 7, 0.5, 0)
	HeaderIcon.Size = UDim2.new(0, 25, 0, 25)
	HeaderIcon.Image = WindowIcon

	Line.Name = "Line"
	Line.Parent = HeaderFrame
	Line.BackgroundColor3 = Color3.fromRGB(17, 238, 253)
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 40, 0, 0)
	Line.Size = UDim2.new(0, 2, 1, 0)

	HeaderLabel.Name = "HeaderLabel"
	HeaderLabel.Parent = HeaderFrame
	HeaderLabel.AnchorPoint = Vector2.new(0, 0.5)
	HeaderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderLabel.BackgroundTransparency = 1.000
	HeaderLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLabel.BorderSizePixel = 0
	HeaderLabel.Position = UDim2.new(0, 50, 0.5, 0)
	HeaderLabel.Size = UDim2.new(1, -50, 0, 25)
	HeaderLabel.Font = Enum.Font.GothamMedium
	HeaderLabel.Text = WindowName
	HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	HeaderLabel.TextSize = 14.000
	HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left

	HoldButton.Name = "HoldButton"
	HoldButton.Parent = HeaderFrame
	HoldButton.AnchorPoint = Vector2.new(1, 0.5)
	HoldButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HoldButton.BackgroundTransparency = 1.000
	HoldButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HoldButton.BorderSizePixel = 0
	HoldButton.Position = UDim2.new(1, -10, 0.5, 0)
	HoldButton.Size = UDim2.new(0, 17, 0, 17)
	HoldButton.Image = "rbxassetid://109535175596957"
	HoldButton.ImageTransparency = 0.150
	
	WindowPayback.__THREAD = task.defer(function()
		while true do task.wait()
			if WindowPayback.IsOpen then
				Compkiller:_Animation(HoldButton,TweenInfo.new(0.1),{
					Rotation = -180,
					ImageTransparency = 0.150
				})
				
				Compkiller:_Animation(ContainerFrame,TweenInfo.new(0.1),{
					Size = UDim2.new(0, 250, 0, UIListLayout.AbsoluteContentSize.Y + 5)
				})
			else
				
				Compkiller:_Animation(HoldButton,TweenInfo.new(0.1),{
					Rotation = 0,
					ImageTransparency = 0.35
				})
				
				Compkiller:_Animation(ContainerFrame,TweenInfo.new(0.1),{
					Size = UDim2.new(0, 250, 0, 40)
				})
			end;
		end;
	end);
	
	Compkiller:_Input(HoldButton,function()
		WindowPayback.IsOpen = not WindowPayback.IsOpen;
	end);
	
	function WindowPayback:GetValue()
		return WindowPayback.IsOpen;
	end;
	
	function WindowPayback:AddToggle(ToggleName: string , DefaultValue: boolean , Callback: (bool: boolean) -> any)
		local ToggleFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Label = Instance.new("TextLabel")
		local ToggleContainer = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ToggleValue = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		
		Compkiller:_Blur(ToggleFrame , WindowPayback);
		
		ToggleFrame.Name = "ToggleFrame"
		ToggleFrame.Parent = ContainerFrame
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 29)
		ToggleFrame.BackgroundTransparency = 0.150
		ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleFrame.BorderSizePixel = 0
		ToggleFrame.ClipsDescendants = true
		ToggleFrame.Size = UDim2.new(1, -5, 0, 40)

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = ToggleFrame

		Label.Name = "Label"
		Label.Parent = ToggleFrame
		Label.AnchorPoint = Vector2.new(0, 0.5)
		Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Label.BackgroundTransparency = 1.000
		Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label.BorderSizePixel = 0
		Label.Position = UDim2.new(0, 10, 0.5, 0)
		Label.Size = UDim2.new(1, -50, 0, 25)
		Label.Font = Enum.Font.GothamMedium
		Label.Text = ToggleName
		Label.TextColor3 = Color3.fromRGB(255, 255, 255)
		Label.TextSize = 14.000
		Label.TextXAlignment = Enum.TextXAlignment.Left

		ToggleContainer.Name = "ToggleContainer"
		ToggleContainer.Parent = ToggleFrame
		ToggleContainer.AnchorPoint = Vector2.new(1, 0.5)
		ToggleContainer.BackgroundColor3 = Color3.fromRGB(22, 26, 29)
		ToggleContainer.BackgroundTransparency = 0.500
		ToggleContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleContainer.BorderSizePixel = 0
		ToggleContainer.Position = UDim2.new(1, -10, 0.5, 0)
		ToggleContainer.Size = UDim2.new(0, 20, 0, 20)

		UICorner_2.CornerRadius = UDim.new(0, 3)
		UICorner_2.Parent = ToggleContainer

		UIStroke.Thickness = 1.500
		UIStroke.Color = Color3.fromRGB(17, 238, 253)
		UIStroke.Parent = ToggleContainer

		ToggleValue.Name = "ToggleValue"
		ToggleValue.Parent = ToggleContainer
		ToggleValue.AnchorPoint = Vector2.new(0.5, 0.5)
		ToggleValue.BackgroundColor3 = Color3.fromRGB(17, 238, 253)
		ToggleValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleValue.BorderSizePixel = 0
		ToggleValue.Position = UDim2.new(0.5, 0, 0.5, 0)
		ToggleValue.Size = UDim2.new(0.9, 0, 0.9, 0)

		UICorner_3.CornerRadius = UDim.new(0, 3)
		UICorner_3.Parent = ToggleValue
		
		local SetValue = function(value)
			if value then
				Compkiller:_Animation(ToggleValue,TweenInfo.new(0.1),{
					BackgroundTransparency = 0,
					Size = UDim2.new(0.9, 0, 0.9, 0)
				})
			else
				Compkiller:_Animation(ToggleValue,TweenInfo.new(0.1),{
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0)
				})
			end;
		end;
		
		SetValue(DefaultValue);
		
		Compkiller:_Input(ToggleContainer,function()
			DefaultValue = not DefaultValue;
			SetValue(DefaultValue);
			
			Callback(DefaultValue);
		end)
	end;
	
	function WindowPayback:AddButton(ButtonName: string , Callback: () -> any)
		local ButtonFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Label = Instance.new("TextLabel")
		local HoldButton = Instance.new("ImageLabel")

		ButtonFrame.Name = "ButtonFrame"
		ButtonFrame.Parent = ContainerFrame
		ButtonFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 29)
		ButtonFrame.BackgroundTransparency = 0.150
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.ClipsDescendants = true
		ButtonFrame.Size = UDim2.new(1, -5, 0, 40)
		Compkiller:_Blur(ButtonFrame , WindowPayback);
		
		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = ButtonFrame

		Label.Name = "Label"
		Label.Parent = ButtonFrame
		Label.AnchorPoint = Vector2.new(0, 0.5)
		Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Label.BackgroundTransparency = 1.000
		Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label.BorderSizePixel = 0
		Label.Position = UDim2.new(0, 10, 0.5, 0)
		Label.Size = UDim2.new(1, -50, 0, 25)
		Label.Font = Enum.Font.GothamMedium
		Label.Text = ButtonName
		Label.TextColor3 = Color3.fromRGB(255, 255, 255)
		Label.TextSize = 14.000
		Label.TextXAlignment = Enum.TextXAlignment.Left

		HoldButton.Name = "HoldButton"
		HoldButton.Parent = ButtonFrame
		HoldButton.AnchorPoint = Vector2.new(1, 0.5)
		HoldButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		HoldButton.BackgroundTransparency = 1.000
		HoldButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HoldButton.BorderSizePixel = 0
		HoldButton.Position = UDim2.new(1, -10, 0.5, 0)
		HoldButton.Size = UDim2.new(0, 17, 0, 17)
		HoldButton.Image = "rbxassetid://125379360015007"
		HoldButton.ImageTransparency = 0.150
		
		Compkiller:_Input(ButtonFrame,function()
			Callback(ButtonName);
		end)
	end;
	
	return WindowPayback;
end;

return Compkiller;
