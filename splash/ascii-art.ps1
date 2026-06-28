# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio ASCII Art Banner
# Display this when terminal starts for a branded welcome experience
# ═══════════════════════════════════════════════════════════════════════════════════════

function Show-LinkUpStudioBanner {
    param(
        [switch]$Minimal,
        [switch]$Color
    )
    
    $bgDark = if ($Color) { "`e[48;2;13;17;23m" } else { "" }
    $accent = if ($Color) { "`e[38;2;88;166;255m" } else { "" }
    $purple = if ($Color) { "`e[38;2;163;113;247m" } else { "" }
    $gray = if ($Color) { "`e[38;2;139;148;158m" } else { "" }
    $reset = if ($Color) { "`e[0m" } else { "" }
    
    if ($Minimal) {
        # Minimal banner
        Write-Host ""
        Write-Host "  ${accent}╔══════════════════════════════════════════════════════════╗${reset}" -NoNewline
        Write-Host ""
        Write-Host "  ${accent}║${reset}    ${purple}██████╗ ██████╗  ██████╗ ████████╗ ██████╗  ██████╗ ${reset}" -NoNewline
        Write-Host ""
        Write-Host "  ${accent}║${reset}    ██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝██╔═══██╗██╔════╝ ${reset}" -NoNewline
        Write-Host ""
        Write-Host "  ${accent}║${reset}    ██████╔╝██████╔╝██║   ██║   ██║   ██║   ██║██║  ███╗${reset}" -NoNewline
        Write-Host ""
        Write-Host "  ${accent}║${reset}    ██╔═══╝ ██╔══██╗██║   ██║   ██║   ██║   ██║██║   ██║${reset}" -NoNewline
        Write-Host ""
        Write-Host "  ${accent}║${reset}    ██║     ██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╔╝${reset}" -NoNewline
        Write-Host ""
        Write-Host "  ${accent}║${reset}    ╚═╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝ ${reset}" -NoNewline
        Write-Host ""
        Write-Host "  ${accent}╚══════════════════════════════════════════════════════════╝${reset}" -NoNewline
        Write-Host ""
        return
    }
    
    # Full banner
    Write-Host ""
    Write-Host "${accent}╔════════════════════════════════════════════════════════════════════════════════╗${reset}" -NoNewline
    Write-Host ""
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host "                                                                                " -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    
    # Logo rows
    Write-Host "${accent}║${reset}        ${purple}███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗███████╗███╗   ███╗ ${reset}" -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    Write-Host "${accent}║${reset}        ████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔════╝████╗ ████║ ${reset}" -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    Write-Host "${accent}║${reset}        ██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║███████╗██╔████╔██║ ${reset}" -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    Write-Host "${accent}║${reset}        ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║╚════██║██║╚██╔╝██║ ${reset}" -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    Write-Host "${accent}║${reset}        ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║███████║██║ ╚═╝ ██║ ${reset}" -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    Write-Host "${accent}║${reset}        ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝╚══════╝╚═╝     ╚═╝ ${reset}" -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host "                                                                                " -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    
    # Title
    Write-Host "${accent}║${reset}                          ${accent}S T U D I O${reset}                                    " -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host "                                                                                " -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    
    # Version and tagline
    Write-Host "${accent}║${reset}                    ${gray}Developer Workspace v1.0.0${reset}                                 " -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    Write-Host "${accent}║${reset}                    ${gray}GitHub Dark Theme · Powered by OpenHands${reset}                    " -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host "                                                                                " -NoNewline
    Write-Host "${accent}║${reset}" -NoNewline
    Write-Host ""
    
    Write-Host "${accent}╚════════════════════════════════════════════════════════════════════════════════╝${reset}" -NoNewline
    Write-Host ""
}

# Quick function for one-liner
function linkup {
    Show-LinkUpStudioBanner -Color
}

# Export functions when dot-sourced
Export-ModuleMember -Function Show-LinkUpStudioBanner, linkup