# Project Structure

This document describes the complete file structure of the Local Email Application and the purpose of each file.

## Root Directory

```
├── .git/                   # Git version control
├── .vscode/                # VS Code configuration
├── _i18n/                  # Internationalization files (messages)
├── app/                    # UI applications
├── db/                     # Database layer (CDS models)
├── docs/                   # Documentation (GitBook)
├── node_modules/           # Node.js dependencies
├── srv/                    # Service layer (CDS services)
├── db.sqlite               # Local SQLite database (dev only)
├── default-env.json        # environment variables (for local dev mode to connect to hana cloud)
├── default-env.json.template  # Template for environment config
├── .gitignore              # Git ignore patterns
├── mta.yaml                # MTA (Multi-Target Application) descriptor
├── package-lock.json       # Locked dependency versions
├── package.json            # Root project configuration
├── readme.md               # Basic project readme
├── xs-security.json        # XSUAA security configuration
```

## Database Layer (`db/`)

```
db/
├── data/                   # Sample data files
│   └── (sample data CSV/JSON files)
├── src/                    # Database source files
│   └── roles/              # HANA database roles
│       └── (role definitions)
└── emails.cds              # Main entity definition
```

### Key Files

| File | Path | Purpose |
|------|------|---------|
| `emails.cds` | `db/emails.cds` | Defines the `Emails` entity with `cuid` and `managed` aspects |

## Service Layer (`srv/`)

```
srv/
├── cat-service.cds         # Service definition (CDS)
└── cat-service.js          # Service implementation (JavaScript handlers)
```

### Key Files

| File | Path | Purpose |
|------|------|---------|
| `cat-service.cds` | `srv/cat-service.cds` | Defines the `EmailService` with OData V4 and draft support |
| `cat-service.js` | `srv/cat-service.js` | Implements user-specific filtering on READ operations |

## UI Layer (`app/`)

```
app/
├── _i18n/                  # App-level internationalization
├── appconfig/              # App configuration
├── browse/                 # Main Fiori application
│   ├── webapp/             # UI5 application files
│   │   ├── ext/            # Controller extensions
│   │   │   ├── EmailsListReportExt.controller.js
│   │   │   └── EmailsObjectPageExt.controller.js
│   │   ├── i18n/           # UI translations
│   │   │   ├── i18n.properties
│   │   │   ├── i18n_de.properties
│   │   │   └── i18n_en.properties
│   │   ├── Component.js    # UI5 Component definition
│   │   ├── index.html      # Application entry point
│   │   └── manifest.json   # UI5 application manifest
│   ├── fiori-service.cds   # Fiori annotations
│   ├── package.json        # UI app dependencies
│   ├── ui5.yaml            # UI5 tooling configuration
│   └── xs-app.json         # App router routes
├── fiori-apps.html         # Fiori launchpad HTML
└── services.cds            # Re-exports fiori-service
```

### Key Files

| File | Path | Purpose |
|------|------|---------|
| `Component.js` | `app/browse/webapp/Component.js` | SAP Fiori elements app component |
| `manifest.json` | `app/browse/webapp/manifest.json` | UI5 app descriptor with routing and extensions |
| `index.html` | `app/browse/webapp/index.html` | Application bootstrap page |
| `EmailsObjectPageExt.controller.js` | `app/browse/webapp/ext/EmailsObjectPageExt.controller.js` | Custom navigation after save |
| `EmailsListReportExt.controller.js` | `app/browse/webapp/ext/EmailsListReportExt.controller.js` | List report extension placeholder |
| `fiori-service.cds` | `app/browse/fiori-service.cds` | UI annotations for Fiori elements |
| `i18n.properties` | `app/browse/webapp/i18n/i18n.properties` | UI text strings |

## Configuration Files

### Deployment & Cloud

| File | Purpose |
|------|---------|
| `mta.yaml` | MTA descriptor for Cloud Foundry deployment |
| `manifest.yml` | Cloud Foundry application manifest |
| `xs-security.json` | XSUAA security scope and role definitions |
| `xs-app.json` | App router route configuration |

### Build & Development

| File | Purpose |
|------|---------|
| `package.json` | Root project dependencies and scripts |
| `ui5.yaml` | UI5 build tooling configuration |
| `default-env.json` | Local development environment variables |
| `.gitignore` | Git ignore patterns |

## File Tags

When referencing files in this documentation, we use tags like:

- `{{db/emails.cds}}` - Database entity definition
- `{{srv/cat-service.cds}}` - Service definition
- `{{srv/cat-service.js}}` - Service implementation
- `{{app/browse/webapp/manifest.json}}` - UI5 manifest
- `{{app/browse/webapp/ext/EmailsObjectPageExt.controller.js}}` - Controller extension
- `{{mta.yaml}}` - Deployment descriptor

## Next Steps

- Learn about the [Database Layer](database-layer.md)
- Explore the [Service Layer](service-layer.md)
- Understand the [UI Layer](ui-layer.md)
