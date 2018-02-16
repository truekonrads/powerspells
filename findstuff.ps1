
function Compress{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
    [ValidateNotNullOrEmpty()]
    [byte[]]$bytes
    )

    [System.IO.MemoryStream] $output = New-Object System.IO.MemoryStream;
    $gzipStream = New-Object System.IO.Compression.GzipStream $output, ([IO.Compression.CompressionMode]::Compress);
    $gzipStream.Write( $bytes, 0, $bytes.Length );
    $gzipStream.Close();
    $output.ToArray();
    
}

function ToBytes{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
    [ValidateNotNullOrEmpty()]
    [string] $b
    )
    [System.Text.Encoding]::UTF8.GetBytes($b)
}

function Find-InterestingFiles{
<#
    .SYNOPSIS
        Find interesting files in some folders and return those
    .PARAMETER location
        Start of search root
    .PARAMETER exts
        Extensions to search in
    .PARAMETER interesting
        array of keywords to search for (will be joined into a regex with a |)
    .PARAMETER packfiles
        Should this be packed into a nice single text
    .PARAMETER compress
        Compress the package?
    .PARAMETER outputfile
        Where to write the compressed archive to    
    .EXAMPLE
        FindInterestingFiles 'C:\secrets' -packfiles $true -compress $true -outputfile here.bin
    
#>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $location,
        [Parameter(Position=1,mandatory=$false)]
        [string[]] $exts=("*.bat", "*.vbs", "*.cmd", "*.ps1"),
        [Parameter(Position=2,mandatory=$false)]
        [string[]] $interesting=("user","pass","net use","login"),
        [Parameter(Position=3,mandatory=$false)]
        [Bool] $packfiles=$false,
        [Parameter(Position=4,mandatory=$false)]
        [Bool] $compress=$false,
        [Parameter(Position=5,mandatory=$false)]
        [string] $outputfile=""
    )

    Get-ChildItem $location -Recurse -Include $exts -File | % {
        $contents = [io.file]::ReadAllText($_.FullName);
        $fullname = $_.FullName;
        $pack="";
        ForEach-Object -InputObject $interesting {
            if ($contents -match ($interesting -join "|")){
                if ($packfiles){
                    $pack="---BEGIN $($fullname) ---`n$($contents)`n---END $($fullname)---`n"
                }else{
                    $o=New-Object PSObject -Property @{FullName = $fullname; contents=$contents}                
                    $o
                }
            }
        }
        if ($pack) {
            if ($compress){
                [System.IO.MemoryStream] $output = New-Object System.IO.MemoryStream;
                $compressed = Compress ($pack |ToBytes)
                if ($outputfile){
                    $compressed | Set-Content $outputfile -Encoding Byte
                }else{
                    $compressed #do with byte array what you please
                }
            }else{
                $pack
            }
        }
    }
}