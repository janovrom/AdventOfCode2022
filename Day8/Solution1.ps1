$fileData = Get-Content .\input.txt

$height = $fileData.Count
$width = $fileData[0].Length
[int[,]] $heights = (New-Object 'int[,]' $height,$width)

for ($i = 0; $i -lt $height; $i++)
{
    $line = $fileData[$i]
    for ($j = 0; $j -lt $width; $j++)
    {
        $value = [int]$line[$j] - 48
        $heights[$i,$j] = $value
    }
}

function IsVisibleFromTop([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    for ($i = $x - 1; $i -ge 0; $i--)
    {
        $v = $heights[$i,$y]
        if ($v -ge $value)
        {
            return $false
        }
    }

    return $true;
}

function IsVisibleFromBottom([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    for ($i = $x + 1; $i -lt $height; $i++)
    {
        $v = $heights[$i,$y]
        if ($v -ge $value)
        {
            return $false
        }
    }

    return $true;
}

function IsVisibleFromLeft([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    for ($i = $y - 1; $i -ge 0; $i--)
    {
        $v = $heights[$x,$i]
        if ($v -ge $value)
        {
            return $false
        }
    }

    return $true;
}

function IsVisibleFromRight([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    for ($i = $y + 1; $i -lt $width; $i++)
    {
        $v = $heights[$x,$i]
        if ($v -ge $value)
        {
            return $false
        }
    }

    return $true;
}

function IsVisible([int] $x, [int] $y)
{
    
    if (($x -eq 0) -or ($y -eq 0) -or ($x -eq ($height -1)) -or ($y -eq ($width - 1)))
    {
        return $true
    }
    
    return (IsVisibleFromTop -x $x -y $y) -or (IsVisibleFromBottom -x $x -y $y) -or (IsVisibleFromLeft -x $x -y $y) -or (IsVisibleFromRight -x $x -y $y)
}

$visibleTreeCount = 0
for ($i = 0; $i -lt $height; $i++)
{
    for ($j = 0; $j -lt $width; $j++)
    {
        if (IsVisible -x $i -y $j)
        {
            $visibleTreeCount += 1
        }
    }
}

Write-Host "There are" $visibleTreeCount "visible trees"
Set-Clipboard $visibleTreeCount