# awesome-terminal
Ichigo's awesome Terminal Hacks - Windows Edition!

## Powershell and Powershell Core Profiles 
> Now supports sync. Download the profiles once and setup, henceforth to update run sync
* To use the powershell profile, run the following:
 ```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

# If in powershell core, run the below command
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

# Open the powershell profile, prompts creation if not created
notepad $PROFILE
```
*  Adding Functions and setting aliases for easy access
```powershell
function Start-DataBoxAgent {
    powershell.exe -noexit -Command "cd D:\Work\1b\DataBox\Agent;.\init.ps1"
}
Set-Alias agent Start-DataBoxAgent
```

* Set edit mode to UNIX style (lists instead of completing)
```powershell
Set-PSReadlineOption -EditMode Emacs
```

* Install posh-git and oh-my-posh for GIT styling. Setting Paradox theme, try out other ones too. Super fun!. Read more [here](https://github.com/JanDeDobbeleer/oh-my-posh)
```powershell
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox
```

## Windows Terminal Profile
* Install Windows terminal from Microsoft Store
* Hit Ctrl + , to open the profile json
* Paste in the contents of the _MicrosoftTerminalProfile.ps1_
* Add/Edit the profiles tab to accomadate specifics like icon, background color etc.


##  Ichigo-Sama Gotchas
* The __Oh-My-Posh__ uses power line symbols which might show weird glyphs if fonts aren't instaled. I use the CascadiaCode Nerd Font from [here](https://github.com/AaronFriel/nerd-fonts/releases) that combines the windows terminal default _Cascadia Code_ and PowerLine symbols
* Creating a shortcut for windows terminal with admin mode enabled.
* Use: `C:\Windows\System32\cmd.exe /c start /b wt`(This has an issue since /b in cmd disallows Ctrl+C or break to be run on the child process)
* Recommended: Use `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Start-Process shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App -Verb RunAs"`

