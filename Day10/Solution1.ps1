$fileData = Get-Content .\input.txt

[int] $x = 1
[int] $cycle = 1
$global:reportedCycle = 20
$global:signalStrength = 0

function ReportCycle($current)
{
    if ($reportedCycle -gt 220)
    {
        return
    }

    if ($cycle -eq $reportedCycle)
    {
        $global:signalStrength += ($cycle * $x)
        $global:reportedCycle += 40
    }
}

foreach ($instruction in $fileData)
{
    ReportCycle -current $cycle
    if ($instruction.StartsWith("noop"))
    {
        $cycle += 1
    }
    else 
    {
        $value = [System.Int32]::Parse($instruction.Split(" ")[1])
        $cycle += 1 # wait cycle
        ReportCycle -current $cycle
        $x += $value
        $cycle += 1
    }
}

Write-Host $reportedCycle
Write-Host "Final signal strength is" $signalStrength
Set-Clipboard $signalStrength