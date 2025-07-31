# Collect system info
$computer = Get-WmiObject Win32_ComputerSystem
$os = Get-WmiObject Win32_OperatingSystem
$cpu = Get-WmiObject Win32_Processor
$memory = Get-WmiObject Win32_PhysicalMemory
$diskDrives = Get-WmiObject Win32_DiskDrive

# Prepare output object
$hardwareInfo = [PSCustomObject]@{
    ComputerName      = $env:COMPUTERNAME
    Manufacturer      = $computer.Manufacturer
    Model             = $computer.Model
    TotalPhysicalMemoryGB = "{0:N2}" -f ($computer.TotalPhysicalMemory / 1GB)
    OSName            = $os.Caption
    OSVersion         = $os.Version
    CPUName           = $cpu.Name
    CPUCores          = $cpu.NumberOfCores
    CPULogicalProcessors = $cpu.NumberOfLogicalProcessors
    RAMModulesCount   = $memory.Count
    DiskDrives        = ($diskDrives | ForEach-Object { $_.Model }) -join ", "
    TotalDiskSizeGB   = "{0:N2}" -f (($diskDrives | Measure-Object -Property Size -Sum).Sum / 1GB)
}

# Export to CSV
$outputPath = "$env:USERPROFILE\Desktop\HardwareInventory.csv"
$hardwareInfo | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8

Write-Host "Hardware inventory saved to $outputPath"
