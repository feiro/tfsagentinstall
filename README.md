# tfsagentinstall
## How to install a deploy agent


Installera agent på server

1. Vilken deployment group ska användas? Bör finnas två, en för testmiljöer och en för prod. Skapa en om det inte finns.

2. Installera en agent på servern som miljön ska ligga på (målservern)
  - a. Detta genom att köra bifogat powershell-skriptet och följa instruktionerna
  b. Installera alltid agenten på data-disken (normalt E:)
  c. Du måste här ange kontot som har beställts och du måste ha lösenordet tillgängligt
  d. Ange de taggar som agenten ska lyssna på, t.ex. ”Test, Acceptance” om test och acc-miljö ligger på samma server. (Dessa går att ändra i efterhand via gränssnittet)
    
3. Installera .net 3.5 på målservern med powershell-kommandot ”Install-WindowsFeature NET-Framework-Features”
4. Se till så att kontot som kör agenten (I\tfsdeploy_{systemnamn}_{miljö}) har läsrättigheter till mappen ”C:\Windows\System32\inetsrv\Config”
