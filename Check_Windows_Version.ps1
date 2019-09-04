#Pegar Versão do Arquivo

(Get-WmiObject -Class CIM_DataFile -Filter "Name='C:\\Windows\\system32\\drivers\\srv.sys'" | Select-Object Version).Version

wmic datafile where name="C:\\Windows\\System32\\drivers\\srv.sys" get Version /value 

Versões do Windows
Versão mínima de Srv.sys atualizada

Windows XP
5.1.2600.7208

Windows Server 2003 SP2
5.2.3790.6021

Windows Vista
Windows Server 2008 SP2
GDR:6.0.6002.19743, LDR:6.0.6002.24067

Windows 7
Windows Server 2008 R2
6.1.7601.23689

Windows 8
Windows Server 2012
6.2.9200.22099

Windows 8.1
Windows Server 2012 R2
6.3.9600.18604

Windows 10 TH1 v1507
10.0.10240.17319

Windows 10 TH2 v1511
10.0.10586.839

Windows 10 RS1 v1607
Windows Server 2016
10.0.14393.953
