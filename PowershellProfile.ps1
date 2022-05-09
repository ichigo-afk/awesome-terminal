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
    $wtProfileLocalPath = "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Set-Content -Value $wtProfile -Path $wtProfileLocalPath
    Write-Host "Synced wt profile"

    #reload profile
    & $profile
}

function ConvertTo-DeveloperPrompt
{
    param([switch]$UseVSPreview)
    pushd

    Write-Host "Initializing Visual Studio Command Prompt Environment ..."
    $vswhere = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
    
    # See https://aka.ms/vs/workloads for a list of product IDs.
    $communityProductId = "Microsoft.VisualStudio.Product.Community"
    $enterpriseProductId = "Microsoft.VisualStudio.Product.Enterprise"
    $productId = $enterpriseProductId # or find a way to switch based on installation.
    $productVersionRange = "[16,18)" 

    if ($UseVSPreview){
        $instanceId = & $vswhere -prerelease -version $productVersionRange -property instanceId -products $productId -latest
        $installationPath = & $vswhere -prerelease -version $productVersionRange -property installationPath -products $productId -latest
    }
    else{
        $instanceId = & $vswhere -version $productVersionRange -property instanceId -products $productId -latest
        $installationPath = & $vswhere -version $productVersionRange -property installationPath -products $productId -latest
    }

    if ([string]::IsNullOrEmpty($instanceId)) {
        Write-Host "Couldn't find the VS2019/VS2022 Enterprise edition. Finding any installed VS2019/VS2022 edition."

        if ($UseVSPreview){
            $instanceId = & $vswhere -prerelease -version $productVersionRange -property instanceId -latest
            $installationPath = & $vswhere -prerelease -version $productVersionRange -property installationPath -latest
        }
        else{
            $instanceId = & $vswhere -version $productVersionRange -property instanceId -latest
            $installationPath = & $vswhere -version $productVersionRange -property installationPath -latest
        }
    }
    
    if ([string]::IsNullOrEmpty($instanceId)) {
        throw "Visual Studio 2019/2022 is not properly installed. Visit https://visualstudio.microsoft.com/ to download and install Visual Studio."
    }

    # Write-Host "Detected visual studio installation path = $installationPath and instanceId = $instanceId"

    Import-Module -Name "$installationPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell -VsInstanceId $instanceId -StartInPath $PSScriptRoot

    popd
}
function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
                ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

function ReplaceAwesomeTerminalRegion{
    param($profileFilePath, $newProfileObject)
    $regexoptions = [System.Text.RegularExpressions.RegexOptions]::Multiline
    $pattern = [String]::Concat('\#region ' , 'awesome-terminal[\s|.|\S]*?\#endregion ', 'awesome-terminal.*')
    $profileFile = Get-Content $profileFilePath -Raw
    $profileFile = [Regex]::Replace($profileFile, $pattern, $newProfileObject, $regexoptions)
    Set-Content -Value $profileFile -Path $profileFilePath
}

$env:POSH_GIT_ENABLED = $true
$env:POSHGIT_CYGWIN_WARNING = $true
Set-Alias sync Sync-AwesomeTerminal
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme "D:\Work\awesome-terminal\ichigo-bubbles-theme.json"
git config --global push.default current
$GitPromptSettings.AnsiConsole = $true

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