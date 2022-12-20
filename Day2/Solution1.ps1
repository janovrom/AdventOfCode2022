$fileData = Get-Content ".\input.txt"

$fileData = $fileData -replace "X", "R"
$fileData = $fileData -replace "Y", "P"
$fileData = $fileData -replace "Z", "S"
$fileData = $fileData -replace "A", "R"
$fileData = $fileData -replace "B", "P"
$fileData = $fileData -replace "C", "S"

$matching = New-Object System.Collections.Generic.Dictionary"[String,Int]"
$matching.Add("R R", 1 + 3)
$matching.Add("R P", 2 + 6)
$matching.Add("R S", 3 + 0)

$matching.Add("P R", 1 + 0)
$matching.Add("P P", 2 + 3)
$matching.Add("P S", 3 + 6)

$matching.Add("S R", 1 + 6)
$matching.Add("S P", 2 + 0)
$matching.Add("S S", 3 + 3)

$score = 0
$iterations = 0
$fileData | Select-Object | foreach { 
    $score = $score + $matching[$_] 
    $iterations += 1
}
Write-Host "Final score is" $score "after" $iterations "iterations"
Set-Clipboard $score