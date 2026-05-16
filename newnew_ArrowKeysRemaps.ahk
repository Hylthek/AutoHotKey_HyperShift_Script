#Requires AutoHotkey v2.0

global ralt_pressed := false

RAlt::
{
  global ralt_pressed
  ralt_pressed := true
  UpdateDynamicHotkeys(ralt_pressed)
  SendInput("{RAlt up}") ; For safety.
}
RAlt up::
{
  global ralt_pressed
  ralt_pressed := false
  UpdateDynamicHotkeys(ralt_pressed)
  SendInput("{RAlt up}") ; For safety.
}

global hotkey_inputs := [ ; Place four keys per line for consistency.
  "*j", "*l", "*i", "*k",
  "*u", "*o", "*w", "*e",
  "*r", "*space", "*a", "*s",
  "*d", "*f"
] ; 1-indexed, fyi.

global hotkey_outputs := [ ; Place four keys per line for consistency.
  "{Left}", "{Right}", "{Up}", "{Down}",
  "{Home}", "{End}", "-", "{+}",
  "=", "_", "[", "]",
  "(", ")"
] ; 1-indexed, fyi.

; Function to set and toggle hotkeys.
UpdateDynamicHotkeys(enable_hotkeys) {
  global hotkey_inputs
  for input in hotkey_inputs {
    try {
      Hotkey input, HotkeyRemapper, (enable_hotkeys ? "On" : "Off")
    }
    catch {
      MsgBox("Error: Failed to set hotkey " input ". Exception thrown")
      return
    }
  }
}

HotkeyRemapper(hotkey_pressed) {
  global ralt_pressed, hotkey_inputs, hotkey_outputs

  ; Safety check.
  if (!ralt_pressed)
  {
    MsgBox("Error: RAlt not pressed despite hotkey enabled. Disabling hotkeys")
    UpdateDynamicHotkeys(false)
    return
  }

  ; Get the state of modifier keys
  modifiers := ""
  if GetKeyState("Ctrl", "P") ; Check if Ctrl is pressed
    modifiers .= "^"
  if GetKeyState("Shift", "P") ; Check if Shift is pressed
    modifiers .= "+"
  if GetKeyState("LAlt", "P") ; Check if Alt is pressed
    modifiers .= "!"

  ; Remap keys
  key := ""
  for idx, input in hotkey_inputs
    if (hotkey_pressed = input)
      key := hotkey_outputs[idx]

  ; Send the key with modifiers
  Send modifiers key
  return
}