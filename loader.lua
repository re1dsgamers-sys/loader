repeat task.wait() until game:IsLoaded()

local API = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
local tween_service = game:GetService("TweenService")
local user_input_service = game:GetService("UserInputService")
local core_gui = game:GetService("CoreGui")
local players = game:GetService("Players")
local local_player = players.LocalPlayer

local function create_instance(instance_type, properties, children)
    local instance = Instance.new(instance_type)
    for key, value in pairs(properties) do instance[key] = value end
    if children then for _, child in pairs(children) do child.Parent = instance end end
    return instance
end

local function create_tween(instance, properties, duration, easing_style, easing_direction)
    local info = TweenInfo.new(
        duration or 0.3,
        easing_style or Enum.EasingStyle.Quart,
        easing_direction or Enum.EasingDirection.Out
    )
    local tween = tween_service:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function create_bounce_tween(instance, properties, duration)
    local info = TweenInfo.new(
        duration or 0.5,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    local tween = tween_service:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function create_smooth_tween(instance, properties, duration)
    local info = TweenInfo.new(
        duration or 0.4,
        Enum.EasingStyle.Exponential,
        Enum.EasingDirection.Out
    )
    local tween = tween_service:Create(instance, info, properties)
    tween:Play()
    return tween
end

local GAME_SCRIPTS = {
    ["Rivals"] = "f734cbc6d30b72abe044a3fb60543345",
    ["Arsenal"] = "d1c8b9e7a0c8f2a5b3e4c6d8f9a1b2c3",
    ["Default"] = "18fa0aa2984290b5582813fe581dd4cf"
}

local function get_script_id()
    local pid = game.PlaceId
    if pid == 17625359962 or pid == 18126510175 or pid == 71874690745115 or pid == 117398147513099 then
        return GAME_SCRIPTS["Rivals"]
    elseif pid == 286090429 or pid == 4902182837 then
        return GAME_SCRIPTS["Arsenal"]
    end
    return GAME_SCRIPTS["Default"]
end

API.script_id = get_script_id()

local Theme = {
    Background = Color3.fromRGB(14, 4, 6),
    Sidebar = Color3.fromRGB(20, 6, 10),
    Border = Color3.fromRGB(45, 45, 45),
    Accent = Color3.fromRGB(101, 3, 22),
    AccentHover = Color3.fromRGB(130, 15, 35),
    AccentGlow = Color3.fromRGB(150, 25, 40),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(200, 200, 200),
    Input = Color3.fromRGB(18, 5, 8),
    InputFocus = Color3.fromRGB(28, 10, 16),
    ElementBorder = Color3.fromRGB(55, 8, 16),
    Dialog = Color3.fromRGB(75, 12, 24),
    TitleBarLine = Color3.fromRGB(85, 16, 28),
    Error = Color3.fromRGB(255, 40, 40)
}

local function typewriter(label, full_text, base_delay)
    local d = base_delay or 0.035
    for i = 1, #full_text do
        if not label or not label.Parent then return end
        label.Text = string.sub(full_text, 1, i)
        local c = string.sub(full_text, i, i)
        if c == " " then
            task.wait(d * 0.5)
        elseif c == "," or c == "." then
            task.wait(d * 2.5)
        else
            task.wait(d + (math.random() * 0.012))
        end
    end
end

local function show_notification(title_text, message_text, display_duration)
    local screen_gui = core_gui:FindFirstChild("PhantomLoader")
    if not screen_gui then return end

    local notification_container = screen_gui:FindFirstChild("NotifContainer")
    if not notification_container then
        notification_container = create_instance("Frame", {
            Name = "NotifContainer",
            Parent = screen_gui,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.new(0, 300, 1, 0),
            AnchorPoint = Vector2.new(1, 1)
        }, {
            create_instance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0, 8)
            })
        })
    end

    local dur = display_duration or 3

    local notification_frame = create_instance("Frame", {
        Parent = notification_container,
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundTransparency = 0.3
    }, {
        create_instance("UICorner", {CornerRadius = UDim.new(0, 6)}),
        create_instance("UIStroke", {Color = Theme.Border, Thickness = 1, Transparency = 0.5}),
        create_instance("Frame", {
            Name = "AccentBar",
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 3, 0, 0),
            BorderSizePixel = 0
        }),
        create_instance("Frame", {
            Name = "TimerBar",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.75,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2),
            BorderSizePixel = 0
        }),
        create_instance("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 10),
            Size = UDim2.new(1, -26, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = title_text or "Notification",
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1
        }),
        create_instance("TextLabel", {
            Name = "Desc",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 28),
            Size = UDim2.new(1, -26, 0, 20),
            Font = Enum.Font.Gotham,
            Text = message_text or "",
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1
        })
    })

    create_smooth_tween(notification_frame, {Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 0}, 0.4)

    local title_n = notification_frame:FindFirstChild("Title")
    local desc_n = notification_frame:FindFirstChild("Desc")
    local accent_bar = notification_frame:FindFirstChild("AccentBar")
    local timer_bar = notification_frame:FindFirstChild("TimerBar")
    local stroke_n = notification_frame:FindFirstChild("UIStroke")

    task.delay(0.15, function()
        if title_n and title_n.Parent then
            create_smooth_tween(title_n, {TextTransparency = 0}, 0.35)
        end
    end)
    task.delay(0.22, function()
        if desc_n and desc_n.Parent then
            create_smooth_tween(desc_n, {TextTransparency = 0}, 0.35)
        end
    end)
    task.delay(0.1, function()
        if accent_bar and accent_bar.Parent then
            create_smooth_tween(accent_bar, {Size = UDim2.new(0, 3, 1, 0)}, 0.6)
        end
    end)
    if stroke_n then
        create_smooth_tween(stroke_n, {Transparency = 0}, 0.4)
    end

    task.delay(0.4, function()
        if timer_bar and timer_bar.Parent then
            local ti = TweenInfo.new(dur - 0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            tween_service:Create(timer_bar, ti, {Size = UDim2.new(0, 0, 0, 2)}):Play()
        end
    end)

    task.delay(dur, function()
        if notification_frame and notification_frame.Parent then
            if title_n and title_n.Parent then
                create_tween(title_n, {TextTransparency = 1}, 0.2)
            end
            if desc_n and desc_n.Parent then
                create_tween(desc_n, {TextTransparency = 1}, 0.2)
            end
            if accent_bar and accent_bar.Parent then
                create_tween(accent_bar, {Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1}, 0.25)
            end

            task.wait(0.12)

            if notification_frame and notification_frame.Parent then
                create_tween(notification_frame, {BackgroundTransparency = 1}, 0.2)
                if stroke_n and stroke_n.Parent then
                    create_tween(stroke_n, {Transparency = 1}, 0.2)
                end

                task.wait(0.1)

                if notification_frame and notification_frame.Parent then
                    create_smooth_tween(notification_frame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                    task.wait(0.35)
                    if notification_frame and notification_frame.Parent then
                        notification_frame:Destroy()
                    end
                end
            end
        end
    end)
end

if core_gui:FindFirstChild("PhantomLoader") then
    core_gui.PhantomLoader:Destroy()
end

local screen_gui = create_instance("ScreenGui", {
    Name = "PhantomLoader",
    Parent = core_gui
})

local shadow = create_instance("Frame", {
    Name = "Shadow",
    Parent = screen_gui,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    Position = UDim2.new(0.5, 4, 0.5, 24),
    Size = UDim2.new(0, 0, 0, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BorderSizePixel = 0,
    BackgroundTransparency = 1
}, {
    create_instance("UICorner", {CornerRadius = UDim.new(0, 12)})
})

local main_frame = create_instance("Frame", {
    Name = "MainFrame",
    Parent = screen_gui,
    BackgroundColor3 = Theme.Background,
    Position = UDim2.new(0.5, 0, 0.5, 20),
    Size = UDim2.new(0, 0, 0, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BorderSizePixel = 0,
    BackgroundTransparency = 1,
    ClipsDescendants = true
}, {
    create_instance("UICorner", {CornerRadius = UDim.new(0, 10)}),
    create_instance("UIStroke", {Color = Theme.Border, Thickness = 1.5, Transparency = 1})
})

local sidebar = create_instance("Frame", {
    Name = "Sidebar",
    Parent = main_frame,
    BackgroundColor3 = Theme.Sidebar,
    Size = UDim2.new(0, 160, 1, 0),
    BorderSizePixel = 0,
    BackgroundTransparency = 1
}, {
    create_instance("UICorner", {CornerRadius = UDim.new(0, 10)}),
    create_instance("Frame", {
        Name = "Divider",
        BackgroundColor3 = Theme.TitleBarLine,
        Position = UDim2.new(1, -1, 0, 10),
        Size = UDim2.new(0, 1, 1, -20),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })
})

local avatar_container = create_instance("Frame", {
    Parent = sidebar,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 40),
    Size = UDim2.new(1, 0, 0, 100)
}, {
    create_instance("ImageLabel", {
        Name = "Avatar",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -30, 0, 0),
        Size = UDim2.new(0, 60, 0, 60),
        Image = "rbxassetid://0",
        ImageTransparency = 1
    }, {
        create_instance("UICorner", {CornerRadius = UDim.new(1, 0)}),
        create_instance("UIStroke", {Color = Theme.TitleBarLine, Thickness = 2, Transparency = 1})
    })
})

task.spawn(function()
    local success, thumb = pcall(function()
        return players:GetUserThumbnailAsync(
            local_player.UserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size420x420
        )
    end)
    if success then avatar_container.Avatar.Image = thumb end
end)

local content = create_instance("Frame", {
    Parent = main_frame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 160, 0, 0),
    Size = UDim2.new(1, -160, 1, 0)
})

local title_label = create_instance("TextLabel", {
    Name = "TitleLabel",
    Parent = content,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 40),
    Size = UDim2.new(1, -60, 0, 30),
    Font = Enum.Font.GothamBold,
    Text = "",
    TextColor3 = Theme.Text,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left
})

local welcome_label = create_instance("TextLabel", {
    Name = "WelcomeLabel",
    Parent = content,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 65),
    Size = UDim2.new(1, -60, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = Theme.Text,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
})

local function create_styled_input(placeholder, y_pos, is_password)
    local container = create_instance("Frame", {
        Parent = content,
        BackgroundColor3 = Theme.Input,
        Position = UDim2.new(0, 30, 0, y_pos),
        Size = UDim2.new(1, -60, 0, 38),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    }, {
        create_instance("UICorner", {CornerRadius = UDim.new(0, 6)}),
        create_instance("UIStroke", {Color = Theme.ElementBorder, Thickness = 1, Transparency = 1})
    })

    local tb = create_instance("TextBox", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.Placeholder,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    })

    if is_password then
        local mask = create_instance("TextLabel", {
            Parent = container,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "",
            TextColor3 = Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })
        tb.TextTransparency = 1
        tb:GetPropertyChangedSignal("Text"):Connect(function()
            mask.Text = string.rep("\226\128\162", #tb.Text)
        end)
    end

    local focus_line = create_instance("Frame", {
        Name = "FocusLine",
        Parent = container,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.6,
        Position = UDim2.new(0.5, 0, 1, -2),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 0, 0, 2),
        BorderSizePixel = 0
    })

    tb.Focused:Connect(function()
        create_smooth_tween(container:FindFirstChild("UIStroke"), {Color = Color3.fromRGB(80, 80, 80), Thickness = 1.5}, 0.25)
        create_smooth_tween(container, {BackgroundColor3 = Theme.InputFocus}, 0.25)
        create_smooth_tween(focus_line, {Size = UDim2.new(0.9, 0, 0, 2)}, 0.35)
    end)
    tb.FocusLost:Connect(function()
        create_smooth_tween(container:FindFirstChild("UIStroke"), {Color = Theme.ElementBorder, Thickness = 1}, 0.35)
        create_smooth_tween(container, {BackgroundColor3 = Theme.Input}, 0.35)
        create_smooth_tween(focus_line, {Size = UDim2.new(0, 0, 0, 2)}, 0.3)
    end)

    return tb, container
end

local user_input, user_input_container = create_styled_input("Username", 110, false)
user_input.Text = local_player.Name
local key_input, key_input_container = create_styled_input("Enter License Key", 158, true)

local function create_button(text, y_pos, is_primary)
    local btn = create_instance("TextButton", {
        Parent = content,
        BackgroundColor3 = is_primary and Theme.Accent or Theme.Background,
        Position = UDim2.new(0, 30, 0, y_pos),
        Size = UDim2.new(1, -60, 0, 38),
        AutoButtonColor = false,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 13,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        ClipsDescendants = true
    }, {
        create_instance("UICorner", {CornerRadius = UDim.new(0, 6)}),
        not is_primary and create_instance("UIStroke", {Color = Theme.ElementBorder, Thickness = 1, Transparency = 1}) or nil
    })

    local underline = create_instance("Frame", {
        Name = "Underline",
        Parent = btn,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(0, 0, 0, 2),
        BorderSizePixel = 0
    })

    btn.MouseEnter:Connect(function()
        if is_primary then
            create_smooth_tween(btn, {BackgroundTransparency = 0.15}, 0.2)
        else
            local s = btn:FindFirstChild("UIStroke")
            if s then create_smooth_tween(s, {Color = Color3.fromRGB(90, 90, 90)}, 0.25) end
        end
        create_smooth_tween(underline, {Size = UDim2.new(1, 0, 0, 2)}, 0.3)
    end)

    btn.MouseLeave:Connect(function()
        if is_primary then
            create_smooth_tween(btn, {BackgroundTransparency = 0}, 0.25)
        else
            local s = btn:FindFirstChild("UIStroke")
            if s then create_smooth_tween(s, {Color = Theme.ElementBorder}, 0.3) end
        end
        create_smooth_tween(underline, {Size = UDim2.new(0, 0, 0, 2)}, 0.25)
    end)

    return btn
end

local login_btn = create_button("Check Key", 205, true)
local get_key_btn = create_button("Get your free key", 253, false)
local buy_btn = create_button("Buy Premium", 299, false)

task.spawn(function()
    while buy_btn and buy_btn.Parent do
        create_smooth_tween(buy_btn, {BackgroundColor3 = Color3.fromRGB(180, 30, 45), BackgroundTransparency = 0}, 1.5)
        task.wait(1.5)
        if not buy_btn or not buy_btn.Parent then break end
        create_smooth_tween(buy_btn, {BackgroundColor3 = Color3.fromRGB(60, 5, 12), BackgroundTransparency = 0}, 1.5)
        task.wait(1.5)
    end
end)

local scan_bar = create_instance("Frame", {
    Name = "ScanBar",
    Parent = login_btn,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Position = UDim2.new(-0.3, 0, 0, 0),
    Size = UDim2.new(0.3, 0, 1, 0),
    BorderSizePixel = 0,
    ZIndex = 2
}, {
    create_instance("UICorner", {CornerRadius = UDim.new(0, 6)})
})

local discord_btn = create_instance("TextButton", {
    Parent = sidebar,
    BackgroundColor3 = Theme.Dialog,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 115),
    Size = UDim2.new(1, -20, 0, 30),
    Text = "Join Our Discord",
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    TextSize = 12,
    AutoButtonColor = false,
    TextTransparency = 1
}, {
    create_instance("UICorner", {CornerRadius = UDim.new(0, 6)})
})

discord_btn.MouseEnter:Connect(function()
    create_smooth_tween(discord_btn, {BackgroundTransparency = 0.2}, 0.25)
end)
discord_btn.MouseLeave:Connect(function()
    create_smooth_tween(discord_btn, {BackgroundTransparency = 0}, 0.3)
end)

local function openDiscord()
    if setclipboard then
        setclipboard("https://discord.com/invite/p7W2GrUwae")
    end

    show_notification("Discord", "Invite link copied to clipboard", 5)

    pcall(function()
        local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()
        discordInviter.Join("https://discord.com/invite/p7W2GrUwae")
    end)
end

discord_btn.MouseButton1Click:Connect(openDiscord)

local function handle_error()
    local stroke = main_frame:FindFirstChild("UIStroke")
    if stroke then create_tween(stroke, {Color = Theme.Error, Thickness = 2.5}, 0.08) end

    local original_pos = main_frame.Position
    for i = 1, 8 do
        local intensity = 6 * (1 - (i / 9))
        local shift = (i % 2 == 0) and intensity or -intensity
        create_tween(main_frame, {
            Position = UDim2.new(
                original_pos.X.Scale, original_pos.X.Offset + shift,
                original_pos.Y.Scale, original_pos.Y.Offset + (math.abs(shift) * 0.3)
            )
        }, 0.035, Enum.EasingStyle.Sine)
        task.wait(0.035)
    end
    create_bounce_tween(main_frame, {Position = original_pos}, 0.4)

    task.wait(0.6)
    if stroke then create_smooth_tween(stroke, {Color = Theme.Border, Thickness = 1.5}, 0.6) end
end

buy_btn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://phantomarket.org")
        show_notification("Clipboard", "Shop link has been copied", 2)
    end
end)

get_key_btn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://ads.luarmor.net/get_key?for=Checkpoints-HSVJWPYAuoAP")
        show_notification("Clipboard", "Key link has been copied", 2)
    end
end)

login_btn.MouseButton1Click:Connect(function()
    local key = key_input.Text:gsub("%s+", "")
    if key == "" then
        handle_error()
        show_notification("Warning", "Key is required", 2)
        return
    end

    login_btn.Text = "Authenticating..."

    local scan_active = true
    task.spawn(function()
        scan_bar.BackgroundTransparency = 0.82
        while scan_active do
            if scan_bar and scan_bar.Parent then
                scan_bar.Position = UDim2.new(-0.3, 0, 0, 0)
                local si = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                local st = tween_service:Create(scan_bar, si, {Position = UDim2.new(1, 0, 0, 0)})
                st:Play()
                st.Completed:Wait()
                task.wait(0.15)
            else
                break
            end
        end
        if scan_bar and scan_bar.Parent then
            scan_bar.BackgroundTransparency = 1
        end
    end)

    task.spawn(function()
        local status = API.check_key(key)
        scan_active = false

        if status.code == "KEY_VALID" then
            getgenv().script_key = key
            show_notification("Success", "Key Validated! Loading...", 3)

            if scan_bar and scan_bar.Parent then
                create_smooth_tween(scan_bar, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.7}, 0.3)
                task.wait(0.2)
                create_smooth_tween(scan_bar, {BackgroundTransparency = 1}, 0.3)
            end

            local stroke = main_frame:FindFirstChild("UIStroke")
            if stroke then
                create_smooth_tween(stroke, {Color = Color3.fromRGB(80, 80, 80), Thickness = 2.5}, 0.3)
            end

            task.wait(0.4)

            for _, child in pairs(main_frame:GetDescendants()) do
                pcall(function()
                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                        create_smooth_tween(child, {TextTransparency = 1}, 0.35)
                    end
                    if child:IsA("ImageLabel") then
                        create_smooth_tween(child, {ImageTransparency = 1}, 0.35)
                    end
                    if child:IsA("Frame") or child:IsA("TextButton") then
                        create_smooth_tween(child, {BackgroundTransparency = 1}, 0.35)
                    end
                    if child:IsA("UIStroke") then
                        create_smooth_tween(child, {Transparency = 1}, 0.35)
                    end
                end)
            end

            task.wait(0.2)

            create_smooth_tween(main_frame, {
                Size = UDim2.new(0, 520, 0, 360),
                BackgroundTransparency = 1
            }, 0.5)
            create_smooth_tween(shadow, {BackgroundTransparency = 1}, 0.4)
            if stroke then
                create_smooth_tween(stroke, {Transparency = 1}, 0.4)
            end

            task.wait(0.55)
            screen_gui:Destroy()
            API.load_script()
        else
            login_btn.Text = "Check Key"
            if scan_bar and scan_bar.Parent then
                scan_bar.BackgroundTransparency = 1
            end
            create_tween(login_btn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent}, 0.2)
            handle_error()

            local err_msg = "Invalid Key"
            if status.code == "KEY_HWID_LOCKED" then
                err_msg = "HWID Locked! Reset in Discord"
            elseif status.code == "KEY_EXPIRED" then
                err_msg = "Key Expired"
            end

            show_notification("Auth Error", err_msg, 3)
        end
    end)
end)

local function make_draggable(f)
    local dragging, dragInput, dragStart, startPos
    f.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = f.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    f.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    user_input_service.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            create_tween(f, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }, 0.06, Enum.EasingStyle.Sine)
            if shadow and shadow.Parent then
                create_tween(shadow, {
                    Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X + 4,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y + 4
                    )
                }, 0.08, Enum.EasingStyle.Sine)
            end
        end
    end)
end

make_draggable(main_frame)

task.spawn(function()
    create_smooth_tween(shadow, {BackgroundTransparency = 0.6, Position = UDim2.new(0.5, 4, 0.5, 4), Size = UDim2.new(0, 504, 0, 349)}, 0.6)

    create_smooth_tween(main_frame, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5)
    local main_stroke = main_frame:FindFirstChild("UIStroke")
    if main_stroke then
        create_smooth_tween(main_stroke, {Transparency = 0}, 0.5)
    end
    create_bounce_tween(main_frame, {Size = UDim2.new(0, 500, 0, 345)}, 0.7)

    task.wait(0.25)

    create_smooth_tween(sidebar, {BackgroundTransparency = 0}, 0.45)
    local divider = sidebar:FindFirstChild("Divider")
    if divider then
        create_smooth_tween(divider, {BackgroundTransparency = 0}, 0.5)
    end

    task.wait(0.12)

    local avatar = avatar_container:FindFirstChild("Avatar")
    if avatar then
        create_smooth_tween(avatar, {ImageTransparency = 0}, 0.45)
        local avatar_stroke = avatar:FindFirstChild("UIStroke")
        if avatar_stroke then
            create_smooth_tween(avatar_stroke, {Transparency = 0}, 0.45)
        end
    end

    task.wait(0.06)

    create_smooth_tween(discord_btn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.4)

    task.wait(0.18)

    typewriter(title_label, "Phantom Hub", 0.045)

    task.wait(0.08)

    typewriter(welcome_label, "Welcome, " .. local_player.DisplayName, 0.028)

    task.wait(0.12)

    create_smooth_tween(user_input_container, {BackgroundTransparency = 0}, 0.35)
    local user_stroke = user_input_container:FindFirstChild("UIStroke")
    if user_stroke then create_smooth_tween(user_stroke, {Transparency = 0}, 0.35) end

    task.wait(0.1)

    create_smooth_tween(key_input_container, {BackgroundTransparency = 0}, 0.35)
    local key_stroke = key_input_container:FindFirstChild("UIStroke")
    if key_stroke then create_smooth_tween(key_stroke, {Transparency = 0}, 0.35) end

    task.wait(0.12)

    create_smooth_tween(login_btn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.35)

    task.wait(0.1)

    create_smooth_tween(get_key_btn, {BackgroundTransparency = 1, TextTransparency = 0}, 0.35)
    local getkey_stroke = get_key_btn:FindFirstChild("UIStroke")
    if getkey_stroke then create_smooth_tween(getkey_stroke, {Transparency = 0}, 0.35) end

    task.wait(0.1)

    create_smooth_tween(buy_btn, {TextTransparency = 0}, 0.35)
    local buy_stroke = buy_btn:FindFirstChild("UIStroke")
    if buy_stroke then create_smooth_tween(buy_stroke, {Transparency = 0}, 0.35) end

    task.wait(0.3)

    task.spawn(function()
        local av = avatar_container:FindFirstChild("Avatar")
        if not av then return end
        local av_stroke = av:FindFirstChild("UIStroke")
        if not av_stroke then return end
        while av and av.Parent and av_stroke and av_stroke.Parent do
            create_tween(av_stroke, {Thickness = 3, Color = Color3.fromRGB(120, 120, 120)}, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.8)
            if not av or not av.Parent then break end
            create_tween(av_stroke, {Thickness = 2, Color = Theme.TitleBarLine}, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.8)
        end
    end)

    task.spawn(function()
        while main_frame and main_frame.Parent do
            local ms = main_frame:FindFirstChild("UIStroke")
            if ms then
                create_tween(ms, {Color = Color3.fromRGB(65, 65, 65)}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(2)
                if not main_frame or not main_frame.Parent then break end
                create_tween(ms, {Color = Theme.Border}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(2)
            else
                break
            end
        end
    end)
end)
