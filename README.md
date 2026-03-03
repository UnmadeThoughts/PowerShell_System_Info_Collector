# PowerShell System Information Collector

This project contains a PowerShell script that gathers key system information and outputs it in a clean, structured format. It demonstrates scripting fundamentals, automation mindset, and practical tooling commonly used in IT support and systems administration roles.

---

## Overview
The script collects:
- Operating system details  
- CPU information  
- Memory statistics  
- Disk usage  
- Network adapter details  
- System uptime  

The output can be displayed in the console or exported to a file for documentation or troubleshooting purposes.

---

## Why This Script Matters
In IT support and systems administration, technicians often need to quickly gather system information for troubleshooting, documentation, or audits. Automating this process saves time, reduces human error, and ensures consistent output. This script demonstrates the ability to write practical PowerShell tools that streamline common support workflows.

---

## What I Learned
I strengthened my understanding of PowerShell fundamentals, including working with system cmdlets, formatting output, and structuring scripts for readability. I also gained experience thinking about automation from an IT support perspective—identifying repetitive tasks and building tools that make them faster and more reliable.

---

## Script Usage

### Run the script
```powershell
.\Get-SystemInfo.ps1
```
### Export output to a text file
```powershell
.\Get-SystemInfo.ps1 -OutputPath .\systeminfo.txt
```
### Export the output to a JSON file
```powershell
.\Get-SystemInfo.ps1 -OutputPath .\systeminfo.json
```
### Example Output
```
OSName          : Microsoft Windows 10 Pro
OSVersion       : 10.0.19045
CPUName         : Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz
CPUCores        : 4
CPULogical      : 8
TotalMemoryGB   : 15.9
UsedMemoryGB    : 7.8
FreeMemoryGB    : 8.1
DiskSizeGB      : 256
DiskFreeGB      : 120
Uptime          : 3 days, 4 hours, 12 minutes
NetworkAdapters : {@{InterfaceAlias=Ethernet; IPv4=192.168.1.25}}
```
