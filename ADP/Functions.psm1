function GetSetOrUpdate-AddressList
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [AllowEmptyString()]
        [String] $RecipientFilter,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [String] $Name
    )

    Process
    {
        $_AddressList
        $_AddressList = Get-AddressList -Identity $Name -ErrorAction SilentlyContinue
        if($_AddressList) {
            if($RecipientFilter -cne $_AddressList.RecipientFilter) {
                Write-Verbose "Updating recipient filter for AddressList $Name"
                Write-Verbose " - old value: $($_AddressList.RecipientFilter)"
                Write-Verbose " - new value: $($RecipientFilter)"
                Set-AddressList -RecipientFilter $RecipientFilter -Identity $Name
                return Get-AddressList -Identity $Name
            } else {
                return $_AddressList
            }
        } else {
            Write-Verbose "Creating AddressList $Name"
            return New-AddressList -RecipientFilter $RecipientFilter -DisplayName $Name -Name $Name
        }
    }
}


function GetSetOrUpdate-GlobalAddressList
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [AllowEmptyString()]
        [String] $RecipientFilter,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [String] $Name
    )

    Process
    {
        $_AddressList = $null
        $_AddressList = Get-GlobalAddressList -Identity $Name -ErrorAction SilentlyContinue
        if($_AddressList) {
            if($RecipientFilter -cne $_AddressList.RecipientFilter) {
                Write-Verbose "Updating recipient filter for GlobalAddressList $Name"
                Write-Verbose " - old value: $($_AddressList.RecipientFilter)"
                Write-Verbose " - new value: $($RecipientFilter)"
                Set-GlobalAddressList -RecipientFilter $RecipientFilter -Identity $Name
                return Get-GlobalAddressList -Identity $Name
            } else {
                return $_AddressList
            }
        } else {
            Write-Verbose "Creating GlobalAddressList $Name"
            return New-GlobalAddressList -RecipientFilter $RecipientFilter -Name $Name
        }
    }
}


function GetSetOrUpdate-OfflineAddressBook
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [AllowEmptyString()]
        [String[]] $AddressLists,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [String] $Name
    )

    Process
    {
        $_OAB = $null
        $_OAB = Get-OfflineAddressBook -Identity $Name -ErrorAction SilentlyContinue
        if($_OAB) {
            if(($AddressLists | Where{$_ -notin $_OAB.AddressLists}) -or ($_OAB.AddressLists | Where{$_ -notin $AddressLists})) {
                Write-Verbose "Updating AddressLists for OfflineAddressBook $Name"
                Write-Verbose " - old value: $($_OAB.AddressLists)"
                Write-Verbose " - new value: $($AddressLists)"
                Set-OfflineAddressBook -Identity $Name -AddressLists $AddressLists
                return Get-OfflineAddressBook -Identity $Name
            } else {
                return $_OAB
            }
        } else {
            Write-Verbose "Creating OfflineAddressBook $Name"
            return New-OfflineAddressBook -Name $Name -AddressLists $AddressLists
        }
    }
}



function GetSetOrUpdate-AddressBookPolicy
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [AllowEmptyString()]
        [String[]] $AddressLists,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [String] $Name,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [AllowEmptyString()]
        [String] $RoomList,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        [AllowEmptyString()]
        [String] $OfflineAddressBook,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=4)]
        [AllowEmptyString()]
        [String] $GlobalAddressList
    )

    Process
    {
        $_ABP = $null
        $_ABP = Get-AddressBookPolicy -Identity $Name -ErrorAction SilentlyContinue
        if($_ABP) {
            if(($AddressLists | Where{$_ -notin $_ABP.AddressLists}) -or ($_ABP.AddressLists | Where{$_ -notin $AddressLists})) {
                Write-Verbose "Updating AddressLists for AddressBookPolicy $Name"
                Write-Verbose " - old value: $($_ABP.AddressLists)"
                Write-Verbose " - new value: $($AddressLists)"
                Set-AddressBookPolicy -Identity $Name -AddressLists $AddressLists
            }

            if($RoomList -cne $_ABP.RoomList) {
                Write-Verbose "Updating RoomList for AddressBookPolicy $Name"
                Write-Verbose " - old value: $($_ABP.RoomList)"
                Write-Verbose " - new value: $($RoomList)"
                Set-AddressBookPolicy -Identity $Name -RoomList $RoomList
            }

            if($GlobalAddressList -cne $_ABP.GlobalAddressList) {
                Write-Verbose "Updating GlobalAddressList for AddressBookPolicy $Name"
                Write-Verbose " - old value: $($_ABP.GlobalAddressList)"
                Write-Verbose " - new value: $($GlobalAddressList)"
                Set-AddressBookPolicy -Identity $Name -GlobalAddressList $GlobalAddressList
            }

            if($OfflineAddressBook -cne $_ABP.OfflineAddressBook) {
                Write-Verbose "Updating OfflineAddressBook for AddressBookPolicy $Name"
                Write-Verbose " - old value: $($_ABP.OfflineAddressBook)"
                Write-Verbose " - new value: $($OfflineAddressBook)"
                Set-AddressBookPolicy -Identity $Name -OfflineAddressBook $OfflineAddressBook
            }

            return (Get-AddressBookPolicy -Identity $Name)
        } else {
            Write-Verbose "Creating AddressBookPolicy $Name"
            return New-AddressBookPolicy -Name $Name -AddressLists $AddressLists -RoomList $RoomList -GlobalAddressList $GlobalAddressList -OfflineAddressBook $OfflineAddressBook
        }
    }
}