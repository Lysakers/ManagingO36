
function Get-AllObjects {
    Write-Progress -Activity "Getting all mailusers" -Status "Operation 1 / 3" -PercentComplete "0"
    $recipients = Get-MailUser -ResultSize Unlimited
    Write-Progress -Activity "Getting all mailboxes" -Status "Operation 2 / 3" -PercentComplete "33"
    $recipients += get-mailbox -ResultSize Unlimited
    Write-Progress -Activity "Getting all distributiongroups" -Status "Operation 3 / 3" -PercentComplete "66"
    $recipients += Get-DistributionGroup -ResultSize Unlimited -filter 'hiddenFromAddressListsEnabled -ne $true'

    Write-Output $recipients
}

function Tickle-EachObject {

    param (
        [Parameter()]
        $recipients
    )

    if ($recipients -eq $null) {$recipients = Get-AllObjects}

    $x=0
    $xtotal=($recipients.count)

    $recipients | Foreach {
        $x++
        Write-Progress -Activity "Tickle each object" -Status "$($_.RecipientTypeDetails): $($_.Name) ($x/$xtotal)" -PercentComplete ($x/$xtotal*100)
        if ($_.RecipientTypeDetails -eq "GuestMailUser") { }
        elseif($_.RecipientTypeDetails -eq "Mailuser") {
            $_ | Set-MailUser -SimpleDisplayName "Temp"
            $_ | Set-MailUser -SimpleDisplayName $null
        } elseif($_.RecipientTypeDetails -eq "MailUniversalSecurityGroup") {
            $_ | Set-DistributionGroup -SimpleDisplayName "Temp"
            $_ | Set-DistributionGroup -SimpleDisplayName $null
        } else {
            $_ | Set-Mailbox -SimpleDisplayName "Temp"
            $_ | set-mailbox -SimpleDisplayName $null
        }
    }
}
