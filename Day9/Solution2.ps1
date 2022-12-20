$fileData = Get-Content .\input.txt

$knots = New-Object 'System.Tuple[int,int][]' 10
for ($i = 0; $i -lt 10; $i++)
{
    $knots[$i] = [System.Tuple]::Create(0, 0)
}

$visitedPlaces = New-Object 'System.Collections.Generic.HashSet[System.Tuple[int,int]]'
[void]$visitedPlaces.Add([System.Tuple]::Create(0,0))

function DisplayKnots()
{
    for ($i = 20; $i -ge -20; $i--)
    {
        for ($j = -20; $j -lt 21; $j++)
        {
            $pos = [System.Tuple]::Create($i,$j)

            $found = $false
            for ($k = 0; $k -lt 10; $k++)
            {
                if ($knots[$k] -eq $pos)
                {
                    Write-Host -NoNewline $k
                    $found = $true
                    break
                }
            }

            if (-not $found)
            {
                Write-Host -NoNewline "."
            }
        } 
        Write-Host ""
    }
    Write-Host ""
    Read-Host "Continue..."
}

function IsAdjacent($knot0, $knot1)
{
    $dx = [System.Math]::Abs($knot0.Item1 - $knot1.Item1)
    $dy = [System.Math]::Abs($knot0.Item2 - $knot1.Item2)
    
    $lndistance = [System.Math]::Max($dx, $dy)
    return $lndistance -eq 1 -or $lndistance -eq 0
}

function MoveRope($dirx, $diry, $distance)
{
    for ($i = 0; $i -lt $distance; $i++)
    {
        $xh = $knots[0].Item1 + $dirx
        $yh = $knots[0].Item2 + $diry
        $knots[0] = [System.Tuple]::Create($xh, $yh)

        # drag the tail behind
        for ($j = 0; $j -lt 9; $j++)
        {
            $knot0 = $knots[$j]
            $knot1 = $knots[$j + 1]

            if (IsAdjacent -knot0 $knot0 -knot1 $knot1)
            {
                continue
            }

            $xt = $knot1.Item1 + [System.Math]::Sign($knot0.Item1 - $knot1.Item1)
            $yt = $knot1.Item2 + [System.Math]::Sign($knot0.Item2 - $knot1.Item2)
            
            $knots[$j + 1] = [System.Tuple]::Create($xt, $yt)
        }

        [void]$visitedPlaces.Add($knots[9])
    }
}

function MoveRopeDisplay($dirx, $diry, $distance)
{
    for ($i = 0; $i -lt $distance; $i++)
    {
        $xh = $knots[0].Item1 + $dirx
        $yh = $knots[0].Item2 + $diry
        $knots[0] = [System.Tuple]::Create($xh, $yh)
        DisplayKnots

        # drag the tail behind
        for ($j = 0; $j -lt 9; $j++)
        {
            $knot0 = $knots[$j]
            $knot1 = $knots[$j + 1]

            if (IsAdjacent -knot0 $knot0 -knot1 $knot1)
            {
                continue
            }

            if ($knot0.Item1 -ne $knot1.Item1 -and $knot0.Item2 -ne $knot1.Item2)
            {
                # not in row, nor in column. move diagonally
                $xt = $knot1.Item1 + [System.Math]::Sign($knot0.Item1 - $knot1.Item1)
                $yt = $knot1.Item2 + [System.Math]::Sign($knot0.Item2 - $knot1.Item2)
            }
            else 
            {
                $xt = $knot1.Item1 + [System.Math]::Sign($knot0.Item1 - $knot1.Item1)
                $yt = $knot1.Item2 + [System.Math]::Sign($knot0.Item2 - $knot1.Item2)
            }
            
            $knots[$j + 1] = [System.Tuple]::Create($xt, $yt)
            DisplayKnots
        }

        [void]$visitedPlaces.Add($knots[9])
    }
}

foreach ($action in $fileData)
{
    $direction = $action[0]
    $distance = [System.Int32]::Parse($action.Split(" ")[1])

    switch ($direction) {
        "D" 
        { 
            MoveRope -dirx -1 -diry 0 -distance $distance
        }
        "U" 
        { 
            MoveRope -dirx 1 -diry 0 -distance $distance
        }
        "R" 
        { 
            MoveRope -dirx 0 -diry 1 -distance $distance
        }
        "L" 
        { 
            MoveRope -dirx 0 -diry -1 -distance $distance
        }
        Default {}
    }
}

Write-Host "The tail visited" $visitedPlaces.Count "places"
Set-Clipboard $visitedPlaces.Count