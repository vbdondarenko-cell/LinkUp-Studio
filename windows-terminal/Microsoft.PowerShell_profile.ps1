# ═══════════════════════════════════════════════════════════════════════════
# LinkUp Studio PowerShell Profile
# Premium Developer Environment - GitHub Dark Theme
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# Oh My Posh Configuration
# ─────────────────────────────────────────────────────────────────────────────
function Get-LinkUpTheme {
    @{
        "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json"
        "finalSpace" = $false
        "console_title" = $true
        "console_title_template" = "{{ .UserName }}@{{ .HostName }} | {{ .PWD }}"
        "blocks" = @(
            # Developer Info Block
            @{
                type = "prompt"
                alignment = "left"
                newline = $true
                segments = @(
                    @{
                        type = "shell"
                        style = "plain"
                        foreground = "#58a6ff"
                        template = "  "
                    }
                )
            }
            
            # Git Status Block (Top)
            @{
                type = "prompt"
                alignment = "left"
                segments = @(
                    # OS Icon
                    @{
                        type = "os"
                        style = "plain"
                        foreground = "#8b949e"
                        template = "{{ if .WSL }}WSL{{ end }}{{ if .Hyper }}Hyper{{ end }}{{ if .PWD }}P{{ end }}"
                        display_distro = $false
                    }
                    
                    # User@Host
                    @{
                        type = "session"
                        style = "plain"
                        foreground = "#8b949e"
                        template = "{{ .UserName }}"
                        display_host = $false
                    }
                    
                    # Working Directory
                    @{
                        type = "path"
                        style = "plain"
                        foreground = "#e6edf3"
                        template = " {{ path .Path .Location }}"
                        home_icon = "~"
                        folder_separator_icon = "/"
                        mixed_path = $false
                        mapped_locations_enabled = $false
                        properties = @{
                            folder_separator_icon = ">"
                            home_icon = "~"
                            windows_registry_icon = "⚙"
                            folder_separator_template = ""
                            enable_hyperlink = $false
                        }
                    }
                )
            }
            
            # Git Branch Block
            @{
                type = "prompt"
                alignment = "left"
                newline = $false
                segments = @(
                    @{
                        type = "git"
                        style = "plain"
                        foreground = "#58a6ff"
                        template = "{{ .HEAD }}"
                        branch_icon = "   "
                        branch_identical_icon = ""
                        branch_ahead_icon = " ↑"
                        branch_behind_icon = " ↓"
                        branch_gone_icon = " ✗"
                        branch_name_color = "#58a6ff"
                        status_colors_enabled = $true
                        local_working_color = "#d29922"
                        local_staged_color = "#a371f7"
                        status_separator_color = "#30363d"
                        behind_and_ahead_color = "#8b949e"
                        ahead_and_behind_color = "#8b949e"
                        working_color = "#d29922"
                        staging_color = "#a371f7"
                        new_operation_color = "#3fb950"
                        properties = @{
                            display_status_hierarchy = $true
                            display_stash_count = $true
                            display_worktree_count = $true
                            display_branch_status = $true
                            display_status_detail = $true
                            branch_status_separator = " |"
                            branch_ahead_suffix = " ↑"
                            branch_behind_suffix = " ↓"
                            branch_gone = " ✗ "
                        }
                    }
                )
            }
            
            # Git Status Icons
            @{
                type = "prompt"
                alignment = "left"
                newline = $false
                segments = @(
                    @{
                        type = "git"
                        style = "plain"
                        foreground = "#3fb950"
                        template = "{{ .UpstreamIcon }}"
                        properties = @{
                            display_status = $true
                            display_stash_count = $true
                            status_separator = " |"
                            stash_count_icon = "📦"
                            worktree_icon = "🔀"
                            repo_root_icon = ""
                        }
                    }
                )
            }
            
            # Execution Time
            @{
                type = "prompt"
                alignment = "left"
                newline = $false
                segments = @(
                    @{
                        type = "executiontime"
                        style = "plain"
                        foreground = "#6e7681"
                        template = " {{ .Duration .Ms }}"
                        show_milliseconds = $false
                        threshold = 100
                        style_pixels = $false
                        properties = @{
                            display_execution_time = $true
                            threshold = 100
                            show_milliseconds = $false
                        }
                    }
                )
            }
            
            # New Line
            @{
                type = "newline"
                newline = $true
            }
            
            # Prompt Symbol
            @{
                type = "prompt"
                alignment = "left"
                segments = @(
                    @{
                        type = "text"
                        style = "plain"
                        foreground = "#3fb950"
                        template = "❯ "
                        background = "transparent"
                        doge_var = "@"
                        doge_text = "not"
                    }
                )
            }
            
            # Exit Code Block
            @{
                type = "prompt"
                alignment = "left"
                segments = @(
                    @{
                        type = "exit"
                        style = "diamond"
                        foreground = "#0d1117"
                        background = "#f85149"
                        template = "{{ if eq .Code 0 }}✓{{ else }}✗{{ end }}"
                        error_background = "#f85149"
                        error_foreground = "#0d1117"
                        evaluate = $false
                        alacritty_options = @{
                            key = "RightAlt"
                            modifiers = "Control"
                        }
                        properties = @{
                            display_exit_code = $true
                            always_enabled = $true
                            error_format = "#f85149"
                            success_format = "#3fb950"
                        }
                    }
                )
            }
            
            # Right Prompt - Status Info
            @{
                type = "prompt"
                alignment = "right"
                segments = @(
                    @{
                        type = "time"
                        style = "plain"
                        foreground = "#6e7681"
                        template = "{{ .CurrentDate | date .Format }}"
                        format = "15:04:05"
                        properties = @{
                            display_time = $true
                            time_format = "15:04:05"
                        }
                    }
                )
            }
        )
        "type" = "prompt"
    }
}

# Try to initialize Oh My Posh
try {
    if (Get-Command oh-my-posh -errorAction SilentlyContinue) {
        oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/linkup.omp.json" | Invoke-Expression
    }
} catch {
    # Fallback to basic prompt if Oh My Posh fails
}

# ─────────────────────────────────────────────────────────────────────────────
# Git Configuration
# ─────────────────────────────────────────────────────────────────────────────
function Get-GitStatus {
    if (Test-Path .git) {
        $status = git status --porcelain 2>$null
        if ($status) {
            $staged = ($status | Where-Object { $_.StartsWith("M") -or $_.StartsWith("A") }).Count
            $modified = ($status | Where-Object { $_.StartsWith(" M") -or $_.StartsWith("??") }).Count
            $branch = git branch --show-current 2>$null
            
            Write-Host ""
            Write-Host "   $branch" -ForegroundColor "Cyan" -NoNewline
            
            if ($staged -gt 0) {
                Write-Host " +$staged" -ForegroundColor "Green" -NoNewline
            }
            if ($modified -gt 0) {
                Write-Host " ~$modified" -ForegroundColor "Yellow" -NoNewline
            }
            Write-Host ""
        }
    }
}

function Get-GitBranch {
    $branch = git branch --show-current 2>$null
    if ($LASTEXITCODE -eq 0 -and $branch) {
        return $branch
    }
    return $null
}

# Git aliases
Set-Alias -Name gs -Value Get-GitStatus -Option AllScope
Set-Alias -Name gb -Value Get-GitBranch -Option AllScope

# ─────────────────────────────────────────────────────────────────────────────
# Developer Shortcuts
# ─────────────────────────────────────────────────────────────────────────────
function code { & code-insiders.cmd $args }
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ll { Get-ChildItem -Force -ErrorAction SilentlyContinue }
function la { Get-ChildItem -Force -ErrorAction SilentlyContinue | Format-Table Mode, LastWriteTime, Length, Name }
function which { Get-Command -Name $args[0] -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path }

# Git shortcuts
function gst { git status }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gaa { git add --all }
function gcm { git commit -m $args }
function gpush { git push }
function gpull { git pull }
function glog { git log --oneline --graph --decorate --all }
function gdiff { git diff }
function gfetch { git fetch --all }

# ─────────────────────────────────────────────────────────────────────────────
# Development Environment
# ─────────────────────────────────────────────────────────────────────────────
function dev {
    if ($args[0]) {
        Set-Location $args[0]
    }
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor "DarkGray"
    Write-Host "  ║           LinkUp Studio Developer Environment          ║" -ForegroundColor "DarkGray"
    Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor "DarkGray"
    Write-Host ""
    
    # Show Git info
    $branch = Get-GitBranch
    if ($branch) {
        Write-Host "   $branch" -ForegroundColor "Cyan"
    }
    
    Write-Host ""
}

# Node shortcuts
function ni { npm install $args }
function nis { npm install $args --save }
function nisd { npm install $args --save-dev }
function nr { npm run $args }
function nrt { npm run test }
function nrw { npm run watch }
function nrb { npm run build }
function nd { npm run dev }

# Python shortcuts
function pa { python $args }
function pipi { pip install $args }
function pact { python activate $args }

# Docker shortcuts
function dps { docker ps }
function dpsa { docker ps -a }
function dstop { docker stop $args }
function drm { docker rm $args }
function dlogs { docker logs $args }
function dexec { docker exec -it $args }
function dsh { docker exec -it $args /bin/sh }

# ─────────────────────────────────────────────────────────────────────────────
# System Information
# ─────────────────────────────────────────────────────────────────────────────
function sysinfo {
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor "DarkGray"
    Write-Host "  ║                  System Information                       ║" -ForegroundColor "DarkGray"
    Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor "DarkGray"
    Write-Host ""
    Write-Host "  Computer Name: " -NoNewline -ForegroundColor "DarkGray"
    Write-Host $env:COMPUTERNAME
    Write-Host "  User Name:      " -NoNewline -ForegroundColor "DarkGray"
    Write-Host $env:USERNAME
    Write-Host "  OS:             " -NoNewline -ForegroundColor "DarkGray"
    Write-Host (Get-CimInstance Win32_OperatingSystem).Caption
    Write-Host "  PowerShell:     " -NoNewline -ForegroundColor "DarkGray"
    Write-Host $PSVersionTable.PSVersion
    Write-Host ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Color Configuration
# ─────────────────────────────────────────────────────────────────────────────
$PSStyle.Progress.Location = "Bottom"
$PSStyle.Progress.UseScript = $true
$PSStyle.Progress.Style = "ProgressBar"

# Git status colors
$GitPromptSettings = @{
    DefaultForegroundColor = "#e6edf3"
    DefaultBackgroundColor = "Transparent"
    BeforeText = "["
    AfterText = "]"
    ForegroundColor = "#8b949e"
    BackgroundColor = "Transparent"
    BranchColor = "#58a6ff"
    BranchAheadStatusColor = "#3fb950"
    BranchBehindStatusColor = "#f85149"
    BranchGoneStatusColor = "#d29922"
    BranchIdenticalStatusColor = "#8b949e"
    BeforePathText = ""
    AfterPathText = ""
    DelimText = ":"
    PathColor = "#e6edf3"
    WorkingColor = "#d29922"
    StagedColor = "#a371f7"
    IndexColor = "#3fb950"
    StashCountColor = "#d29922"
    UntrackedFileColor = "#8b949e"
    ErrorColor = "#f85149"
}

# ─────────────────────────────────────────────────────────────────────────────
# Welcome Message
# ─────────────────────────────────────────────────────────────────────────────
function Show-Welcome {
    $ascii = @"
  ╔═══════════════════════════════════════════════════════════╗
  ║     ██╗██╗   ██╗███╗   ██╗ ██████╗ ███████╗██████╗     ║
  ║     ██║██║   ██║████╗  ██║██╔════╝ ██╔════╝██╔══██╗    ║
  ║     ██║██║   ██║██╔██╗ ██║██║  ███╗█████╗  ██████╔╝    ║
  ║██   ██║██║   ██║██║╚██╗██║██║   ██║██╔══╝  ██╔══██╗    ║
  ║╚█████╔╝╚██████╔╝██║ ╚████║╚██████╔╝███████╗██║  ██║    ║
  ║ ╚════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    ║
  ║              Premium Developer Terminal                   ║
  ╚═══════════════════════════════════════════════════════════╝
"@
    
    Write-Host $ascii -ForegroundColor Cyan
    
    # Show branch if in git repo
    $branch = Get-GitBranch
    if ($branch) {
        Write-Host ""
        Write-Host "   $branch" -ForegroundColor "Cyan"
    }
    
    Write-Host ""
    Write-Host "  Type 'help' for available commands" -ForegroundColor "DarkGray"
    Write-Host "  Type 'dev' for developer environment" -ForegroundColor "DarkGray"
    Write-Host "  Type 'sysinfo' for system information" -ForegroundColor "DarkGray"
    Write-Host ""
}

# Show welcome on new session
Show-Welcome

# ─────────────────────────────────────────────────────────────────────────────
# Clear screen with welcome
# ─────────────────────────────────────────────────────────────────────────────
function prompt {
    # Get Git branch
    $branch = Get-GitBranch
    
    # Build prompt
    $prompt = ""
    
    # Git branch
    if ($branch) {
        $prompt += "   $branch " -ForegroundColor Cyan
    }
    
    # Path
    $prompt += "$((Get-Location).Path.Replace($HOME, '~')) " -ForegroundColor White
    
    # Git status indicators
    if (Test-Path .git) {
        $status = git status --porcelain 2>$null
        if ($status) {
            $staged = ($status | Where-Object { $_.StartsWith("M") -or $_.StartsWith("A") }).Count
            $modified = ($status | Where-Object { $_.StartsWith(" M") -or $_.StartsWith("??") }).Count
            
            if ($staged -gt 0) {
                $prompt += "| +$staged" -ForegroundColor Green
            }
            if ($modified -gt 0) {
                $prompt += "| ~$modified" -ForegroundColor Yellow
            }
        }
    }
    
    # Prompt symbol
    if ($LASTEXITCODE -eq 0) {
        $prompt += "`n❯ " -ForegroundColor Green
    } else {
        $prompt += "`n❯ " -ForegroundColor Red
    }
    
    return $prompt
}

# ─────────────────────────────────────────────────────────────────────────────
# Import Terminal Icons (if available)
# ─────────────────────────────────────────────────────────────────────────────
try {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
} catch {
    # Module not available, continue without it
}

# ═══════════════════════════════════════════════════════════════════════════
# LinkUp Studio PowerShell Profile Loaded Successfully
# ═══════════════════════════════════════════════════════════════════════════