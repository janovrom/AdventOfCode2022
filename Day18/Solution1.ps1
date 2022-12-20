$fileData = Get-Content ".\input.txt"

$set = New-Object 'System.Collections.Generic.HashSet[System.Tuple[int,int,int]]'
foreach ($line in $fileData)
{
    $split = $line.Split(",")
    [void]$set.Add([System.Tuple]::Create([int]$split[0], [int]$split[1], [int]$split[2]))
}

$surface = 0
foreach ($value in $set)
{
    $leftx = [System.Tuple]::Create($value.Item1 - 1, $value.Item2, $value.Item3)
    $rightx = [System.Tuple]::Create($value.Item1 + 1, $value.Item2, $value.Item3)

    $lefty = [System.Tuple]::Create($value.Item1, $value.Item2 - 1, $value.Item3)
    $righty = [System.Tuple]::Create($value.Item1, $value.Item2 + 1, $value.Item3)

    $leftz = [System.Tuple]::Create($value.Item1, $value.Item2, $value.Item3 - 1)
    $rightz = [System.Tuple]::Create($value.Item1, $value.Item2, $value.Item3 + 1)

    $directions = @($leftx, $rightx, $lefty, $righty, $leftz, $rightz)

    foreach ($dir in $directions)
    {
        if (-not $set.Contains($dir))
        {
            $surface += 1
        }
    }
}

Write-Host "The surface area is" $surface
Set-Clipboard $surface