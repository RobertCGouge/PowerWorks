#requires -Version 1
#
# Module manifest for module 'PowerWorks'
#
# Generated by: Robert Gouge
#
# Generated on: 3/26/2017
#

@{
    RootModule        = 'PowerWorks.psm1'
    ModuleVersion     = '0.0.5.0'
    GUID              = '92f21958-43c1-437f-9692-0725cc02405f'
    Author            = 'Robert Gouge'
    CompanyName       = 'Unknown'
    Copyright         = '(c) 2017 Robert Gouge. All rights reserved.'
    Description       = 'A collection of cmdlets and classes to provide enchanced tools for SysAdmins'
    NestedModules     = 'Public\Test-Port.ps1'
    FunctionsToExport = @('Test-Port')
    CmdletsToExport   = @()
    VariablesToExport = '*'
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('SysAdmin', 'Networking', 'System', 'Administration', 'Tools')
            LicenseUri   = 'https://github.com/RobertCGouge/PowerWorks/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/RobertCGouge/PowerWorks'
            ReleaseNotes = '# Version 0.0.5.0 (2017-03-27)
         
## Notes

First Release!

## Functtions

### Test-Port

* Added Test-Port function outline'
        }
    }
}






