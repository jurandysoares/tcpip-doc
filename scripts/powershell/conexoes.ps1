# Referências:
#  * https://stackoverflow.com/questions/44509183/powershell-get-nettcpconnection-script-that-also-shows-username-process-name
#  * https://docs.microsoft.com/en-us/powershell/module/nettcpip/get-nettcpconnection?view=win10-ps

# Lista conexões TCP/IP estabelecidas entre o computador local e uma máquia remota
Get-NetTCPConnection -State Established | Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort

# Salva os dados do comando acima em um arquivo CSV
$saida_csv = -join(
                   [environment]::getfolderpath(“mydocuments”), 
                   "\", 
                   "Conexoes-", 
                   (Get-Date -format "yyyyMMddHHmmss"), 
                   "-",
                   $env:USERNAME, 
                   ".csv")

Get-NetTCPConnection -State Established | 
    Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort | 
    Export-Csv -Path $saida_csv 

Write-Host "Conexões TCP salvas no arquivo $saida_csv"

# Salva os dados do primeiro comando em um arquivo JSON
$saida_json = -join(
                   [environment]::getfolderpath(“mydocuments”), 
                   "\", 
                   "Conexoes-", 
                   (Get-Date -format "yyyyMMddHHmmss"), 
                   "-",
                   $env:USERNAME, 
                   ".json")

Get-NetTCPConnection -State Established | 
    Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort | 
    Export-Csv -Path $saida_json    

Write-Host "Conexões TCP salvas no arquivo $saida_json"

# A Fazer
# * Copiar arquivos gerados via SCP
# * Exibir os nomes do processo e do usuário a qual ele pertence
## https://mcpmag.com/articles/2018/07/19/transfer-files-via-scp-with-powershell.aspx
# Install-Module -Name Posh-SSH

<#
# Cria um dicionário vazio
$Processos = @{}

# Preenche o dicionário com os dados de cada processo, 
# usando o ID do processo como chave.
Get-Process -IncludeUserName | ForEach-Object {
    $Processos[$_.Id] = $_
}

# Lista as conexões estabelecidas
Get-NetTCPConnection | 
    Where-Object { $_.State -eq "Established" } |
    Select-Object RemoteAddress,
                  RemotePort,
                  @{Name="PID"; Expression={ $_.OwningProcess }},
                  @{Name="ProcessName"; Expression={ $Processos[[int]$_.OwningProcess].ProcessName }},
                  @{Name="UserName"; Expression={ $Processos[[int]$_OwningProcess].Username }} |
    Sort-Object -Property ProcessName, UserName | 
    Format-Table -AutoSize
#>
