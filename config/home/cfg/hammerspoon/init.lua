-- Cmd+drag to move a window, Cmd+right-drag to resize it from the nearest
-- corner. Windows are floated in AeroSpace first, so it doesn't snap them back
-- into the tiling layout.

require("hs.ipc")

local aerospace = "/opt/homebrew/bin/aerospace"
local types = hs.eventtap.event.types

hs.window.animationDuration = 0

local function windowAt(pos)
  local el = hs.axuielement.systemWideElement():elementAtPosition(pos)
  if not el then return nil end
  local win = el.AXRole == "AXWindow" and el or el.AXWindow
  return win and win:asHSWindow()
end

local drag = nil

local function startDrag(e, resize)
  if not e:getFlags():containExactly({ "cmd" }) then return false end
  local pos = e:location()
  local win = windowAt(pos)
  if not win then return false end

  hs.execute(aerospace .. " layout floating --window-id " .. win:id())

  local frame = win:frame()
  drag = {
    win = win,
    resize = resize,
    mouse = pos,
    frame = frame,
    left = pos.x < frame.x + frame.w / 2,
    top = pos.y < frame.y + frame.h / 2,
  }
  return true
end

local function continueDrag(e)
  local pos = e:location()
  local dx, dy = pos.x - drag.mouse.x, pos.y - drag.mouse.y
  local f = drag.frame
  if not drag.resize then
    drag.win:setTopLeft({ x = f.x + dx, y = f.y + dy })
    return
  end
  local x, y, w, h = f.x, f.y, f.w, f.h
  if drag.left then x, w = x + dx, w - dx else w = w + dx end
  if drag.top then y, h = y + dy, h - dy else h = h + dy end
  drag.win:setFrame({ x = x, y = y, w = w, h = h })
end

-- Global, so the tap isn't garbage collected.
windowDragTap = hs.eventtap.new({
  types.leftMouseDown, types.leftMouseDragged, types.leftMouseUp,
  types.rightMouseDown, types.rightMouseDragged, types.rightMouseUp,
}, function(e)
  local t = e:getType()
  if t == types.leftMouseDown or t == types.rightMouseDown then
    return startDrag(e, t == types.rightMouseDown)
  end
  if not drag then return false end
  if t == types.leftMouseDragged or t == types.rightMouseDragged then
    continueDrag(e)
  else
    drag = nil
  end
  return true
end)
windowDragTap:start()
