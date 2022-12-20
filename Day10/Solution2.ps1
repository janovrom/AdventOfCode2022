$fileData = Get-Content .\input.txt

[int] $x = 1
[int] $cycle = 0
$results = New-Object 'System.Collections.Generic.List[string]'

function ReportCycle($current, $value)
{
    $pixel = ($current) % 40
    if (($pixel -le $value + 1) -and ($pixel -ge $value - 1))
    {
        return "#"
    }
    else 
    {
        return " "
    }
}

foreach ($instruction in $fileData)
{
    $result = ReportCycle -current $cycle -value $x
    [void] $results.Add($result)
    if ($instruction.StartsWith("noop"))
    {
        $cycle += 1
    }
    else 
    {
        $value = [System.Int32]::Parse($instruction.Split(" ")[1])
        $cycle += 1 # wait cycle

        $result = ReportCycle -current $cycle -value $x
        [void] $results.Add($result)

        $x += $value
        $cycle += 1
    }
}

for ($i = 0; $i -lt $results.Count; $i++)
{
    $shouldPad = ($i + 1) % 5 -eq 0
    if ($shouldPad)
    {
        Write-Host -NoNewline "   "
    }
    else 
    {
        Write-Host -NoNewline $results[$i]
    }

    if (($i + 1) % 40 -eq 0)
    {
        Write-Host ""
    }
}