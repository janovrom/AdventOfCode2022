$fileData = Get-Content .\input.txt

$startx = 0
$starty = 0

$endx = 0
$endy = 0

$heights = New-Object 'char[,]' $fileData.Count, $fileData[0].Length
$visitedValue = New-Object 'int[,]' $fileData.Count, $fileData[0].Length

for ($i = 0; $i -lt $fileData.Count; $i++)
{
    for ($j = 0; $j -lt $fileData[0].Length; $j++) 
    {
        $heights[$i,$j] = $fileData[$i][$j]
        $visitedValue[$i,$j] = [System.Int32]::MaxValue

        if ($heights[$i,$j] -ceq 'S')
        {
            $heights[$i,$j] = [char]96
            $startx = $i
            $starty = $j
        }

        if ($heights[$i,$j] -ceq 'E')
        {
            $heights[$i,$j] = '{'
            $endx = $i
            $endy = $j
        }
    }
}

$steps = New-Object 'System.Collections.Generic.Stack[System.Tuple[int,int,int]]'
$steps.Push([System.Tuple]::Create($startx, $starty, 0))

while ($steps.Count -gt 0)
{
    $step = $steps.Pop()
    [int] $px = $step.Item1
    [int] $py = $step.Item2
    [int] $v = $step.Item3

    if ($visitedValue[$px,$py] -lt $v)
    {
        continue
    }

    $visitedValue[$px,$py] = $v

    [char]$current = $heights[$px,$py]
    if ($current -ceq '{')
    {
        continue
    }

    # go right
    if ($py + 1 -lt $heights.GetLength(1))
    {
        $px1 = $px
        $py1 = $py + 1
        $d = [int]$heights[$px1, $py1] - [int]$current
        if ([System.Math]::Abs($d) -le 1 -and ($visitedValue[$px1,$py1] -gt $v + 1))
        {
            $steps.Push([System.Tuple]::Create($px1, $py1, $v + 1))
        }
    }

    # left
    if ($py - 1 -ge 0)
    {
        $px1 = $px
        $py1 = $py - 1
        $d = [int]$heights[$px1, $py1] - [int]$current
        if ($d -le 1 -and ($visitedValue[$px1,$py1] -gt $v + 1))
        {
            $steps.Push([System.Tuple]::Create($px1, $py1, $v + 1))
        }
    }

    # up
    if ($px - 1 -ge 0)
    {
        $px1 = $px - 1
        $py1 = $py
        $d = [int]$heights[$px1, $py1] - [int]$current
        if ($d -le 1 -and ($visitedValue[$px1,$py1] -gt $v + 1))
        {
            $steps.Push([System.Tuple]::Create($px1, $py1, $v + 1))
        }
    }

    # down
    if ($px + 1 -lt $heights.GetLength(0))
    {
        $px1 = $px + 1
        $py1 = $py
        $d = [int]$heights[$px1, $py1] - [int]$current
        if ($d -le 1 -and ($visitedValue[$px1,$py1] -gt $v + 1))
        {
            $steps.Push([System.Tuple]::Create($px1, $py1, $v + 1))
        }
    }
}


Write-Output "We can get there in" $visitedValue[$endx,$endy] "steps" 
Set-Clipboard ($visitedValue[$endx,$endy])

# for ($i = 0; $i -lt $fileData.Count; $i++)
# {
#     for ($j = 0; $j -lt $fileData[0].Length; $j++) 
#     {
#         Write-Host -NoNewline $fileData[$i][$j]
#     }

#     Write-Host
# }
"" | Out-File -FilePath .\out.log
for ($i = 0; $i -lt $fileData.Count; $i++)
{
    for ($j = 0; $j -lt $fileData[0].Length; $j++) 
    {
        if ($visitedValue[$i,$j] -eq [System.Int32]::MaxValue)
        {
            " `t" | Out-File -FilePath .\out.log -Append -NoNewline
        }
        else
        {
            ($visitedValue[$i,$j].ToString() + "`t") | Out-File -FilePath .\out.log -Append -NoNewline
        }
    }

    "" | Out-File -FilePath .\out.log -Append
}