#Parameters
param([string]$source = "C:\temp\source_files", [string]$destination = "C:\temp\target_files")

#Functions

#Function CheckFolder checks for the existence of a specific directory/folder that is passed 
#to it as a parameter. Also, include a switch parameter named create.

function CheckFolder([string]$path, [switch]$create)
{	
	$exists = Test-Path $path
	if(!$exists -and $create){
		#creating the directory as it does not exists when this criteria is met
		mkdir $path | out-null # out null to not put any output in the console 
		$exists = Test-Path $path
	}
	return $exists
}


#Function DisplayFolderStatistics to display folder statistics for a directory/path that is passed to it.

function DisplayFolderStats([string]$path)
{
	$files = dir $path -Recurse | where {!$_.PSIsContainer} #PSIsContainer to exclude folders
	$totals = $files | Measure-Object -Property length -sum
	$stats = "" | Select path,count,size
	$stats.path =$path
	$stats.count = $totals.count
	$stats.size = [math]::round($totals.sum/1MB,2) #[mat] needed because it throws an error about string division
	return $stats
}



# Main processing

# Testing for existence of the source folder (using the CheckFolder function).

$sourceexists = CheckFolder $source

if(!$sourceexists)
{
	Write-Host "The source directory have not been found. Script can not continue without that."
	Exit
}

# Testing for the existence of the destination folder

$destinationexists = CheckFolder $source -create

if(!$destinationexists)
{
	Write-Host "The destination directory can not be created."
	Exit
}

# Copying each file to the appropriate destination.

$files = dir $source -Recurse | where {!$_.PSIsContainer}

foreach ($file in $files)
{
	#checking for extension of the file
	$ext = $file.Extension.Replace(".","")
	$extdestdir = "$destination\$ext"
	$extdestdir
	#checking whether folder exists, creating it if not
	$extdestdirexists = CheckFolder $extdestdir -create	
	
	if(!$extdestdirexists)
	{
		Write-Host "The destination directory ($extdestdir) can not be created."
		Exit
	}
	
	#copy the file
	copy $file.fullname $extdestdir
}


#Displaying each target folder name with the file count and byte count for each folder.

$dirs = dir $destination | where {$_.PSIsContainer} # in this case we only need folders so no ! before current object

$allstats = @() #blank array where stats about subfolders will be stored

foreach($dir in $dirs)
{	#for each subfolder displaying stats about it.
	$allstats += DisplayFolderStats $dir.FullName
	
}

#sorting to display biggest-sized folder at the top
$allstats | sort size -Descending