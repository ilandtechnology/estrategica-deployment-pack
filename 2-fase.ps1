$WallpaperStyle = "2"
$TileWallpaper   = "0"
$UserProfilesPath = "$env:SystemDrive\Users"

$ppkgName = "ESTRATÉGICA - Microsoft Intune & Entra ID"
$origFolder = "$env:SystemDrive\Temp\provisioning"
$ppkgPath = "$origFolder\estrategica-deployment-pack-main\intune-estrategica.ppkg"

# Ensure the script is running with elevated permissions
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    throw "Este script deve ser executado com permissões elevadas (Administrador)."
}

# $Profiles = Get-ChildItem $UserProfilesPath -Directory | Where-Object {
#     $_.Name -notin @("Default", "Default User", "Public", "All Users", "Administrator", "Administrador")
# }

# foreach ($prof in $Profiles) {
#     $NtUserDat = Join-Path $prof.FullName "NTUSER.DAT"

#     if (Test-Path $NtUserDat) {
#         Write-Host "Processando perfil: $($prof.Name)"
#         try {
#             # Monta o hive temporário
#             reg load "HKU\TempHive" $NtUserDat

#             # Altera as chaves
#             Set-ItemProperty -Path "HKU\TempHive\Control Panel\Desktop" -Name "WallpaperStyle" -Value $WallpaperStyle
#             Set-ItemProperty -Path "HKU\TempHive\Control Panel\Desktop" -Name "TileWallpaper" -Value $TileWallpaper

#             # Desmonta o hive
#             reg unload "HKU\TempHive"

#             Write-Host "Perfil $($prof.Name) atualizado com sucesso."
#         }
#         catch {
#             Write-Warning "Erro ao processar perfil $($prof.Name): $_"
#         }
#     }
#     else {
#         Write-Warning "NTUSER.DAT não encontrado para $($prof.Name)"
#     }
# }

# Register computer in Microsoft Intune & Entra ID
# $ppkgPath = (Copy-Item -Path $ppkgPath -Destination $destFolder -PassThru -Force).VersionInfo.FileName

Get-ProvisioningPackage | Where-Object { $_.PackageName -eq $ppkgName } | ForEach-Object {
    Uninstall-ProvisioningPackage -PackagePath $_.PackageId -ForceUninstall -QuietUninstall
}
Install-ProvisioningPackage -PackagePath $ppkgPath -ForceInstall -QuietInstall