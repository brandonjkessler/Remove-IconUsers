
param(
    [parameter(Mandatory)]
    [string]$Icon,
    [string]$Exclude
)

[array]$ExcludeArr = @('Public')

if($Exclude -ne ''){
    $ExcludeArr += $Exclude.Split(',').Trim()
}

Get-ChildItem -Path 'C:\Users' | ForEach-Object{
    # Ignore the exclusions
    ## Compare the Array to the currently selected user
    if($ExcludeArr -contains "$($_.Name)"){
        Write-Output "Skipping User $($_.Name). User is excluded."
    } else {
        $curUser = "$($_.Name)"
        Write-Host "Currently scanning User $curUser"
        $iconTest = Get-ChildItem -Path "C:\Users\$($curUser)\Desktop" | Where-Object {$_.Name -match "$Icon"}
        # Test to make sure a link was found
        if($null -ne $iconTest){
            $iconTest | ForEach-Object{
                Write-Output "Removing $($_.Name) Icon from User $curUser"
                Remove-Item -Path "$($_.FullName)" -Force -Verbose
            }
        } else {
            Write-Error "No icon found matching $Icon."
        }
    }
}
