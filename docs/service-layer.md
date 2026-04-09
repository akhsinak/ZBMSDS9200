# Service Layer

The service layer exposes the data model through OData services and implements business logic. It serves as the API between the database and the UI.

## Service Definition

### `{{srv/cat-service.cds}}`

```cds
using { local.email as my } from '../db/emails';

@path: 'email'
service EmailService {
  @odata.draft.enabled
  entity Emails as projection on my.Emails;
}
```

### Key Elements

| Element | Value | Description |
|---------|-------|-------------|
| `@path` | `'email'` | Service endpoint: `/odata/v4/email/` |
| Service Name | `EmailService` | OData service identifier |
| Entity | `Emails` | Projection on `my.Emails` (from `{{db/emails.cds}}`) |
| `@odata.draft.enabled` | - | Enables draft capabilities for create/edit |

## OData V4 Features

### Draft Support

The `@odata.draft.enabled` annotation enables:
- **Draft Creation**: Users can start creating without immediately saving
- **Active/Edit Modes**: Support for viewing vs. editing data
- **Discard Changes**: Ability to cancel edits without saving

Draft entities have these additional properties:
- `IsActiveEntity` - Whether this is the active (saved) version
- `HasDraftEntity` - Whether a draft exists for this entity
- `HasActiveEntity` - Whether an active version exists

## Service Implementation

### `{{srv/cat-service.js}}`

```javascript
const cds = require('@sap/cds')

module.exports = class EmailService extends cds.ApplicationService {
  init() {
    this.on('READ', 'Emails', async (req, next) => {
      const userId = req.user && req.user.id
      if (userId && req.query && req.query.SELECT) {
        req.query.where({ createdBy: userId })
      }
      return next()
    })

    return super.init()
  }
}
```

## Custom Handlers

### READ Handler with User Filtering

The custom READ handler implements **row-level security**:

```javascript
this.on('READ', 'Emails', async (req, next) => {
  const userId = req.user && req.user.id
  if (userId && req.query && req.query.SELECT) {
    req.query.where({ createdBy: userId })
  }
  return next()
})
```

### How It Works

1. **Extract User ID**: Gets the current user's ID from `req.user.id`
2. **Inject WHERE Clause**: Adds `createdBy = <userId>` to the query
3. **Delegate**: Calls `next()` to continue with the modified query

### Security Model

| User Action | Result |
|-------------|--------|
| User A queries Emails | Only sees emails where `createdBy = 'UserA'` |
| User B queries Emails | Only sees emails where `createdBy = 'UserB'` |
| User A tries to access User B's email | Email not returned (filtered at DB level) |

## Service Endpoints

When running locally:

| Endpoint | Purpose |
|----------|---------|
| `http://localhost:4004/odata/v4/email/Emails` | Main entity collection |
| `http://localhost:4004/odata/v4/email/Emails(ID='xxx')` | Single entity |
| `http://localhost:4004/odata/v4/email/$metadata` | Service metadata |

## Data Source Configuration

### `{{app/browse/webapp/manifest.json}}`

The UI connects to this service:

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

## Related Files

- Database: `{{db/emails.cds}}` - Underlying entity with `createdBy` field
- UI Manifest: `{{app/browse/webapp/manifest.json}}` - Configures the OData data source
- XSUAA: `{{xs-security.json}}` - Authentication that populates `req.user`

## Learn More

- [CAP Services Documentation](https://cap.cloud.sap/docs/node.js/services)
- [OData V4 with Draft](https://cap.cloud.sap/docs/guides/draft/)
- [Authorization in CAP](https://cap.cloud.sap/docs/guides/authorization)
