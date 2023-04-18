$targetOU = 'OU=TermOU1,DC=domain,DC=com'
Get-Content .\IDs.txt | ForEach-Object {
	Try {
		Write-Host "Moving $($_) ..."
		$result = $_ | Select-Object -Property @{n='SamAccountName'; e={$_}}, Result
		Get-ADUser -Identity $_ -ErrorAction Stop | Move-ADObject -TargetPath $targetOU
		$result.Result = 'OK'
	} Catch {
		$result.Result = "Error: $($_.Exception.Message)"
	}
	Write-Host "... $($result.Result)"
	$result
} | Export-Csv -NoTypeInformation -Path .\moved.csv
