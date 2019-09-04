$FileName = "D:\planilha.xlsm"
$updatefilename = "D:\Planilha\planilha.xlsm"
$FileTime = Get-Date
$Excel = New-Object -ComObject Excel.Application
$Excel.DisplayFullScreen = $true
Invoke-Item $FileName
 
# Loop
for () {
    $excelApp = [Runtime.InteropServices.Marshal]::GetActiveObject("Excel.Application") 
    $excelApp.DisplayFullScreen = $true
    $file = Get-Item $filename
    $updatefile = Get-Item $updatefilename
    if ($updatefile.LastWriteTime -ne $file.LastWriteTime) {
        $excelApp.quit()
        Start-Sleep 5
        Copy-Item $updatefile -Destination $FileName -Force
        Invoke-Item $FileName
    }
    $FileTime = $updatefile.LastWriteTime
    Start-Sleep 7200
} 
