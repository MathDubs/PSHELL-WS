# Charger le module Active Directory si nécessaire
Import-Module ActiveDirectory

# Demander à l'utilisateur où les utilisateurs doivent être créés via une boîte de dialogue
Add-Type -AssemblyName System.Windows.Forms
$ouInput = Read-Host "Entrez le chemin LDAP de l'OU où les utilisateurs seront créés (ex: OU=Marketing,DC=exemple,DC=com)", "Sélectionner l'OU", "OU=Default,DC=exemple,DC=com"

# Vérifier que l'utilisateur a bien fourni un chemin OU
if ($ouInput -eq "") {
    Write-Host "Vous devez spécifier un chemin LDAP pour l'OU. Le script sera arrêté."
    exit
}

# Spécifier le chemin du fichier CSV
$csvPath = "C:\Users\Administrateur\Documents\AddUser\MOCK_DATA.csv"

# Importer les données du CSV
$users = Import-Csv -Path $csvPath

# Parcourir chaque ligne du CSV et créer l'utilisateur
foreach ($user in $users) {
    # Définir les variables à partir des colonnes du CSV
    $firstName = $user.first_name
    $lastName = $user.last_name
    $username = $user.user_name
    $password = $user.password

    # Créer l'UPN (User Principal Name) basé sur l'username
    $userPrincipalName = "$username@$ouInput"

    # Créer l'utilisateur dans Active Directory
    New-ADUser -SamAccountName $username `
               -UserPrincipalName $userPrincipalName `
               -GivenName $firstName `
               -Surname $lastName `
               -Name "$firstName $lastName" `
               -DisplayName "$firstName $lastName" `
               -Path $ouInput `
               -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) `
               -Enabled $true `
               -PassThru

    Write-Host "Utilisateur $username créé avec succès dans l'OU $ouInput."
}

Write-Host "Tous les utilisateurs ont été créés avec succès."
