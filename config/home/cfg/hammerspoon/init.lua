-- Cmd+drag to move a window, Cmd+right-drag to resize it from the nearest
-- corner. Windows are floated in AeroSpace first, so it doesn't snap them back
-- into the tiling layout, and focused.
--
-- Setting a window's frame goes through synchronous Accessibility calls into
-- the target app, which can be slow (e.g., browsers relayout on every resize).
-- Mouse events therefore only record the pointer position; a timer applies the
-- resulting frame at most once per display frame, dropping stale intermediate
-- ones.

require("hs.ipc")

local aerospace = "/opt/homebrew/bin/aerospace"
local types = hs.eventtap.event.types
local updateInterval = 1 / 60

-- When floating a window, AeroSpace resizes it to its last floating size (or
-- the size it had when AeroSpace first saw it), asynchronously. For this long
-- after floating, the window's actual frame is checked on every tick, and
-- corrected if AeroSpace's resize landed after ours.
local floatSettleTime = 0.5

hs.window.animationDuration = 0

local function windowAt(pos)
  local el = hs.axuielement.systemWideElement():elementAtPosition(pos)
  if not el then return nil end
  local win = el.AXRole == "AXWindow" and el or el.AXWindow
  return win and win:asHSWindow()
end

local drag = nil

-- Gestures whose AeroSpace task or settle timer are still running, so those
-- aren't garbage collected after the gesture ends.
local active = {}

-- The window frame for the given pointer position, relative to the frame the
-- window had when the gesture started.
local function targetFrame(d, pos)
  local dx, dy = math.floor(pos.x - d.mouse.x), math.floor(pos.y - d.mouse.y)
  local x, y, w, h = d.frame.x, d.frame.y, d.frame.w, d.frame.h
  if not d.resize then return { x = x + dx, y = y + dy, w = w, h = h } end
  if d.left then x, w = x + dx, w - dx else w = w + dx end
  if d.top then y, h = y + dy, h - dy else h = h + dy end
  return { x = x, y = y, w = w, h = h }
end

local function settling(d)
  return hs.timer.secondsSinceEpoch() < d.settleUntil
end

-- Apply the frame for the latest pointer position, touching only what changed.
-- Moving and resizing from the bottom-right corner each need a single
-- Accessibility call.
local function applyPending(d)
  if not d.ready then return end
  local s = settling(d)
  if not d.dirty and not s then return end
  d.dirty = false
  local p = targetFrame(d, d.pos)
  local cur = s and d.win:frame() or d.applied
  if p.x ~= cur.x or p.y ~= cur.y then d.win:setTopLeft({ x = p.x, y = p.y }) end
  if p.w ~= cur.w or p.h ~= cur.h then d.win:setSize({ w = p.w, h = p.h }) end
  d.applied = p
end

local function endDrag()
  drag.done = true
  applyPending(drag)
  drag = nil
end

local function startDrag(e, resize)
  if not e:getFlags():containExactly({ "cmd" }) then return false end
  local pos = e:location()
  local win = windowAt(pos)
  if not win then return false end

  win:focus()

  local f = win:frame()
  local d = {
    win = win,
    resize = resize,
    mouse = pos,
    pos = pos,
    frame = { x = f.x, y = f.y, w = f.w, h = f.h },
    left = pos.x < f.x + f.w / 2,
    top = pos.y < f.y + f.h / 2,
    ready = false,
    done = false,
  }
  drag = d
  active[d] = true

  -- Float the window without blocking the event tap. Frame updates wait until
  -- AeroSpace is done, then restore the window's original frame, so it stays
  -- under the pointer. This also runs if the gesture ended in the meantime.
  d.task = hs.task.new(aerospace, function()
    d.ready = true
    d.settleUntil = hs.timer.secondsSinceEpoch() + floatSettleTime
    applyPending(d)
    d.timer = hs.timer.doEvery(updateInterval, function()
      applyPending(d)
      if d.done and not settling(d) then
        d.timer:stop()
        active[d] = nil
      end
    end)
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
    drag.pos = e:location()
    drag.dirty = true
  else
    endDrag()
  end
  return true
end)
windowDragTap:start()
