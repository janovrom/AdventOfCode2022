$fileData = Get-Content ".\input.txt"

$set = New-Object 'System.Collections.Generic.HashSet[System.Tuple[int,int,int]]'
foreach ($line in $fileData)
{
    $split = $line.Split(",")
    [void]$set.Add([System.Tuple]::Create([int]$split[0], [int]$split[1], [int]$split[2]))
}

$minx = 0
$maxx = 0

$miny = 0
$maxy = 0

$minz = 0
$maxz = 0
foreach ($value in $set)
{
    $minx = [System.Math]::Min($minx, $value.Item1)
    $maxx = [System.Math]::Max($maxx, $value.Item1)

    $miny = [System.Math]::Min($miny, $value.Item2)
    $maxy = [System.Math]::Max($maxy, $value.Item2)

    $minz = [System.Math]::Min($minz, $value.Item3)
    $maxz = [System.Math]::Max($maxz, $value.Item3)
}

# just add small padding to make sure we are outside
$minx -= 1
$miny -= 1
$minz -= 1
$maxx += 1
$maxy += 1
$maxz += 1

$flooded = New-Object 'System.Collections.Generic.HashSet[System.Tuple[int,int,int]]'
$floodExpansion = New-Object 'System.Collections.Generic.Stack[System.Tuple[int,int,int]]'

[void]$floodExpansion.Push([System.Tuple]::Create($minx, $miny, $minz))
while ($floodExpansion.Count -gt 0)
{
    $value = $floodExpansion.Peek()
    [void]$floodExpansion.Pop()

    [void]$flooded.Add($value)

    $leftx = [System.Tuple]::Create($value.Item1 - 1, $value.Item2, $value.Item3)
    $rightx = [System.Tuple]::Create($value.Item1 + 1, $value.Item2, $value.Item3)

    $lefty = [System.Tuple]::Create($value.Item1, $value.Item2 - 1, $value.Item3)
    $righty = [System.Tuple]::Create($value.Item1, $value.Item2 + 1, $value.Item3)

    $leftz = [System.Tuple]::Create($value.Item1, $value.Item2, $value.Item3 - 1)
    $rightz = [System.Tuple]::Create($value.Item1, $value.Item2, $value.Item3 + 1)

    $directions = @($leftx, $rightx, $lefty, $righty, $leftz, $rightz)
    foreach ($dir in $directions)
    {
        if ($dir.Item1 -lt $minx -or $dir.Item1 -gt $maxx)
        {
            continue
        }

        if ($dir.Item2 -lt $miny -or $dir.Item2 -gt $maxy)
        {
            continue
        }

        if ($dir.Item3 -lt $minz -or $dir.Item3 -gt $maxz)
        {
            continue
        }

        if ((-not $set.Contains($dir)) -and (-not $flooded.Contains($dir)))
        {
            [void]$floodExpansion.Push($dir)
        }
    }
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
        if ($flooded.Contains($dir))
        {
            $surface += 1
        }
    }
}

Write-Host "The surface area is" $surface
Set-Clipboard $surface