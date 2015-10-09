# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                                                                                           Rikard Ronnkvist / snowland.se
#  Will rename JPG and AVI files, uses EXIF-tag on JPG-images and filedate on AVI-files.
#
#  Files will be named:
#    \some path\YYYYMM\YYYYMMDD_HHMMSS_00.JPG
#               ^^^^^^ - Optional, if you have createSubdir set to True
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$basePath = "F:\Pictures\Import dir"
$createSubdir = $True
$testMode = $False
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Download from:  http://code.msdn.microsoft.com/PowerShellPack
Import-Module PowerShellPack

 # Add \* to use when searching
 $searchPath = $basePath + "\*"

  # Search for files
  Write-Host "           Searching: " -ForegroundColor DarkGray -NoNewline
  Write-Host $basePath -ForegroundColor Yellow

   $allFiles  = Get-ChildItem -Path $searchPath -Include *.AVI,*.JPG -Exclude folder.jpg

    Write-Host "               Found: " -ForegroundColor DarkGray -NoNewline
    Write-Host $allFiles.Count -ForegroundColor Yellow -NoNewline
    Write-Host " files" -ForegroundColor DarkGray

     $fNum = 0
     # Loop thru all files
     foreach ($file in $allFiles )
     {
         $fNum++
             # If it is an jpg use the exif-data, otherwise use date on file
                 if ($file.Extension -eq ".JPG") {
                         $imgInfo = $file | Get-Image | Get-ImageProperty
                                 $fileDate = $imgInfo.dt
                                     } else {
                                             $fileDate = $file.LastWriteTime
                                                 }

                                                      if ($createSubdir -eq $True) {
                                                              # Set new filepath
                                                                      $fileDir = $basePath + "\" + $fileDate.ToString("yyyyMM")

                                                                               # Check directory
                                                                                       if (!(Test-Path($fileDir))) {
                                                                                                   # Create a new subdirectory
                                                                                                               if ($testMode -ne $True) {
                                                                                                                               $newDir = New-Item -Type directory -Path $fileDir
                                                                                                                                               Write-Host "            Creating: " -ForegroundColor DarkGray -NoNewline
                                                                                                                                                               Write-Host $fileDir -ForegroundColor Red
                                                                                                                                                                           }
                                                                                                                                                                                   }
                                                                                                                                                                                       } else {
                                                                                                                                                                                               # Use current directory
                                                                                                                                                                                                       $fileDir = $basePath
                                                                                                                                                                                                           }

                                                                                                                                                                                                                # Set new name to current to get "False" on first while
                                                                                                                                                                                                                    $newPath = $file.Fullname

                                                                                                                                                                                                                         $i = 0
                                                                                                                                                                                                                             while (Test-Path $newPath) {
                                                                                                                                                                                                                                     # Set new filename
                                                                                                                                                                                                                                             $newPath = $fileDir + "\" + $fileDate.ToString("yyyyMMdd_HHmmss") + "_" + $i.ToString("00") + $file.Extension
                                                                                                                                                                                                                                                     $i++
                                                                                                                                                                                                                                                         }

                                                                                                                                                                                                                                                              # Write som info
                                                                                                                                                                                                                                                                  Write-Host $fNum.ToString().PadLeft(4) -ForegroundColor DarkYellow -NoNewline
                                                                                                                                                                                                                                                                      Write-Host " / " -ForegroundColor DarkGray -NoNewline
                                                                                                                                                                                                                                                                          Write-Host $allFiles.Count.ToString().PadRight(4) -ForegroundColor Yellow -NoNewline
                                                                                                                                                                                                                                                                              Write-Host "   Moving: " -ForegroundColor DarkGray -NoNewline
                                                                                                                                                                                                                                                                                  Write-Host $file.Name -ForegroundColor Cyan -NoNewline
                                                                                                                                                                                                                                                                                      Write-Host " -> " -ForegroundColor DarkGray -NoNewline
                                                                                                                                                                                                                                                                                          Write-Host $newPath -ForegroundColor Green

                                                                                                                                                                                                                                                                                               # Move and rename the file
                                                                                                                                                                                                                                                                                                   if ($testMode -ne $True) {
                                                                                                                                                                                                                                                                                                           Move-Item $file.Fullname $newPath
                                                                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                                                                               } 
