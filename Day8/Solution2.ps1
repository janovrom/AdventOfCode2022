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

function VisibleFromTop([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    $score = 0
    for ($i = $x - 1; $i -ge 0; $i--)
    {
        $score += 1
        $v = $heights[$i,$y]
        if ($v -ge $value)
        {
            break
        }
    }

    return $score;
}

function VisibleFromBottom([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    $score = 0
    for ($i = $x + 1; $i -lt $height; $i++)
    {
        $score += 1
        $v = $heights[$i,$y]
        if ($v -ge $value)
        {
            break
        }
    }

    return $score;
}

function VisibleFromLeft([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    $score = 0
    for ($i = $y - 1; $i -ge 0; $i--)
    {
        $score += 1
        $v = $heights[$x,$i]
        if ($v -ge $value)
        {
            break
        }
    }

    return $score;
}

function VisibleFromRight([int] $x, [int] $y)
{
    $value = $heights[$x,$y]
    $score = 0
    for ($i = $y + 1; $i -lt $width; $i++)
    {
        $score += 1
        $v = $heights[$x,$i]
        if ($v -ge $value)
        {
            break
        }
    }

    return $score;
}

function GetScenicScore([int] $x, [int] $y)
{
    
    if (($x -eq 0) -or ($y -eq 0) -or ($x -eq ($height -1)) -or ($y -eq ($width - 1)))
    {
        return 0
    }
    
    return (VisibleFromTop -x $x -y $y) * (VisibleFromBottom -x $x -y $y) * (VisibleFromLeft -x $x -y $y) * (VisibleFromRight -x $x -y $y)
}

$maxScenicScore = 0
for ($i = 1; $i -lt $height - 1; $i++)
{
    for ($j = 1; $j -lt $width - 1; $j++)
    {
        $score = GetScenicScore -x $i -y $j
        $maxScenicScore = [System.Math]::Max($maxScenicScore, $score)
    }
}

Write-Host "The best scenic score is" $maxScenicScore
Set-Clipboard $maxScenicScore