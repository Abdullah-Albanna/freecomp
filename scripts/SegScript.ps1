# Path to the commands file
$commandsFilePath = "~\Desktop\commands.txt"

# Define the current user's username
$username = $env:USERNAME


# Read commands from the file
$commands = Get-Content -Path $commandsFilePath

# Initialize variables to store private key, host configuration, and private key path
$privateKey = ""
$hostConfig = ""
$privateKeyPath = ""

# Flags to indicate whether we are currently reading the private key, host configuration, or private key path
$readingPrivateKey = $false
$readingHostConfig = $false
$readingPrivateKeyPath = $false

# Loop through each command
foreach ($line in $commands) {
    if ($readingPrivateKey) {
        # Append the line to the private key
        $privateKey += $line + "`n"
        
        # Check if this line ends the private key
        if ($line -like "*END OPENSSH PRIVATE KEY*") {
            $readingPrivateKey = $false
        }
    }
    elseif ($readingHostConfig) {
        # Append the line to the host configuration
        $hostConfig += $line + "`n"
        
        # Check if this line ends the host configuration
        if ($line -like "*SetEnv*") {
            $readingHostConfig = $false
        }
        # Check if this line contains the private key path
        elseif ($line -like "*IdentityFile*") {
            $privateKeyPath = $line -replace '.*IdentityFile\s+(.*)$', '$1'
            $privateKeyPath = $privateKeyPath.Trim()
        }
    }
    else {
        # Check if this line starts the private key
        if ($line -like "*BEGIN OPENSSH PRIVATE KEY*") {
            $readingPrivateKey = $true
            $privateKey += $line + "`n"
        }
        # Check if this line starts the host configuration
        elseif ($line -like "*host*") {
            $readingHostConfig = $true
            $hostConfig += $line + "`n"
        }
    }
}


# Update the host configuration to the proper format
$hostConfig = $hostConfig -replace '(?m)^\s*host\s+(.*)$', 'Host $1' -replace '^(?!Host).+=', '    $&'

# Echo the full private key to the file identified by the private key path
$privateKey | Out-File -FilePath $privateKeyPath -Encoding UTF8

(Get-Content -Path $privateKeyPath) -replace '\r', '' | Set-Content -Path $privateKeyPath

# Echo the host configuration to the ~/.ssh/config file with proper encoding and line endings
$hostConfig | Out-File -FilePath "~/.ssh/config" -Encoding UTF8

# Set the permission for the private key path
$acl1 = Get-Acl $privateKeyPath
$acl1.SetAccessRuleProtection($true, $false)
$rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule($username, "FullControl", "Allow")
$acl1.SetAccessRule($rule1)
$acl1 | Set-Acl $privateKeyPath

# Set the permission for the ~/.ssh/config file
$configFilePath = "~/.ssh/config"
$acl2 = Get-Acl $configFilePath
$acl2.SetAccessRuleProtection($true, $false)
$rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule($username, "FullControl", "Allow")
$acl2.SetAccessRule($rule2)
$acl2 | Set-Acl $configFilePath
