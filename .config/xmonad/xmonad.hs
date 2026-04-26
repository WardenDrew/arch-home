import XMonad
import XMonad.Util.EZConfig
import System.Exit (exitSuccess)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import qualified XMonad.StackSet as SS
import XMonad.Layout.Minimize
import XMonad.Actions.Minimize
import qualified XMonad.Layout.BoringWindows as BW
import XMonad.Actions.WindowMenu
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.LimitWindows
import XMonad.Actions.RotSlaves

myTabConfig = def
  {
  activeColor = "#222255",
  inactiveColor = "#111111",
  urgentColor = "#CC0000",
  activeBorderColor = "#333333CC",
  inactiveBorderColor = "#222222",
  urgentBorderColor = "#FFFFFF",
  activeTextColor = "#6666FF",
  inactiveTextColor = "#888888",
  urgentTextColor = "FFFFFF"
  }

myLayout = avoidStruts (
  renamed [Replace "primary"] (spacingWithEdge 4 $ BW.boringWindows $ minimize $ limitWindows 3 $ normal) 
  ||| renamed [Replace "grid"] (spacingWithEdge 4 $ BW.boringWindows $ minimize $ limitWindows 9 $ Grid) 
  ||| renamed [Replace "tabbed"] (spacingWithEdge 4 $ BW.boringWindows $ minimize $ tabbedBottom shrinkText myTabConfig)
  ||| renamed [Replace "all"] (spacingWithEdge 4 $ Grid)
  ) where
    normal = Tall nmaster delta ratio
    nmaster = 1
    ratio = 2/3
    delta = 3/100

myRemoveKeys = 
  [
  "M-S-q",
  "M-q",
  "M-S-<Return>",
  "M-h",
  "M-j",
  "M-k",
  "M-l"
  ]

myStartupHook = do
  spawn "picom"
  spawn "feh --bg-scale ~/.config/wallpaper.jpg"

getActiveLayoutDescription :: X String
getActiveLayoutDescription = do
  workspaces <- gets windowset
  return $ description . SS.layout . SS.workspace . SS.current $ workspaces

myAddKeys = 
  [
  ("M-p", spawn "poweroff"),
  ("M-<Home>", io exitSuccess),
  ("M-<Escape>", kill),
  ("M-<Right>", do
    layout <- getActiveLayoutDescription
    case layout of
      "primary" -> BW.focusDown
      "grid" -> BW.focusDown
      "tabbed" -> BW.focusDown
      "all" -> windows SS.focusDown
      _ -> windows SS.focusDown
  ),
  ("M-<Left>", do
    layout <- getActiveLayoutDescription
    case layout of
      "primary" -> BW.focusUp
      "grid" -> BW.focusUp
      "tabbed" -> BW.focusUp
      "all" -> windows SS.focusUp
      _ -> windows SS.focusUp
  ),
  ("M-<Up>", do
    layout <- getActiveLayoutDescription
    case layout of
      "primary" -> rotAllDown
      "grid" -> rotAllDown
      "tabbed" -> BW.swapUp
      "all" -> windows SS.swapUp
      _ -> windows SS.swapUp
  ),
  ("M-<Down>", do
    layout <- getActiveLayoutDescription
    case layout of
      "primary" -> rotAllUp
      "grid" -> rotAllUp
      "tabbed" -> BW.swapDown
      "all" -> windows SS.swapDown
      _ -> windows SS.swapDown
  ),
  ("M-<Page_Down>", withFocused minimizeWindow),
  ("M-<Page_Up>", withLastMinimized maximizeWindowAndFocus),
  ("M-/", windowMenu),
  ("M-l", spawn "slock"),
  ("M-t", spawn "ghostty"),
  ("M-e", spawn "ghostty -e ranger"),
  ("M-w", spawn "firefox"),
  ("M-c", spawn "code"),
  ("M-r", spawn "rofi -show combi"),
  ("<Print>", spawn "screengrab"),
  ("M-<Tab>", do
    layout <- getActiveLayoutDescription
    case layout of
      "all" -> sendMessage $ JumpToLayout "primary"
      _ -> sendMessage $ JumpToLayout "all"
  ),
  ("M-<Space>", do
    layout <- getActiveLayoutDescription
    case layout of
      "primary" -> sendMessage $ JumpToLayout "grid"
      "grid" -> sendMessage $ JumpToLayout "tabbed"
      "tabbed" -> sendMessage $ JumpToLayout "primary"
      _ -> sendMessage $ JumpToLayout "primary"
  )
  ]

myConfig = def
  {
  modMask = mod4Mask,
  layoutHook = myLayout,
  terminal = "ghostty",
  startupHook = myStartupHook,
  focusedBorderColor = "#FF8100",
  normalBorderColor = "#333333",
  borderWidth = 2
  }
  `removeKeysP` myRemoveKeys
  `additionalKeysP` myAddKeys

main :: IO ()
main = xmonad $ ewmhFullscreen $ ewmh $ xmobarProp $ myConfig
