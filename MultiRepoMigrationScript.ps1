Write-Host " "
Write-Host "!!! IMPORTANT: Read the following instructions before proceeding !!!"
Write-Host " "
Write-Host "This script is used to migrate multiple repos into a single destination repo cloned in your local computer that has a folder called 'pack'. All repos will be merged inside the 'pack' folder. Your source path should lead to a directory containing multiple cloned local repos that needs to be merged."
Write-Host " "
Write-Host " "

$source = Read-Host -Prompt "Enter your source path: "
$dest = Read-Host -Prompt "Enter your destination repo path: "

# Define the path to the "source" folder
#$sourceDirectory = "C:\Users\Public"
$sourceDirectory = $source

# Define destination repo path
#$destinationRepoPath = "C:\Users\Public\dist-repo"
$destinationRepoPath = $dest

# Get a list of all directories inside the "temp" folder
$directories = Get-ChildItem -Path $sourceDirectory -Directory

# Loop through each directory
foreach ($directory in $directories) {
    # Change the current working directory to the directory being processed
    Set-Location -Path $directory.FullName

    # Define the directory name
    $folderName = $directory.Name

    # Define the script content to execute in each directory
    $prepareRepoScript = @"
# Create a new branch named "monorepo-prep" and switch to it
git checkout -b "monorepo-prep"

# Create directories
mkdir pack
mkdir "pack\$folderName"  # Create folder with the same name as the directory

# Move directories from source to a subdirectory
move * "pack\$folderName"

# Commit changes to prepare for migration
git add -A
git commit -m "Prep for monorepo migration"
"@

    # Execute the script content
    Invoke-Expression -Command $prepareRepoScript

    # Change the current working directory to the destination directory
    Set-Location -Path $destinationRepoPath

    # Define the script content to execute in each directory
    $mergeRepoScript = @"
    git remote add -f $folderName "$sourceDirectory\$folderName"
    git merge $folderName/monorepo-prep --no-commit --allow-unrelated-histories
    git add -A
    git commit -m "Merging repos"
    git remote rm $folderName
"@

    # Execute the script content
    Invoke-Expression -Command $mergeRepoScript
}

