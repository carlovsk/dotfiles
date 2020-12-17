Add-Type -AssemblyName System.Windows.Forms

Function Get-SystemSpecifications() 
{

    $UserInfo = Get-UserInformation;
    $OS = Get-OS;
    $Uptime = Get-Uptime;
    $Shell = Get-Shell;
    $Displays = Get-Displays;
    $Font = Get-Font;
    $CPU = Get-CPU;
    $GPU = Get-GPU;
    $RAM = Get-RAM;


    [System.Collections.ArrayList] $SystemInfoCollection = 
        $UserInfo, 
        $OS,
        $Uptime,
        $Shell,
        $Displays,
        $Font,
        $CPU,
        $GPU,
        $RAM;
    
    return $SystemInfoCollection;
}

Function Get-LineToTitleMappings() 
{ 
    $TitleMappings = @{
        0 = "";
        1 = "OS: "; 
        2 = "Uptime: ";
        3 = "Shell: ";
        4 = "Resolution: ";
        5 = "Font: ";
        6 = "CPU: ";
        7 = "GPU ";
        8 = "RAM: ";
    };

    return $TitleMappings;
}

Function Get-UserInformation()
{
    return $env:USERNAME + "@" + (Get-WmiObject Win32_OperatingSystem).CSName;
}

Function Get-OS()
{
    return (Get-WmiObject Win32_OperatingSystem).Caption;
}

Function Get-Uptime()
{
    $Uptime = ((Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
        (Get-WmiObject Win32_OperatingSystem).LocalDateTime) - 
        (Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
            (Get-WmiObject Win32_OperatingSystem).LastBootUpTime));

    $FormattedUptime =  $Uptime.Days.ToString() + "d " + $Uptime.Hours.ToString() + "h " + $Uptime.Minutes.ToString() + "m " + $Uptime.Seconds.ToString() + "s ";
    return $FormattedUptime;
}

Function Get-Shell()
{
    return "PowerShell $($PSVersionTable.PSVersion.ToString())";
}

Function Get-Displays()
{ 
    $Displays = New-Object System.Collections.Generic.List[System.Object];

    # This gives the available resolutions
    $monitors = Get-WmiObject -N "root\wmi" -Class WmiMonitorListedSupportedSourceModes

    foreach($monitor in $monitors) 
    {
        # Sort the available modes by display area (width*height)
        $sortedResolutions = $monitor.MonitorSourceModes | sort -property {$_.HorizontalActivePixels * $_.VerticalActivePixels}
        $maxResolutions = $sortedResolutions | select @{N="MaxRes";E={"$($_.HorizontalActivePixels) x $($_.VerticalActivePixels) "}}

        $Displays.Add(($maxResolutions | select -last 1).MaxRes);
    }

    return $Displays;
}

Function Get-Font() 
{
    return "Segoe UI";
}

Function Get-CPU() 
{
    return (((Get-WmiObject Win32_Processor).Name) -replace '\s+', ' ');
}

Function Get-GPU() 
{
    return (Get-WmiObject Win32_DisplayConfiguration).DeviceName;
}

Function Get-RAM() 
{
    $FreeRam = ([math]::Truncate((Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1KB)); 
    $TotalRam = ([math]::Truncate((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1MB));
    $UsedRam = $TotalRam - $FreeRam;
    $FreeRamPercent = ($FreeRam / $TotalRam) * 100;
    $FreeRamPercent = "{0:N0}" -f $FreeRamPercent;
    $UsedRamPercent = ($UsedRam / $TotalRam) * 100;
    $UsedRamPercent = "{0:N0}" -f $UsedRamPercent;

    return $UsedRam.ToString() + "MB / " + $TotalRam.ToString() + " MB " + "(" + $UsedRamPercent.ToString() + "%" + ")";
}

