#!/bin/bash

# Setup script for TestyTech Designs Website launchd service on macOS
# This script configures the system to run the website as a launchd service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SERVICE_NAME="com.testytech.website"
PLIST_FILE="$SERVICE_NAME.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
CURRENT_DIR="$(pwd)"
LOG_DIR="$HOME/Library/Logs"

echo -e "${GREEN}Setting up TestyTech Designs Website Service for macOS${NC}"
echo "=========================================================="

# Check if plist file exists
if [[ ! -f "$PLIST_FILE" ]]; then
    echo -e "${RED}Error: $PLIST_FILE not found in current directory${NC}"
    exit 1
fi

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed or not in PATH${NC}"
    echo "Please install Python 3 from https://www.python.org/downloads/"
    exit 1
fi

echo -e "${GREEN}✓ Python 3 found: $(python3 --version)${NC}"

# Create LaunchAgents directory if it doesn't exist
echo -e "${YELLOW}Creating LaunchAgents directory...${NC}"
mkdir -p "$LAUNCH_AGENTS_DIR"

# Create logs directory if it doesn't exist
echo -e "${YELLOW}Creating logs directory...${NC}"
mkdir -p "$LOG_DIR"

# Update the plist file with current user and working directory
echo -e "${YELLOW}Updating plist file with current user and paths...${NC}"
TEMP_PLIST="/tmp/$PLIST_FILE"
cp "$PLIST_FILE" "$TEMP_PLIST"

# Replace placeholder paths with actual paths (order matters!)
sed -i '' "s|/Users/james/Documents/AI/website|$CURRENT_DIR|g" "$TEMP_PLIST"
sed -i '' "s|/Users/james|$HOME|g" "$TEMP_PLIST"

# Update the start script path
sed -i '' "s|start-website.sh|$CURRENT_DIR/start-website.sh|g" "$TEMP_PLIST"

# Get current username
CURRENT_USER=$(whoami)
sed -i '' "s|<string>james</string>|<string>$CURRENT_USER</string>|g" "$TEMP_PLIST"

# Stop existing service if running
echo -e "${YELLOW}Stopping existing service (if running)...${NC}"
launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_FILE" 2>/dev/null || true

# Copy the updated plist file
echo -e "${YELLOW}Installing launchd service file...${NC}"
cp "$TEMP_PLIST" "$LAUNCH_AGENTS_DIR/$PLIST_FILE"

# Clean up temp file
rm "$TEMP_PLIST"

# Load the service
echo -e "${YELLOW}Loading launchd service...${NC}"
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_FILE"

# Start the service
echo -e "${YELLOW}Starting the service...${NC}"
launchctl start "$SERVICE_NAME"

# Wait a moment for the service to start
sleep 3

# Check if the service is running
if launchctl list | grep -q "$SERVICE_NAME"; then
    echo -e "${GREEN}✓ Service is loaded!${NC}"
    
    # Check if it's actually serving by testing the port
    sleep 2
    if curl -s http://localhost:8080 > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Service is responding on port 8080!${NC}"
        
        # Get the Mac's IP address
        IP_ADDRESS=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')
        
        echo ""
        echo -e "${GREEN}🚀 TestyTech Designs Website is now running!${NC}"
        echo "=============================================="
        echo -e "${BLUE}Local access:${NC}    http://localhost:8080"
        echo -e "${BLUE}Network access:${NC}  http://$IP_ADDRESS:8080"
        echo ""
        echo -e "${YELLOW}Service Management Commands:${NC}"
        echo "  Start service:    launchctl start $SERVICE_NAME"
        echo "  Stop service:     launchctl stop $SERVICE_NAME"
        echo "  Restart service:  launchctl stop $SERVICE_NAME && launchctl start $SERVICE_NAME"
        echo "  Check status:     launchctl list | grep $SERVICE_NAME"
        echo "  View logs:        tail -f $LOG_DIR/testytech-website.log"
        echo "  View errors:      tail -f $LOG_DIR/testytech-website-error.log"
        echo ""
        echo -e "${YELLOW}To uninstall the service:${NC}"
        echo "  launchctl unload $LAUNCH_AGENTS_DIR/$PLIST_FILE"
        echo "  rm $LAUNCH_AGENTS_DIR/$PLIST_FILE"
        echo ""
        echo -e "${GREEN}The service will automatically start when you log in to your Mac.${NC}"
    else
        echo -e "${YELLOW}⚠ Service is loaded but not responding. Check logs:${NC}"
        echo "  tail $LOG_DIR/testytech-website-error.log"
    fi
else
    echo -e "${RED}✗ Service failed to load. Check the logs:${NC}"
    echo "  tail $LOG_DIR/testytech-website-error.log"
    exit 1
fi
