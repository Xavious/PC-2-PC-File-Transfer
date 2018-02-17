$FoldersToCopy = @(
    'Desktop'
    'Favorites'
    'Documents'
    'AppData\Local\Microsoft\Outlook'
    )

$ConfirmComp = $null
$ConfirmUser = $null

while( $ConfirmComp -ne 'y' ){
    $SourceComputer = Read-Host -Prompt 'Enter the computer to copy from'

    if( -not ( Test-Connection -ComputerName $SourceComputer -Count 2 -Quiet ) ){
        Write-Warning "$SourceComputer is not online. Please enter another computer name."
        continue
        }

    $ConfirmComp = Read-Host -Prompt "The entered computer name was:`t$SourceComputer`r`nIs this correct? (y/n)"
    }

while( $ConfirmUser -ne 'y' ){
    $SourceUser = Read-Host -Prompt 'Enter the user profile to copy from'

    if( -not ( Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser" -PathType Container ) ){
        Write-Warning "$SourceUser could not be found on $SourceComputer. Please enter another user profile."
        continue
        }

    $ConfirmUser = Read-Host -Prompt "The entered user profile was:`t$SourceUser`r`nIs this correct? (y/n)"
    }

$ConfirmComp = $null
$ConfirmUser = $null
	
while( $ConfirmComp -ne 'y' ){
    $DestinationComputer = Read-Host -Prompt 'Enter the computer to copy to'

    if( -not ( Test-Connection -ComputerName $DestinationComputer -Count 2 -Quiet ) ){
        Write-Warning "$DestinationComputer is not online. Please enter another computer name."
        continue
        }

    $ConfirmComp = Read-Host -Prompt "The entered computer name was:`t$DestinationComputer`r`nIs this correct? (y/n)"
    }

while( $ConfirmUser -ne 'y' ){
    $DestinationUser = Read-Host -Prompt 'Enter the user profile to copy to'

    if( -not ( Test-Path -Path "\\$DestinationComputer\c$\Users\$DestinationUser" -PathType Container ) ){
        Write-Warning "$DestinationUser could not be found on $DestinationComputer. Please enter another user profile."
        continue
        }

    $ConfirmUser = Read-Host -Prompt "The entered user profile was:`t$DestinationUser`r`nIs this correct? (y/n)"
    }

$SourceRoot      = "\\$SourceComputer\c$\Users\$SourceUser"
$DestinationRoot = "\\$DestinationComputer\c$\Users\$DestinationUser"

foreach( $Folder in $FoldersToCopy ){
    $Source      = Join-Path -Path $SourceRoot -ChildPath $Folder
    $Destination = Join-Path -Path $DestinationRoot -ChildPath $Folder

    if( -not ( Test-Path -Path $Source -PathType Container ) ){
        Write-Warning "Could not find path`t$Source"
        continue
        }

    robocopy $Source $Destination /E /IS /V
    }
	
Read-Host -Prompt 'Press Enter to exit'