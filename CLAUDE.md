# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a TestyTech Designs portfolio website - a single-page application showcasing web development projects with stunning aurora effects and modern design. The website is built with vanilla HTML, CSS, and JavaScript using Tailwind CSS for styling and includes contact form integration via Formspree.

## Architecture & Structure

### Core Files
- `index.html` - Main portfolio website with 4 sections: hero, portfolio, about, contact
- `aurora_theme.css` - Custom aurora-themed design system with glass morphism effects
- `default_ui_darkmode.css` - Alternative dark mode UI framework (not currently used)
- `test-formspree.html` - Simple form testing page for Formspree integration

### Service Configuration
- `start-website.sh` - Shell script to start Python HTTP server (port 8080)
- `setup-macos-service.sh` - macOS launchd service installer script
- `com.testytech.website.plist` - macOS launchd service configuration
- `website.service` - Linux systemd service configuration (for deployment)

### Design System Integration
When asked to design UI & frontend interfaces, the system follows a 4-step workflow:
1. Layout design (ASCII wireframes)
2. Theme design (using generateTheme tool)
3. Animation design
4. HTML file generation

Design files are saved to `.superdesign/design_iterations/` folder.

## Common Development Commands

### Local Development
```bash
# Start the website locally
./start-website.sh
# OR manually:
python3 -m http.server 8080 --bind 0.0.0.0

# Access website
open http://localhost:8080
```

### Service Management (macOS)
```bash
# Install as system service
./setup-macos-service.sh

# Service control commands
launchctl start com.testytech.website
launchctl stop com.testytech.website
launchctl unload ~/Library/LaunchAgents/com.testytech.website.plist

# View logs
tail -f ~/Library/Logs/testytech-website.log
tail -f ~/Library/Logs/testytech-website-error.log
```

### Testing Form Integration
```bash
# Test Formspree integration
open test-formspree.html
# Form submissions go to: https://formspree.io/f/xdkdgbob
```

## Technology Stack

- **Frontend**: Vanilla HTML5, CSS3, JavaScript (ES6+)
- **Styling**: Tailwind CSS (via CDN), Custom CSS Variables, Glass Morphism
- **Icons**: Lucide Icons (via CDN)
- **Fonts**: Google Fonts (Inter, JetBrains Mono)
- **Form Handling**: Formspree integration
- **Server**: Python HTTP Server (development)
- **Service Management**: launchd (macOS), systemd (Linux)

## Design System

### Aurora Theme CSS Variables
The `aurora_theme.css` uses OKLCH color space for enhanced color fidelity:
- Dark background with aurora gradient animations
- Glass morphism effects with backdrop-filter blur
- Custom shadow system with colored glows
- Responsive design with mobile breakpoints

### Animation System
- Aurora background waves with CSS keyframes
- Floating elements with staggered timing
- Smooth scroll behavior and intersection observer
- Glass hover effects with transform and shadow transitions

## Key Features

### Single Page Application
- Section-based navigation with dots indicator
- Smooth scrolling between sections (hero, portfolio, about, contact)
- Responsive grid layouts for portfolio projects
- Interactive contact form with validation

### Contact Form
- Formspree integration (endpoint: xdkdgbob)
- Honeypot spam protection
- Form debugging with console logging
- Success/error handling

### Service Deployment
- Cross-platform service configuration (macOS/Linux)
- Automatic startup and restart capabilities
- Comprehensive logging and monitoring
- Security hardening for production deployment

## Development Notes

- The website uses external CDNs for Tailwind CSS and Lucide icons
- Images are sourced from Unsplash with specific dimensions
- Form submissions require internet connectivity for Formspree
- Service scripts include user/path customization for different environments
- The aurora theme creates animated background effects that may impact performance on low-end devices