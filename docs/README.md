# Email Application Documentation

Welcome to the documentation for the **Email Application** - a SAP Cloud Application Programming Model (CAP) based application with a Fiori elements frontend.

## Overview

This application allows users to:
- Create and manage email addresses
- View only their own created emails (user-scoped data)
- Use a modern SAP Fiori interface with List Report and Object Page patterns

## Architecture

The application follows the **CAP (Cloud Application Programming Model)** architecture with three main layers:

1. **Database Layer** (`db/`) - Domain model and data persistence
2. **Service Layer** (`srv/`) - Business logic and OData services  
3. **UI Layer** (`app/`) - Fiori elements frontend application

## Quick Links

- [Project Structure](project-structure.md)
- [Database Layer](database-layer.md)
- [Service Layer](service-layer.md)
- [UI Layer](ui-layer.md)
- [Configuration Files](configuration-files.md)
- [Security & Authorization](security.md)
- [Deployment](deployment.md)

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Backend Framework | SAP CAP (Cloud Application Programming Model) |
| Database | SAP HANA Cloud |
| OData Version | OData V4 |
| UI Framework | SAPUI5 / Fiori Elements |
| UI5 Version | 1.136.0 |
| Authentication | SAP XSUAA |

## Getting Started

### Prerequisites
- Node.js 20.x
- SAP BTP account (for deployment)
- SAP HANA Cloud instance

### Local Development
```bash
# Install dependencies
npm install

# Start the CAP server locally
npm start
# The server will run at http://localhost:4004
```

### Accessing the Application
- **OData Service**: `http://localhost:4004/odata/v4/email/`
- **Fiori App**: `http://localhost:4004/app/browse/webapp/index.html`

## Key Features

### User-Scoped Data Access
The application implements row-level security where each user can only see and manage emails they created. This is implemented in the service layer using CAP's `managed` aspect.

### Draft-Enabled CRUD
The OData service supports draft capabilities, allowing users to:
- Create new email drafts
- Edit existing emails
- Save or discard changes

### Custom Navigation Flow
A controller extension modifies the default Fiori navigation behavior - after creating a new email in *screen 2* , users are redirected back to the list view (*screen 1*) instead of the object page.


