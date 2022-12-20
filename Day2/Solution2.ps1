$fileData = Get-Content ".\input.txt"

$fileData = $fileData -replace "A", "R"
$fileData = $fileData -replace "B", "P"
$fileData = $fileData -replace "C", "S"

$matching = New-Object System.Collections.Generic.Dictionary"[String,Int]"
$matching.Add("R X", 3 + 0)
$matching.Add("R Y", 1 + 3)
$matching.Add("R Z", 2 + 6)

$matching.Add("P X", 1 + 0)
$matching.Add("P Y", 2 + 3)
$matching.Add("P Z", 3 + 6)

$matching.Add("S X", 2 + 0)
$matching.Add("S Y", 3 + 3)
$matching.Add("S Z", 1 + 6)

$score = 0
$iterations = 0
$fileData | Select-Object | foreach { 
    $score = $score + $matching[$_] 
    $iterations += 1
}
Write-Host "Final score is" $score "after" $iterations "iterations"
Set-Clipboard $score