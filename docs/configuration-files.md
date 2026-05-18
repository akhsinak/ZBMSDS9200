# Configuration Files

This document describes all the configuration files that define the application's dependencies, build process, and deployment settings.

## ==Root Project Configuration==

### `{{package.json}}`

Located at the project root, this file defines the backend service configuration.

```json
{
  "name": "zbmsds9200",
  "version": "1.0.2",
  "dependencies": {
    "@cap-js/hana": "^2",
    "@sap/cds": "^9",
    "@sap/xsenv": "^5",
    "@sap/xssec": "^4"
  },
  "devDependencies": {
    "@cap-js/sqlite": "^2",
    "@sap/cds-dk": "^9.7.2"
  },
  "engines": {
    "node": "20.x"
  },
  "scripts": {
    "start": "cds-serve"
  },
  "cds": {
    "requires": {
      "db": {
        "kind": "hana"
      },
      "destinations": true,
      "html5-repo": true,
      "workzone": true
    }
  }
}
```

### Key Sections

#### Dependencies

| Package        | Version | Purpose                           |
| -------------- | ------- | --------------------------------- |
| `@cap-js/hana` | ^2      | SAP HANA database adapter for CAP |
| `@sap/cds`     | ^9      | Core CAP framework                |
| `@sap/xsenv`   | ^5      | BTP environment access            |
| `@sap/xssec`   | ^4      | XSUAA security integration        |

#### Dev Dependencies

| Package          | Version | Purpose                         |
| ---------------- | ------- | ------------------------------- |
| `@cap-js/sqlite` | ^2      | SQLite for local development    |
| `@sap/cds-dk`    | ^9.7.2  | CAP development kit (CLI tools) |

#### CDS Configuration

```json
"cds": {
  "requires": {
    "db": {
      "kind": "hana"
    },
    "destinations": true,
    "html5-repo": true,
    "workzone": true
  }
}
```

| Setting        | Value  | Description                             |
| -------------- | ------ | --------------------------------------- |
| `db.kind`      | `hana` | Uses SAP HANA Cloud for production      |
| `destinations` | `true` | Enables BTP destinations service        |
| `html5-repo`   | `true` | Enables HTML5 Applications Repository   |
| `workzone`     | `true` | Enables SAP Build Work Zone integration |

---

## UI Application Configuration

### `{{app/browse/package.json}}`

The UI5 application's package configuration.

```json
{
  "name": "browse",
  "version": "1.0.2",
  "main": "webapp/index.html",
  "scripts": {
    "build": "ui5 build preload --clean-dest",
    "start": "ui5 serve"
  },
  "devDependencies": {
    "@ui5/cli": "^4",
    "ui5-task-zipper": "^3"
  }
}
```

### Scripts

| Script  | Command                          | Purpose                             |
| ------- | -------------------------------- | ----------------------------------- |
| `build` | `ui5 build preload --clean-dest` | Builds the UI5 app with preloading  |
| `start` | `ui5 serve`                      | Starts local UI5 development server |

### Dev Dependencies

| Package           | Purpose                               |
| ----------------- | ------------------------------------- |
| `@ui5/cli`        | UI5 command line tools                |
| `ui5-task-zipper` | Creates deployable ZIP for HTML5 repo |

---

## UI5 Build Configuration

### `{{app/browse/ui5.yaml}}`

UI5 tooling configuration for building the Fiori app.

```yaml
# yaml-language-server: $schema=https://sap.github.io/ui5-tooling/schema/ui5.yaml.json
specVersion: "4.0"
metadata:
  name: zbmsds9200.browse
type: application
resources:
  configuration:
    propertiesFileSourceEncoding: UTF-8
builder:
  resources:
    excludes:
      - "/test/**"
      - "/localService/**"
  customTasks:
    - name: ui5-task-zipper
      afterTask: generateVersionInfo
      configuration:
        archiveName: zbmsds9200browse
        relativePaths: true
        additionalFiles:
          - xs-app.json
```

### Key Settings

| Setting         | Value               | Description                       |
| --------------- | ------------------- | --------------------------------- |
| `specVersion`   | `4.0`               | UI5 tooling specification version |
| `metadata.name` | `zbmsds9200.browse` | Application identifier            |
| `type`          | `application`       | Project type                      |
| `customTasks`   | `ui5-task-zipper`   | Creates ZIP for deployment        |
| `archiveName`   | `zbmsds9200browse`  | Output ZIP filename               |

---

## Deployment Configuration

### `{{mta.yaml}}`

Multi-Target Application descriptor for Cloud Foundry deployment.

#### Application Modules

| Module                    | Type                        | Purpose                   |
| ------------------------- | --------------------------- | ------------------------- |
| `zbmsds9200-srv`          | nodejs                      | CAP service runtime       |
| `zbmsds9200-db-deployer`  | hdb                         | Database deployment       |
| `zbmsds9200-app-deployer` | com.sap.application.content | UI app deployment         |
| `zbmsds9200browse`        | html5                       | UI5 build module          |
| `zbmsds9200-destinations` | com.sap.application.content | Destination configuration |

#### Service Resources

| Resource                     | Type            | Purpose                  |
| ---------------------------- | --------------- | ------------------------ |
| `zbmsds9200-db`              | hana            | HANA Cloud database      |
| `zbmsds9200-destination`     | destination     | BTP Destinations service |
| `zbmsds9200-html5-repo-host` | html5-apps-repo | HTML5 repo for UI apps   |
| `zbmsds9200-html5-repo-rt`   | html5-apps-repo | HTML5 repo runtime       |
| `zbmsds9200-xsuaa`           | xsuaa           | Authentication service   |

#### Key Configuration

```yaml
modules:
  - name: zbmsds9200-srv
    type: nodejs
    path: gen/srv
    requires:
      - name: zbmsds9200-db
      - name: zbmsds9200-destination
      - name: zbmsds9200-xsuaa
```

---

## Security Configuration

### `{{xs-security.json}}`

XSUAA security configuration for authentication and authorization.

```json
{
  "xsappname": "zbmsds9200",
  "tenant-mode": "dedicated",
  "scopes": [
    {
      "name": "$XSAPPNAME.User",
      "description": "User"
    }
  ],
  "role-templates": [
    {
      "name": "User",
      "description": "Default user role",
      "scope-references": ["$XSAPPNAME.User"]
    }
  ]
}
```

### Settings

| Setting          | Value             | Description               |
| ---------------- | ----------------- | ------------------------- |
| `xsappname`      | `zbmsds9200`      | Application name in XSUAA |
| `tenant-mode`    | `dedicated`       | Single-tenant mode        |
| `scopes`         | `$XSAPPNAME.User` | Defined permission scope  |
| `role-templates` | `User`            | Role containing the scope |

---

### `{{app/browse/xs-app.json}}`

App router route configuration for the UI application.

```json
{
  "welcomeFile": "/index.html",
  "authenticationMethod": "route",
  "routes": [
    {
      "source": "^/resources/(.*)$",
      "target": "/resources/$1",
      "authenticationType": "none",
      "destination": "ui5"
    },
    {
      "source": "^/test-resources/(.*)$",
      "target": "/test-resources/$1",
      "authenticationType": "none",
      "destination": "ui5"
    },
    {
      "source": "^/?odata/(.*)$",
      "target": "/odata/$1",
      "destination": "srv-api",
      "authenticationType": "xsuaa",
      "csrfProtection": true
    },
    {
      "source": "^(.*)$",
      "service": "html5-apps-repo-rt",
      "target": "$1",
      "authenticationType": "xsuaa"
    }
  ]
}
```

### Route Configuration

| Route         | Source         | Destination        | Auth  |
| ------------- | -------------- | ------------------ | ----- |
| UI5 Resources | `/resources/*` | ui5                | none  |
| OData Service | `/odata/*`     | srv-api            | xsuaa |
| App Content   | `/*`           | html5-apps-repo-rt | xsuaa |

---

## Environment Configuration

### `{{default-env.json}}` & `{{default-env.json.template}}`

Local development environment variables. Contains:

- Database connection settings
- Service credentials
- Feature toggles

The `.template` file is a sanitized version without actual credentials.

---

## Summary

| File                      | Location      | Purpose                        |
| ------------------------- | ------------- | ------------------------------ |
| `package.json`            | Root          | Backend dependencies & scripts |
| `mta.yaml`                | Root          | Cloud Foundry deployment       |
| `manifest.yml`            | Root          | CF app manifest                |
| `xs-security.json`        | Root          | XSUAA configuration            |
| `default-env.json`        | Root          | Local env variables            |
| `app/browse/package.json` | `app/browse/` | UI dependencies                |
| `app/browse/ui5.yaml`     | `app/browse/` | UI5 build config               |
| `app/browse/xs-app.json`  | `app/browse/` | App router routes              |
