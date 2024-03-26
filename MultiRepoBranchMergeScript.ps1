Write-Host " "
Write-Host "!!! IMPORTANT: Read the following instructions before proceeding !!!"
Write-Host " "
Write-Host "The branch name should be the same for all repos to be merged with the main branch."
Write-Host " "
Write-Host " "

$branchName = Read-Host -Prompt "Enter the branch name: "

# Define the path to the folder
$tempFolderPath = "C:\Users\Public\My Docs\ex"

# Get a list of all directories inside the folder
$directories = Get-ChildItem -Path $tempFolderPath -Directory

# Loop through each directory
foreach ($directory in $directories) {
    # Change the current working directory to the directory being processed
    Set-Location -Path $directory.FullName

    # Define the script content to execute in each directory
    $scriptContent = @"
git checkout main
git pull
#git merge "monorepo-prep"
git merge $branchName
git push
"@

    # Execute the script content
    Invoke-Expression -Command $scriptContent
}

