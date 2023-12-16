$ToolBelt = @(
    [PSCustomObject]@{
        name = "Open IMELog with CMTrace"
        description = "Download CMTrace to temp directory and open IntuneManagementExtension Log"
        keywords = @("cmtrace", "log", "logs", "intune", "ime")
        id = "imelog"
        script = "https://raw.githubusercontent.com/everydayintech/Scripts/main/Intune/Invoke-CMTraceIMELog.ps1"
    },
    [PSCustomObject]@{
        name = "Run CMTrace"
        description = "Download CMTrace to temp directory and run it"
        keywords = @("cmtrace", "log", "logs")
        id = "cmt"
        script = "https://raw.githubusercontent.com/everydayintech/Scripts/main/Intune/Invoke-CMTraceIMELog.ps1"
    },
    [PSCustomObject]@{
        name = "Run HP Image Assistant"
        description = "Download HP Image Assistant to temp directory and run it"
        keywords = @("hp", "image", "assistant", "drivers", "driver", "update", "treiber")
        id = "hpia"
        script = "https://raw.githubusercontent.com/everydayintech/Scripts/main/HP/Invoke-HPImageAssistant.ps1"
    },
    [PSCustomObject]@{
        name = "Install and load AppCat PowerShell Module"
        description = "Download and load AppCat PowerShell Module via AppCat Installer."
        keywords = @("install", "apps", "update")
        id = "appcat"
        script = "https://appcat.leuchter-cloud.ch"
    },
    [PSCustomObject]@{
        name = "Logoff and remove LastLoggedOnUser from Registry"
        description = "Logoff from a PC as if you have never been there."
        keywords = @("logout")
        id = "logoff"
        script = "https://gist.githubusercontent.com/everydayintech/d2762560d3b24c06f14143778cc25de4/raw/6293e8604de710725f6ee6000bc2c6f894ee1b82/logoff.ps1"
    }
    
)

do {
    $UserInput = Read-Host "pstool>"

    if(!($UserInput.Length -gt 0)){
        continue
    }

    $SelectedTool = $ToolBelt | Where-Object{($_.id -eq $UserInput)} | Select-Object -First 1
    if($SelectedTool){
        $UserConfirm = Read-Host ("=> [{0}] {1} `n=> Description: {2} `nGo? [Y/n]" -f $SelectedTool.id, $SelectedTool.name, $SelectedTool.description)
        if ($UserConfirm.ToLower().Equals("y")) {
            Write-Host ("Running Tool [{0}]!" -f $SelectedTool.name) -ForegroundColor Magenta

            Invoke-RestMethod -UseBasicParsing -Uri $SelectedTool.script | Invoke-Expression
        }
        
    }
    else{
        $MatchingTools = $ToolBelt | Where-Object{($_.id -eq $UserInput) -or ($_.keywords -contains $UserInput) -or ($_.description -like "*$UserInput*")}
        foreach ($tool in $MatchingTools) {
            Write-Host ("[{0}] {1}" -f $tool.id, $tool.name) -ForegroundColor Cyan
        }    
    }
    
} until (
    $UserInput.ToLower().Equals("exit") -or $UserInput.ToLower().Equals("quit")
)