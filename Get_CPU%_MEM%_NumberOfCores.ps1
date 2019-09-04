$Servers = Get-Content "C:\Temp\comps.txt"
$Array = @()
 
ForEach ($Server in $Servers) {
    $Check = $Processor = $ComputerMemory = $RoundMemory = $Object = $null
    $Server = $Server.trim()
 
    Try {
        # Processor utilization
        $Processor = (Get-WmiObject -ComputerName $Server -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
        #$NProcessor = (Get-WmiObject -ComputerName $Server –class Win32_processor -ErrorAction Stop | Select-Object -Property NumberOfCores)
        $NProcessor = (Get-WmiObject -ComputerName $Server -namespace root\CIMV2 -class Win32_Processor | Measure-Object NumberOfCores).count

        # Memory utilization
        $ComputerMemory = Get-WmiObject -ComputerName $Server -Class win32_operatingsystem -ErrorAction Stop
        $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)
        $RoundMemory = [math]::Round($Memory, 2)
         
        # Creating custom object
        $Object = New-Object PSCustomObject
        $Object | Add-Member -MemberType NoteProperty -Name "Server name" -Value $Server
        $Object | Add-Member -MemberType NoteProperty -Name "CPU %" -Value $Processor
        $Object | Add-Member -MemberType NoteProperty -Name "Memory %" -Value $RoundMemory
        $Object | Add-Member -MemberType NoteProperty -Name "Number of Proc" -Value $NProcessor

        $Object
        $Array += $Object
    }
    Catch {
        Write-Host "Something went wrong ($Server): "$_.Exception.Message
        Continue
    }
}
 
#Final results
If ($Array) { 
    $Array | Out-GridView -Title "CPU and Memory"
    $Array | Export-Csv -Path "C:\users\$env:username\desktop\results.csv" -NoTypeInformation -Force
}
