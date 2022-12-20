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
$fileData | foreach {
    $half = $_.Length / 2
    $set = New-Object System.Collections.Generic.HashSet[int]
    foreach ($char in $_.Substring(0, $half).ToCharArray()) { 
        [int]$value = ToValue($char)
        $added = $set.Add($value) 
    }

    $unique = $_.Substring($half, $half).ToCharArray() | Sort-Object | Get-Unique

    foreach ($char in $unique) { 
        
        [int]$value = ToValue($char)
        if ($set.Contains($value))
        {
            $score += $value
        }
    }
}

Write-Host "Score of matching items in compartments is" $score
Set-Clipboard $score