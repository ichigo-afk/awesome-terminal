function Start-EdgeGateway {
    powershell.exe -noexit -Command "cd D:\Work\1b\Edge\Gateway;.\init.ps1"
}

function Start-Helsinki {
    powershell.exe -noexit -Command "cd D:\Work\1b\StorSimple\Service;.\init.ps1"
}

function Start-Garda {
    powershell.exe -noexit -Command "cd D:\Work\1b\StorSimple\GService;.\init.ps1"
}

function Start-StorSimpleComponents {
    powershell.exe -noexit -Command "cd D:\Work\1b\StorSimple\Components;.\init.ps1"
}

function Start-DataBoxAgent {
    powershell.exe -noexit -Command "cd D:\Work\1b\DataBox\Agent;.\init.ps1"
}

Set-Alias edge Start-EdgeGateway
Set-Alias helsinki Start-Helsinki
Set-Alias garda Start-Garda
Set-Alias components Start-StorSimpleComponents
Set-Alias agent Start-DataBoxAgent
Set-PSReadlineOption -EditMode Emacs
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox