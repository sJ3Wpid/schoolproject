echo "Goodbye perverts :)"
while($true)
{
    $find =  tasklist | findstr "PCControl";
    if($find -eq $null)
    {
        Start-Sleep -Seconds 1;
    }
    else
    {
        taskkill /F /IM PCControl2ClientService.exe /T;
        taskkill /F /IM PCControl2ClientUser.exe /T;
        taskkill /F /IM PCControl2Client.exe /T;
    }
}
