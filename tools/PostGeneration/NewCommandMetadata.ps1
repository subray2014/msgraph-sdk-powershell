# ------------------------------------------------------------------------------
#  Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
# ------------------------------------------------------------------------------

# Set-StrictMode -Version 2

[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $SourcePath = (Join-Path $PSScriptRoot "..\..\src\"),

    [Parameter()]
    [string]
    $OutputPath = (Join-Path $PSScriptRoot "..\..\src\Authentication\Authentication\custom\common\"),

    [Parameter()]
    [switch]
    $IncludePermissions
)
if (!(Test-Path $SourcePath)) {
    Write-Error "SourcePath is not valid or does not exist. Please ensure that $SourcePath exists then try again."
}

if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath
}

$MgCommandMetadataFile = Join-Path $OutputPath "MgCommandMetadata.json"
$CommandPathMapping = [ordered]@{}

# Regex patterns.
$CmdletPathPattern = Join-Path $SourcePath "\*\*\generated\cmdlets"
$OpenApiTagPattern = '\[OpenAPI\].s*(.*)=>(.*):\"(.*)\"'
$ProfilePattern = 'Profile\("(v1\.0|v1\.0-beta)"\)'
$OutputTypePattern = 'OutputType\(typeof\(Microsoft\.Graph\.PowerShell\.Models\.(.*)\)\)'
$ActionFunctionFQNPattern = "\/Microsoft.Graph.(.*)$"
$PermissionsUrl = "https://graphexplorerapi.azurewebsites.net/permissions"

$v1EntityRelationShipJson = Invoke-RestMethod -Method Get -Uri "https://metadataexplorerstorage.blob.core.windows.net/`$web/cleanv1.js"
$v1EntityRelationShipJson = $v1EntityRelationShipJson.TrimStart("const json = ")
$TargetIndex = $v1EntityRelationShipJson.IndexOf(";")
$v1EntityRelationShipJson = $v1EntityRelationShipJson.Remove($TargetIndex)

$v1EntityRelationships = $v1EntityRelationShipJson | ConvertFrom-Json

$betaEntityRelationShipJson = Invoke-RestMethod -Method Get -Uri "https://metadataexplorerstorage.blob.core.windows.net/`$web/cleanbeta.js"
$betaEntityRelationShipJson = $betaEntityRelationShipJson.TrimStart("const json = ")
$TargetIndex = $betaEntityRelationShipJson.IndexOf(";")
$betaEntityRelationShipJson = $betaEntityRelationShipJson.Remove($TargetIndex)

$betaEntityRelationships = $betaEntityRelationShipJson | ConvertFrom-Json

Write-Debug "Crawling cmdlets in $CmdletPathPattern."
$Stopwatch = [system.diagnostics.stopwatch]::StartNew()
Get-ChildItem -path $CmdletPathPattern -Filter "*.cs" -Recurse | Where-Object { $_.Attributes -ne "Directory" } | ForEach-Object {
    $SplitFileName = $_.BaseName.Split("_")
    $CommandName = (New-Object regex -ArgumentList "Mg").Replace($SplitFileName[0], "-Mg", 1)
    $VariantName = $SplitFileName[1]

    if ($_.DirectoryName -match "\\src\\(.*?.)\\") {
        $ModuleName = $Matches.1
    }

    $RawFileContent = (Get-Content -Path $_.FullName -Raw)
    if ($RawFileContent -match $OpenApiTagPattern) {
        $Method = $Matches.2
        $Uri = $Matches.3

        # Remove FQN in action/function names.
        if ($Uri -match $ActionFunctionFQNPattern) {
            $MatchedUriSegment = $Matches.0
            # Trim nested namespace segments.
            $NestedNamespaceSegments = $Matches.1 -split "\."
            # Remove trailing '()' from functions.
            $LastSegment = $NestedNamespaceSegments[-1] -replace "\(\)", ""
            $Uri = $Uri -replace [Regex]::Escape($MatchedUriSegment), "/$LastSegment"
        }

        $MappingValue = @{
            Command     = $CommandName
            Variants    = [System.Collections.ArrayList]@($VariantName)
            Method      = $Method
            Uri         = $Uri
            ApiVersion  = $null
            OutputType  = $null
            Module      = $ModuleName
            Permissions = @()
            DerivedTypes = @()
        }

        if ($RawFileContent -match $ProfilePattern) {
            $MappingValue.ApiVersion = ($Matches.1 -eq "v1.0-beta") ? "beta" : $Matches.1
        }

        if ($RawFileContent -match $OutputTypePattern) {
            $MappingValue.OutputType = $Matches.1
            $TypeName = $MappingValue.OutputType -replace "IMicrosoftGraph|[\d-]", ""
            $DerivedTypes = @()
            # Find all derived types of OutputType.
            if ($MappingValue.ApiVersion -eq "v1.0") {
                $DerivedTypes = $v1EntityRelationships | Where-Object BaseType -eq $TypeName | Select-Object -ExpandProperty Name
            } else {
                $DerivedTypes = $betaEntityRelationships | Where-Object BaseType -eq $TypeName | Select-Object -ExpandProperty Name
            }

            if ($DerivedTypes -ne $null) { $MappingValue.DerivedTypes =  $DerivedTypes }
        }

        # Disambiguate between /users (Get-MgUser) and /users/{id} (Get-MgUser) by variant name (parameterset) i.e., List and Get.
        if ($VariantName.StartsWith("List")) {
            $CommandMappingKey = "$($MappingValue.Command)_List_$($MappingValue.ApiVersion)"
        }
        else {
            $CommandMappingKey = "$($MappingValue.Command)_$($MappingValue.ApiVersion)"
        }

        if ($CommandPathMapping.Contains($CommandMappingKey)) {
            $CommandPathMapping[$CommandMappingKey].Variants.AddRange($MappingValue.Variants)
        }
        else {
            if ($IncludePermissions) {
                try {
                    Write-Debug "Fetching permissions for $CommandMappingKey"
                    $Permissions = @()
                    $PermissionsResponse = Invoke-RestMethod -Uri "$($PermissionsUrl)?requesturl=$($MappingValue.Uri)&method=$($MappingValue.Method)" -ErrorAction SilentlyContinue
                    $PermissionsResponse | ForEach-Object {
                        $Permissions += [PSCustomObject]@{
                            Name            = $_.value
                            Description     = $_.consentDisplayName
                            FullDescription = $_.consentDescription
                            IsAdmin         = $_.IsAdmin
                        }
                    }
                    $MappingValue.Permissions = ($Permissions | Sort-Object -Property Name -Unique)
                }
                catch {
                    Write-Warning "Failed to fetch permissions: $($PermissionsUrl)?requesturl=$($MappingValue.Uri)&method=$($MappingValue.Method)"
                }
            }
            $CommandPathMapping.Add($CommandMappingKey, $MappingValue)
        }
    }
    else {
        Write-Error "No match for $OpenApiTagPattern"
    }
}
if ($CommandPathMapping.Count -eq 0) {
    Write-Warning "Skipped writing metadata to $MgCommandMetadataFile. Metadata is empty."
}
else {
    Write-Debug "Writing metadata to $MgCommandMetadataFile."
    $CommandPathMapping.GetEnumerator() | Sort-Object Name | Select-Object -ExpandProperty Value | ConvertTo-Json -Depth 4 | Out-File -FilePath $MgCommandMetadataFile
}
$stopwatch.Stop()
Write-Debug "Generated command metadata file in '$($Stopwatch.Elapsed.TotalSeconds)`s."