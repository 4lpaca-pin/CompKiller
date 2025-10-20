# CompKiller UI Document

## Using Library
```lua
local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();
```

## Creating Notification
```lua
local Notifier = Compkiller.newNotify();
```

### Send Notification
```lua
Notifier.new({
	Title = "Notification",
	Content = "Compkiller",
	Duration = 10,
	Icon = "rbxassetid://120245531583106"
});
```

## Loading UI
```lua
Compkiller:Loader("rbxassetid://120245531583106" , 1.5).yield();
```

## Creating Window
```lua
local Window = Compkiller.new({
	Name = "COMPKILLER",
	Keybind = "Insert",
	Logo = "rbxassetid://120245531583106",
	Scale = Compkiller.Scale.Window, -- Leave blank if you want automatic scale [PC, Mobile].
	TextSize = 15,
});
```

## Creating Watermark
```lua
local Watermark = Window:Watermark();
```

### Creating Text
```lua
local Time = Watermark:AddText({
	Icon = "timer",
	Text = "TIME",
});
```

### Editing Text
```lua
Time:SetText(Compkiller:GetTimeNow());
```

## Creating Tab Category
```lua
Window:DrawCategory({
	Name = "Category"
});
```

## Creating Tab (Normal)
```lua
local NormalTab = Window:DrawTab({
	Name = "Example Tab",
	Icon = "apple",
});
```

## Creating Tab (Single)
```lua
local NormalTab = Window:DrawTab({
	Name = "Example Tab",
	Icon = "apple",
	Type = "Single",
});
```

## Creating Container Tab
```lua
local ContainerTab = Window:DrawContainerTab({
	Name = "Extract Tabs",
	Icon = "contact",
});

-- Creating Tab (Normal) --
local ExtractTab = ContainerTab:DrawTab({
	Name = "Tab 1",
	Type = "Double"
});

-- Creating Tab (Single) --
local SingleExtractTab = ContainerTab:DrawTab({
	Name = "Tab 2",
	Type = "Single",
});
```

## Creating Section
```lua
local NormalSection = NormalTab:DrawSection({
	Name = "Section",
	Position = 'left'	
});
```

## Creating Toggle
```lua
local Toggle = NormalSection:AddToggle({
	Name = "Toggle",
	Flag = "Toggle_Example", -- Leave it blank will not save to config (ALL ELEMENTS)
	Default = false,
	Callback = print,
});
```

### Element Link
Link is available for Toggle, Slider, Keybind and Color Picker

### Link Keybind
```lua
Element.Link:AddKeybind({
	Default = "E",
	Flag = "Option_Keybind",
	Callback = print
});
```

### Link Helper
```lua
Element.Link:AddHelper({
	Text = "Helper Text"
})
```

### Link Color-Picker
```lua
Element.Link:AddColorPicker({
	Default = Color3.fromRGB(255,255,255),
	Callback = print
})
```

### Link Option
```lua
local Option = Toggle.Link:AddOption()

Option:AddToggle({
	Name = "Toggle in option!",
	Callback = print
})
```

## Creating Keybind
```lua
NormalSection:AddKeybind({
	Name = "Keybind",
	Default = "LeftAlt",
	Flag = "Keybind_Example",
	Callback = print,
});
```

## Creating Slider
```lua
NormalSection:AddSlider({
	Name = "Slider",
	Min = 0,
	Max = 100,
	Default = 50,
	Round = 0,
	Flag = "Slider_Example",
	Callback = print
});
```

## Creating ColorPicker
```lua
NormalSection:AddColorPicker({
	Name = "ColorPicker",
	Default = Color3.fromRGB(0, 255, 140),
	Flag = "Color_Picker_Example",
	Callback = print
})
```

## Creating Dropdown
```lua
NormalSection:AddDropdown({
	Name = "Single Dropdown",
	Default = "Head",
	Flag = "Single_Dropdown",
	Values = {"Head","Body","Arms","Legs"},
	Callback = print
})
```

### Multi Dropdown
```lua
NormalSection:AddDropdown({
	Name = "Multi Dropdown",
	Default = {"Head"},
	Multi = true,
	Flag = "Multi_Dropdown",
	Values = {"Head","Body","Arms","Legs"},
	Callback = print
})
```

## Creating Button
```lua
NormalSection:AddButton({
	Name = "Button",
	Callback = function()
		print('PRINT!')
	end,
})
```

## Creating Paragraph
```lua
NormalSection:AddParagraph({
	Title = "Paragraph",
	Content = "Very cool paragraph"
})
```

## Creating Textbox
```lua

NormalSection:AddTextBox({
	Name = "Textbox",
	Placeholder = "Placeholder",
	Default = "Hello, World",
  Flag = "TextBoxExample",
	Callback = print
})
```

## Creating Config Tab
```lua
local ConfigUI = Window:DrawConfig({
	Name = "Config",
	Icon = "folder",
	Config = ConfigManager, -- Config Manager (required)
});

ConfigUI:Init();
```

# Config Manager
## Write Config
write current value to config
```lua
ConfigManager:WriteConfig({
	Name = "Config Name",
	Author = "Creator Name"
})
```

## Read Info
read config info. Ex: Author and Created date
```lua
ConfigManager:ReadInfo("<Config Name>")
```

## Load Config
Load the config in directory
```lua
ConfigManager:LoadConfig("<Config Name>")
```

## Delete Config
Delete the config in directory
```lua
ConfigManager:DeleteConfig("<Config Name>")
```

## Get Configs
get all configs in directory
```lua
ConfigManager:GetConfigs()
```

## Directory Path
config directory path
```lua
ConfigManager.Directory
```

# User Settings
## Create
```lua
local UserSettings = Window.UserSettings:Create();
```

## Example
```lua
UserSettings:AddColorPicker({
	Name = "Menu Color",
	Default = Compkiller.Colors.Highlight,
	Callback = function(f)
		Compkiller.Colors.Highlight = f;
		
		Compkiller:RefreshCurrentColor();
	end,
});

UserSettings:AddKeybind({
	Name = "Menu Key",
	Default = MenuKey,
	Callback = function(f)
		MenuKey = f;
		
		Window:SetMenuKey(MenuKey)
	end,
});

UserSettings:AddDropdown({
	Name = "Menu Language",
	Values = {"English","Russian","Chinese"},
	Default = "English",
	Callback = print
});

UserSettings:AddDropdown({
	Name = "Menu Theme",
	Values = {
		"Default",
		"Dark Green",
		"Dark Blue",
		"Purple Rose",
		"Skeet"
	},
	
	Default = "Default",
	
	Callback = function(f)
		Compkiller:SetTheme(f)
	end,
});

UserSettings:AddDropdown({
	Name = "Visible Widgets",
	Values = {"Watermark","Keybinds","Double Tab"},
	Multi = true,
	Default = {"Watermark"},
	Callback = function(f)
		print(f)
	end,
});
```
