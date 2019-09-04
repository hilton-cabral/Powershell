function Get-HostToIP($hostname) {     
    $result = [system.Net.Dns]::GetHostByName($hostname)     
    $result.AddressList | ForEach-Object {$_.IPAddressToString } 
} 
 
Get-Content "C:\Temp\comps.txt" | ForEach-Object {(Get-HostToIP($_)) >> C:\Temp\IPs.txt}
