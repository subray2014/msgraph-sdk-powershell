### Example 1: Code snippet

```powershell

Import-Module Microsoft.Graph.Beta.Applications

$params = @{
	"@odata.id" = "https://graph.microsoft.com/beta/policies/homeRealmDiscoveryPolicies/6c6f154f-cb39-4ff9-bf5b-62d5ad585cde"
}

New-MgBetaServicePrincipalHomeRealmDiscoveryPolicyByRef -ServicePrincipalId $servicePrincipalId -BodyParameter $params

```
This example shows how to use the New-MgBetaServicePrincipalHomeRealmDiscoveryPolicyByRef Cmdlet.

