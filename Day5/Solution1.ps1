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

$stacks = New-Object "System.Collections.Generic.Dictionary[String,System.Collections.Generic.Stack[String]]"
$indexLine = $lineStackList[$lineStackList.Count - 2]
for ($k = 1; $k -lt $indexLine.Length; $k+=4)
{
    $stacks[$indexLine[$k]] = New-Object "System.Collections.Generic.Stack[String]"
}

for ($j = $lineStackList.Count - 3; $j -ge 0; $j--)
{
    $line = $lineStackList[$j]
    for ($k = 1; $k -lt $line.Length; $k+=4)
    {
        if ($line[$k] -match "[A-Z]")
        {
            $stacks[$indexLine[$k]].Push($line[$k])
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

    for ($k = 0; $k -lt $count; $k++)
    {
        $stacks[$to].Push($stacks[$from].Pop())
    }
}

$output = ""
for ($k = 1; $k -lt $indexLine.Length; $k+=4)
{
    if ($stacks[$indexLine[$k]].Count -gt 0)
    {
        $output += $stacks[$indexLine[$k]].Peek()
    }
}

Write-Host "The stack tops are" $output
Set-Clipboard $output