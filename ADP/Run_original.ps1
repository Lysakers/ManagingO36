
$l = @{
    rorikt = GetSetOrUpdate-AddressList -Name "Alle ansatte - ROR-IKT" -RecipientFilter "((RecipientTypeDetails -eq 'UserMailbox') -and (WindowsEmailAddress -like '*@ror-ikt.no'))" -Verbose
    alle = GetSetOrUpdate-AddressList -Name "Alle mottakere" -RecipientFilter "Alias -ne `$null" -Verbose

}

$gal = @{
   rorikt = GetSetOrUpdate-GlobalAddressList -Name "Global Address List - ROR-IKT" -RecipientFilter "((RecipientTypeDetails -eq 'UserMailbox') -and (WindowsEmailAddress -like '*@ror-ikt.no'))" -Verbose
}

$oab = @{
   rorikt = GetSetOrUpdate-OfflineAddressBook -Name "Offline Address Book - ROR-IKT" -AddressLists @($l.values.id + $gal.rorikt.id) -Verbose
}

GetSetOrUpdate-AddressBookPolicy -Name "ROR-IKT" -AddressLists $l.Values.id -RoomList "\All Rooms" -OfflineAddressBook $oab.rorikt.Id -GlobalAddressList $gal.rorikt.id -Verbose | Out-Null


# We need to "tickle" each object, or any new or updated address lists will not contain any recipients:
$recipients = Get-MailUser -ResultSize Unlimited
$recipients += get-mailbox -ResultSize Unlimited
$recipients += Get-DistributionGroup -ResultSize Unlimited

$recipients | Foreach {
    $_
    if($_.RecipientTypeDetails -eq "Mailuser") {
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
