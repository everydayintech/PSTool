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
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/Intune/Invoke-CMTraceIMELog.ps1"
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
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/Intune/Get-CMTrace.ps1"
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
        "script":  "https://raw.githubusercontent.com/everydayintech/Scripts/main/HP/Invoke-HPImageAssistant.ps1"
    },
    {
        "name":  "Logoff and remove LastLoggedOnUser from Registry",
        "description":  "Logoff from a PC as if you have never been there.",
        "keywords":  [
                         "logout"
                     ],
        "id":  "logoff",
        "script":  "https://gist.githubusercontent.com/everydayintech/d2762560d3b24c06f14143778cc25de4/raw/6293e8604de710725f6ee6000bc2c6f894ee1b82/logoff.ps1"
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
        "script":  "https://gist.githubusercontent.com/everydayintech/45fe66b0ee59f58f9aa0a5ec0b655e3d/raw/346d57029d6c563aac2878650de66ce47aa1e468/Remove%2520CCMAgent.ps1"
    }
]
'@

function Read-UserInput {
    param (
        $Prompt, $ForegroundColor = "white"
    )
    
    Write-Host "$Prompt" -NoNewLine -ForegroundColor $ForegroundColor
    return ($Host.UI.ReadLine())
}

function Get-UrlParamUserInput {
    if(($Script:MyCommand) -match "pstool\.everydayin\.tech\?([a-z]+)\s"){
        return [string]$Matches[1]
    }
}

$Script:MyCommand = $MyInvocation.MyCommand

$ToolBelt = $ToolBeltJson | ConvertFrom-Json

$UrlParamUserInput = Get-UrlParamUserInput

do {
    if($UrlParamUserInput){
        Write-Host "Found URL Parameter Input: [$($UrlParamUserInput)]"
        $UserInput = $UrlParamUserInput
        $UrlParamUserInput = $null
    }
    else {
        $UserInput = Read-UserInput -Prompt 'PSTool> ' -ForegroundColor DarkGray

        if (!($UserInput.Length -gt 0)) {
            continue
        }    
    }

    $SelectedTool = $ToolBelt | Where-Object { ($_.id -eq $UserInput) } | Select-Object -First 1
    if ($SelectedTool) {
        $UserConfirm = Read-UserInput `
            -Prompt ("=> [{0}] {1} `n   Description:  {2} `n   Script:       {3} `n`nRun? [Y/n] " -f $SelectedTool.id, $SelectedTool.name, $SelectedTool.description, $SelectedTool.script) `
            -ForegroundColor Cyan
        if ($UserConfirm.ToLower().Equals('y')) {
            Write-Host ('Running Tool [{0}]!' -f $SelectedTool.name) -ForegroundColor Magenta

            Invoke-RestMethod -UseBasicParsing -Uri $SelectedTool.script | Invoke-Expression
            return
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