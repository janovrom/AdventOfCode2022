class Monkey
{
    [System.Collections.Generic.List[int]] $items
    [int] $divisor
    [int] $testFail
    [int] $testPass
    [Parameter(Mandatory)]
    [Scriptblock] $operation    
}

$monkeys = New-Object 'Monkey[]' 8
$monkeys[0] = New-Object Monkey
$monkeys[0].items = New-Object System.Collections.Generic.List[int]
(85, 79, 63, 72) | % { $monkeys[0].items.Add($_) }
$monkeys[0].divisor = 2
$monkeys[0].testPass = 2
$monkeys[0].testFail = 6
$monkeys[0].operation = 
{
    param([int] $x)

    return $x * 17
}

$monkeys[1] = New-Object Monkey
$monkeys[1].items = New-Object System.Collections.Generic.List[int]
(53, 94, 65, 81, 93, 73, 57, 92) | % { $monkeys[1].items.Add($_) }
$monkeys[1].divisor = 7
$monkeys[1].testPass = 0
$monkeys[1].testFail = 2
$monkeys[1].operation = 
{
    param($x)

    return $x * $x
}

$monkeys[2] = New-Object Monkey
$monkeys[2].items = New-Object System.Collections.Generic.List[int]
(62, 63) | % { $monkeys[2].items.Add($_) }
$monkeys[2].divisor = 13
$monkeys[2].testPass = 7
$monkeys[2].testFail = 6
$monkeys[2].operation = 
{
    param($x)

    return $x + 7
}

$monkeys[3] = New-Object Monkey
$monkeys[3].items = New-Object System.Collections.Generic.List[int]
(57, 92, 56) | % { $monkeys[3].items.Add($_) }
$monkeys[3].divisor = 5
$monkeys[3].testPass = 4
$monkeys[3].testFail = 5
$monkeys[3].operation = 
{
    param($x)

    return $x + 4
}

$monkeys[4] = New-Object Monkey
$monkeys[4].items = New-Object System.Collections.Generic.List[int]
(67) | % { $monkeys[4].items.Add($_) }
$monkeys[4].divisor = 3
$monkeys[4].testPass = 1
$monkeys[4].testFail = 5
$monkeys[4].operation = 
{
    param($x)

    return $x + 5
}

$monkeys[5] = New-Object Monkey
$monkeys[5].items = New-Object System.Collections.Generic.List[int]
(85, 56, 66, 72, 57, 99) | % { $monkeys[5].items.Add($_) }
$monkeys[5].divisor = 19
$monkeys[5].testPass = 1
$monkeys[5].testFail = 0
$monkeys[5].operation = 
{
    param($x)

    return $x + 6
}

$monkeys[6] = New-Object Monkey
$monkeys[6].items = New-Object System.Collections.Generic.List[int]
(86, 65, 98, 97, 69) | % { $monkeys[6].items.Add($_) }
$monkeys[6].divisor = 11
$monkeys[6].testPass = 3
$monkeys[6].testFail = 7
$monkeys[6].operation = 
{
    param($x)

    return $x * 13
}

$monkeys[7] = New-Object Monkey
$monkeys[7].items = New-Object System.Collections.Generic.List[int]
(87, 68, 92, 66, 91, 50, 68) | % { $monkeys[7].items.Add($_) }
$monkeys[7].divisor = 17
$monkeys[7].testPass = 4
$monkeys[7].testFail = 3
$monkeys[7].operation = 
{
    param($x)

    return $x + 2
}

$inspectedItems = @(0) * 8
$rounds = 20

for ($round = 0; $round -lt $rounds; $round++)
{
    for ($i = 0; $i -lt $monkeys.Length; $i++)
    {
        $monkey = $monkeys[$i]
        foreach ($item in $monkey.items)
        {
            $new = [int]($monkey.operation.Invoke($item))[0]
            $new = [System.Math]::Floor($new / 3)
    
            if ($new % $monkey.divisor -eq 0)
            {
                $monkeys[$monkey.testPass].items.Add($new)
            }
            else 
            {
                $monkeys[$monkey.testFail].items.Add($new)
            }
        }
    
        $inspectedItems[$i] += $monkey.items.Count
        $monkey.items.Clear()
    }
}

for ($i = 0; $i -lt $monkeys.Length; $i++)
{
    $monkey = $monkeys[$i]
    Write-Host -NoNewline "Monkey" $i": "
    foreach ($item in $monkey.items)
    {
        Write-Host -NoNewline $item", "
    }

    Write-Host ""
}

for ($i = 0; $i -lt $monkeys.Length; $i++)
{
    $monkey = $monkeys[$i]
    Write-Host "Monkey" $i "inspected" $inspectedItems[$i] "items"
}

$inspectedItems = $inspectedItems | Sort-Object -Descending
Write-Host "Monkey business is" ($inspectedItems[0] * $inspectedItems[1])
Set-Clipboard ($inspectedItems[0] * $inspectedItems[1])