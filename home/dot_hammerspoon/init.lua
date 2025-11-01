hs.window.animationDuration=0
hs.grid.setMargins(hs.geometry.size(0,0))
hs.grid.setGrid('12x2')

-- Track last window and grid position for double-press detection
local lastWindow = nil
local lastGrid = nil

-- Helper function to handle grid positioning with screen switching
local function setGridWithScreenSwitch(gridSpec)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end

    local isMultiPress = win == lastWindow and gridSpec == lastGrid

    local screen = win:screen()

    local targetScreen
    if isMultiPress then
      targetScreen = screen:next()
    else
      targetScreen = screen
    end

    win:move(win:frame(), targetScreen, true, 0)
    hs.grid.set(win, gridSpec, targetScreen)

    -- Update tracking variables
    lastWindow = win
    lastGrid = gridSpec
  end
end

-- Window management shortcuts
-- Row 1: Y U I O P [ ]
-- Row 2: H J K L ; '
-- Row 3: N M   . /

-- Full
hs.hotkey.bind({"cmd", "shift", "alt"}, "K", setGridWithScreenSwitch('0,0 12x2'))

-- Left 50
hs.hotkey.bind({"cmd", "shift", "alt"}, "J", setGridWithScreenSwitch('0,0 6x2'))

-- Right 50
hs.hotkey.bind({"cmd", "shift", "alt"}, "L", setGridWithScreenSwitch('6,0 6x2'))

-- Center 33
hs.hotkey.bind({"cmd", "shift", "alt"}, "I", setGridWithScreenSwitch('4,0 4x2'))

-- Left 33
hs.hotkey.bind({"cmd", "shift", "alt"}, "U", setGridWithScreenSwitch('0,0 4x2'))

-- Right 33
hs.hotkey.bind({"cmd", "shift", "alt"}, "O", setGridWithScreenSwitch('8,0 4x2'))

-- Left 66
hs.hotkey.bind({"cmd", "shift", "alt"}, "M", setGridWithScreenSwitch('0,0 8x2'))

-- Right 66
hs.hotkey.bind({"cmd", "shift", "alt"}, ".", setGridWithScreenSwitch('4,0 8x2'))

-- Left 42
hs.hotkey.bind({"cmd", "shift", "alt"}, "Y", setGridWithScreenSwitch('0,0 5x2'))

-- Right 42
hs.hotkey.bind({"cmd", "shift", "alt"}, "P", setGridWithScreenSwitch('7,0 5x2'))

-- Top 50
hs.hotkey.bind({"cmd", "shift", "alt"}, "H", setGridWithScreenSwitch('0,0 12x1'))

-- Bottom 50
hs.hotkey.bind({"cmd", "shift", "alt"}, ";", setGridWithScreenSwitch('0,1 12x1'))

-- Left 58
hs.hotkey.bind({"cmd", "shift", "alt"}, "N", setGridWithScreenSwitch('0,0 7x2'))

-- Right 58
hs.hotkey.bind({"cmd", "shift", "alt"}, "/", setGridWithScreenSwitch('5,0 7x2'))

-- Center 50
hs.hotkey.bind({"cmd", "shift", "alt"}, "'", setGridWithScreenSwitch('3,0 6x2'))

-- Left 25
hs.hotkey.bind({"cmd", "shift", "alt"}, "[", setGridWithScreenSwitch('0,0 3x2'))

-- Right 25
hs.hotkey.bind({"cmd", "shift", "alt"}, "]", setGridWithScreenSwitch('9,0 3x2'))


--
-- Auto-reload config on change.
--

function reloadConfig(files)
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      hs.reload()
    end
  end
end

myWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
