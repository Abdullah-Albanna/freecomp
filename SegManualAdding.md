### Creating the neccasry files
* open up powershell, and type in
  
      New-Item -ItemType File -Path "~\.ssh\[IdentityFile]"
* the identity file path should be seen in your SegFault terminal (e.g: ~/.ssh/is_sf-****-segfault.net)
* ```ls ~\.ssh```, if you can see a file called "config", skip this step, if there is no then type

            New-Item -ItemType File -Path "~\.ssh\config"

### Saving the keys and the host
* on your SegFault terminal, there is a private key and a host for your config, you need to select the private key from the "-----BEGIN OPENSSH PRIVATE KEY-----" to "-----END OPENSSH PRIVATE KEY-----" and copy it
* next is typing

             Start-Process notepad.exe -ArgumentList "$HOME\.ssh\[IdentityFile]
* and pasting the private key in there
* next is copying the host configuration, which starts from "host ****" to "SetEnv SECRET= *********" and copy it and past it to

            Start-Process notepad.exe -ArgumentList "$HOME\.ssh\config"
### Setting the permissons
* copy and paste these in powershell one by one

                 $acl2 = Get-Acl ~/.ssh/config
  
                 $acl2.SetAccessRuleProtection($true, $false)

                 $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "FullControl", "Allow")
  
                 $acl2.SetAccessRule($rule2)

                 $acl2 | Set-Acl ~/.ssh/config
* now for the other file
 
    
                 $acl2 = Get-Acl ~/.ssh/[IdentityFile]
  
                 $acl2.SetAccessRuleProtection($true, $false)

                 $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "FullControl", "Allow")
  
                 $acl2.SetAccessRule($rule2)

                 $acl2 | Set-Acl ~/.ssh/[IdentityFile]

### Removing Windows's /r stuff
* type in
      
                      (Get-Content -Path ~\.ssh\[IdentityFile]) -replace '\r', '' | Set-Content -Path ~\.ssh\[IdentityFile]

                      (Get-Content -Path ~\.ssh\config) -replace '\r', '' | Set-Content -Path ~\.ssh\config


**That is it, you can now do "ssh [host]"**
  
