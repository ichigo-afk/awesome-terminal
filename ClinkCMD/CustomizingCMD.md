# Customizing CMD prompt
CMD prompt is super-old school and doesn't have most of the modern day terminal features like autocomplete, syntax highlighting, in-line editors etc.
Trying to address some of these to make CMD usable for those of us who have experienced the dark-side ^^

## Install Clink
Clink is a super cool way to bring bash-like functionalities into CMD, with options to easily add `.lua` scripts for extensibility. 
- [Documentation for clink](https://chrisant996.github.io/clink/clink.html)
- [Releases for clink](https://github.com/chrisant996/clink/releases)
```powershell
winget install clink
```

## Install oh-my-posh
`oh-my-posh` is simply my favourite prompt customizer of all time. It has several beautiful themes and when combined with `posh-git` has almost all the functionalities I'd expect from a terminal.
oh-my-posh is now installed as a standalone executable using the command:
 ```powershell
winget install JanDeDobbeleer.OhMyPosh
```

just in case it was previously installed as a PS module, uninstall it prior to installing:
 ```powershell
Uninstall-Module oh-my-posh -AllVersions
```

## Configuring Clink with oh-my-posh
Simply copy the `.lua` scripts present in this folder to where clink scripts are present. (Run `clink info` to check the the scripts location).

### Additional configurations:
- Added a doskey aliases `cmd_doskey_aliases.lua` which adds basic common muscle-memory command translations like `ls`, `clear`, `cd without /d` etc to CMD. (Remember to change the path to .txt file)
- add a `--quiet` flag to _x86.exe and _64.exe in `clink.bat` (typically present here: C:\Program Files (x86)\clink\clink.bat") file to supress copyright header on every prompt. 