$fileData = Get-Content ".\input.txt"

class Node {
    [int] $value
    [Node] $next
    [Node] $previous

    Move($loopCount) {
        if ($this.value -eq 0)
        {
            return
        }

        if ($this.value -gt 0)
        {
            $this.MoveRight($loopCount)
        }
        else 
        {
            $this.MoveLeft($loopCount)
        }
    }

    MoveLeft($loopCount) {
        $direction = [System.Math]::Sign($this.value)
        $current = $this
        $stop = $this.value % ($loopCount - 1)
        for ($j = 0; $j -ne $stop; $j += $direction)
        {
            $current = $current.previous
        }

        if ($current -eq $this) {
            return
        }

        $this.InsertBehind($current.previous)
    }

    MoveRight($loopCount)
    {
        $direction = [System.Math]::Sign($this.value)
        $current = $this
        $stop = $this.value % ($loopCount - 1)
        for ($j = 0; $j -ne $stop; $j += $direction)
        {
            $current = $current.next
        }

        if ($current -eq $this) {
            return
        }

        $this.InsertBehind($current)
    }

    InsertBehind($x) {
        $p = $this.previous
        $n = $this.next

        $p.next = $n
        $n.previous = $p

        $xnext = $x.next
        $x.next = $this
        $this.previous = $x

        $xnext.previous = $this
        $this.next = $xnext
    }
}

$nodes = New-Object 'System.Collections.Generic.List[Node]'
$zeroNode = $null
for ($i = 0; $i -lt $fileData.Length; $i++)
{
    $node = New-Object 'Node'
    $value = [int]$fileData[$i]
    if ($value -eq 0)
    {
        $zeroNode = $node
    }
    $node.value = $value
    [void] $nodes.Add($node)
}

for ($i = 0; $i -lt $nodes.Count; $i++)
{
    $node = $nodes[$i]
    $in = ($i + 1) % $nodes.Count
    $ip = ($i - 1)
    if ($ip -lt 0)
    {
        $ip += $nodes.Count
    }

    $node.next = $nodes[$in]
    $node.previous = $nodes[$ip]
}

foreach ($node in $nodes)
{
    $node.Move($nodes.Count)
}

function GetNext($node, $stopAt) {
    $idx = 0
    while ($idx -ne $stopAt) {
        $idx++
        $node = $node.next
    }

    return $node.value
}

$element1000 = GetNext -node $zeroNode -stopAt (1000 % $nodes.Count)
$element2000 = GetNext -node $zeroNode -stopAt (2000 % $nodes.Count)
$element3000 = GetNext -node $zeroNode -stopAt (3000 % $nodes.Count)

$sum = $element1000 + $element2000 + $element3000
Write-Host "Sum of the elements is" $sum
Set-Clipboard $sum