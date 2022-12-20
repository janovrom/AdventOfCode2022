$inputData = Get-Content ".\input.txt"

$beacons = New-Object 'System.Collections.Generic.List[System.Tuple[int,int]]'
$sensors = New-Object 'System.Collections.Generic.List[System.Tuple[int,int]]'

function L1Distance($beacon, $sensor)
{
    return [System.Math]::Abs($beacon.Item1 - $sensor.Item1) + [System.Math]::Abs($beacon.Item2 - $sensor.Item2)
}

foreach ($line in $inputData)
{
    $rawData = $line -replace "Sensor at ","" -replace " closest beacon is at ","" -replace "x=","" -replace "y=","" -replace ":",","
    $positions = $rawData.Split(",")
    $sensor = [System.Tuple]::Create([int]$positions[0], [int]$positions[1])
    $beacon = [System.Tuple]::Create([int]$positions[2], [int]$positions[3])
    $beacons.Add($beacon)
    $sensors.Add($sensor)
}

$y = 2000000
$regions = New-Object 'System.Collections.Generic.List[System.Tuple[int,int]]'
for ($i = 0; $i -lt $beacons.Count; $i++)
{
    $beacon = $beacons[$i]
    $sensor = $sensors[$i]
    $distance = L1Distance -beacon $beacon -sensor $sensor

    $c = $distance - [System.Math]::Abs($sensor.Item2 - $y)

    if ($c -lt 0)
    {
        continue
    }

    $x1 = $c + $sensor.Item1
    $x2 = $sensor.Item1 - $c

    $min = [System.Math]::Min($x1, $x2)
    $max = [System.Math]::Max($x1, $x2)
    $regions.Add([System.Tuple]::Create($min, $max))
}

$sortedRegions = $regions | Sort-Object -Property Item1

$previous = $sortedRegions[0]
$impossiblePlaces = 0
for ($i = 1; $i -lt $sortedRegions.Count; $i++)
{
    $region = $sortedRegions[$i]

    # item1 is start
    # item2 is end
    if ($previous.Item2 + 1 -ge $region.Item1)
    {
        # overlap on end, merge them
        $previous = [System.Tuple]::Create($previous.Item1, [System.Math]::Max($previous.Item2, $region.Item2))
    }
    else 
    {
        # they don't overlap. close the previous, update the length and set region as previous
        $impossiblePlaces += $previous.Item2 - $previous.Item1 + 1
        $previous = $region
    }
}

$impossiblePlaces += $previous.Item2 - $previous.Item1 + 1

$filledSpaces = New-Object 'System.Collections.Generic.HashSet[System.Tuple[int,int]]'
$beacons | % { if ($_.Item2 -eq $y) { [void] $filledSpaces.Add($_) } }
$sensors | % { if ($_.Item2 -eq $y) { [void] $filledSpaces.Add($_) } }

$impossiblePlaces -= $filledSpaces.Count

Write-Host "Beacon cannot be present at" $impossiblePlaces "places"
Set-Clipboard $impossiblePlaces