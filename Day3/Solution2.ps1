$fileData = Get-Content ".\input.txt"

function ToValue(){
    param (
        [char] $character
    )
    if (([int]$character) -gt 96)
    {
        # Lowercase
        return [int]$character - 96
    }
    else
    {
        # Uppercase
        return [int]$character - 64 + 26
    }
}

$score = 0
for ($i = 0; $i -lt $fileData.Length; $i+=3)
{
    $elf0 = $fileData[$i+0].ToCharArray() | Sort-Object | Get-Unique
    $elf1 = $fileData[$i+1].ToCharArray() | Sort-Object | Get-Unique
    $elf2 = $fileData[$i+2].ToCharArray() | Sort-Object | Get-Unique
    $items = $elf0 + $elf1 + $elf2
    $uniqueItems = $items | Sort-Object
    for ($j = 0; $j -lt $uniqueItems.Length - 2; $j++) {
        if ($uniqueItems[$j] -eq $uniqueItems[$j+1] -and $uniqueItems[$j] -eq $uniqueItems[$j+2]) {
            $score += ToValue($uniqueItems[$j])
            break;
        }
    }
}



Write-Host "Score of matching items in compartments is" $score
Set-Clipboard $score