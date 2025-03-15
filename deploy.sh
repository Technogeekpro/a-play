#!/bin/bash

# Print colorful messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the absolute path of the project directory
PROJECT_DIR="$(pwd)"
BUILD_DIR="$PROJECT_DIR/build/web"

echo -e "${YELLOW}Starting deployment process...${NC}"

# Step 1: Build Flutter web app
echo -e "${YELLOW}Building Flutter web app...${NC}"
flutter build web --release --no-tree-shake-icons

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build successful!${NC}"
    
    # Step 2: Navigate to build/web directory
    echo -e "${YELLOW}Navigating to build/web directory...${NC}"
    cd "$BUILD_DIR"
    
    # Step 3: Deploy to Vercel with archive flag to avoid rate limiting
    echo -e "${YELLOW}Deploying to Vercel...${NC}"
    vercel deploy --prod --archive=tgz
    
    # Check if deployment was successful
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Deployment successful!${NC}"
    else
        echo -e "\033[0;31mDeployment failed. Please check the error messages above.${NC}"
    fi
    
    # Return to the project directory
    cd "$PROJECT_DIR"
else
    echo -e "\033[0;31mBuild failed. Please fix the errors before deploying.${NC}"
fi

echo -e "${YELLOW}Deployment process completed.${NC}" 