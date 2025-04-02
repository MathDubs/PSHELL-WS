# Vérifie si le script est exécuté avec des droits d'administrateur
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentPrincipal = New-Object System.Security.Principal.WindowsPrincipal($CurrentUser)
if (-not $CurrentPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ce script doit être exécuté avec des privilèges d'administrateur !"
    exit
}

# Demander si l'utilisateur souhaite changer le nom de l'ordinateur
$changeComputerName = Read-Host "Souhaitez-vous changer le nom de l'ordinateur ? (Oui/Non)"

if ($changeComputerName -eq "Oui" -or $changeComputerName -eq "oui") {
    $newComputerName = Read-Host "Entrez le nouveau nom pour cet ordinateur"
    
    # Vérifier si le nouveau nom est valide
    try {
        Rename-Computer -NewName $newComputerName -Force
        Write-Host "Le nom de l'ordinateur a été changé en : $newComputerName. Le serveur sera redémarré à la fin du script pour appliquer les modifications."
    } catch {
        Write-Host "Erreur lors du changement du nom de l'ordinateur : $_"
        exit
    }
}

# Installer le rôle Active Directory Domain Services (AD DS)
Write-Host "Installation du rôle Active Directory Domain Services (AD DS)..."
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Installer le rôle DNS
Write-Host "Installation du rôle DNS..."
Install-WindowsFeature DNS -IncludeManagementTools

# Demander les informations nécessaires pour la promotion du serveur
$domainName = Read-Host "Entrez le nom de domaine (ex: mon-domaine.local)"
$domainNetbios = Read-Host "Entrez le nom NetBIOS du domaine (ex: MONDOMAINE)"
$siteName = Read-Host "Entrez le nom du site Active Directory (ex: Default-First-Site-Name)"
$administratorPassword = Read-Host "Entrez le mot de passe du compte administrateur du domaine" -AsSecureString

# Promouvoir le serveur en contrôleur de domaine
Write-Host "Promotion du serveur en tant que contrôleur de domaine..."

# Exécution de la commande de promotion pour un nouveau domaine
Install-ADDSDomainController `
    -DomainName $domainName `
    -InstallDNS `
    -DomainNetbiosName $domainNetbios `
    -SiteName $siteName `
    -SafeModeAdministratorPassword $administratorPassword `
    -Force `
    -NoRebootOnCompletion

# Redémarrer le serveur pour appliquer les changements
Write-Host "Le serveur sera redémarré pour finaliser la promotion en contrôleur de domaine et appliquer le changement de nom."
Restart-Computer -Force

Write-Host "Le serveur a été promu en tant que contrôleur de domaine et les rôles AD DS et DNS ont été installés avec succès."
