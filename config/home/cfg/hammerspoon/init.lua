-- Cmd+drag to move a window, Cmd+right-drag to resize it from the nearest
-- corner. Windows are floated in AeroSpace first, so it doesn't snap them back
-- into the tiling layout, and focused.
--
-- Setting a window's frame goes through synchronous Accessibility calls into
-- the target app, which can be slow (e.g., browsers relayout on every resize).
-- Mouse events therefore only record the target frame; a timer applies the
-- latest one at most once per display frame, dropping stale intermediate ones.

require("hs.ipc")

local aerospace = "/opt/homebrew/bin/aerospace"
local types = hs.eventtap.event.types
local updateInterval = 1 / 60

hs.window.animationDuration = 0

local function windowAt(pos)
  local el = hs.axuielement.systemWideElement():elementAtPosition(pos)
  if not el then return nil end
  local win = el.AXRole == "AXWindow" and el or el.AXWindow
  return win and win:asHSWindow()
end

local drag = nil

local function targetFrame(pos)
  local dx, dy = pos.x - drag.mouse.x, pos.y - drag.mouse.y
  local x, y, w, h = drag.frame.x, drag.frame.y, drag.frame.w, drag.frame.h
  if not drag.resize then return { x = x + dx, y = y + dy, w = w, h = h } end
  if drag.left then x, w = x + dx, w - dx else w = w + dx end
  if drag.top then y, h = y + dy, h - dy else h = h + dy end
  return { x = x, y = y, w = w, h = h }
end

-- Apply the frame for the latest mouse position, touching only what changed.
-- Moving and resizing from the bottom-right corner each need a single
-- Accessibility call.
local function applyPending()
  if not drag or not drag.ready or not drag.last then return end
  local p, cur = targetFrame(drag.last), drag.applied
  drag.last = nil
  if p.x ~= cur.x or p.y ~= cur.y then drag.win:setTopLeft({ x = p.x, y = p.y }) end
  if p.w ~= cur.w or p.h ~= cur.h then drag.win:setSize({ w = p.w, h = p.h }) end
  drag.applied = p
end

local function endDrag()
  applyPending()
  if drag.timer then drag.timer:stop() end
  drag = nil
end

local function startDrag(e, resize)
  if not e:getFlags():containExactly({ "cmd" }) then return false end
  local pos = e:location()
  local win = windowAt(pos)
  if not win then return false end

  win:focus()

  local frame = win:frame()
  local d = {
    win = win,
    resize = resize,
    mouse = pos,
    left = pos.x < frame.x + frame.w / 2,
    top = pos.y < frame.y + frame.h / 2,
    ready = false,
  }
  drag = d

  -- Float the window without blocking the event tap. Frame updates wait until
  -- AeroSpace is done, as floating may change the window's frame.
  d.task = hs.task.new(aerospace, function()
    if drag ~= d then return end
    local f = win:frame()
    d.frame = { x = f.x, y = f.y, w = f.w, h = f.h }
    d.applied = d.frame
    d.ready = true
    d.timer = hs.timer.doEvery(updateInterval, applyPending)
  end, { "layout", "floating", "--window-id", tostring(win:id()) })
  d.task:start()
  return true
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
    drag.last = e:location()
  else
    endDrag()
  end
  return true
end)
windowDragTap:start()
