# ═══════════════════════════════════════════════════════════════════════════════════════
# ║                                                                                      ║
#    ██╗    ██╗  ██████╗  ██████╗  ██████╗     ███╗   ███╗ ██████╗ ██████╗  ██████╗     ║
#    ██║    ██║ ██╔════╝ ██╔════╝ ██╔═══██╗    ████╗ ████║██╔═══██╗██╔══██╗██╔═══██╗    ║
#    ██║ █╗ ██║ ██║  ███╗██║  ███╗██║   ██║    ██╔████╔██║██║   ██║██║  ██║██║   ██║    ║
#    ██║███╗██║ ██║   ██║██║   ██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║    ║
#    ╚██████╔╝ ╚██████╔╝╚██████╔╝╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝    ║
#     ╚═══██╔╝   ╚═════╝  ╚═════╝  ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝     ║
#                                                                                      ║
#                    Premium PowerShell Experience for Developers                       ║
#                                                                                      ║
# ═══════════════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Configuration
# ─────────────────────────────────────────────────────────────────────────────────────
$env:POSH_GIT_ENABLED = $true

# Color Palette - GitHub Dark
$Colors = @{
    Reset          = "`e[0m"
    Bold           = "`e[1m"
    Dim            = "`e[2m"
    
    # GitHub Dark Colors
    Canvas         = "#0d1117"
    Surface        = "#161b22"
    Elevated       = "#21262d"
    Overlay        = "#30363d"
    Border         = "#484f58"
    
    # Text Colors
    TextPrimary    = "#e6edf3"
    TextSecondary  = "#8b949e"
    TextTertiary   = "#6e7681"
    
    # Accent Colors
    AccentBlue     = "#58a6ff"
    AccentDark     = "#1f6feb"
    Success        = "#3fb950"
    Warning        = "#d29922"
    Danger         = "#f85149"
    Purple         = "#a371f7"
    Cyan           = "#39c5cf"
    
    # ANSI Escapes
    Black          = "`e[38;2;72;79;88m"
    BrightBlack    = "`e[38;2;110;118;128m"
    Red            = "`e[38;2;248;81;73m"
    BrightRed      = "`e[38;2;255;123;114m"
    Green          = "`e[38;2;63;185;80m"
    BrightGreen    = "`e[38;2;86;211;100m"
    Yellow         = "`e[38;2;210;153;34m"
    BrightYellow   = "`e[38;2;227;179;65m"
    Blue           = "`e[38;2;88;166;255m"
    BrightBlue     = "`e[38;2;121;192;255m"
    Magenta        = "`e[38;2;163;113;247m"
    BrightMagenta  = "`e[38;2;188;140;255m"
    Cyan           = "`e[38;2;57;197;207m"
    BrightCyan     = "`e[38;2;86;212;221m"
    White          = "`e[38;2;177;186;196m"
    BrightWhite    = "`e[38;2;230;237;243m"
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Helper Functions
# ─────────────────────────────────────────────────────────────────────────────────────

function Get-GitRepositoryInfo {
    <#
    .SYNOPSIS
        Get detailed Git repository information
    #>
    $info = @{
        IsGitRepo    = $false
        Branch       = ""
        Status       = ""
        AheadBehind  = ""
        StashCount   = 0
        RepoName     = ""
        RepoPath     = ""
        HasChanges   = $false
        StagedCount  = 0
        ModifiedCount = 0
        UntrackedCount = 0
    }
    
    try {
        $gitDir = Get-Item .git -ErrorAction SilentlyContinue
        if ($gitDir) {
            $info.IsGitRepo = $true
            
            # Get branch name
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            if ($branch) { $info.Branch = $branch }
            
            # Get repository name
            $info.RepoName = Split-Path (git rev-parse --show-toplevel 2>$null) -Leaf
            $info.RepoPath = git rev-parse --show-toplevel 2>$null
            
            # Get status
            $status = git status --porcelain 2>$null
            if ($status) {
                $info.HasChanges = $true
                
                # Count staged
                $info.StagedCount = ($status | Where-Object { $_.Substring(0, 1) -match "[MADRC]" } | Measure-Object).Count
                
                # Count modified
                $info.ModifiedCount = ($status | Where-Object { $_.Substring(1, 1) -match "[MDRC]" } | Measure-Object).Count
                
                # Count untracked
                $info.UntrackedCount = ($status | Where-Object { $_.StartsWith("??") } | Measure-Object).Count
            }
            
            # Get ahead/behind
            $branchInfo = git rev-list --left-right --count "@{upstream}...HEAD" 2>$null
            if ($branchInfo) {
                $parts = $branchInfo -split '\s+'
                if ($parts.Count -ge 2) {
                    $ahead = [int]$parts[0]
                    $behind = [int]$parts[1]
                    
                    if ($ahead -gt 0) { $info.AheadBehind += "+$ahead" }
                    if ($behind -gt 0) { $info.AheadBehind += "-$behind" }
                }
            }
            
            # Get stash count
            $stash = git stash list 2>$null
            if ($stash) { $info.StashCount = ($stash | Measure-Object).Count }
        }
    }
    catch {
        # Silently continue - not a git repo
    }
    
    return $info
}

function Get-SystemInfo {
    <#
    .SYNOPSIS
        Get system and PowerShell information
    #>
    return @{
        PSVersion    = $PSVersionTable.PSVersion.ToString()
        PSEdition    = $PSVersionTable.PSEdition
        OS           = (Get-CimInstance Win32_OperatingSystem).Caption
        ComputerName = $env:COMPUTERNAME
        UserName     = $env:USERNAME
        HomePath     = $env:USERPROFILE
        CurrentTime  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Uptime       = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpDate
        TotalRAM     = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
        CPU          = (Get-CimInstance Win32_Processor).Name
        DisplayDPI   = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    }
}

function Write-Banner {
    <#
    .SYNOPSIS
        Write the LinkUp Studio banner
    #>
    param(
        [string]$Title = "LinkUp Studio",
        [string]$Subtitle = "Premium PowerShell Experience"
    )
    
    $banner = @"

    ╔══════════════════════════════════════════════════════════════════════════════════╗
    ║                                                                                  ║
    ║    ██╗    ██╗  ██████╗  ██████╗  ██████╗     ███╗   ███╗ ██████╗ ██████╗  ██████╗      ║
    ║    ██║    ██║ ██╔════╝ ██╔════╝ ██╔═══██╗    ████╗ ████║██╔═══██╗██╔══██╗██╔═══██╗     ║
    ║    ██║ █╗ ██║ ██║  ███╗██║  ███╗██║   ██║    ██╔████╔██║██║   ██║██║  ██║██║   ██║     ║
    ║    ██║███╗██║ ██║   ██║██║   ██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║     ║
    ║    ╚██████╔╝ ╚██████╔╝╚██████╔╝╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝     ║
    ║     ╚═══██╔╝   ╚═════╝  ╚═════╝  ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝      ║
    ║                                                                                  ║
    ╚══════════════════════════════════════════════════════════════════════════════════╝

"@
    
    Write-Host $banner -ForegroundColor Cyan
}

function Write-RepositoryPanel {
    <#
    .SYNOPSIS
        Write repository information panel
    #>
    param(
        [hashtable]$GitInfo
    )
    
    Write-Host ""
    Write-Host "  ┌──────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor $Colors.Border
    Write-Host "  │  REPOSITORY INFORMATION                                                       │" -ForegroundColor $Colors.TextSecondary
    Write-Host "  ├──────────────────────────────────────────────────────────────────────────────┤" -ForegroundColor $Colors.Border
    
    if ($GitInfo.IsGitRepo) {
        Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
        Write-Host " Repository   " -NoNewline -ForegroundColor $Colors.TextTertiary
        Write-Host (" {0,-66}" -f $GitInfo.RepoName) -NoNewline -ForegroundColor $Colors.AccentBlue
        Write-Host "  │" -ForegroundColor $Colors.TextSecondary
        
        Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
        Write-Host " Path         " -NoNewline -ForegroundColor $Colors.TextTertiary
        
        # Truncate path if too long
        $displayPath = $GitInfo.RepoPath
        if ($displayPath.Length -gt 52) {
            $displayPath = "..." + $displayPath.Substring($displayPath.Length - 49)
        }
        Write-Host (" {0,-66}" -f $displayPath) -NoNewline -ForegroundColor $Colors.TextPrimary
        Write-Host "  │" -ForegroundColor $Colors.TextSecondary
        
        # Branch with icon
        Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
        Write-Host " Branch       " -NoNewline -ForegroundColor $Colors.TextTertiary
        Write-Host " $ " -NoNewline -ForegroundColor $Colors.Purple
        Write-Host (" {0,-65}" -f $GitInfo.Branch) -NoNewline -ForegroundColor $Colors.AccentBlue
        Write-Host "  │" -ForegroundColor $Colors.TextSecondary
        
        # Status indicators
        $statusParts = @()
        
        if ($GitInfo.StagedCount -gt 0) {
            $statusParts += "$($Colors.Success)+$($GitInfo.StagedCount)$($Colors.Reset)"
        }
        if ($GitInfo.ModifiedCount -gt 0) {
            $statusParts += "$($Colors.Warning)*$($GitInfo.ModifiedCount)$($Colors.Reset)"
        }
        if ($GitInfo.UntrackedCount -gt 0) {
            $statusParts += "$($Colors.TextTertiary)?$($GitInfo.UntrackedCount)$($Colors.Reset)"
        }
        if ($GitInfo.AheadBehind) {
            $statusParts += "[$($GitInfo.AheadBehind)]"
        }
        
        Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
        Write-Host " Status       " -NoNewline -ForegroundColor $Colors.TextTertiary
        
        if ($statusParts.Count -gt 0) {
            $statusStr = $statusParts -join " "
            Write-Host (" {0,-66}" -f $statusStr) -NoNewline
        } else {
            Write-Host (" {0,-66}" -f "Clean") -NoNewline -ForegroundColor $Colors.Success
        }
        Write-Host "  │" -ForegroundColor $Colors.TextSecondary
        
        if ($GitInfo.StashCount -gt 0) {
            Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
            Write-Host " Stashes      " -NoNewline -ForegroundColor $Colors.TextTertiary
            Write-Host (" {0,-63}" -f "S$($GitInfo.StashCount)") -NoNewline -ForegroundColor $Colors.Warning
            Write-Host "  │" -ForegroundColor $Colors.TextSecondary
        }
    }
    else {
        Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
        Write-Host " No Git repository detected                                            │" -ForegroundColor $Colors.TextTertiary
    }
    
    Write-Host "  └──────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor $Colors.Border
}

function Write-SystemPanel {
    <#
    .SYNOPSIS
        Write system information panel
    #>
    param(
        [hashtable]$SysInfo
    )
    
    Write-Host ""
    Write-Host "  ┌──────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor $Colors.Border
    Write-Host "  │  SYSTEM INFORMATION                                                           │" -ForegroundColor $Colors.TextSecondary
    Write-Host "  ├──────────────────────────────────────────────────────────────────────────────┤" -ForegroundColor $Colors.Border
    
    Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
    Write-Host " Current Time  " -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host (" {0,-66}" -f $SysInfo.CurrentTime) -NoNewline -ForegroundColor $Colors.AccentBlue
    Write-Host "  │" -ForegroundColor $Colors.TextSecondary
    
    Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
    Write-Host " PowerShell    " -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host (" v{0} ({1})" -f $SysInfo.PSVersion, $SysInfo.PSEdition) -NoNewline -ForegroundColor $Colors.Success
    Write-Host (" {0,-51}" -f "") -NoNewline
    Write-Host "  │" -ForegroundColor $Colors.TextSecondary
    
    Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
    Write-Host " Computer      " -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host (" {0,-52}" -f "$($SysInfo.ComputerName) ($($SysInfo.UserName))") -NoNewline -ForegroundColor $Colors.TextPrimary
    Write-Host "  │" -ForegroundColor $Colors.TextSecondary
    
    Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
    Write-Host " OS            " -NoNewline -ForegroundColor $Colors.TextTertiary
    $osShort = $SysInfo.OS -replace "Microsoft ", "" -replace " Enterprise", " Ent" -replace " Pro", " Pro"
    Write-Host (" {0,-66}" -f $osShort) -NoNewline -ForegroundColor $Colors.TextPrimary
    Write-Host "  │" -ForegroundColor $Colors.TextSecondary
    
    Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
    Write-Host " Memory        " -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host (" {0} GB RAM" -f $SysInfo.TotalRAM) -NoNewline -ForegroundColor $Colors.Purple
    Write-Host (" {0,-56}" -f "") -NoNewline
    Write-Host "  │" -ForegroundColor $Colors.TextSecondary
    
    Write-Host "  │  " -NoNewline -ForegroundColor $Colors.TextSecondary
    Write-Host " Uptime        " -NoNewline -ForegroundColor $Colors.TextTertiary
    $uptimeStr = "{0}d {1}h {2}m" -f $SysInfo.Uptime.Days, $SysInfo.Uptime.Hours, $SysInfo.Uptime.Minutes
    Write-Host (" {0,-66}" -f $uptimeStr) -NoNewline -ForegroundColor $Colors.Cyan
    Write-Host "  │" -ForegroundColor $Colors.TextSecondary
    
    Write-Host "  └──────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor $Colors.Border
}

function Write-QuickCommands {
    <#
    .SYNOPSIS
        Write quick commands reference
    #>
    Write-Host ""
    Write-Host "  ┌──────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor $Colors.Border
    Write-Host "  │  QUICK COMMANDS                                                               │" -ForegroundColor $Colors.TextSecondary
    Write-Host "  ├──────────────────────────────────────────────────────────────────────────────┤" -ForegroundColor $Colors.Border
    Write-Host "  │" -NoNewline -ForegroundColor $Colors.Border
    Write-Host ("  git   {0,-20} {1,-43}" -f "gst, gco, gaa, gcm, gpush" , "Git operations") -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host "  │" -ForegroundColor $Colors.Border
    Write-Host "  │" -NoNewline -ForegroundColor $Colors.Border
    Write-Host ("  node  {0,-20} {1,-43}" -f "ni, nr, nrb, nrd" , "Node.js shortcuts") -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host "  │" -ForegroundColor $Colors.Border
    Write-Host "  │" -NoNewline -ForegroundColor $Colors.Border
    Write-Host ("  docker{0,-20} {1,-43}" -f "dps, dexec, dlogs" , "Docker shortcuts") -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host "  │" -ForegroundColor $Colors.Border
    Write-Host "  │" -NoNewline -ForegroundColor $Colors.Border
    Write-Host ("  sys   {0,-20} {1,-43}" -f "sysinfo, cls, ll, la" , "System commands") -NoNewline -ForegroundColor $Colors.TextTertiary
    Write-Host "  │" -ForegroundColor $Colors.Border
    Write-Host "  └──────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor $Colors.Border
    Write-Host ""
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Oh My Posh Configuration
# ─────────────────────────────────────────────────────────────────────────────────────

try {
    if (Get-Command oh-my-posh -errorAction SilentlyContinue) {
        $ompConfig = "$env:POSH_THEMES_PATH/linkup.omp.json"
        if (Test-Path $ompConfig) {
            oh-my-posh init pwsh --config $ompConfig | Invoke-Expression
        }
    }
} catch {
    # Continue without Oh My Posh
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Git Aliases
# ─────────────────────────────────────────────────────────────────────────────────────

function gst { git status }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gaa { git add --all }
function gcm { git commit -m $args }
function gpush { git push }
function gpull { git pull }
function gpll { git pull --rebase }
function glog { git log --oneline --graph --decorate --all }
function gdiff { git diff }
function gdiffc { git diff --cached }
function gfetch { git fetch --all }
function gstash { git stash }
function gstashp { git stash pop }
function gbranch { git branch -a }
function gremote { git remote -v }
function gconf { git config --list }

Set-Alias -Name gs -Value gst -Option AllScope
Set-Alias -Name gb -Value gbranch -Option AllScope

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Developer Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ~ { Set-Location $HOME }

function ll { Get-ChildItem -Force -ErrorAction SilentlyContinue | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function la { Get-ChildItem -Force -ErrorAction SilentlyContinue | Format-List }

function sysinfo {
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Border
    Write-Host "  ║                           SYSTEM INFORMATION                                  ║" -ForegroundColor $Colors.TextSecondary
    Write-Host "  ╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Border
    Write-Host ""
    Get-SystemInfo | Format-List
}

Set-Alias -Name sys -Value sysinfo -Option AllScope

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Node.js Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────

function ni { npm install $args }
function nis { npm install --save $args }
function nisd { npm install --save-dev $args }
function nr { npm run $args }
function nrt { npm run test }
function nrw { npm run watch }
function nrb { npm run build }
function nrd { npm run dev }
function nidi { npm init -y }
function nirl { npm info $args }
function nild { npm list }
function niout { npm outdated }

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Python Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────

function pa { python $args }
function pa3 { python3 $args }
function pipi { pip install $args }
function pip3i { pip3 install $args }
function pact { python -m venv venv; .\venv\Scripts\Activate.ps1 }
function pyd { python -m http.server $args }

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Docker Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────

function dps { docker ps }
function dpsa { docker ps -a }
function dstop { docker stop $args }
function drm { docker rm $args }
function drmi { docker rmi $args }
function dlogs { docker logs $args }
function dexec { docker exec -it $args }
function dsh { docker exec -it $args /bin/sh }
function dib { docker build -t $args }
function drun { docker run -it $args }
function dnet { docker network ls }
function dvol { docker volume ls }
function dclean { docker system prune -af }

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Development Commands
# ─────────────────────────────────────────────────────────────────────────────────────

function dev {
    Clear-Host
    Write-Banner
    
    $gitInfo = Get-GitRepositoryInfo
    $sysInfo = Get-SystemInfo
    
    Write-RepositoryPanel -GitInfo $gitInfo
    Write-SystemPanel -SysInfo $sysInfo
    Write-QuickCommands
    
    Write-Host "  Current: " -NoNewline -ForegroundColor $Colors.TextSecondary
    Write-Host (Get-Location) -ForegroundColor $Colors.AccentBlue
    Write-Host ""
}

function refresh {
    dev
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Terminal Settings
# ─────────────────────────────────────────────────────────────────────────────────────

$PSStyle.Progress.Location = "Bottom"
$PSStyle.Progress.UseScript = $true

$GitPromptSettings = @{
    DefaultForegroundColor = $Colors.TextPrimary
    DefaultBackgroundColor = "Transparent"
    BeforeText = "["
    AfterText = "]"
    ForegroundColor = $Colors.TextSecondary
    BranchColor = $Colors.AccentBlue
    BranchAheadStatusColor = $Colors.Success
    BranchBehindStatusColor = $Colors.Danger
    WorkingColor = $Colors.Warning
    StagingColor = $Colors.Purple
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Region: Initialize
# ─────────────────────────────────────────────────────────────────────────────────────

dev

# ═════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio PowerShell Profile - Premium Developer Experience
# ═════════════════════════════════════════════════════════════════════════════════════