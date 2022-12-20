$fileData = Get-Content input.txt

$characters = 0
for ($i = 0; $i -lt $fileData.Length - 4; $i++)
{
    $marker = $fileData.Substring($i, 4)
    $marker = $marker.ToCharArray() | Sort-Object | Get-Unique
    if ($marker.Length -eq 4)
    {
        $characters = $i + 4
        break;
    }
}

Write-Host "Start-of-packet marker found after" $characters "characters"
Set-Clipboard $characters