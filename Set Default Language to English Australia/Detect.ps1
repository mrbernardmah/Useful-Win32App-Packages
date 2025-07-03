$Path = "HKLM:\Software\Devicie\LanguageXPWIN11ESP\v1.0"
$Name = "SetLanguage-en-AU"
$Type = "DWORD"
$Value = "1"
 
Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Detected"
       Exit 0
    } 

    Exit 1
} 

Catch {

    Exit 1
}