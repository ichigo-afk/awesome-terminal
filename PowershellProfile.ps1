#region awesome-terminal
function Sync-AwesomeTerminal {
    $pwshProfileCloudPath = "https://raw.githubusercontent.com/ichigo-afk/awesome-terminal/master/PowershellCoreProfile.ps1"
    $powershellProfileCloudPath = "https://raw.githubusercontent.com/ichigo-afk/awesome-terminal/master/PowershellProfile.ps1"
    $wtProfileCloudPath = "https://raw.githubusercontent.com/ichigo-afk/awesome-terminal/master/WindowsTerminalProfile.json"

    #setting pwsh profile
    $pwshProfile = (iwr $pwshProfileCloudPath).Content
    $pwshProfileLocalPath = pwsh.exe -Command '(Get-Variable -Name PROFILE).Value'
    ReplaceAwesomeTerminalRegion -profileFilePath $pwshProfileLocalPath -newProfileObject $pwshProfile
    Write-Host "Synced pwsh profile"

    #setting powershell profile
    $powershellProfile = (iwr $powershellProfileCloudPath).Content
    $powershellProfileLocalPath = powershell.exe -Command '(Get-Variable -Name PROFILE).Value'
    ReplaceAwesomeTerminalRegion -profileFilePath $powershellProfileLocalPath -newProfileObject $powershellProfile
    Write-Host "Synced powershell profile"

    #setting windows terminal profile
    $wtProfile = (iwr $wtProfileCloudPath).Content
    $sh = New-Object -COM WScript.Shell
    $targetPath = $sh.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2019\Visual Studio Tools\Developer PowerShell for VS 2019.lnk")
    if($targetPath.Arguments -match "Enter-VsDevShell (.*)}"){
        $vsDevShellId = $Matches[1]
        $wtProfile = $wtProfile -replace "Enter-VsDevShell (.*);", "Enter-VsDevShell $vsDevShellId;"
    }
    
    $wtProfileLocalPath = "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json"
    Set-Content -Value $wtProfile -Path $wtProfileLocalPath
    Write-Host "Synced wt profile"

    #reload profile
    & $profile
}

function ReplaceAwesomeTerminalRegion{
    param($profileFilePath, $newProfileObject)
    $regexoptions = [System.Text.RegularExpressions.RegexOptions]::Multiline
    $pattern = [String]::Concat('\#region ' , 'awesome-terminal[\s\S]*?\#endregion ', 'awesome-terminal.*')
    $profileFile = Get-Content $profileFilePath -Raw
    $profileFile = [Regex]::Replace($profileFile, $pattern, $newProfileObject, $regexoptions)
    Set-Content -Value $profileFile -Path $profileFilePath
}

Set-Alias sync Sync-AwesomeTerminal
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

# PSReadLine Edits
Set-PSReadlineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Escape -Function RevertLine
Set-PSReadLineKeyHandler -Key Ctrl+c -Function CopyOrCancelLine
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Shift+Ctrl+LeftArrow -Function SelectBackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Shift+Ctrl+RightArrow -Function SelectForwardWord
Set-PSReadLineKeyHandler -Key Shift+Ctrl+RightArrow -Function SelectForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord
#endregion awesome-terminal