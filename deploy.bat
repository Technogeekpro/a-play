@echo off
echo Starting deployment process...

REM Step 1: Build Flutter web app
echo Building Flutter web app...
call flutter build web --release --no-tree-shake-icons

REM Check if build was successful
if %ERRORLEVEL% EQU 0 (
    echo Build successful!
    
    REM Step 2: Navigate to build/web directory
    echo Navigating to build/web directory...
    cd build\web
    
    REM Step 3: Deploy to Vercel with archive flag to avoid rate limiting
    echo Deploying to Vercel...
    call vercel deploy --prod --archive=tgz
    
    REM Check if deployment was successful
    if %ERRORLEVEL% EQU 0 (
        echo Deployment successful!
    ) else (
        echo Deployment failed. Please check the error messages above.
    )
    
    REM Return to the project directory
    cd ..\..
) else (
    echo Build failed. Please fix the errors before deploying.
)

echo Deployment process completed.
pause 