$scoop= "scoop"
$git = "git"
$main_tool = "lp-bucket/maven lp-bucket/nodejs-lts lp-bucket/mongodb lp-bucket/openjdk9"
$extra_tool = "extras/vcredist2015 extras/vcredist2017"
$repo = "https://github.com/NguHoaDuy/lp-bucket"
$lp_api_repo = "https://github.com/NguHoaDuy/LandingPageAPI.git"
$lp_ui_repo = "https://github.com/NguHoaDuy/LandingPageUI.git"

$script_path = Get-Location

function has_dir($dir) {
    return Test-Path -Path $dir
}
function is_installed($name) {
    $installed = Get-Command $name 2>&1
    return !($installed -like '*not recognized*')
}

function print_title($title) {
    Write-Host "=======================================================================" -ForegroundColor green
    Write-Host "$title" -ForegroundColor green
    Write-Host "=======================================================================" -ForegroundColor green
}

# Install scoop
if(-not (is_installed($scoop))) {
    print_title("Install scoop...")
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
} 

# Install git if any 
if(-not (is_installed($git))) {
    print_title("Install git...")
    Invoke-Expression "scoop install git"
} 

# Add bucket
print_title("Add scoop bucket...")
Invoke-Expression "scoop bucket rm lp-bucket 2>&1" | Out-null
Invoke-Expression "scoop bucket rm extras 2>&1" | Out-null
Invoke-Expression "scoop bucket add lp-bucket $repo"
Invoke-Expression "scoop bucket add extras"

# Add optional tool, comment it if do not need
if(-not (is_installed("code"))) {
    Invoke-Expression "scoop install extras/vscode"
} 

print_title("Install tools...")
Invoke-Expression "scoop install $extra_tool $main_tool"

Push-Location $script_path\..
$current_dir = Get-Location
 
# clone repo
if(-not (has_dir("$current_dir\LandingPageAPI"))) {
    print_title("Cloning lp-api project ...")
    Invoke-Expression "git clone $lp_api_repo"
}

if(-not (has_dir("$current_dir\LandingPageUI"))) {
    print_title("Cloning lp-api project ...")
    Invoke-Expression "git clone $lp_ui_repo"
    Push-Location "$current_dir\LandingPageUI"
    # Add angular CLI 
    print_title("Install angular...")
    Invoke-Expression "npm install -g @angular/cli@12.0.5"
    print_title("Update npm package...")
    Invoke-Expression "npm update"
}

Pop-Location
Pop-Location

print_title("Set up done!.......")

