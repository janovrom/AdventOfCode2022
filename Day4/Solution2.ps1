function Overlap([int] $minx, [int] $maxx, [int] $miny, [int] $maxy) {
    return ($maxx -ge $miny -and $minx -le $maxy) -or ($maxy -ge $minx -and $miny -le $maxx)
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
    $overlaped = Overlap -minx $minx -maxx $maxx -miny $miny -maxy $maxy
    if ($overlaped){
        $count++
    }
}

Write-Host "The count of overlapping shifts is" $count
Set-Clipboard $count