$ErrorActionPreference="Stop";
If(-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent() ).IsInRole( [Security.Principal.WindowsBuiltInRole] 'Administrator')){ throw "Run command in Administrator PowerShell Prompt"};
If($PSVersionTable.PSVersion -lt (New-Object System.Version("3.0"))){ throw "The minimum version of Windows PowerShell that is required by the script (3.0) does not match the currently running version of Windows PowerShell." };

$Drive = Read-Host -Prompt 'Vilken disk ska agenten installeras på (D: eller E:)?'
$DeploymentGroupName = Read-Host -Prompt 'Ange namn på deployment group (tex Valda)'
$AgentName = Read-Host -Prompt 'Ange agentnamn (tex Valda-Test)'
$ProjectName = Read-Host -Prompt 'Ange projektnamn (samma som teamprojektet heter i TFS)'

If(-NOT (Test-Path $Drive\'vstsagent'))
{
	mkdir $Drive\'vstsagent'
};

cd $Drive\'vstsagent'; 

for($i=1; $i -lt 100; $i++)
{
	$destFolder="A"+$i.ToString();
	if(-NOT (Test-Path ($destFolder))){
		mkdir $destFolder;
		cd $destFolder;
		break;
	}
}; 

$agentZip="$PWD\agent.zip";
$DefaultProxy=[System.Net.WebRequest]::DefaultWebProxy;
$securityProtocol=@();
$securityProtocol+=[Net.ServicePointManager]::SecurityProtocol;
$securityProtocol+=[Net.SecurityProtocolType]::Tls12;

[Net.ServicePointManager]::SecurityProtocol=$securityProtocol;

$WebClient=New-Object Net.WebClient; 
$Uri='https://go.microsoft.com/fwlink/?linkid=872265';

if($DefaultProxy -and (-not $DefaultProxy.IsBypassed($Uri)))
{
	$WebClient.Proxy= New-Object Net.WebProxy($DefaultProxy.GetProxy($Uri).OriginalString, $True);
}; 

$WebClient.DownloadFile($Uri, $agentZip);

Add-Type -AssemblyName System.IO.Compression.FileSystem;
[System.IO.Compression.ZipFile]::ExtractToDirectory( $agentZip, "$PWD");

.\config.cmd --deploymentgroup --deploymentgroupname $DeploymentGroupName --agent $AgentName --runasservice --work '_work' --url 'https://tfs.i.uhr.se/' --collectionname 'DefaultCollection' --projectname $ProjectName; 

Remove-Item $agentZip;