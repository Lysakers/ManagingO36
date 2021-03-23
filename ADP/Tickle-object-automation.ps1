

$date = get-date -Format ddMMyyyy
$LogPath = "c:\templog\TickleLog\log$date.txt"

# Start Transcript.
if (-not (Test-Path $LogPath)) { 
    New-Item -ItemType File -Path $LogPath
}
Start-Transcript -Path $LogPath -Append

$cred = Get-StoredCredential -UserName account@tenant.onmicrosoft.com

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -Credential $cred 

$AllVisibleRecipients = Get-EXORecipient -filter 'HiddenFromAddressListsEnabled -eq $false' -ResultSize Unlimited

$DividedCount = [math]::Round(($AllVisibleRecipients.count)/12)+10
$selector = (get-date).hour
if ($selector -gt 12) { $selector = $selector-12 }
elseif ($selector -eq "0") {$selector = 12}

$RecipientsToTickle = $AllVisibleRecipients[(($DividedCount*$selector)-$DividedCount)..($DividedCount*$selector)]

$RecipientsToTickle | ForEach-Object {
    #$_
    if($_.RecipientTypeDetails -eq "Mailuser") {
        $_ | Set-MailUser -SimpleDisplayName "Temp"
        $_ | Set-MailUser -SimpleDisplayName $null
    } elseif($_.RecipientType -eq "MailContact") {
        $_ | Set-MailContact -SimpleDisplayName "Temp"
        $_ | Set-MailContact -SimpleDisplayName $null
    }
    elseif($_.RecipientTypeDetails -eq "MailUniversalSecurityGroup" -or $_.RecipientTypeDetails -eq "MailUniversalDistributionGroup") {
        $_ | Set-DistributionGroup -SimpleDisplayName "Temp"
        $_ | Set-DistributionGroup -SimpleDisplayName $null
    } else {
        $_ | Set-Mailbox -SimpleDisplayName "Temp"
        $_ | set-mailbox -SimpleDisplayName $null
    }
}
 
Stop-Transcript
