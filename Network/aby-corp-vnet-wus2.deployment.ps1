
$subscriptionId = "149f1c85-2fa5-49d7-bfb3-608d40c1ef51"
Set-AzContext -Subscriptionid $subscriptionId

$resourceGroupName = "neu-pnw-cis-sandbox-rg"
$resourceGroupLocation = [string]"westus2"

# Create Network Resource Group
#Create or check for existing resource group
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    Write-Host "Resource group '$resourceGroupName' does not exist.";
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";

    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    $resourceTags = @{ `
            "Group Name"      = "fr"; `
            "Budget Code"     = "neudesic"; `
            "Project ID"      = "neudesic-cis"; `
            "Deployed By"     = "Fitsum Legesse"; `
            "Internal Owner"  = "fitsum.legesse@neudesic.com"; `
            "Support Contact" = "fitsum.legesse@neudesic.com"; `
            "SL"              = "5"; `
            "PL"              = "4"; 
    }

    # Assign tags to the resource group
    Set-AzResourceGroup -Name $resourceGroupName -Tag $resourceTags
}
else {
    Write-Host "Using existing resource group '$resourceGroupName'";
}

# Start the deployment for the production virtual network in the production enviroment 
Write-Host "Starting deployment for a virtual network";

$templateFilePath = "IaC ARM\aby-corp-vnet-wus2.template.json"
$templateParameterFilePath = "IaC ARM\aby-corp-vnet-wus2.parameteres.json"

$timestamp = ((Get-Date).ToString("MM-dd-yyyy-hh-mm-ss"))
$deploymentName = "Abyssinia" + $timestamp
if (Test-Path $templateParameterFilePath) {
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -location "westus2" -Name $deploymentName -TemplateFile $templateFilePath -TemplateParameterFile $templateParameterFilePath -Mode Incremental -Verbose;
}
else {
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -location "westus2" -Name $deploymentName -TemplateFile $templateFilePath  -Mode Incremental -Verbose;
}
