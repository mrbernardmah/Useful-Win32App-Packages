# Install Language
Set-PreferredLanguage -Language en-AU
Set-SystemPreferredUILanguage -Language en-AU

# Set culture and system locale
Set-Culture -CultureInfo en-AU
Set-WinSystemLocale -SystemLocale en-AU
Set-WinHomeLocation -GeoId 12
Set-WinUILanguageOverride -Language en-AU

# Set user language list to only en-AU
$LangList = New-WinUserLanguageList en-AU
Set-WinUserLanguageList $LangList -Force -Confirm:$false

Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True