$fileData = Get-Content "./input.txt"

[long]$sum = 0
$fileData | foreach { 
    $mul = 1
    $number = 0
    for ($i = $_.Length - 1; $i -ge 0; $i--) {
        $char = $_[$i]
        if ($char -eq "=") {
            $number += -2 * $mul
        } elseif ($char -eq "-") {
            $number += -1 * $mul
        } else {
            $number += [long]::Parse($char) * $mul
        }

        $mul *= 5
    }

    $number
 } | foreach { Write-Host $_; $sum += $_}

Write-Host "The sum after conversion is" $sum

# convert back to snafu
$snafu = ""
$div = 5
while ($sum -ne 0) {
    $remainder = $sum % $div
    $sum /= $div

    if ($remainder -eq 4) {
        $snafu += "-"
    } elseif ($remainder -eq 3) {
        $snafu += "="
    }
    else {
         $snafu += $remainder
    }
}

$arr = $snafu.ToCharArray()
[array]::Reverse($arr)
$snafu = $arr -join ''

Write-Host "SNAFU representation is" $snafu
Set-Clipboard $snafu