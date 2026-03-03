<#
.SYNOPSIS
    Collects basic system information for IT support and documentation purposes.

.DESCRIPTION
    Gathers operating system, CPU, memory, disk, network, and uptime details
    and outputs them as a structured PowerShell object. Optionally exports
    the results to a text or JSON file.

.PARAMETER OutputPath
    Optional. If provided, the script will write the output to the specified file.
    The extension determines the format:
        - .txt  = formatted list
        - .json = JSON

.EXAMPLE
    .\Get-SystemInfo.ps1

.EXAMPLE
    .\Get-SystemInfo.ps1 -OutputPath .\systeminfo.txt

.EXAMPLE
    .\Get-SystemInfo.ps1 -OutputPath .\systeminfo.json
#>

param(
    [string]$OutputPath
)

# OS info
$os = Get-CimInstance Win32_OperatingSystem
$osName = $os.Caption
$osVersion = $os.Version

# CPU info
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$cpuName = $cpu.Name
$cpuCores = $cpu.NumberOfCores
$cpuLogical = $cpu.NumberOfLogicalProcessors

# Memory info
$totalMemoryGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeMemoryGB  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedMemoryGB  = [math]::Round($totalMemoryGB - $freeMemoryGB, 2)

# Disk info (system drive)
$systemDrive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskSizeGB  = [math]::Round($systemDrive.Size / 1GB, 2)
$diskFreeGB  = [math]::Round($systemDrive.FreeSpace / 1GB, 2)

# Network adapters (enabled, with IP)
$netAdapters = Get-NetIPConfiguration |
    Where-Object { $_.IPv4Address -ne $null } |
    Select-Object InterfaceAlias, @{Name="IPv4";Expression={$_.IPv4Address.IPAddress}}

# Uptime
$lastBoot = $os.LastBootUpTime
$uptime   = (Get-Date) - $lastBoot

$uptimeString = "{0} days, {1} hours, {2} minutes" -f `
    [int]$uptime.Days, `
    [int]$uptime.Hours, `
    [int]$uptime.Minutes

# Build result object
$result = [PSCustomObject]@{
    OSName          = $osName
    OSVersion       = $osVersion
    CPUName         = $cpuName
    CPUCores        = $cpuCores
    CPULogical      = $cpuLogical
    TotalMemoryGB   = $totalMemoryGB
    UsedMemoryGB    = $usedMemoryGB
    FreeMemoryGB    = $freeMemoryGB
    DiskSizeGB      = $diskSizeGB
    DiskFreeGB      = $diskFreeGB
    Uptime          = $uptimeString
    NetworkAdapters = $netAdapters
}

# Output to console
$result

# Optional export
if ($OutputPath) {
    $extension = [System.IO.Path]::GetExtension($OutputPath).ToLower()

    switch ($extension) {
        ".json" {
            $result | ConvertTo-Json -Depth 4 | Out-File -FilePath $OutputPath -Encoding UTF8
        }
        default {
            $result | Format-List | Out-File -FilePath $OutputPath -Encoding UTF8
        }
    }

    Write-Host "System information written to $OutputPath" -ForegroundColor Green
}
