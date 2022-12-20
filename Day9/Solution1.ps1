$fileData = Get-Content .\input.txt

[System.Tuple[int,int]]$head = [System.Tuple]::Create(0,0)
[System.Tuple[int,int]]$tail = [System.Tuple]::Create(0,0)

$visitedPlaces = New-Object 'System.Collections.Generic.HashSet[System.Tuple[int,int]]'
[void]$visitedPlaces.Add([System.Tuple]::Create(0,0))

function DisplayPosition()
{
    for ($i = 6; $i -ge 0; $i--)
    {
        for ($j = 0; $j -lt 7; $j++)
        {
            $pos = [System.Tuple]::Create($i,$j)

            if ($pos -eq $head)
            {
                Write-Host -NoNewline "H"
            }
            elseif ($pos -eq $tail) 
            {
                Write-Host -NoNewline "T"
            }
            else 
            {
                Write-Host -NoNewline "."
            }
        } 
        Write-Host ""
    }

    Read-Host "Continue..."
}

function IsAdjacent()
{
    $dx = [System.Math]::Abs($head.Item1 - $tail.Item1)
    $dy = [System.Math]::Abs($head.Item2 - $tail.Item2)
    
    $lndistance = [System.Math]::Max($dx, $dy)
    return $lndistance -eq 1 -or $lndistance -eq 0
}

function MoveRope($dirx, $diry, $distance, [System.Tuple[int,int]]$head, [System.Tuple[int,int]]$tail)
{
    for ($i = 0; $i -lt $distance; $i++)
    {
        $xh = $head.Item1 + $dirx
        $yh = $head.Item2 + $diry
        $head = [System.Tuple]::Create($xh, $yh)

        if (IsAdjacent)
        {
            continue
        }

        # drag the tail behind
        if ($head.Item1 -ne $tail.Item1 -and $head.Item2 -ne $tail.Item2)
        {
            # not in row, nor in column. move diagonally
            $xt = $tail.Item1 + [System.Math]::Sign($head.Item1 - $tail.Item1)
            $yt = $tail.Item2 + [System.Math]::Sign($head.Item2 - $tail.Item2)
        }
        else 
        {
            $xt = $tail.Item1 + $dirx
            $yt = $tail.Item2 + $diry
        }
        
        $tail = [System.Tuple]::Create($xt, $yt)
        [void]$visitedPlaces.Add($tail)
    }

    return $head, $tail
}
foreach ($action in $fileData)
{
    $direction = $action[0]
    $distance = [System.Int32]::Parse($action.Split(" ")[1])

    switch ($direction) {
        "D" 
        { 
            [System.Tuple[int,int]]$head, [System.Tuple[int,int]]$tail = MoveRope -dirx -1 -diry 0 -distance $distance -head $head -tail $tail
        }
        "U" 
        { 
            [System.Tuple[int,int]]$head, [System.Tuple[int,int]]$tail = MoveRope -dirx 1 -diry 0 -distance $distance -head $head -tail $tail
        }
        "R" 
        { 
            [System.Tuple[int,int]]$head, [System.Tuple[int,int]]$tail = MoveRope -dirx 0 -diry 1 -distance $distance -head $head -tail $tail
        }
        "L" 
        { 
            [System.Tuple[int,int]]$head, [System.Tuple[int,int]]$tail = MoveRope -dirx 0 -diry -1 -distance $distance -head $head -tail $tail
        }
        Default {}
    }
}

Write-Host "The tail visited" $visitedPlaces.Count "places"
Set-Clipboard $visitedPlaces.Count