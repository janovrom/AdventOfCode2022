$inputData = Get-Content .\input.txt
$lineStackList = New-Object "System.Collections.Generic.List[String]"

$i = 0
foreach ($line in $inputData) 
{
    $i++
    $lineStackList.Add($line)
    if ($line -eq "")
    {
        break;
    }
}

$lists = New-Object "System.Collections.Generic.Dictionary[String,System.Collections.Generic.List[String]]"
$indexLine = $lineStackList[$lineStackList.Count - 2]
for ($k = 1; $k -lt $indexLine.Length; $k+=4)
{
    $lists[$indexLine[$k]] = New-Object "System.Collections.Generic.List[String]"
}

for ($j = $lineStackList.Count - 3; $j -ge 0; $j--)
{
    $line = $lineStackList[$j]
    for ($k = 1; $k -lt $line.Length; $k+=4)
    {
        if ($line[$k] -match "[A-Z]")
        {
            $lists[$indexLine[$k]].Add($line[$k])
        }
    }
}

# Read instructions
for (;$i -lt $inputData.Length; $i++)
{
    $line = $inputData[$i] -replace "[a-z]","" -replace "\s+"," "
    $instructions = $line.Trim().Split(" ")
    $count = [int]$instructions[0]
    $from = $instructions[1]
    $to = $instructions[2]

    $fromCount = $lists[$from].Count - $count
    for ($k = 0; $k -lt $count; $k++)
    {
        $lists[$to].Add($lists[$from][$fromCount + $k])
    }
    $lists[$from].RemoveRange($fromCount, $count)
}

$output = ""
for ($k = 1; $k -lt $indexLine.Length; $k+=4)
{
    $list = $lists[$indexLine[$k]]
    if ($list.Count -gt 0)
    {
        $output += $list[$list.Count - 1]
    }
}

Write-Host "The stack tops are" $output
Set-Clipboard $output