# UI Layer

The UI layer provides the Fiori elements interface for managing emails. It uses SAP Fiori elements templates with custom extensions for specific behaviors.

## Fiori Application Structure

### Location
```
app/browse/
├── webapp/               # UI5 application
│   ├── ext/              # Controller extensions
│   ├── i18n/             # Translations
│   ├── Component.js      # UI5 component
│   ├── index.html        # Entry point
│   └── manifest.json     # App descriptor
├── fiori-service.cds     # UI annotations
├── package.json          # App dependencies
├── ui5.yaml              # Build config
└── xs-app.json           # App router config
```

## UI5 Application Manifest

### `{{app/browse/webapp/manifest.json}}`

This is the central configuration file for the Fiori application.

### Key Sections

#### Application ID
```json
"sap.app": {
  "id": "localemailapp2.browse",
  "type": "application",
  "version": "1.0.2"
}
```

#### Data Source (OData Service)
```json
"dataSources": {
  "EmailService": {
    "uri": "/odata/v4/email/",
    "type": "OData",
    "settings": {
      "odataVersion": "4.0"
    }
  }
}
```

Connects to the `{{srv/cat-service.cds}}` endpoint.

#### Controller Extensions
```json
"extends": {
  "extensions": {
    "sap.ui.controllerExtensions": {
      "sap.fe.templates.ListReport.ListReportController": {
        "controllerName": "localemailapp2.browse.ext.EmailsListReportExt"
      },
      "sap.fe.templates.ObjectPage.ObjectPageController": {
        "controllerName": "localemailapp2.browse.ext.EmailsObjectPageExt"
      }
    }
  }
}
```

Registers custom controller extensions for:
- **ListReport**: `{{app/browse/webapp/ext/EmailsListReportExt.controller.js}}`
- **ObjectPage**: `{{app/browse/webapp/ext/EmailsObjectPageExt.controller.js}}`

#### Routing Configuration

The app has two routes:

| Route | Pattern | Target | Purpose |
|-------|---------|--------|---------|
| `EmailsList` | `:?query:` | `EmailsList` | Main list view |
| `EmailsDetails` | `Emails({key}):?query:` | `EmailsDetails` | Detail/edit view |

#### Targets

**List Report Target**:
```json
"EmailsList": {
  "type": "Component",
  "name": "sap.fe.templates.ListReport",
  "options": {
    "settings": {
      "entitySet": "Emails",
      "liveMode": true,
      "navigation": {
        "Emails": {
          "detail": {
            "route": "EmailsDetails"
          }
        }
      }
    }
  }
}
```

**Object Page Target**:
```json
"EmailsDetails": {
  "type": "Component",
  "name": "sap.fe.templates.ObjectPage",
  "options": {
    "settings": {
      "entitySet": "Emails"
    }
  }
}
```

## Controller Extensions

### `{{app/browse/webapp/ext/EmailsObjectPageExt.controller.js}}`

This extension modifies the default navigation behavior.

```javascript
sap.ui.define(["sap/ui/core/mvc/ControllerExtension", "sap/base/Log"], 
  function (ControllerExtension, Log) {
    "use strict";

    return ControllerExtension.extend("localemailapp2.browse.ext.EmailsObjectPageExt", {
      override: {
        editFlow: {
          onAfterSave: function () {
            try {
              var oExtensionAPI = this.base && this.base.getExtensionAPI && this.base.getExtensionAPI();
              if (oExtensionAPI && oExtensionAPI.routing && oExtensionAPI.routing.navigateToRoute) {
                oExtensionAPI.routing.navigateToRoute("EmailsList");
              }
            } catch (e) {
              Log.error("Failed to navigate back to Emails list after save", e);
            }
          }
        }
      }
    });
  }
);
```

### What It Does

| Standard Behavior | Custom Behavior |
|-------------------|-----------------|
| After Create: Navigate to Object Page (view mode) | After Create: Navigate back to List Report |
| User sees newly created record in detail view | User sees updated list with new record |

### Navigation Flow

```
List Report (Screen 1) 
    ↓ [Click Create]
Object Page in Create Mode (Screen 2)
    ↓ [Click Create/Save]
List Report with new record (Back to Screen 1) ← Custom behavior
    ↓
(Instead of: Object Page View Mode (Screen 3))
```

### `{{app/browse/webapp/ext/EmailsListReportExt.controller.js}}`

Placeholder extension for the List Report:

```javascript
sap.ui.define(["sap/ui/core/mvc/ControllerExtension"], 
  function (ControllerExtension) {
    "use strict";

    return ControllerExtension.extend("localemailapp2.browse.ext.EmailsListReportExt", {
      onInit: function () {
        // no-op - reserved for future extensions
      }
    });
  }
);
```

## Fiori Annotations

### `{{app/browse/fiori-service.cds}}`

CDS annotations that configure the Fiori UI appearance and behavior.

#### Header Information
```cds
annotate EmailService.Emails with @(
  UI.HeaderInfo : {
    TypeName       : 'Email',
    TypeNamePlural : 'Emails',
    Title          : { Value: address }
  }
);
```

#### List Report Configuration
```cds
annotate EmailService.Emails with @(UI : {
  SelectionFields : [ address ],
  LineItem        : [
    { Value: address, Label: 'Email Address' },
    { Value: createdAt, Label: 'Created At' },
    { Value: modifiedAt, Label: 'Modified At' },
  ]
});
```

| Annotation | Purpose |
|------------|---------|
| `SelectionFields` | Fields shown in the filter bar |
| `LineItem` | Columns displayed in the table |

#### CRUD Capabilities
```cds
annotate EmailService.Emails with @(
  Capabilities.InsertRestrictions.Insertable : true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true
);
```

## UI5 Bootstrap

### `{{app/browse/webapp/index.html}}`

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script
        id="sap-ui-bootstrap"
        src="https://sapui5.hana.ondemand.com/1.136/resources/sap-ui-core.js"
        data-sap-ui-theme="sap_horizon"
        data-sap-ui-resourceroots='{"localemailapp2.browse": "./"}'
        data-sap-ui-oninit="module:sap/ui/core/ComponentSupport"
        data-sap-ui-compatVersion="edge"
        data-sap-ui-async="true"
    ></script>
</head>
<body class="sapUiBody sapUiSizeCompact" id="content">
    <div
        data-sap-ui-component
        data-name="localemailapp2.browse"
        data-id="container"
        data-settings='{"id":"container"}'
    ></div>
</body>
</html>
```

### Key Settings

| Setting | Value | Description |
|---------|-------|-------------|
| `data-sap-ui-theme` | `sap_horizon` | SAP's latest Fiori theme |
| `data-sap-ui-async` | `true` | Asynchronous module loading |
| UI5 Version | `1.136.0` | SAPUI5 version from CDN |

## Internationalization

### `{{app/browse/webapp/i18n/i18n.properties}}`

```properties
appTitle = Emails
appSubTitle = Email Application
appDescription = Email Application
```

These strings are referenced in the manifest as `{{appTitle}}`, `{{appSubTitle}}`, and `{{appDescription}}`.

## Component Definition

### `{{app/browse/webapp/Component.js}}`

```javascript
sap.ui.define(["sap/fe/core/AppComponent"], 
  ac => ac.extend("localemailapp2.browse.Component", {
    metadata:{ manifest:'json' }
  })
);
```

This is a standard Fiori elements application component that loads the manifest.

## Related Files

- Service: `{{srv/cat-service.cds}}` - OData service consumed by the UI
- Annotations: `{{app/browse/fiori-service.cds}}` - UI annotations
- Manifest: `{{app/browse/webapp/manifest.json}}` - Main app configuration


