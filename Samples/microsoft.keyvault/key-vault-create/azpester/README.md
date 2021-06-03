# Create an Azure Key Vault

[![CI key-vault-create](https://github.com/dupuyjs/AzPester/actions/workflows/key-vault-create.yml/badge.svg)](https://github.com/dupuyjs/AzPester/actions/workflows/key-vault-create.yml)

## Usage

```Powershell
PS C:\AzPester\Samples\network\private-dns-zone\azpester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Output details

```Powershell
Running tests from 'C:\Projects\GitHub\AzPester\Source\Resources\Security\KeyVault\KeyVault.Tests.ps1'
Describing Key Vault azpesterkv Acceptance Tests
 Context Key Vault azpesterkv
   [+] Validate key vault azpesterkv has been provisioned 8ms (1ms|7ms)
   [+] Validate key vault sku is Standard 9ms (8ms|1ms)
   [+] Validate key vault enabledForDeployment is False 4ms (3ms|1ms)
   [+] Validate key vault enabledForTemplateDeployment is False 4ms (3ms|1ms)
   [+] Validate key vault enabledForDiskEncryption is False 4ms (3ms|1ms)
 Context Network Rule Set
   [+] Validate network rule bypass is AzureServices 6ms (2ms|4ms)
   [+] Validate network rule defaultAction is Allow 5ms (4ms|1ms)
 Context Access Policies for 901b44ef-bbee-49d9-9255-38c040e57d0c
   [+] Validate access policies for 901b44ef-bbee-49d9-9255-38c040e57d0c have been provisioned 5ms (2ms|3ms)
   [+] Validate access policies permissionsToKeys is get list 19ms (17ms|2ms)
 Context Secrets
   [+] Validate secret Secret1 is Enabled 1.49s (1.48s|4ms)
Tests completed in 3.72s
Tests Passed: 10, Failed: 0, Skipped: 0 NotRun: 0
```
