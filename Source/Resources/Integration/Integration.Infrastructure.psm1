function New-TestInfrastructure {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $TestDeploymentInfo,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [HashTable] $Runners,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts
    )

    # Get existing runners resource group
    $RunnersResourceGroup = Get-AzResourceGroup -Name $TestDeploymentInfo.resourceGroupName `
        -ErrorVariable rgDoesNotExist `
        -ErrorAction SilentlyContinue

    Write-Host "[#] Begin creation of the test runners. It can take a few minutes..."

    # Create the group if it does not existZ
    if ($rgDoesNotExist) {
        Write-Information "[#] Creating new resource group $($TestDeploymentInfo.resourceGroupName) in $($TestDeploymentInfo.location) for runners..."
        $RunnersResourceGroup = New-AzResourceGroup -Name $TestDeploymentInfo.resourceGroupName `
            -Location $TestDeploymentInfo.location `
            -Force
    } else {
        Write-Information "[#] Resource group $($TestDeploymentInfo.resourceGroupName) already exists."
    }

    # Creating runners in parallel
    $Runners.GetEnumerator() | ForEach-Object -Parallel {
        $vnet = Get-AzVirtualNetwork -Name $_.Value.vnet `
            -ResourceGroupName $_.Value.contextRef.resourceGroupName `
            -DefaultProfile $_.Value.contextRef.Context `
            -ErrorVariable vnetDoesNotExist `
            -ErrorAction SilentlyContinue
        
        if ($vnetDoesNotExist) {
            Write-Error "[#] Virtual Network $($_.Value.vnet) was not found in resource group $($_.Value.contextRef.resourceGroupName) for runner $($_.Key)."
            Continue
        }

        $subnet = Get-AzVirtualNetworkSubnetConfig -Name $_.Value.subnet `
            -VirtualNetwork $vnet `
            -DefaultProfile $_.Value.contextRef.Context `
            -ErrorVariable subnetDoesNotExist `
            -ErrorAction SilentlyContinue
        
        if ($subnetDoesNotExist) {
            Write-Error "[#] Subnet $($_.Value.subnet) was not found in virtual network $($_.Value.vnet) in resource group $($_.Value.contextRef.resourceGroupName) for runner $($_.Key)."
            Continue
        }

        $vmName = $_.Key
        $vmSku = $_.Value.sku
        $vmSshPublicKey = $_.Value.sshPublicKey

        $vm = Get-AzVM -Name $vmName `
            -ResourceGroupName $using:RunnersResourceGroup.ResourceGroupName `
            -ErrorVariable vmDoesNotExist `
            -ErrorAction SilentlyContinue

        if ($vmDoesNotExist) {
            Write-Information "[#] Virtual machine $($vmName) will be created in subnet: $($subnet.Id)"

            $nicName = "nic-$vmName"
            $nic = New-AzNetworkInterface -Name $nicName `
                -ResourceGroupName $using:RunnersResourceGroup.ResourceGroupName `
                -Location $using:RunnersResourceGroup.Location `
                -SubnetId $subnet.Id `
                -Force

            # General credential for the virtual machine
            $userName = 'azureuser'
            $securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force # Password is not used so it can be leaved as ' '
            $credential = New-Object System.Management.Automation.PSCredential ($userName, $securePassword)

            # Sepcify Name, SKU, OS, Credentials
            $virtualMachine = New-AzVMConfig -VMName $vmName -VMSize $vmSku
            $virtualMachine = Set-AzVMOperatingSystem -VM $virtualMachine -Linux -ComputerName $vmName -Credential $credential
            
            # Set NIC configuration
            $virtualMachine = Add-AzVMNetworkInterface -VM $virtualMachine -Id $nic.Id
            
            # Set the source image
            $virtualMachine = Set-AzVMSourceImage -VM $virtualMachine `
                -PublisherName 'Canonical' `
                -Offer 'UbuntuServer' `
                -Skus '18.04-LTS' `
                -Version latest
            
            # Ephemeral OS: https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks
            $virtualMachine = Set-AzVMOSDisk -VM $virtualMachine `
                -DiffDiskSetting Local `
                -Caching ReadOnly `
                -CreateOption FromImage
            
            # Setting up SSH key
            $virtualMachine = Add-AzVMSshPublicKey -VM $virtualMachine `
                -KeyData $vmSshPublicKey `
                -Path "/home/azureuser/.ssh/authorized_keys"

            # Creating the VM
            New-AzVM -ResourceGroupName $using:RunnersResourceGroup.ResourceGroupName `
                -Location $using:RunnersResourceGroup.Location `
                -VM $virtualMachine | Out-Null

            # Retrieve the created VM
            $vm = Get-AzVM -Name $vmName -ResourceGroupName $using:RunnersResourceGroup.ResourceGroupName
        } else {
            Write-Information "[#] Virtual machine $($vmName) already exists."
        }

        Write-Information "[#] Virtual machine $($vm.Id) is ready."
        $_.Value.vm = $vm
    }

    Write-Host "[#] Creation of the test runners ended."
}

function Remove-TestInfrastructure {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $TestDeploymentInfo
    )

    $ResourceGroupName = $TestDeploymentInfo.resourceGroupName
    
    if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
        throw 'ResourceGroupName input value is Null|Empty or WhiteSpace'
    }

    Write-Host "[#] Removing resource group $ResourceGroupName..."
    Remove-AzResourceGroup -Name $ResourceGroupName -Force
    Write-Host "[#] Resource group $ResourceGroupName has been removed."
}

function Invoke-CheckResourceAccessCommand {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $RunnerVmId,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Hostname,
        [Parameter(Mandatory = $true)]
        [Int64] $Port,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $RunnerContext
    )

    $runCommandResult = Invoke-AzVMRunCommand -ResourceId $RunnerVmId `
        -CommandId RunShellScript `
        -ScriptPath "$($PSScriptRoot)/resource-access-check.sh" `
        -Parameter @{ 'Hostname' = $Hostname; 'Port' = $Port } `
        -DefaultProfile $RunnerContext.Context

    $result = @{ExitCode=-1}
    $result.Status = $runCommandResult.Status
    
    $message = $runCommandResult.Value[0].Message
    $found = $message -match '\[SCRIPT_EXIT_CODE=(\d+)\]'

    if($found) {
        $result.ExitCode = ($matches[1] -as [int])
    }
    
    return $result
}

Export-ModuleMember -Function New-TestInfrastructure
Export-ModuleMember -Function Remove-TestInfrastructure
Export-ModuleMember -Function Invoke-CheckResourceAccessCommand