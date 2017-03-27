---
external help file: PowerWorks-help.xml
online version: http://powerworks.readthedocs.io/en/latest/functions/Test-Port.md
schema: 2.0.0
---

# Test-Port

## SYNOPSIS
This cmdlet will test a given TCP port till the port is open

## SYNTAX

```
Test-Port [-Computer] <Object> [-Port] <Int32>
```

## DESCRIPTION
This cmdlet will continously test a given TCP port untill the cmdlet is halted or a connection to the given port is established. 
This is useful for testing connectivity while configuring firewall rules.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Test-Port -Computer somePC -Port 80
```

### -------------------------- EXAMPLE 2 --------------------------
```
Test-Port -Computer someIP -Port 80
```

## PARAMETERS

### -Computer
This is the name or IP address of the computer you want to test connectivity to

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Port
This is the port on the remote Computer you want to test connectivity to

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### This script has no outputs.

## NOTES

## RELATED LINKS

[http://powerworks.readthedocs.io/en/latest/functions/Test-Port.md](http://powerworks.readthedocs.io/en/latest/functions/Test-Port.md)

[https://github.com/RobertCGouge/PowerWorks/blob/master/PowerWorks/Public/Test-Port.ps1](https://github.com/RobertCGouge/PowerWorks/blob/master/PowerWorks/Public/Test-Port.ps1)

