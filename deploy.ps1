# PowerShell script to build Flutter web app and deploy to Vercel

# Get the absolute path of the project directory
$PROJECT_DIR = Get-Location
$BUILD_DIR = Join-Path -Path $PROJECT_DIR -ChildPath "build\web"

Write-Host "Starting deployment process..." -ForegroundColor Yellow

# Step 1: Build Flutter web app
Write-Host "Building Flutter web app..." -ForegroundColor Yellow
flutter build web --release --no-tree-shake-icons

# Check if build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful!" -ForegroundColor Green
    
    # Step 2: Navigate to build/web directory
    Write-Host "Navigating to build/web directory..." -ForegroundColor Yellow
    Push-Location -Path $BUILD_DIR
    
    # Step 3: Deploy to Vercel with archive flag to avoid rate limiting
    Write-Host "Deploying to Vercel..." -ForegroundColor Yellow
    vercel deploy --prod --archive=tgz
    
    # Check if deployment was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Deployment successful!" -ForegroundColor Green
    } else {
        Write-Host "Deployment failed. Please check the error messages above." -ForegroundColor Red
    }
    
    # Return to the project directory
    Pop-Location
} else {
    Write-Host "Build failed. Please fix the errors before deploying." -ForegroundColor Red
}

Write-Host "Deployment process completed." -ForegroundColor Yellow 