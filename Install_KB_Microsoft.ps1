#========================= KBs ==========================#
$KB7x64 = "\\10.11.13.73\d\Windows7\x64_windows6.1-kb4012212.msu"
$KB7x86 = "\\10.11.13.73\d\Windows7\x86_windows6.1-kb4012212-x86_6bb04d3971bb58ae4bac44219e7169812914df3f.msu"
$KB2008x32 = "\\10.11.13.73\d\Windows2008\windows6.0-kb4012598-x86_13e9b3d77ba5599764c296075a796c16a85c745c.msu"
$KB2008x64 = "\\10.11.13.73\d\Windows2008\windows6.0-kb4012598-x64_6a186ba2b2b98b2144b50f88baf33a5fa53b5d76.msu"
$KB2012 = "\\10.11.13.73\d\Windows2012\windows8-rt-kb4012214-x64_b14951d29cb4fd880948f5204d54721e64c9942b.msu"

#================ Lista de Computadores =================#
$computerlist = Get-Content C:\Temp\Comps.txt    

#=================== Logfile ===================#
$logfile = "C:\Temp\Log.txt"

$results= foreach ($computer in $computerlist)  
{
    $destination = "\\$computer\C$\Windows\Temp\KB.msu"
    $ARCH=(gwmi -Computer $computer -Query "Select OSArchitecture from Win32_OperatingSystem").OSArchitecture  
    $OSVer=(gwmi -Computer $computer -Query "Select Version from Win32_OperatingSystem").version
    If ($ARCH -eq "32-bit") {
             
        if ($OSVer -Like "5.2*" -or $OSVer -Like "5.1*")
        {    
            Write-Host $computer "- Windows XP x86"
        }    
        if ($OSVer -Like "6.0.*")
        {
            Write-Host $(Get-Date) $computer "Windows Server 2008 x86"
            Copy-Item $KB2008x32 -Destination $destination -recurse -force
            $SB={Start-Process -FilePath 'wusa.exe' -ArgumentList "C:\Windows\temp\KB.msu /extract:C:\Windows\temp\" -Wait -PassThru}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB
            $SB={ Start-Process -FilePath 'dism.exe' -ArgumentList "/online /add-package /PackagePath:C:\Windows\temp\Windows6.0-kb4012598-x86.cab /quiet /norestart" -Wait -WindowStyle Hidden}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB 
        }
        if ($OSVer -Like "6.1.*")
        {
            Write-Host $(Get-Date -format "dd/MM/yy | HH:mm:ss") "-" $computer "- Windows 7 (x86"
            Copy-Item $KB7x86 -Destination $destination -recurse -force
            $SB={Start-Process -FilePath 'wusa.exe' -ArgumentList "C:\Windows\temp\KB.msu /extract:C:\Windows\temp\" -Wait -PassThru}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB
            $SB={ Start-Process -FilePath 'dism.exe' -ArgumentList "/online /add-package /PackagePath:C:\Windows\temp\Windows6.1-KB4012212-x64.cab /quiet /norestart" -Wait -WindowStyle Hidden}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB       
        }
        #if ($OSVer -Like "6.2.*")
        #{ 
        #    {"This is a Windows 2012"}      
        #} 
        #if ($OSVer -Like "6.3.*")
        #{
        #    {"This is a Windows 2012R2"}      
        #} 
    }
    
  ElseIf ($ARCH -eq "64-bit") {
                 
        if ($OSVer -Like "5.2*" -or $OSVer -Like "5.1*")
        {    
            Write-Host $computer "- Windows XP x64"
        }    
        if ($OSVer -Like "6.0.*")
        {
            Write-Host $(Get-Date -format "dd/MM/yy | HH:mm:ss") "-" $computer "- Windows Server 2008 x64"
            Copy-Item $KB2008x64 -Destination $destination -recurse -force
            $SB={Start-Process -FilePath 'wusa.exe' -ArgumentList "C:\Windows\temp\KB.msu /extract:C:\Windows\temp\" -Wait -PassThru}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB
            $SB={ Start-Process -FilePath 'dism.exe' -ArgumentList "/online /add-package /PackagePath:C:\Windows\temp\Windows6.0-kb4012598-x64.cab /quiet /norestart" -Wait -WindowStyle Hidden}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB 
        }
        if ($OSVer -Like "6.1.*")
        {
            write-host $(Get-Date -format "dd/MM/yy | HH:mm:ss| ") $computer "| Windows 2012 (x64)"
            Copy-Item $KB7x64 -Destination $destination -recurse -force
            write-host "$Computer - KB copiado com sucesso! - Passo 1 OK"
            $SB={Start-Process -FilePath 'wusa.exe' -ArgumentList "C:\Windows\temp\KB.msu /extract:C:\Windows\temp\" -Wait -PassThru}
            Invoke-Command -ComputerName $computer -ScriptBlock $SB
            write-host "$Computer - KB executado com sucesso - Passo 2 OK"
            $SB={ Start-Process -FilePath 'dism.exe' -ArgumentList "/online /add-package /PackagePath:C:\Windows\temp\Windows6.1-KB4012212-x64.cab /quiet /norestart" -Wait -WindowStyle Hidden}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB    
        }
        if ($OSVer -Like "6.2.*")
        {
            write-host $(Get-Date -format "dd/MM/yy | HH:mm:ss| ") $computer "| Windows 2012 (x64)" 
            Copy-Item $KB2012 -Destination $destination -recurse -force
            write-host "$Computer - KB copiado com sucesso! - Passo 1 OK"
            $SB={Start-Process -FilePath 'wusa.exe' -ArgumentList "C:\Windows\temp\KB.msu /extract:C:\Windows\temp\" -PassThru}
            Invoke-Command -ComputerName $computer -ScriptBlock $SB
            write-host "$Computer - KB executado com sucesso - Passo 2 OK"
            $SB={ Start-Process -FilePath 'dism.exe' -ArgumentList "/online /add-package /PackagePath:C:\Windows\temp\Windows8-RT-KB4012214-x64.CAB /quiet /norestart" -Wait -WindowStyle Hidden}
            Invoke-Command -ComputerName $computer -ScriptBlock $SB   
            write-host "$Computer - Concluido com sucesso!"
        } 
        if ($OSVer -Like "6.3.*")
        {
            Write-output $(Get-Date -format "dd/MM/yy | HH:mm:ss") "|" $computer "| Windows 2012R2 (x64)"
            Copy-Item $KB2012 -Destination $destination -recurse -force
            $SB={Start-Process -FilePath 'wusa.exe' -ArgumentList "C:\Windows\temp\KB.msu /extract:C:\Windows\temp\" -Wait -PassThru}
            #do {} until ($SB.HasExited); # wait...
            #$SB.ExitCode; # <-- this is what I really needed from the output
            Invoke-Command -ComputerName $computer -ScriptBlock $SB
            $SB={ Start-Process -FilePath 'dism.exe' -ArgumentList "/online /add-package /PackagePath:C:\Windows\temp\Windows8-RT-KB4012214-x64.CAB /quiet /norestart" -Wait -WindowStyle Hidden}
            do {} until ($SB.HasExited); # wait...
            $SB.ExitCode;
            Invoke-Command -ComputerName $computer -ScriptBlock $SB  
            
        } 
    }
}
$results | Out-File $logfile -Append
