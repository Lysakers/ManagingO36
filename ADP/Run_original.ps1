
$l = @{
    contoso = GetSetOrUpdate-AddressList -Name "Alle ansatte - contoso" -RecipientFilter "((RecipientTypeDetails -eq 'UserMailbox') -and (WindowsEmailAddress -like '*@contoso.no'))" -Verbose
    alle = GetSetOrUpdate-AddressList -Name "Alle mottakere" -RecipientFilter "Alias -ne `$null" -Verbose

}

$gal = @{
   contoso = GetSetOrUpdate-GlobalAddressList -Name "Global Address List - contoso" -RecipientFilter "((RecipientTypeDetails -eq 'UserMailbox') -and (WindowsEmailAddress -like '*@contoso.no'))" -Verbose
}

$oab = @{
   contoso = GetSetOrUpdate-OfflineAddressBook -Name "Offline Address Book - contoso" -AddressLists @($l.values.id + $gal.contoso.id) -Verbose
}

GetSetOrUpdate-AddressBookPolicy -Name "contoso" -AddressLists $l.Values.id -RoomList "\All Rooms" -OfflineAddressBook $oab.contoso.Id -GlobalAddressList $gal.contoso.id -Verbose | Out-Null


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
