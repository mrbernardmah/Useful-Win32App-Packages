If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Try {
        &"$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCOMMANDPATH
    }
    Catch {
        Throw "Failed to start $PSCOMMANDPATH"
    }
    Exit
}

# Start logging
Start-Transcript "$($env:ProgramData)\Devicie\Autopilot\Set-Language.log"

#Set variables (change to your needs):
"Set variables"
#Company name
$CompanyName = "XYZ"
"CompanyName = $CompanyName"
# The language we want as new default. Language tag can be found here: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/available-language-packs-for-windows
$LPlanguage = "en-AU"
"LPlanguage = $LPlanguage"
# As In some countries the input locale might differ from the installed language pack language, we use a separate input local variable.
# A list of input locales can be found here: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs
$inputlocale = "en-AU"
"inputlocale = $inputlocale"
# Geographical ID we want to set. GeoID can be found here: https://learn.microsoft.com/en-us/windows/win32/intl/table-of-geographical-locations?redirectedfrom=MSDN
$geoId = "12"  # Australia
"geoId = $geoId"

#Install language pack and change the language of the OS on different places

#Install an additional language pack including FODs
"Installing languagepack"
Install-Language $LPlanguage -CopyToSettings

#Check status of the installed language pack
"Checking installed languagepack status"
$installedLanguage = (Get-InstalledLanguage).LanguageId

if ($installedLanguage -like $LPlanguage){
	Write-Host "Language $LPlanguage installed"
	}
	else {
	Write-Host "Failure! Language $LPlanguage NOT installed"
    Exit 1
}

#Set System Preferred UI Language
"Set SystemPreferredUILanguage $inputlocale"
Set-SystemPreferredUILanguage $inputlocale

# Configure new language defaults under current user (system) after which it can be copied to system
#Set Win UI Language Override for regional changes
"Set WinUILanguageOverride $inputlocale"
Set-WinUILanguageOverride -Language $inputlocale

# Set Win User Language List, sets the current user language settings
"Set WinUserLanguageList"
$OldList = Get-WinUserLanguageList
$UserLanguageList = New-WinUserLanguageList -Language $inputlocale
$UserLanguageList += $OldList | where { $_.LanguageTag -ne $inputlocale }
$UserLanguageList | select LanguageTag
Set-WinUserLanguageList -LanguageList $UserLanguageList -Force

# Set Culture, sets the user culture for the current user account.
"Set culture $inputlocale"
Set-Culture -CultureInfo $inputlocale

# Set Win Home Location, sets the home location setting for the current user 
"Set WinHomeLocation $geoId"
Set-WinHomeLocation -GeoId $geoId

# Copy User Internaltional Settings from current user to System, including Welcome screen and new user
"Copy UserInternationalSettingsToSystem"
Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True

# Add registry key for Intune detection
"Add registry key for Intune detection to HKLM\Software\$CompanyName\LanguageXPWIN11ESP\"
REG add "HKLM\Software\$CompanyName\LanguageXPWIN11ESP\v1.0" /v "SetLanguage-$inputlocale" /t REG_DWORD /d 1

Exit 3010
Stop-Transcript
