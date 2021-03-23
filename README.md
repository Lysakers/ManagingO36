# ManagingO36
Random functions and scripts for managing Office 365


### StudentsTeamsChat
A simple script that monitors the source group and compares it with an onboarding group.
When differences is found, it connect to SfB and changes the messaging policy for new or removed students, giving us an easy wat to enable and disable Teams chat on a per users basis.

### ADP
Sample code to manage address book policy in Exchange Online
- Functions.psm1 - The functions to get, set or update adress book policies rolled into a few simple cmdlets
- Run_original.ps1 - A few sample lines of how to run the cmdlets
- Tickle-EachObject.ps1 - Code to manually update all recipients in order to fill newly created or edited address book policies
- Tickle-Object-Automation.ps1 - Code to add as a scheduled task to update all recipients over a span of 12 hours. Task needs to trigger every hour for 12 hours.
