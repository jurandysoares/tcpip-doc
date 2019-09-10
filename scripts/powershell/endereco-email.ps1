<# 
  Referências: 
    * https://stackoverflow.com/questions/8666627/how-to-obtain-email-of-the-logged-in-user-in-powershell
    * 
#>

# Solução 1
$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
$searcher.FindOne().Properties.mail

# Solução 2
([adsi]"LDAP://$(whoami /fqdn)").mail

