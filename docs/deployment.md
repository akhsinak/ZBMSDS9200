# Deployment

This document explains how the Email Application is built and deployed to SAP BTP (Cloud Foundry) using an MTA (Multi-Target Application).

## Deployment Options

primary deployment approaches in this project:

1. **MTA Deployment** (recommended for BTP)
   - Uses `{{mta.yaml}}`
   - Builds and deploys DB + CAP service + UI content

---

## Local Build & Run

### Backend (CAP Service)

From project root:

```bash
npm install
npm start
```

The CAP server runs at:

- `http://localhost:4004`

````

---

## MTA Deployment (SAP BTP)

### Key File: `{{mta.yaml}}`

The MTA descriptor defines:
- Build steps
- Deployment modules
- Required service instances

### Build Process

The root build step is defined under `build-parameters`:

```yaml
build-parameters:
  before-all:
    - builder: custom
      commands:
        - npm ci
        - npx cds build --production
````

#### What this does

- **`npm ci`**
  - Installs dependencies in a reproducible way using `package-lock.json`

- **`npx cds build --production`**
  - Generates the `gen/` folder
  - Produces deployable artifacts:
    - `gen/srv` (Node.js service)
    - `gen/db` (HANA deployment artifacts)

---

## Modules

### 1) CAP Service Module

**Module name:** `zbmsds9200-srv`  
**Type:** `nodejs`  
**Path:** `gen/srv`

```yaml
- name: zbmsds9200-srv
  type: nodejs
  path: gen/srv
  requires:
    - name: zbmsds9200-db
    - name: zbmsds9200-destination
    - name: zbmsds9200-xsuaa
```

#### Responsibilities

- Hosts the OData service at runtime (see `{{srv/cat-service.cds}}`)
- Enforces server-side filtering (see `{{srv/cat-service.js}}`)

---

### 2) DB Deployer Module

**Module name:** `zbmsds9200-db-deployer`  
**Type:** `hdb`  
**Path:** `gen/db`

```yaml
- name: zbmsds9200-db-deployer
  type: hdb
  path: gen/db
  requires:
    - name: zbmsds9200-db
```

#### Responsibilities

- Deploys CDS-to-HANA artifacts into the HDI container

---

### 3) UI5 Build Module

**Module name:** `zbmsds9200browse`  
**Type:** `html5`  
**Path:** `app/browse`

```yaml
- name: zbmsds9200browse
  type: html5
  path: app/browse
  build-parameters:
    build-result: dist
    builder: custom
    commands:
      - npm install
      - npm run build
```

#### Responsibilities

- Builds the UI5 frontend into a deployable `dist/` folder
- Uses `{{app/browse/ui5.yaml}}` to ZIP the result (`ui5-task-zipper`)

---

### 4) HTML5 App Deployer (Content)

**Module name:** `zbmsds9200-app-deployer`  
**Type:** `com.sap.application.content`

```yaml
- name: zbmsds9200-app-deployer
  type: com.sap.application.content
  requires:
    - name: zbmsds9200-html5-repo-host
      parameters:
        content-target: true
  build-parameters:
    build-result: resources
    requires:
      - name: zbmsds9200browse
        artifacts:
          - zbmsds9200browse.zip
        target-path: resources/
```

#### Responsibilities

- Uploads the built UI ZIP into the HTML5 repo host service

---

### 5) Destinations Content Module

**Module name:** `zbmsds9200-destinations`

This module configures destinations in the Destination service.

Key destinations:

- `ui5` → `https://ui5.sap.com`
- `srv-api` → CAP service route (`~{srv-api/srv-url}`)

---

## Service Instances

### HANA HDI Container

```yaml
- name: zbmsds9200-db
  type: com.sap.xs.hdi-container
```

### Destination Service

```yaml
- name: zbmsds9200-destination
  type: org.cloudfoundry.managed-service
  parameters:
    service: destination
    service-plan: lite
```

### HTML5 Apps Repository

- Host (`app-host`)
- Runtime (`app-runtime`)

### XSUAA

```yaml
- name: zbmsds9200-xsuaa
  type: org.cloudfoundry.managed-service
  parameters:
    service: xsuaa
    service-plan: application
    path: ./xs-security.json
```

---

## App Router

The UI app includes `{{app/browse/xs-app.json}}` which defines:

- Protected routes (xsuaa)
- OData proxying to `srv-api`
- UI5 resources from `ui5` destination

---

## Operational Notes

### Versioning

The project version `1.0.2` appears consistently in:

- `{{package.json}}`
- `{{app/browse/package.json}}`
- `{{app/browse/webapp/manifest.json}}`
- `{{mta.yaml}}`

---

## Related Files

- `{{mta.yaml}}` - Main deployment descriptor
- `{{manifest.yml}}` - Direct CF deployment
- `{{app/browse/ui5.yaml}}` - UI build config
- `{{app/browse/xs-app.json}}` - App router routes
- `{{xs-security.json}}` - Authentication setup
