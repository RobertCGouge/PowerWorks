# Test-Port

## SYNOPSIS
This cmdlet will test a given TCP port till the port is open

## SYNTAX

### ComputerName
```
Test-Port [-Computer] <Object> [-Port] <Int32>
```

### IPAddress
```
Test-Port [-IPv4] <Object> [[-Port] <Int32>]
```

## DESCRIPTION
This cmdlet will continously test a given TCP port untill the cmdlet is halted or a connection to the given port is established. 
This is useful for testing connectivity while configuring firewall rules. 
This function also allows for the verbose switch to be used.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Test-Port -Computer somePC -Port 80
```

### -------------------------- EXAMPLE 2 --------------------------
```
Test-Port -IPv4 someIP -Port 80
```

### -------------------------- EXAMPLE 3 --------------------------
```
Test-Port -Computer somePC -Port 80 -Verbose
```

### -------------------------- EXAMPLE 4 --------------------------
```
Test-Port -IPv4 someIP -Port 80 -Verbose
```

## PARAMETERS

### -Computer
This is the name of the computer you want to test connectivity to

```yaml
Type: Object
Parameter Sets: ComputerName
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPv4
This is the IP address of the computer you want to test connectivity to

```yaml
Type: Object
Parameter Sets: IPAddress
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
This is the port on the remote Computer you want to test connectivity to

```yaml
Type: Int32
Parameter Sets: ComputerName
Aliases: 

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: IPAddress
Aliases: 

Required: False
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

