function Contained([int] $minx, [int] $maxx, [int] $miny, [int] $maxy) {
    return ($minx -le $miny -and  $maxx -ge $maxy) -or ($minx -ge $miny -and  $maxx -le $maxy)
}

$fileData = Get-Content ".\input.txt"

$count = 0

foreach ($line in $fileData) {
    $sections = $line.Split(",")
    $section0 = $sections[0].Split("-")
    $section1 = $sections[1].Split("-")
    [int] $minx = [int]($section0[0])
    [int] $maxx = [int]($section0[1])
    [int] $miny = [int]($section1[0])
    [int] $maxy = [int]($section1[1])
    $contained = Contained -minx $minx -maxx $maxx -miny $miny -maxy $maxy
    if ($contained){
        $count++
    }
}

Write-Host "The count of overlapping shifts is" $count
Set-Clipboard $count