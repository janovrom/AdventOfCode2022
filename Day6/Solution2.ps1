$fileData = Get-Content input.txt

$characters = 0
for ($i = 0; $i -lt $fileData.Length - 14; $i++)
{
    $marker = $fileData.Substring($i, 14)
    $marker = $marker.ToCharArray() | Sort-Object | Get-Unique
    if ($marker.Length -eq 14)
    {
        $characters = $i + 14
        break;
    }
}

Write-Host "Start-of-packet marker found after" $characters "characters"
Set-Clipboard $characters