$scoop= "scoop"
$git = "git"
$main_tool = "lp-bucket/maven lp-bucket/nodejs-lts lp-bucket/mongodb lp-bucket/openjdk9"
$extra_tool = "extras/vcredist2015 extras/vcredist2017 extras/vscode"
$repo = "https://github.com/NguHoaDuy/lp-bucket"

function is_installed($name) {
    $installed = Get-Command $name 2>&1
    return !($installed -like '*not recognized*')
}

function print_title($title) {
    Write-Host "=======================================================================" -ForegroundColor green
    Write-Host "$title" -ForegroundColor green
    Write-Host "=======================================================================" -ForegroundColor green
}

if(-not (is_installed($scoop))) {
    print_title("Install scoop...")
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
} 

if(-not (is_installed($git))) {
    print_title("Install git...")
    Invoke-Expression "scoop install git"
} 

print_title("Add scoop bucket...")
Invoke-Expression "scoop bucket rm lp-bucket 2>&1" | Out-null
Invoke-Expression "scoop bucket rm extras 2>&1" | Out-null
Invoke-Expression "scoop bucket add lp-bucket $repo"
Invoke-Expression "scoop bucket add extras"

print_title("Install tools...")
Invoke-Expression "scoop install $extra_tool $main_tool"
Invoke-Expression "npm install -g @angular/cli@12.0.5"
