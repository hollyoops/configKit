local This = {}

function move_window_to_next_monitor()
    local app = hs.window.focusedWindow()
    app:moveToScreen(app:screen():next(), true, true)
end

function get_window_under_mouse()
    local mousePos = hs.geometry.new(hs.mouse.getAbsolutePosition())
    local mouseScreen = hs.mouse.getCurrentScreen()

    return hs.fnutils.find(hs.window.orderedWindows(), function(w)
        return mouseScreen == w:screen() and w:isStandard() and (not w:isFullScreen())
        -- return mouseScreen == w:screen() and w:isStandard() and (not w:isFullScreen()) and mousePos:inside(w:frame())
    end)
end

function focus_top_window_by_mouse()
    local target = get_window_under_mouse()
    if (target) then
        target:focus()
    else
        hs.window.frontmostWindow():focus()
    end
end

-- Move Mouse to center of next Monitor
function move_mouse_to_next_monitor()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    -- hs.mouse.setRelativePosition(center, nextScreen)
    hs.mouse.setAbsolutePosition(center)
end

function focus_next_monitor_top_window()
    move_mouse_to_next_monitor()
    focus_top_window_by_mouse()
end

function move_window_center()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w * 0.75
    f.h = max.h * 0.75
    f.x = max.x + max.w * (0.25 / 2)
    f.y = max.y + max.h * (0.25 / 2)
    win:setFrame(f, 0)
end

function move_window_left()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f, 0)
end

function move_window_right()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w / 2
    f.h = max.h
    f.x = max.w / 2
    f.y = max.y
    win:setFrame(f, 0)
end

function move_window_up()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w
    f.h = max.h / 2
    f.x = max.x
    f.y = max.y
    win:setFrame(f, 0)
end

function move_window_down()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w
    f.h = max.h / 2
    f.x = max.x
    f.y = max.h / 2
    win:setFrame(f, 0)
end

function maximize_window()
    local win = hs.window.focusedWindow()
    win:maximize(0)
end

function This.setup()
    local window = {"cmd", "alt", "ctrl"}
    hs.hotkey.bind(window, 'n', move_window_to_next_monitor)
    hs.hotkey.bind(window, 'f', focus_top_window_by_mouse)
    hs.hotkey.bind({"alt"}, 'tab', focus_next_monitor_top_window)
    hs.hotkey.bind(window, "h", move_window_left)
    -- 屏幕右半部分
    hs.hotkey.bind(window, "l", move_window_right)
    -- 屏幕上半部分
    hs.hotkey.bind(window, "k", move_window_up)

    -- 屏幕下半部分
    hs.hotkey.bind(window, "j", move_window_down)

    -- 居中
    hs.hotkey.bind(window, "C", move_window_center)

    -- 屏幕全屏，保留 menu bar
    hs.hotkey.bind(window, "M", maximize_window)
end

return This
