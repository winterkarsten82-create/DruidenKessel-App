# ========================================
# AUTOMATISCHES MUSIK-SETUP FÜR WINNIE
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  WINNIE MUSIK SETUP" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Pfade
$quellOrdner = "G:\Meine Ablage\WinnieMusik"
$zielOrdner = "$PSScriptRoot\musik"
$appDatei = "$PSScriptRoot\DruidenApp.html"

# Prüfe ob Quell-Ordner existiert
if (-not (Test-Path $quellOrdner)) {
    Write-Host "FEHLER: WinnieMusik Ordner nicht gefunden!" -ForegroundColor Red
    Write-Host "Pfad: $quellOrdner" -ForegroundColor Red
    Write-Host ""
    Write-Host "Bitte passe den Pfad in diesem Skript an!" -ForegroundColor Yellow
    pause
    exit
}

# Erstelle Ziel-Ordner falls nicht vorhanden
if (-not (Test-Path $zielOrdner)) {
    Write-Host "Erstelle musik Ordner..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $zielOrdner -Force | Out-Null
}

# Kopiere alle MP3-Dateien
Write-Host "Kopiere MP3-Dateien..." -ForegroundColor Green
$mp3Dateien = Get-ChildItem -Path $quellOrdner -Filter "*.mp3"

if ($mp3Dateien.Count -eq 0) {
    Write-Host "WARNUNG: Keine MP3-Dateien gefunden!" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "Gefunden: $($mp3Dateien.Count) MP3-Dateien" -ForegroundColor Cyan
Write-Host ""

foreach ($datei in $mp3Dateien) {
    Write-Host "  Kopiere: $($datei.Name)" -ForegroundColor Gray
    Copy-Item -Path $datei.FullName -Destination $zielOrdner -Force
}

Write-Host ""
Write-Host "Alle Dateien kopiert!" -ForegroundColor Green
Write-Host ""

# Erstelle JavaScript Array für App
Write-Host "Erstelle Datei-Liste für App..." -ForegroundColor Green
$jsArray = "const winnieMusikOrdner = [`n"

foreach ($datei in $mp3Dateien) {
    $jsArray += "            'musik/$($datei.Name)',`n"
}

# Entferne letztes Komma
$jsArray = $jsArray.TrimEnd(",`n") + "`n"
$jsArray += "        ];"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FERTIG!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "$($mp3Dateien.Count) MP3-Dateien kopiert nach:" -ForegroundColor White
Write-Host "$zielOrdner" -ForegroundColor Cyan
Write-Host ""
Write-Host "NÄCHSTER SCHRITT:" -ForegroundColor Yellow
Write-Host "Öffne DruidenApp.html in einem Text-Editor" -ForegroundColor White
Write-Host "Suche nach: const winnieMusikOrdner = [" -ForegroundColor White
Write-Host "Ersetze die Liste mit:" -ForegroundColor White
Write-Host ""
Write-Host $jsArray -ForegroundColor Green
Write-Host ""
Write-Host "ODER kopiere diese Liste in die Zwischenablage:" -ForegroundColor Yellow
$jsArray | Set-Clipboard
Write-Host "✓ In Zwischenablage kopiert! (Strg+V zum Einfügen)" -ForegroundColor Green
Write-Host ""
Write-Host "Dann:" -ForegroundColor Yellow
Write-Host "1. Speichere DruidenApp.html" -ForegroundColor White
Write-Host "2. Öffne App im Browser" -ForegroundColor White
Write-Host "3. Login als Winnie" -ForegroundColor White
Write-Host "4. Musik wird automatisch geladen!" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Datei-Liste auch in Textdatei speichern
$jsArray | Out-File -FilePath "$PSScriptRoot\musik-liste.txt" -Encoding UTF8
Write-Host ""
Write-Host "Liste auch gespeichert in: musik-liste.txt" -ForegroundColor Cyan
Write-Host ""

pause
