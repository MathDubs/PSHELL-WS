# Charger le module ActiveDirectory si nécessaire
Import-Module ActiveDirectory

# Demander à l'utilisateur le nombre d'OUs à créer
$nombreOU = Read-Host "Combien d'OUs voulez-vous créer?"

# Boucle pour créer chaque OU
for ($i = 1; $i -le $nombreOU; $i++) {
    # Demander le nom de l'OU
    $nomOU = Read-Host "Entrez le nom de l'OU numéro $i"
    
    # Demander le chemin (DN) où l'OU sera créée (par exemple: "OU=Test,DC=exemple,DC=com")
    $cheminOU = Read-Host "Entrez le chemin où l'OU sera créée (par exemple: 'OU=Test,DC=exemple,DC=com')"

    # Créer l'OU dans Active Directory
    New-ADOrganizationalUnit -Name $nomOU -Path $cheminOU

    Write-Host "OU '$nomOU' créée avec succès dans '$cheminOU'."
}

Write-Host "Toutes les OUs ont été créées avec succès."
