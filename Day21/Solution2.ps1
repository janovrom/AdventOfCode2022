$fileData = Get-Content ".\input.txt"

$operations = New-Object 'System.Collections.Generic.Dictionary[string,System.Func[Int64,Int64,Int64]]'
$inverseOperations = New-Object 'System.Collections.Generic.Dictionary[string,System.Func[Int64,Int64,Int64]]'
$dependencies = New-Object 'System.Collections.Generic.Dictionary[string,string[]]'
$values = New-Object 'System.Collections.Generic.Dictionary[string,Int64]'

foreach ($line in $fileData) {
    $split = $line.Split(": ")
    $monkey = $split[0]
    
    if ($monkey -eq "humn")
    {
        continue
    }

    $action = $split[1]

    if ($action.Contains("+")) {
        $xy = $action.Split(" + ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x + $y }
        $inverseOperations[$xy[0]] = { param($m,$y) return $m - $y }
        $inverseOperations[$xy[1]] = { param($m,$x) return $m - $x }
    } elseif ($action.Contains("-")) {
        $xy = $action.Split(" - ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x - $y }
        $inverseOperations[$xy[0]] = { param($m,$y) return $m + $y }
        $inverseOperations[$xy[1]] = { param($m,$x) return $x - $m }
    } elseif ($action.Contains("*")) {
        $xy = $action.Split(" * ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x * $y }
        $inverseOperations[$xy[0]] = { param($m,$y) return $m / $y }
        $inverseOperations[$xy[1]] = { param($m,$x) return $m / $x }
    } elseif ($action.Contains("/")) {
        $xy = $action.Split(" / ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x / $y }
        $inverseOperations[$xy[0]] = { param($m,$y) return $m * $y }
        $inverseOperations[$xy[1]] = { param($m,$x) return $x / $m }
    } else {
        # just a number
        $values[$monkey] = [int]::Parse($action)
    }
}

$queue = New-Object 'System.Collections.Generic.Queue[string]'
$stack = New-Object 'System.Collections.Generic.Stack[string]'
[void]$queue.Enqueue("root")

# Simple topo-sort
while ($queue.Count -gt 0) {
    $monkey = $queue.Dequeue()
    [void]$stack.Push($monkey)

    if ($dependencies.ContainsKey($monkey)) {
        foreach ($d in $dependencies[$monkey]) {
            [void]$queue.Enqueue($d)
        }
    }
}

while ($stack.Count -gt 0) {
    $monkey = $stack.Pop()

    if ($values.ContainsKey($monkey)) {
        continue
    }

    if ($operations.ContainsKey($monkey)) {
        $xy = $dependencies[$monkey]
        if (-not $values.ContainsKey($xy[0])) {
            continue
        } 
        
        if (-not $values.ContainsKey($xy[1])) {
            continue
        }

        $value = $operations[$monkey].Invoke($values[$xy[0]], $values[$xy[1]])
        $values[$monkey] = $value
    }
}

$current = $null
# We resolved all we could, now figure out the inverse
if ($values.ContainsKey($dependencies["root"][0])) {
    Write-Host $dependencies["root"][1] "is unknown"
    $current = $dependencies["root"][1]
    $values[$current] = $values[$dependencies["root"][0]]
} else {
    Write-Host $dependencies["root"][0] "is unknown"
    $current = $dependencies["root"][0]
    $values[$current] = $values[$dependencies["root"][1]]
}

do {
    $xy = $dependencies[$current]
    if ($values.ContainsKey($xy[0])) {
        $values[$xy[1]] = $inverseOperations[$xy[1]].Invoke($values[$current], $values[$xy[0]])
        $current = $xy[1]
    } else {
        $values[$xy[0]] = $inverseOperations[$xy[0]].Invoke($values[$current], $values[$xy[1]])
        $current = $xy[0]
    }
} while ($current -ne "humn")

Write-Host "Root monkey shouts" $values["humn"]
Set-Clipboard $values["humn"]