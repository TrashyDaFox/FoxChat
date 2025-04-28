# Load the necessary DllImport from user32.dll to interact with screen settings
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class ScreenFlip {
    [DllImport("user32.dll")]
    public static extern int SystemParametersInfo(int uAction, int uParam, IntPtr lpvParam, int fuWinIni);
}
"@

# Define the SystemParametersInfo action codes
$SPI_SETDESKWALLPAPER = 0x0014
$SPI_GETDESKWALLPAPER = 0x0015

# Flip screen function
function Flip-Screen {
    $currentRotation = (Get-WmiObject -Class Win32_VideoController).CurrentHorizontalResolution
    if ($currentRotation -eq 1920) {
        # Rotate 90 degrees
        $flip = 1
    } elseif ($currentRotation -eq 1080) {
        # Rotate 180 degrees
        $flip = 2
    } elseif ($currentRotation -eq 1080) {
        $flip = 3;
    };
    }

###
