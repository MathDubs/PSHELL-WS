# PSHELL-WS
Ce repo contient plusieurs script PowerShell pour faciliter la gestion d'un windows serveur.


Le script AddAD_DNS :
    - Installe les services AD DS et DNS;
    - Vous propose de modifier en amont le nom de votre serveur, su cela n'a pas encore était fait.

Le script CreateOU.ps1 :
    - Créer des OU dans votre AD;
    - Vous demandes le nombre d'OU souhaité;
    - Vous demande de nommer chaques OU demandé.

Le script CreateUser.ps1 :
    - Créer des users dans votre AD via un fichier .csv;
    - Le fichier .csv doit être stocké "C:\Users\Administrateur\Documents\AddUser\" avec comme nom "MOCK_DATA.csv"
    - Le fichier .csv doit avoir comme colonne "first_name,last_name,user,name,password"
    - Vous demande dans quelle OU les utilisateurs doivent être créés;
