$fileData = Get-Content ".\input.txt"

$operations = New-Object 'System.Collections.Generic.Dictionary[string,System.Func[Int64,Int64,Int64]]'
$dependencies = New-Object 'System.Collections.Generic.Dictionary[string,string[]]'
$values = New-Object 'System.Collections.Generic.Dictionary[string,Int64]'

foreach ($line in $fileData) {
    $split = $line.Split(": ")
    $monkey = $split[0]
    $action = $split[1]

    if ($action.Contains("+")) {
        $xy = $action.Split(" + ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x + $y }
    } elseif ($action.Contains("-")) {
        $xy = $action.Split(" - ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x - $y }
    } elseif ($action.Contains("*")) {
        $xy = $action.Split(" * ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x * $y }
    } elseif ($action.Contains("/")) {
        $xy = $action.Split(" / ")
        $dependencies[$monkey] = $xy
        $operations[$monkey] = { param($x,$y) return $x / $y }
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
        $value = $operations[$monkey].Invoke($values[$xy[0]], $values[$xy[1]])
        $values[$monkey] = $value
    }
}

Write-Host "Root monkey shouts" $values["root"]
Set-Clipboard $values["root"]