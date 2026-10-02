$ErrorActionPreference = 'Stop'
$catalog = Join-Path (Split-Path $PSScriptRoot -Parent) 'src/SkyDolly/i18n/SkyDolly_zh_CN.ts'
[xml]$document = Get-Content -LiteralPath $catalog -Raw
$errors = @()
$count = 0
foreach ($message in $document.SelectNodes('/TS/context/message')) {
    $source = $message.SelectSingleNode('source').InnerText
    $translation = $message.SelectSingleNode('translation')
    if ($translation.GetAttribute('type') -in @('vanished', 'obsolete')) { continue }
    $forms = @($translation.SelectNodes('numerusform'))
    if (!$forms.Count) { $forms = @($translation) }
    foreach ($form in $forms) {
        $text = $form.InnerText
        if (!$text -or $translation.GetAttribute('type') -eq 'unfinished') {
            $errors += "Unfinished: $source"
            continue
        }
        $sourceTokens = @([regex]::Matches($source, '%(?:L?[1-9][0-9]?|L?n)') | ForEach-Object Value | Sort-Object)
        $targetTokens = @([regex]::Matches($text, '%(?:L?[1-9][0-9]?|L?n)') | ForEach-Object Value | Sort-Object)
        if (($sourceTokens -join '|') -ne ($targetTokens -join '|')) { $errors += "Placeholder mismatch: $source" }
    }
    $count++
}
if ($document.DocumentElement.GetAttribute('language') -ne 'zh_CN') { $errors += 'Incorrect catalog language.' }
if ($errors.Count) { $errors | ForEach-Object { Write-Output $_ }; throw "$($errors.Count) translation errors." }
Write-Output "PASS: $count translated messages; all format placeholders preserved."
