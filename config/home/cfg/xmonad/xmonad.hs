import XMonad
import qualified XMonad.StackSet as S
import XMonad.Layout (Tall, Mirror)
import XMonad.Layout.Spacing (spacingRaw, Border(..), incWindowSpacing, decWindowSpacing)
import XMonad.Layout.NoBorders (lessBorders, noBorders, Ambiguity( Screen ))
import XMonad.Layout.Tabbed (simpleTabbedBottom)
import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.SimpleFloat (simpleFloat')
import XMonad.Layout.SimpleDecoration (shrinkText, decoWidth)
import XMonad.Layout.MagicFocus (followOnlyIf, disableFollowOnWS)
import XMonad.Layout.BorderResize (borderResize)
import XMonad.Layout.Fullscreen (fullscreenSupport)
import qualified XMonad.Layout.Renamed as R
import XMonad.Operations (sendMessage, windows)
import XMonad.StackSet (greedyView, shift)
import XMonad.Util.SessionStart (doOnce)
import XMonad.Util.SpawnOnce (spawnOnce, spawnOnOnce)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP(..), wrap)
import XMonad.Hooks.ManageDocks (docks, avoidStruts, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.UrgencyHook (withUrgencyHook, NoUrgencyHook(..))
import XMonad.Actions.CycleWS (swapNextScreen)
import XMonad.Actions.SpawnOn (manageSpawn)

import qualified DBus as D
import qualified DBus.Client as D

import Control.Monad (when, join)
import Data.Maybe (maybeToList)

import MySystem (system)

modM = mod4Mask
altMask = mod1Mask
ctrlMask = controlMask

barActive = "#c0333333"
barYellow = "#f9d300"
barPurple = "#9f78e1"
barRed = "#fb4934"
barRedUnderline = "#992618"

myStartupHook = do
  -- Trigger window-manager systemd target.
  spawnOnce "systemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS && \
             \ systemctl --no-block --user start window-manager.target"
  -- Set background image.
  spawn "feh --bg-scale /home/thomas/Backgrounds/wallpaper-pixelart1.png"
  -- Initialize thingshare.
  spawnOnce "thingshare_init"
  -- Perform system-specific hooks.
  case system of
    "castor" -> do
      spawnOnOnce "6" "Discord"
      spawnOnOnce "9" "thunderbird"
      spawnOnOnce "9" "keepassxc"
      spawnOnOnce "9" "seafile-applet"
      spawnOnOnce "9" "deluge"
      spawnOnOnce "m" "urxvt -e ncmpcpp"
      spawnOnOnce "m" "cool-retro-term -e vis"
  -- Patch in fullscreen support.
  addEWMHFullscreen

myKeys = [ ((modM, xK_m), windows $ greedyView "m")
         , ((modM .|. shiftMask, xK_m), windows $ shift "m")
         , ((modM, xK_d), windows $ greedyView "d")
         , ((modM .|. shiftMask, xK_d), windows $ shift "d")
         , ((modM, xK_f), spawn "firefox" )
         , ((modM, xK_p), spawn "rofi -combi-modi run,drun -show combi -modi combi" )
         , ((modM .|. shiftMask, xK_s), swapNextScreen)
         , ((modM .|. shiftMask, xK_f), sendMessage ToggleStruts)
         , ((controlMask .|. shiftMask, xK_1), spawn "thingshare_screenshot full")
         , ((controlMask .|. shiftMask, xK_2), spawn "thingshare_screenshot display")
         , ((controlMask .|. shiftMask, xK_3), spawn "thingshare_screenshot window")
         , ((controlMask .|. shiftMask, xK_4), spawn "thingshare_screenshot region")
         , ((0, 0x1008FF02), spawn "brightness-control up")
         , ((0, 0x1008FF03), spawn "brightness-control down")
         , ((0, 0x1008FF11), spawn "volume-control down")
         , ((0, 0x1008FF12), spawn "volume-control toggle-mute")
         , ((0, 0x1008FF13), spawn "volume-control up")
         , ((0, 0x1008FF14), spawn "playerctl play-pause")
         , ((0, 0x1008FF15), spawn "playerctl stop")
         , ((0, 0x1008FF16), spawn "playerctl previous")
         , ((0, 0x1008FF17), spawn "playerctl next")
         -- Fun:
         , ((modM, xK_equal), incWindowSpacing 1)
         , ((modM, xK_minus), decWindowSpacing 1)
         -- BSP:
         , ((modM .|. shiftMask, xK_l), do
            layout <- getActiveLayoutDescription
            case layout of
                "BSP" -> sendMessage $ ExpandTowards R
                _     -> sendMessage Expand
           )
         , ((modM .|. shiftMask, xK_h), do
            layout <- getActiveLayoutDescription
            case layout of
                "BSP" -> sendMessage $ ExpandTowards L
                _     -> sendMessage Shrink
           )
         , ((modM .|. shiftMask, xK_j), sendMessage $ ExpandTowards D)
         , ((modM .|. shiftMask, xK_k), sendMessage $ ExpandTowards U)
         , ((modM .|. ctrlMask,  xK_j), windows S.swapDown)
         , ((modM .|. ctrlMask,  xK_k), windows S.swapUp)
         , ((modM,               xK_r), sendMessage Rotate)
         , ((modM,               xK_s), sendMessage Swap)
         , ((modM,               xK_n), sendMessage FocusParent)
         , ((modM .|. shiftMask, xK_n), sendMessage SelectNode)
         , ((modM .|. shiftMask, xK_m), sendMessage MoveNode)
         , ((modM,               xK_a), sendMessage Balance)
         , ((modM .|. shiftMask, xK_a), sendMessage Equalize)
         ]

-- Get the name of the active layout.
getActiveLayoutDescription :: X String
getActiveLayoutDescription = do
    workspaces <- gets windowset
    return $ description . S.layout . S.workspace . S.current $ workspaces

-- Patch in fullscreen support.
addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

-- Output a string to a DBus.
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

polybarLogHook dbus = def
    {  ppOutput = dbusOutput dbus
     , ppCurrent = wrap ("%{B" ++ barActive ++ "}%{u" ++ barYellow ++  "}<") ">%{-u}%{B-}"
     , ppVisible = wrap ("%{B" ++ barActive ++ "}%{u" ++ barPurple ++ "} ") " %{-u}%{B-}"
     , ppUrgent = wrap ("%{u" ++ barRedUnderline ++ "}%{F" ++ barRed ++ "} ") "!%{F-}%{-u}"
     , ppHidden = wrap " " " "
     , ppWsSep = ""
     , ppSep = ": "
     , ppTitle = \s -> ""
    }

main = do
    num <- countScreens
    dbus <- D.connectSession
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad
        $ ewmh
        $ docks
        $ withUrgencyHook NoUrgencyHook
        $ fullscreenSupport
        $ defaults dbus

defaults dbus = def {
      modMask = modM
    , terminal = "urxvt"
    , workspaces = ["1:dev", "2", "3", "4", "5", "6", "7", "8", "9", "m", "d"]
    , normalBorderColor = "#BBBBBB"
    , focusedBorderColor = "#FF6600"
    , layoutHook = avoidStruts
                    $ lessBorders Screen
                      -- Remove "Spacing" from layout names.
                    $ R.renamed [R.CutWordsLeft 1]
                    $ (spacingRaw True (Border 0 0 0 0) False (Border 0 0 0 0) True)
                      -- Tabbed-only workspace.
                    $ onWorkspace "9" simpleTabbedBottom
                      -- Dynamic-only (floating) workspace.
                    $ onWorkspace "d" (
                        borderResize
                        $ simpleFloat' shrinkText (def {decoWidth = 10000})
                    )
                      -- Music workspace.
                    $ onWorkspace "m" (
                      noBorders
                      $ Mirror
                      $ Tall 1 (5/100) (70/100)
                    )
                    $ (borderResize emptyBSP) ||| layoutHook def
    , handleEventHook = followOnlyIf (disableFollowOnWS ["d"])
    , startupHook = myStartupHook
    , logHook = dynamicLogWithPP $ polybarLogHook dbus
    , manageHook = manageSpawn <+> composeOne [
        isDialog -?> doFloat
      ]
} `additionalKeys` myKeys
