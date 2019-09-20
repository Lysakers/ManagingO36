<#	
	.NOTES
	===========================================================================
	 Created with: 	VsCode
	 Created on:   	24.05.2019
	 Created by:   	Steffen.Lysaker
	 Filename:     	StudensTeamChat
	 Version:		1.1
	===========================================================================
	.DESCRIPTION
		
#>

#Requires -Modules SkypeOnlineConnector

###Env variables
###Remember to make changes so this matches your environment
$SourceGroup = "GROUPNAME"
$OnboradingGroup = "GROUPNAME_ONBOARDING"
$credentials = Get-Credential
###Name of messaging policys in MS Teams
$Edu_StudentsMute = "EduStudents_Mute"
$Edu_StudentsDefault = "EduStudents_Custom"


#Geting users
$DeactiveChatUsers = get-adgroupmember -identity $SourceGroup
$OnboardedUsers = get-adgroupmember -identity $OnboradingGroup

#Look for changes
if (!($DeactiveChatUsers)) {$DeactiveChatUsers =  "Empty"}
if (!($OnboardedUsers)) {$OnboardedUsers = "Empty"}
$equal = @(Compare-Object $DeactiveChatUsers $OnboardedUsers -SyncWindow 0).Length -eq 0

if ($equal -eq $false) {

	Write-host "Connecting to Skype"
        $sfbSession = New-CsOnlineSession -Credential $credentials
        Import-PSSession $sfbSession
}
else {
	Write-host "No changes, ending script"
	break
}

# Calculating users to change

$StudentsToMute = $DeactiveChatUsers.samaccountname | Where-Object {$OnboardedUsers.samaccountname -notcontains $psitem}
if ($StudentsToMute) { $StudentsToMute = $StudentsToMute | get-aduser }
$StudentsToUnmute = $OnboardedUsers.samaccountname | Where-Object {$DeactiveChatUsers.samaccountname -notcontains $psitem}
if ($StudentsToUnmute) { $StudentsToUnmute = $StudentsToUnmute | get-aduser }

# Processing changes to be made

if ($StudentsToMute){
    foreach ($student in $StudentsToMute){
		Write-host "Student $($student.userprincipalname) been added to policy"
		Grant-CsTeamsMessagingPolicy -Identity $student.UserPrincipalName -PolicyName $Edu_StudentsMute
		Grant-CsTeamsCallingPolicy -Identity $student.UserPrincipalName -PolicyName $Edu_StudentsMute
		Add-ADGroupMember -Identity $OnboradingGroup -Members $student.sAMAccountName
    }
}

if ($StudentsToUnmute) {
    foreach ($student in $StudentsToUnmute){
		Write-host "Student $($student.userprincipalname) been removed from policy"
		Grant-CsTeamsMessagingPolicy -Identity $student.UserPrincipalName -PolicyName $Edu_StudentsDefault
		Grant-CsTeamsCallingPolicy -Identity $student.UserPrincipalName -PolicyName $Edu_StudentsMute
		Remove-ADgroupmember -identity $OnboradingGroup -Members $student.sAMAccountName -Confirm:$false
    }
}