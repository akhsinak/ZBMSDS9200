# File Reference

This page is a quick lookup of the most important files in the repository, with short descriptions.

## Backend (CAP)
  [`{{db/emails.cds}}`](../db/emails.cds)
- `{{db/emails.cds}}`
  - Defines the `Emails` entity. Uses `cuid` + `managed`.

- `{{srv/cat-service.cds}}`
  - Defines `EmailService` and exposes `Emails` via OData V4 with draft.

- `{{srv/cat-service.js}}`
  - Adds a `READ` handler to restrict results to `createdBy = req.user.id`.

- `{{app/services.cds}}`
  - Re-exports the Fiori annotation model used by the UI.

- `{{app/browse/fiori-service.cds}}`
  - Adds Fiori elements UI annotations (ListReport + ObjectPage).

## UI (Fiori elements)

- `{{app/browse/webapp/index.html}}`
  - Boots SAPUI5 from CDN and loads the UI5 Component.

- `{{app/browse/webapp/Component.js}}`
  - UI5 component extending `sap/fe/core/AppComponent`.

- `{{app/browse/webapp/manifest.json}}`
  - Main UI5 descriptor:
    - OData data source
    - routing targets for ListReport + ObjectPage
    - controller extensions

- `{{app/browse/webapp/ext/EmailsObjectPageExt.controller.js}}`
  - Overrides `editFlow.onAfterSave` to navigate back to `EmailsList`.

- `{{app/browse/webapp/ext/EmailsListReportExt.controller.js}}`
  - ListReport extension placeholder.

## Deployment / Security

- `{{mta.yaml}}`
  - MTA definition for BTP deployment (srv + db + html5 repo + destinations + xsuaa).

- `{{manifest.yml}}`
  - Simple Cloud Foundry manifest for deploying the srv module.

- `{{xs-security.json}}`
  - XSUAA scopes and role templates.

- `{{app/browse/xs-app.json}}`
  - UI app router routes, destinations, and auth enforcement.

## Docs (GitBook)

- `{{docs/README.md}}`
  - Documentation landing page.

- `{{docs/SUMMARY.md}}`
  - GitBook navigation file.

- `{{docs/project-structure.md}}`
  - Folder/file structure details.

- `{{docs/database-layer.md}}`
  - Data model documentation.

- `{{docs/service-layer.md}}`
  - OData service + custom handler documentation.

- `{{docs/ui-layer.md}}`
  - UI manifest, routing, controller extensions, and annotations.

- `{{docs/configuration-files.md}}`
  - package.json, ui5.yaml, mta.yaml, etc.

- `{{docs/security.md}}`
  - Auth + authorization + data isolation.

- `{{docs/deployment.md}}`
  - Build + deployment flow.
