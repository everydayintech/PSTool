$ToolBeltJson = @'
[
    {
        "name":  "Open IMELog with CMTrace",
        "description":  "Download CMTrace to temp directory and open IntuneManagementExtension Log",
        "keywords":  [
                         "cmtrace",
                         "log",
                         "logs",
                         "intune",
                         "ime"
                     ],
        "id":  "imelog",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/Intune/Invoke-CMTraceIMELog.ps1",
        "newProcess": false
    },
    {
        "name":  "Run CMTrace",
        "description":  "Download CMTrace to temp directory and run it",
        "keywords":  [
                         "cmtrace",
                         "log",
                         "logs"
                     ],
        "id":  "cmt",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/Intune/Get-CMTrace.ps1",
        "newProcess": false
    },
    {
        "name":  "Run HP Image Assistant",
        "description":  "Download HP Image Assistant to temp directory and run it",
        "keywords":  [
                         "hp",
                         "image",
                         "assistant",
                         "drivers",
                         "driver",
                         "update",
                         "treiber"
                     ],
        "id":  "hpia",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/HP/Invoke-HPImageAssistant.ps1",
        "newProcess": false
    },
    {
        "name":  "Logoff and remove LastLoggedOnUser from Registry",
        "description":  "Logoff from a PC as if you have never been there.",
        "keywords":  [
                         "logout"
                     ],
        "id":  "logoff",
        "script":  "https://gist.githubusercontent.com/everydayintech/d2762560d3b24c06f14143778cc25de4/raw/6293e8604de710725f6ee6000bc2c6f894ee1b82/logoff.ps1",
        "newProcess": false
    },
    {
        "name":  "Uninstall Microsoft ConfigMgr Agent",
        "description":  "Uninstalles the Microsoft ConfigMgr (aka SCCM) Agent and opens the uninstall Log with CMTrace.",
        "keywords":  [
                         "ccmagent",
                         "uninstall",
                         "sccm"
                     ],
        "id":  "rcm",
        "script":  "https://gist.githubusercontent.com/everydayintech/45fe66b0ee59f58f9aa0a5ec0b655e3d/raw/346d57029d6c563aac2878650de66ce47aa1e468/Remove%2520CCMAgent.ps1",
        "newProcess": false
    },
    {
        "name":  "Run Process Explorer",
        "description":  "Download Process Explorer to temp directory and run it",
        "keywords":  [
                         "procexp",
                         "process",
                         "taskmanager",
                         "task",
                         "sysinternals"
                     ],
        "id":  "pe",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/Tools/Get-ProcExp.ps1",
        "newProcess": false
    },
    {
        "name":  "Run Process Monitor",
        "description":  "Download Process Monitor to temp directory and run it",
        "keywords":  [
                         "procmon",
                         "process",
                         "sysinternals"
                     ],
        "id":  "pm",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/Tools/Get-ProcMon.ps1",
        "newProcess": false
    },
    {
        "name":  "Run WinDirStat",
        "description":  "Download WinDirStat Portable to temp directory and run it",
        "keywords":  [
                         "disk",
                         "diskspace",
                         "clean",
                         "windirstat",
                         "stat"
                     ],
        "id":  "wds",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/refs/heads/main/Tools/Invoke-DownloadExpandRun.ps1?https%3a%2f%2fgithub.com%2fwindirstat%2fwindirstat%2freleases%2fdownload%2frelease%2fv2.2.2%2fWinDirStat.zip%26WinDirStat.zip%268161876730EB80E56B34331BDA633DB83E44AEC9897713A48713633CD6D672E5%26True%26WinDirStatPortable%26x64%2fWinDirStat.exe#",
        "newProcess": true
    },
    {
        "name":  "Run Rufus",
        "description":  "Download Rufus Portable to temp directory and run it",
        "keywords":  [
                         "disk",
                         "usb",
                         "iso",
                         "burn",
                         "boot",
                         "windows",
                         "linux"
                     ],
        "id":  "ruf",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/refs/heads/main/Tools/Invoke-DownloadExpandRun.ps1?https%3a%2f%2fgithub.com%2fpbatard%2frufus%2freleases%2fdownload%2fv4.11%2frufus-4.11p.exe%26rufus-4.11p.exe%26ABBF04D50A44A9612C027FC8072F6DA67F5BCDA2B826F1F852C9C24D7A1FCDFF%26False%26%26rufus-4.11p.exe#",
        "newProcess": true
    },
    {
        "name":  "Run TeamViewer QS",
        "description":  "Download TeamViewer QS to temp directory and run it",
        "keywords":  [
                         "remote",
                         "control"
                     ],
        "id":  "tvq",
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/refs/heads/main/Tools/Get-TeamViewerQS.ps1",
        "newProcess": false
    }
]
'@

function Read-UserInput {
    param (
        $Prompt, $ForegroundColor = 'white'
    )
    
    Write-Host "$Prompt" -NoNewline -ForegroundColor $ForegroundColor
    return ($Host.UI.ReadLine())
}

function Get-UrlParamUserInput {
    if (($Script:MyCommand) -match 'pstool\.everydayin\.tech\?([a-z]+!?)\s') {
        return [string]$Matches[1]
    }
    if (($Script:MyCommand) -match 'pstool\.net\?([a-z]+!?)\s') {
        return [string]$Matches[1]
    }
}

$Script:MyCommand = $MyInvocation.MyCommand

$ToolBelt = $ToolBeltJson | ConvertFrom-Json

$UrlParamUserInput = Get-UrlParamUserInput
$UrlParamUserConfirm = $false

do {
    if ($UrlParamUserInput) {
        $UserInput = $UrlParamUserInput -match '[a-z]+' | ForEach-Object { $Matches[0] }
        $UrlParamUserConfirm = ($UrlParamUserInput[-1] -eq '!')
        $UrlParamUserInput = $null
    }
    else {
        $UserInput = Read-UserInput -Prompt 'PSTool> '

        if (!($UserInput.Length -gt 0)) {
            continue
        }    
    }

    $SelectedTool = $ToolBelt | Where-Object { ($_.id -eq $UserInput) } | Select-Object -First 1
    if ($SelectedTool) {
        if (-NOT $UrlParamUserConfirm) {
            $UserConfirm = Read-UserInput `
                -Prompt ("=> [{0}] {1} `n   Description:  {2} `n   Script:       {3} `n`nRun? [Y/n] " -f $SelectedTool.id, $SelectedTool.name, $SelectedTool.description, $SelectedTool.script) `
                -ForegroundColor Cyan
        }
        if ($UrlParamUserConfirm -OR $UserConfirm.ToLower().Equals('y')) {
            Write-Host ('Running Tool [{0}]!' -f $SelectedTool.name) -ForegroundColor Magenta

            if ($SelectedTool.newProcess) {
                $PSCommand = "`$VerbosePreference = `"$VerbosePreference`"; Invoke-RestMethod -UseBasicParsing -Uri `"$($SelectedTool.script)`" | Invoke-Expression"
                if ($PSVersionTable.PSVersion.Major -eq 5) {
                    & powershell -Command $PSCommand
                    return
                }
                else {
                    & pwsh -Command $PSCommand
                    return
                }   
            } 
            else {
                Invoke-RestMethod -UseBasicParsing -Uri $SelectedTool.script | Invoke-Expression
                return
            }
        }

        #Reset Selected Tool
        $SelectedTool = $null
        
    }
    else {
        $MatchingTools = $ToolBelt | Where-Object { ($_.id -eq $UserInput) -or ($_.keywords -contains $UserInput) -or ($_.description -like "*$UserInput*") }
        foreach ($tool in $MatchingTools) {
            Write-Host ('[{0}] {1}' -f $tool.id, $tool.name) -ForegroundColor Cyan
        }    
    }
    
} until (
    $UserInput.ToLower().Equals('exit') -or $UserInput.ToLower().Equals('quit')
)