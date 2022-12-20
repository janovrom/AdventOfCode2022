$fileData = Get-Content .\input.txt

$directoryList = New-Object System.Collections.Generic.List[String]
$directories = New-Object "System.Collections.Generic.Dictionary[String,System.Collections.Generic.HashSet[String]]"
$files = New-Object "System.Collections.Generic.Dictionary[String,System.Collections.Generic.HashSet[String]]"
$directorySizes = New-Object "System.Collections.Generic.Dictionary[String,int]"

function GetPath()
{
    $path = ""
    foreach ($dir in $directoryList){
        $path += $dir
        $path += "/"
    }

    return $path
}

foreach ($command in $fileData)
{
    if ($command -eq "$ cd /")
    {
        $directoryList.Clear()
        $directoryList.Add("/")
    }
    elseif ($command -eq "$ cd ..") 
    {
        if ($directoryList.Count -eq 1)
        {
            continue;
        }

        [void] $directoryList.RemoveAt($directoryList.Count - 1)
    }
    elseif ($command.StartsWith("$ cd"))
    {
        $workingDir = GetPath
        $directory = $command.Substring(5)

        if ($directory -eq $workingDir)
        {
            continue;
        }

        if (-not $directories[$workingDir].Contains($directory))
        {
            continue;
        }

        [void] $directoryList.Add($directory)

        # if (-not $directories.ContainsKey($workingDir))
        # {
        #     $directories[$workingDir] = New-Object System.Collections.Generic.HashSet[String]
        # }

        # [void] $directories[$workingDir].Add($directory)
    }
    elseif ($command -eq "$ ls")
    {
        # list files but can be done later
        $workingDir = GetPath
        if (-not $files.ContainsKey($workingDir))
        {
            $files[$workingDir] = New-Object System.Collections.Generic.HashSet[String]
        }

        if (-not $directories.ContainsKey($workingDir))
        {
            $directories[$workingDir] = New-Object System.Collections.Generic.HashSet[String]
        }
    }
    else 
    {
        $workingDir = GetPath
        $splitData = $command.Split(" ")
        if ($splitData[0] -eq "dir") 
        {
            # that's a directory - dir/name
            [void] $directories[$workingDir].Add($splitData[1])
        }
        else 
        {
            # that's a file - size/name
            [void] $files[$workingDir].Add($command)
        }
    }
}

function GetSizes([string] $directory)
{
    foreach ($dir in $directories[$directory])
    {
        GetSizes($directory + $dir + "/")
    }

    $size = 0
    foreach ($dir in $directories[$directory])
    {
        $size += $directorySizes[$directory + $dir + "/"]
    }

    foreach ($file in $files[$directory])
    {
        $size += [int] ($file.Split(" ")[0])
    }

    if ($size -gt 0)
    {
        $directorySizes[$directory] = $size
    }
}

GetSizes("//")

$sortedSizes = $directorySizes.Values | Sort-Object

$rootSize = $directorySizes["//"]
foreach ($size in $sortedSizes)
{
    if (70000000 - $rootSize + $size -ge 30000000)
    {
        Write-Host "The smallest directory to delete has size" $size
        Set-Clipboard $size
        return
    }
}