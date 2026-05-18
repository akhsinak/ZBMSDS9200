# Database Layer

The database layer defines the data model using SAP CAP's Core Data Services (CDS). This is the foundation of the application's data persistence.

## Entity Definition

### `{{db/emails.cds}}`

```cds
using { cuid, managed } from '@sap/cds/common';

namespace local.email;

entity Emails : cuid, managed {
  address : String(255) @mandatory;
}
```

## Key Concepts

### Namespace

```cds
namespace local.email;
```

The namespace `local.email` groups all entities within this domain. This prevents naming conflicts with other entities in larger applications.

### Entity: Emails

The `Emails` entity represents an email address stored in the system.

#### Aspects Used

| Aspect    | Purpose        | Fields Added                                         |
| --------- | -------------- | ---------------------------------------------------- |
| `cuid`    | Common UUID    | `ID : UUID` - Primary key                            |
| `managed` | Audit tracking | `createdAt`, `createdBy`, `modifiedAt`, `modifiedBy` |

#### Fields

| Field        | Type        | Properties                | Description                       |
| ------------ | ----------- | ------------------------- | --------------------------------- |
| `ID`         | UUID        | Primary Key (from `cuid`) | Unique identifier                 |
| `address`    | String(255) | `@mandatory`              | The email address (required)      |
| `createdAt`  | Timestamp   | (from `managed`)          | When record was created           |
| `createdBy`  | String      | (from `managed`)          | User who created the record       |
| `modifiedAt` | Timestamp   | (from `managed`)          | When record was last modified     |
| `modifiedBy` | String      | (from `managed`)          | User who last modified the record |

## Managed Aspect Details

The `managed` aspect from `@sap/cds/common` provides automatic audit tracking:

```cds
aspect managed {
  createdAt  : Timestamp @cds.on.insert : $now;
  createdBy  : String    @cds.on.insert : $user;
  modifiedAt : Timestamp @cds.on.insert : $now  @cds.on.update : $now;
  modifiedBy : String    @cds.on.insert : $user @cds.on.update : $user;
}
```

### How It Works

1. **On Insert (Create)**:
   - `createdAt` = current timestamp
   - `createdBy` = current user ID
   - `modifiedAt` = current timestamp
   - `modifiedBy` = current user ID

2. **On Update**:
   - `modifiedAt` = current timestamp
   - `modifiedBy` = current user ID
   - `createdAt` and `createdBy` remain unchanged

### Security Benefit

The `createdBy` field is used in `{{srv/cat-service.js}}` to implement **row-level security** - users can only see emails they created.

## Database Deployment

### HANA Cloud

For production deployment to SAP BTP with HANA Cloud:

```yaml
# From {{mta.yaml}}
resources:
  - name: zbmsds9200-db
    type: com.sap.xs.hdi-container
    parameters:
      service: hana
      service-plan: hdi-shared
```

### Local Development

For local development, SQLite is used (see `db.sqlite` in root).

## Related Files

- Service Layer: `{{srv/cat-service.cds}}` - Exposes Emails via OData
- Service Handlers: `{{srv/cat-service.js}}` - Implements user filtering using `createdBy`
- Fiori Annotations: `{{app/browse/fiori-service.cds}}` - UI annotations for the Emails entity
