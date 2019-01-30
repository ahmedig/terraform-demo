Param(
    [Parameter(Mandatory = $true)]  [string]$TFStateResourceGroupName,
    [Parameter(Mandatory = $true)]  [string]$TFStateStorageAccountName,
    [Parameter(Mandatory = $true)]  [string]$TFStateStorageAccessKey,
    [Parameter(Mandatory = $true)]  [string]$TFStateContainerName
)


$loc = Get-Command "terraform.exe"
$tfBinaryLocation = $loc.Source
$tfBinaryLocation = $tfBinaryLocation.Substring(0, $tfBinaryLocation.Length - 14)
Write-Host "Found terraform.exe in $tfBinaryLocation"

."$tfBinaryLocation\terraform.exe" init -backend=true `
    -backend-config="resource_group_name=$TFStateResourceGroupName" `
    -backend-config="storage_account_name=$TFStateStorageAccountName" `
    -backend-config="container_name=$TFStateContainerName" `
    -backend-config="access_key=$TFStateStorageAccessKey" `
    -backend-config="key=terraform.tfstate"


$FindTaintedResource = @()
$FindTaintedResource = (."$tfBinaryLocation\terraform.exe" state list | findstr /V "azurerm_resource_group")

ForEach ($MarkTainted in $FindTaintedResource) {
    if ($MarkTainted.contains('[')) {
        $MarkTainted = $MarkTainted -replace "[[\]]", "."
        $MarkTainted = $MarkTainted.Substring(0, $MarkTainted.Length - 1)
    }
    Write-Host "Executing: $tfBinaryLocation\terraform.exe taint $Marktainted"
    ."$tfBinaryLocation\terraform.exe" taint "$Marktainted"
}
