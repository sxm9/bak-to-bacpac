#region local docker image variables

# this is the password for the sa account for the container
if(-not ($containerSaPassword)){
    $containerSaPassword = Get-Credential -Message "Enter a password for the sa account for the container"
}

# Set the temp area so this works x-plat

$dockertempdir = [system.io.path]::GetTempPath() + 'docker/'
if(-not(Test-Path $dockertempdir)){
    New-Item $dockertempdir -ItemType Directory
}
$dockertempcreateimage = "$dockertempdir\create_docker_image.sh"



# This is the path on the host to the directory for testing the image and container
# If you are on Windows and using WSL use the format /mnt/DRIVELETTER/Directory
# If you are using Windows use DRIVELETTER:\PathtoDirectory

$localDockerHostDirectory = 'F:\BackupShare'

#endregion

#region other variables

# This is the name of the Azure Subscription

$AzureSubscriptionName = 'Azure subscription 2'

# This is the name of the Resource Group - will be created if it does not exist
$ResourceGroupName = 'satya(ch)-training'

# The location in Azure in the northeurope format not North Europe
$Location = 'eastus'

#This is the name of the storage account that the backups and bacpacs will be stored in
# must be unique across Azure
$StorageResourceGroupName = 'satya(ch)-training'
$StorageAccountName = 'ch9teststorageaccount'

# This is the name of the share that will be created in the Storage account for storing the backups
$ShareName = 'baks'

# This is the name of the Key Vault - It will be created if it does not exist and
# must be unique across Azure
$KVName = 'beardkvsqlcontainers'

# This is the user who will have access to the Key Vault to set and retrieve secrets
$UserForKeyVault = 'satyabrata@comp9260gmail.onmicrosoft.com'

# This is the name of the Azure Container Registry that will be created
# must be unique across Azure
$ACRName = 'beardacrsqlcontainersd'

# This is the name of the Key Vault secret that will hold the Storage Account SAS key
$AcctKeySecretName = 'storage-acct-key'

# This is the name of the Key Vault secret that will hold the acr pull user
$AcrUserSecretName = 'acr-pull-user'

# This is the name of the Key Vault secret that will hold the acr pull users password
$AcrPassSecretName = 'acr-pull-pass'

# This is the name of the Azure SQL Server. It will be created if it does not exist
$SqlServerName = 'satya-test-server'

# This is the name of the Admin user for the Azure SQL Database
$SqlAdminUser = 'satya'

# This is the password for the admin user for the Azure SQL Database

$SqlServerAdminPwdSecretName = "$SqlServerName-admin"

$GetAzSecretParams = @{
    VaultName   = $KVName 
    Name        = $SqlServerAdminPwdSecretName 
    ErrorAction = 'SilentlyContinue'
}

$SqlAdminPwd = Get-AzKeyVaultSecret @GetAzSecretParams

if(-not $SqlAdminCred){
    $SqlServerAdminCred = Get-Credential -Message "Enter a username and password for the the admin user (Dont use sa) for the Azure SQL Database"
} else{
    $SqlServerAdminCred = New-Object System.Management.Automation.PSCredential($SqlAdminUser, $SqlAdminPwd)
}

# This is the full path to the container and the tag
# folder/image:tag
$ACRPath = 'sql/bak-bacpac:latest'

# This is the local path where backups are stored for copying to the Azure File Share
$onprembackupdirectory = 'F:\BackupShare'

# This is the 'folder' path in the Azure Storage File Share for storing the backups
$ShareFolderPath = '\'

# This is the name of the container group that will be created 
$ContainerGroupName = 'aci-sql-bak-bacpac'

# This is the path in the container that the file share will be mounted
# You probably dont want to change this
# If you do you will also need to change a lot of the docker creation scripts
$VolumeMountPath  = '/mnt/external'

# This is the edition of the Azure SQL Server
$sqlEdition = 'BusinessCritical'

# This is the Service Level of the Azure SQL Database
$sqlSLO = 'BC_Gen5_2'

#endregion
