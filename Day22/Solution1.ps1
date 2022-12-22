$fileData = Get-Content ".\input.txt"
$fileDataPath = Get-Content ".\input-path.txt"

# true for floor, false for wall
$isFloor = New-Object 'System.Collections.Generic.Dictionary[System.Tuple[int,int],bool]'
$rowStarts = New-Object 'System.Collections.Generic.Dictionary[int,int]'
$rowEnds = New-Object 'System.Collections.Generic.Dictionary[int,int]'
$colStarts = New-Object 'System.Collections.Generic.Dictionary[int,int]'
$colEnds = New-Object 'System.Collections.Generic.Dictionary[int,int]'

for ($row = 1; $row -le $fileData.Length; $row++) 
{
    $rowStarts[$row] = $fileData[0].Length + 1
    $rowEnds[$row] = 0
    for ($col = 1; $col -le $fileData[0].Length; $col++) 
    {
        $colStarts[$col] = $fileData.Length + 1
        $colEnds[$col] = 0
    }
}

for ($row = 1; $row -le $fileData.Length; $row++)
{
    $line = $fileData[$row - 1]
    for ($i = 1; $i -le $line.Length; $i++) {
        $tile = $line[$i - 1]
        if ($tile -eq ".") 
        {
            # floor
            $rowStarts[$row] = [Math]::Min($rowStarts[$row], $i)
            $rowEnds[$row] = [Math]::Max($rowEnds[$row], $i)
            $colStarts[$i] = [Math]::Min($colStarts[$i], $row)
            $colEnds[$i] = [Math]::Max($colEnds[$i], $row)
            $isFloor[[System.Tuple]::Create($row, $i)] = $true
        }
        elseif ($tile -eq "#") 
        {
            # wall
            $rowStarts[$row] = [Math]::Min($rowStarts[$row], $i)
            $rowEnds[$row] = [Math]::Max($rowEnds[$row], $i)
            $colStarts[$i] = [Math]::Min($colStarts[$i], $row)
            $colEnds[$i] = [Math]::Max($colEnds[$i], $row)
            $isFloor[[System.Tuple]::Create($row, $i)] = $false
        }
    }
}

$forwards = ($fileDataPath -replace "R"," " -replace "L"," ").Split(" ")
$rotations = $fileDataPath[[regex]::Matches($fileDataPath, "[RL]").Index]

$forward = 0
$rotate = 0
$x = $rowStarts[1]
$y = $colStarts[$x]
$dx = 1
$dy = 0
while ($forward -lt $forwards.Count -or $rotate -lt $rotations.Count) 
{
    # Move
    $f = $forwards[$forward]
    for ($i = 0; $i -lt $f; $i++)
    {
        $ret = $false
        $nextPos = [System.Tuple]::Create($y + $dy, $x + $dx)
        if ($isFloor.TryGetValue($nextPos, [ref]$ret))
        {
            if (-not $ret)
            {
                # We hit the wall so we should stop moving
                break
            }

            $x += $dx
            $y += $dy
        }
        else 
        {
            # We have to wrap
            $tx = $x
            $ty = $y
            if ($dx -eq 1)
            {
                $tx = $rowStarts[$y]
            }
            elseif ($dx -eq -1) 
            {
                $tx = $rowEnds[$y]
            }
            elseif ($dy -eq 1)
            {
                $ty = $colStarts[$x]
            }
            elseif ($dy -eq -1) 
            {
                $ty = $colEnds[$x]
            }

            $pos = [System.Tuple]::Create($ty, $tx)
            if ($isFloor[$pos])
            {
                $x = $tx
                $y = $ty
            }
            else 
            {
                # That's a wall on opposite side
                break
            }
        }

        
    }

    $forward++
    
    # Rotate
    if ($rotate -ge $rotations.Count)
    {
        continue
    }

    $r = $rotations[$rotate]
    if ($r -eq "R")
    {
        $tmp = $dy
        $dy = $dx
        $dx = -$tmp
    }
    else 
    {
        $tmp = $dy
        $dy = -$dx
        $dx = $tmp
    }

    $rotate++
}

if ($dx -eq 0)
{
    if ($dy -eq 1)
    {
        $facing = 1
    }
    else 
    {
        $facing = 3
    }
}
else 
{
    if ($dx -eq 1)
    {
        $facing = 0
    }
    else
    {
        $facing = 2
    }
}

Write-Host "We ended up on row=" $y" and column="$x "with facing" $facing
$password = 1000 * $y + 4 * $x + $facing
Write-Host "Password is" $password
Set-Clipboard $password