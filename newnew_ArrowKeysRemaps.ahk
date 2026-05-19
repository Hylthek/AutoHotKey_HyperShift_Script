#Requires AutoHotkey v2.0

global hyper_shift_key_pressed := false

RAlt::
{
  global hyper_shift_key_pressed
  hyper_shift_key_pressed := true
  EnableDisableHotkeyRemapper(hyper_shift_key_pressed)
  SendInput("{RAlt up}") ; For safety.
}
RAlt up::
{
  global hyper_shift_key_pressed
  hyper_shift_key_pressed := false
  EnableDisableHotkeyRemapper(hyper_shift_key_pressed)
  SendInput("{RAlt up}") ; For safety.
}

global remapper_input_keys := [ ; Place four keys per line for consistency.
  "*j", "*l", "*i", "*k",
  "*u", "*o", "*w", "*e",
  "*r", "*space", "*a", "*s",
  "*d", "*f"
] ; 1-indexed, fyi.

global remapper_output_keys := [ ; Place four keys per line for consistency.
  "{Left}", "{Right}", "{Up}", "{Down}",
  "{Home}", "{End}", "-", "{+}",
  "=", "_", "[", "]",
  "(", ")"
] ; 1-indexed, fyi.

; Function to set and toggle hotkeys.
EnableDisableHotkeyRemapper(enable_hotkeys) {
  global remapper_input_keys
  for key in remapper_input_keys
    try
      Hotkey(key, HotkeyRemapper, enable_hotkeys ? "On" : "Off")
    catch
      MsgBox("Error: Failed to set hotkey " key ". Exception thrown")
}

HotkeyRemapper(hotkey_pressed) {
  global hyper_shift_key_pressed
  global remapper_input_keys, remapper_output_keys

  ; Assert that hypershift key is pressed.
  if (!hyper_shift_key_pressed)
  {
    MsgBox("Error: hypershift variable unset despite remapping enabled. Disabling remapping")
    EnableDisableHotkeyRemapper(false)
    return
  }

  ; Get state of modifier keys.
  modifiers := ""
  if GetKeyState("Ctrl", "P") ; Check if Ctrl is pressed
    modifiers .= "^"
  if GetKeyState("Shift", "P") ; Check if Shift is pressed
    modifiers .= "+"
  if GetKeyState("LAlt", "P") ; Check if Left Alt is pressed
    modifiers .= "!"

  ; Remap keys
  key := ""
  for idx, input in remapper_input_keys
    if (hotkey_pressed = input) { ; Guaranteed, 1 statement will be true.
      key := remapper_output_keys[idx]
    }


  ; Send the key with modifiers
  Send modifiers key
}