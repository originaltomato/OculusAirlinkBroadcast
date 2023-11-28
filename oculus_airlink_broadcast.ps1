# Get the PC name
$PCName = $env:COMPUTERNAME

# Append extra string to PC name
$ExtraString = "-OCULUS"
$PCNameWithExtra = "$PCName$ExtraString"

# Get the local IP address
$LocalIP = (Test-Connection -ComputerName $PCName -Count 1).IPv4Address.IPAddressToString

# Get the process ID of OVRServer_x64.exe
$OculusServerProcess = Get-Process -Name OVRServer_x64

# Get the listening port of OVRServer_x64.exe
$ListeningPort = (Get-NetTCPConnection -OwningProcess $OculusServerProcess.Id -State Listen).LocalPort[0]

# Construct the command for dns-sd.exe
$Command = "C:\windows\System32\dns-sd.exe -P $env:USERNAME::$PCNameWithExtra _oculusal_sp_v2._tcp local $ListeningPort $PCNameWithExtra.local $LocalIP"

echo $Command

# Run the command
try {
    Invoke-Expression $Command
}
catch {
    Write-Host "Error running DNS-SD command: $_"
}
