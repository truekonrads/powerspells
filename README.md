# powerspells
Small collection of powershell scripts useful during lateral movement

## Find-InterestingFiles
  Look for keywords in files and package them for exfil
  ```
  FindInterestingFiles 'C:\secrets' -packfiles $true -compress $true -outputfile here.bin
  ```
  (decompress with gunzip)
