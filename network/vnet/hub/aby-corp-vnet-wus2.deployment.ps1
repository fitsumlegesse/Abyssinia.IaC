
$subscriptionId = "4808e0f7-190f-482d-906c-08c77f186e28"
Set-AzContext -Subscriptionid $subscriptionId

$resourceGroupName = "rg-mgmt-it-eastus"
$resourceGroupLocation = [string]"eastus"



$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    Write-Host "Resource group '$resourceGroupName' does not exist.";
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";

    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    $resourceTags = @{ `
            "Group Name"      = "Abyssinia"; `
            "Budget Code"     = ""; `
            "Project ID"      = "azuremig"; `
            "Deployed By"     = "Fitsum Legesse"; `
            "Internal Owner"  = "Fitsum"; `
            "Support Contact" = "ftljobs@yahoo.com"; `
            "SL"              = "5"; `
            "PL"              = "4"; 
    }

    # Assign tags to the resource group
    Set-AzResourceGroup -Name $resourceGroupName -Tag $resourceTags
}
else {
    Write-Host "Using existing resource group '$resourceGroupName'";
}
 
Write-Host "Starting deployment for Azure Virtual Network";

$templateFilePath = "C:\Users\Fitsum\Documents\ftl-projects\Abyssinia\Network\aby-corp-vnet-wus2.template.json"
$templateParameterFilePath = "C:\Users\Fitsum\Documents\ftl-projects\Abyssinia\Network\aby-corp-vnet-wus2.parameteres.json"

$timestamp = ((Get-Date).ToString("MM-dd-yyyy-hh-mm-ss"))
$deploymentName = "Abyssinia" + $timestamp
if (Test-Path $templateParameterFilePath) {
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -location "eastus" -Name $deploymentName -TemplateFile $templateFilePath -TemplateParameterFile $templateParameterFilePath -Mode Incremental -Verbose;
}
else {
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -location "eastus" -Name $deploymentName -TemplateFile $templateFilePath  -Mode Incremental -Verbose;
}
