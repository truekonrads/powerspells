# powerspells
Small collection of powershell scripts useful during lateral movement

## Find-InterestingFiles
  Look for keywords in files and package them for exfil
  ```
  FindInterestingFiles 'C:\secrets' -packfiles $true -compress $true -outputfile here.bin
  ```
  (decompress with gunzip)


  
## ADQuery
  Ask Something of Active Directory (thin LDAP wrapper)
  ```
  (AdQuery -ldapflter $ldapfilter).FindAll() | % {$_.Properties | Convert-LDAPProperty }
  ```
## FindVeryActiveComputers
  Look for computers logged on to AD with their computer account in last 8 hours
  ```
	FindVeryActiveComputers -osversion "*"
  ```
  
## OneObject
  Fetch one object matching a filter
  ```
	OneObject -ldapfilter "(name=truekonrads)"
  ```
  
