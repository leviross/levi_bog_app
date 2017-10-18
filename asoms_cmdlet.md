---
pageTitle: 'ACOM Automation PowerShell Cmdlets Overview'
description: 'Provides an overview of the PowerShell Automation cmdlets used by the ACOM Engineering team'
audience: 'engineering'
contentStatus: 'draft'
---

# ACOM Automation PowerShell Module

The ACOM Automation PowerShell module is designed to automate several of the common tasks performed by the ACOM engineering team for managing the azure.microsoft.com website.  This article explains how to install the module, defines the commands included in the module, and provides common troubleshooting recommendations.

## ACOM Automation Commands

The following commands are currently provided by the ACOM Automation module.  

### Module Configuration
| Command | Description |
|---------|--------|
| Get-AutomationConfiguration | Creates a config.json file that holds most of the settings required by the rest of the Cmdlets in the module. |

### Projects Database
| Command | Description |  |
|---------|--------|--------|
| Get-OnyxProjects | Get the Onyx projects entities used to configure the automation subsystems. | [more details](devops-projects-metadata.md) | |
Show-OnyxProject

### Key Vault
| Command | Description |  |
|---------|--------|--------|
| Get-KeyVaultSecrets| List all secrets properties in a given vault (actual secrets values are not available) | [more details](workitems-automation-module-command-get-keyvaultsecrets.md)
| Set-KeyVaultSecrets| Set all secrets specified in a file | [more details](workitems-automation-module-command-set-keyvaultsecrets.md) 
| Get-KeyVaultSecret | Get the value of a specific secret | [more details](workitems-automation-module-command-get-keyvaultsecret.md)
| Set-KeyVaultSecret | Set the value of a specific secret (upload a file such as a cert is supported) | [more details](workitems-automation-module-command-set-keyvaultsecret.md)

### Release Emails generation
| Command | Description |  |
|---------|--------|--------|
| Get-ReleaseUpdateEmail | Generates an email to provide stakeholders with an update on the tasks completed since the last release. | [more details](workitems-automation-module-command-get-releaseupdateemail.md) 
| Get-ShiproomEmail | Generates an email for the weekly shiproom discussion with ACOM stakeholders. | |

### Release Workflow
| Command | Description |  |
|---------|--------|--------|
| Set-ReleaseWorkflowProject | Configures a repository to integrate it in the realease workflow. | [more details](workitems-automation-module-command-set-releaseworkflowproject.md) |
| Set-ReleaseWorkflowUser |  Register a user mapping between GitHub and Jira. | [more details](workitems-automation-module-commands-releaseworkflowuser.md) |
| Find-ReleaseWorkflowUser | Search for a user mapping. | [more details](workitems-automation-module-commands-releaseworkflowuser.md) |
| Remove-ReleaseWorkflowUser | Remove a user mapping. | [more details](workitems-automation-module-commands-releaseworkflowuser.md) |

### VSO Release Workflow (deprecated)
| Command | Description |  |
|---------|--------|--------|
| Set-VSOWorkItemType | Used to change a work item from one type to another. For example, can be used to change a bug to a backlog item. |  | 
| Set-VSOWorkItemIteration | Moves work items from one iteration to another. |   [more details](workitems-automation-module-command-set-vsoworkitemiteration.md)| 
| Set-VSOOrphanedWorkItems | Changes the state for backlog items to be "Done" if all of the child tasks are done or removed. |  [more details](workitems-automation-module-command-set-vsoorphanworkitems.md) | 
| Set-VsoTeamQueries | Creates queries for the list of team members that are passed in the parameter based on the template queries. |  [more details](workitems-automation-module-command-set-vsoteamqueries.md) | 

### Merge Workflow
| Command | Description |
|---------|--------|
| Set-MergeWorkflowRepository | Configures a repository to integrate it in the merge workflow |

### Localization Services
| Command | Description |
|---------|--------|
| Set-LocServicesWebhook | Configures a repository to integrate it with the Localization services. |

### Prioritization
| Command | Description |  |
|---------|--------|--------|
| Set-IssuesRanking | Automatically update the ranking of Jira issues based on a ranking policy file | [more details](process-auto-ranking.md) |

### Resource management
| Command | Description |
|---------|--------|
| Get-BranchesReport | Generate a spreadheet with the status of the branches of a given repository. |

### Github
| Command | Description |  |
|---------|--------|--------|
| Set-GitHubSyncWebhook | Configures a repository to integrate it in the GitHub sync workflow | [more details](workitems-automation-module-command-set-githubsyncwebhook.md)

To get help information for each command, just use the PowerShell built-in get-help command.  For example:  ````get-help get-releaseupdateemail -full````  See the above links for individual commands for more information.  


## Installing the module
In order to use the ACOM Automation module for the first time you will need to install them through a nuget feed.  

1. Open a Windows PowerShell console.  NOTE:  You should not use admin mode with the ACOM Automation Module. 

1. Change to the directory where you want to install the modules, save configurations, and generate the emails. It is recommended to create a directory at the root for ACOM such as c:\ACOM.

  ````
  cd c:\ACOM
  ````
  
1. Register the Nuget feed that contains the Automation PowerShell modules. 

  ````
  Register-PSRepository -Name ACOM -SourceLocation https://www.myget.org/F/acomtools/auth/119b9e68-afb9-4ffe-b1dd-ddf2231ac323/api/v2 -PublishLocation https://www.myget.org/F/acomtools/auth/119b9e68-afb9-4ffe-b1dd-ddf2231ac323/api/v2/package -InstallationPolicy Trusted
  ````

1. Install the Automation module by running the following command:

  ````
  Install-Module -Name AutomationCmdlets -Repository ACOM -Scope CurrentUser
  ````
  **IMPORTANT**: Please make sure to restart your PowerShell console after the install.
  
## Configuring the ACOM Automation Module
In order to use the commands provided by the ACOM Automation Module, you must first define a configuration file with settings that are common to the commands.  This is a one time operation.

1. Create a directory to store settings and output from the ACOM Automation commmands.  It is recommended to create this directory as c:\acom.

2. It is recommended that you obtain this file from [here](https://github.com/Azure/acom-tools/blob/master/code/AutomationCmdlets/AcomAutomation.Cmdlets/config.json).  However, you can create this file by using the commmand Get-AutomationConfiguration.  For example:

  ````
  Get-AutomationConfiguration -JiraPassword [jirapass] -DocumentDbKey [docdbkey] -OutputPath C:\ACOM
  ````
  NOTE: The cmdlets can also resolve to secrets from KeyVault at runtime. 
  To resolve the secrets from keyvault the input must match the placeholder: `#{keyvault:VaultName:VaultKey}`
  
   - VaultName: Name of the vault from which to retrieve the secret
   - VaultKey: Name of the key used to access the secret in the vault
  
  If KeyVault placeholders are found, running the cmdlets will show a popup prompting for the user's credentials. The credentials are used to autenticate against KeyVault and for retrieving the secrets (users need to have access to all the referenced vaults).

  **IMPORTANT**: Please make sure to restart your PowerShell console after any change in the configuration file.

**Get-AutomationConfiguration cmdlet mandatory secret parameters**

|**Parameter Name**        |**Description**                                                                                    |**Vault**    |**Key**                                     |**Used by**                                                          |**Used for**                                                                                                          |
|--------------------------|---------------------------------------------------------------------------------------------------|-------------|--------------------------------------------|---------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
|JiraPassword              |Jira Password corresponding to the _Jira User_ passed as parameter or through configuration.       |onyxb-primary|jira-acomjiraint-user                       |Get-ReleaseUpdateEmail, Set-ReleaseWorkflowProject, Set-IssuesRanking|Retrieving information from jira                                                                                      |
|DocumentDbKey             |DocumentDb Key corresponding to the _DocumentDb Host_ passed as parameter or through configuration |onyxb-primary|onyxb-production-services-docdb-onyxb-westus|Get-ReleaseUpdateEmail, ReleaseWorkflow cmdlets                      |Retrieving and storing information from/to the projects database                                                      |

  **Cmdlet mandatory secret parameters**

|**Cmdlet**                     |**Parameter Name**         |**Description**                                                                              |**Used for**                                                       |
|-------------------------------|---------------------------|---------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
|Set-LocServicesWebHooks        |AccessToken                |GitHub access token for the source repo                                                      |Configuring the webhooks on the source repo                        |
|Set-LocServicesWebHooks        |LocAccessToken             |GitHub access token for the localization repo                                                |Configuring the webhooks on the localization repo                  |
|Set-LocServicesWebHooks        |WebHookSecret              |GitHub webhook secret                                                                        |Configuring the webhook secret on the source and localization repos|
|Set-MergeWorkflowWebhooksSecret|MergeWorkflowWebhooksSecret|GitHub webhook secret                                                                        |Configuring the webhook secret for the merge workflow              |
|Set-MergeWorkflowWebhooksSecret|SetupAccessTokens          |Comma separated list of GitHub access tokens that have admin access in the repository        |Used to create the webhook in GitHub                               |
|Set-MergeWorkflowWebhooksSecret|AccessTokens               |Comma separated list of GitHub access tokens                                                 |Used to configure the project in DocumentDB                        |  
|Set-ReleaseWorkflowProject     |MergeWorkflowWebhooksSecret|GitHub webhook secret                                                                        |Configuring the webhook secret for the merge workflow              |
|Set-ReleaseWorkflowProject     |SetupAccessTokens          |Comma separated list of GitHub access tokens that have admin access in the repository        |Used to create the webhook in GitHub                               |
|Set-ReleaseWorkflowProject     |AccessTokens               |Comma separated list of GitHub access tokens                                                 |Used to configure the project in DocumentDB                        |  

## Using the ACOM Automation Module

Once you have the Automation Module installed, you can use any of the above commands.  For example, the following steps explain how to use the Get-ReleaseUpdateEmail command to generate a daily release status email.  The release update email contains information about the tasks that were completed since the last release.  

1. Open a PowerShell console. NOTE: You should not use admin mode.

1. Verify that you have the latest version of the ACOM Automation Modules installed and update the modules if there are newer versions.

  ````
  Update-Module AutomationCmdlets -verbose
  ````
  
  **IMPORTANT**: Please make sure to restart your PowerShell console after the update.

1. Change directory to the location where you have the config.json stored, which is likely c:\acom

  ````
  cd c:\ACOM
  ````
  
  NOTE:  If you do not have a config.json file located in the current path, the you must pass in the path to the configuration file when executing most of the commands.  

1. Generate the release update email by running the following command:

  ````
  Get-OnyxProjects -Id ACOM | Get-ReleaseUpdateEmail
  ````

- By default the Cmdlet shows the Jira issues that are currently in the **In Staging** status. This means the Cmdlet should be run after the staging deployment has been performed. Alternatively, you can set the `UseCommitDiffForReleaseItems` parameter to generate the email based on the commits comparison between `master` and the latest production deployment tag (e.g `staging-deployment-1234`)..

  ````
  Get-OnyxProjects -Id ACOM | Get-ReleaseUpdateEmail -BaseBranch staging-deployment-1419 -HeadBranch staging-deployment-1420
  ````

## Useful commands
The following section defines some useful commands that maybe needed when using the ACOM Automation Module. 

### Capturing detailed error information
If you get an exception, please run the following line to see more details:

  ````
  $Error | Format-List * -Force
  ````
  
  
### Check the version of the installed ACOM Automation Module
To check the cmdlets installed version  

  ````
  Get-InstalledModule -Name AutomationCmdlets
  ````

### See available versions of the ACOM Automation Module
To see all the available versions within the feed

  ````
  Find-Package -Name AutomationCmdlets –AllVersions
  ````
  
### Clean-up your installed versions
To clean-up your environment, uninstall the module and install it again.

  ````
  Uninstall-Module -Name AutomationCmdlets -Force
  ````
  NOTE:  The module is successfully uninstalled, nonetheless you will see an exception saying that "The property 'ModuleBase' cannot be found on this object".
