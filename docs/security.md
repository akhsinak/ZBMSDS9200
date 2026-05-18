# Security & Authorization

This document describes the security architecture of the Email Application, including authentication, authorization, and data access control.

## Overview

The application implements a comprehensive security model:

1. **Authentication**: XSUAA (XS Advanced User Authentication & Authorization)
2. **Authorization**: Role-based access control (RBAC)
3. **Data Access**: Row-level security based on `createdBy` field

## Authentication

### XSUAA Integration

The application uses SAP XSUAA for authentication, integrated with SAP BTP's Identity Provider.

### Configuration

**`{{xs-security.json}}`**:

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

### Authentication Flow

```
User → App Router → XSUAA → Identity Provider
         ↓
    JWT Token issued
         ↓
    Token validated on each request
```

### Routes Protection

**`{{app/browse/xs-app.json}}`**:

| Route               | Authentication |
| ------------------- | -------------- |
| `/resources/*`      | None (public)  |
| `/test-resources/*` | None (public)  |
| `/odata/*`          | XSUAA          |
| `/*` (app)          | XSUAA          |

### Mocked Authentication (Local Development)

During local development (`cds watch` or `npm start`), CAP uses mocked authentication:

```
[cds] - using auth strategy {
  kind: 'mocked',
  impl: 'node_modules\\@sap\\cds\\lib\\srv\\middlewares\\auth\\basic-auth.js'
}
```

With mocked auth, a default user ID is provided for testing.

---

## Authorization

### Role-Based Access Control

| Role   | Scope             | Access                  |
| ------ | ----------------- | ----------------------- |
| `User` | `$XSAPPNAME.User` | Full CRUD on own emails |

### Scope Definition

```json
{
  "name": "$XSAPPNAME.User",
  "description": "User"
}
```

### Role Assignment

Roles are assigned to users in the SAP BTP cockpit under:

- **Security** → **Role Collections**
- Assign role collection to users or groups

---

## Row-Level Security

### Implementation

Data access is restricted at the row level through the `{{srv/cat-service.js}}` READ handler:

```javascript
this.on("READ", "Emails", async (req, next) => {
  const userId = req.user && req.user.id;
  if (userId && req.query && req.query.SELECT) {
    req.query.where({ createdBy: userId });
  }
  return next();
});
```

### How It Works

1. **User Makes Request**: User queries `/odata/v4/email/Emails`
2. **Handler Intercepts**: The READ handler adds a WHERE clause
3. **Query Modified**: Original query becomes `SELECT ... WHERE createdBy = '<user-id>'`
4. **Database Query**: Only matching rows are returned

### Example Scenarios

| User              | Action                        | Database Query                                                  | Result              |
| ----------------- | ----------------------------- | --------------------------------------------------------------- | ------------------- |
| alice@example.com | GET /Emails                   | `WHERE createdBy = 'alice@example.com'`                         | Only Alice's emails |
| bob@example.com   | GET /Emails                   | `WHERE createdBy = 'bob@example.com'`                           | Only Bob's emails   |
| alice@example.com | GET Emails(ID='bob-email-id') | `WHERE ID = 'bob-email-id' AND createdBy = 'alice@example.com'` | No results (404)    |

### Data Isolation

| User   | Can See         | Can Edit        | Can Delete      |
| ------ | --------------- | --------------- | --------------- |
| User A | Own emails only | Own emails only | Own emails only |
| User B | Own emails only | Own emails only | Own emails only |

---

## Managed Aspect

The security model relies on the `managed` aspect from `{{db/emails.cds}}`:

```cds
entity Emails : cuid, managed {
  address : String(255) @mandatory;
}
```

### Managed Fields

| Field        | Set On        | Description                 |
| ------------ | ------------- | --------------------------- |
| `createdBy`  | Insert        | User who created the record |
| `modifiedBy` | Insert/Update | User who last modified      |

These fields are automatically populated by CAP based on the authenticated user.

---

## Security Best Practices

### OData Security

| OData Feature | Security                              |
| ------------- | ------------------------------------- |
| `$filter`     | Combined with `createdBy` restriction |
| `$search`     | Searches within user's own data only  |
| `$expand`     | Respects entity-level permissions     |
| `$count`      | Counts only user's records            |

---

## Related Files

- Service Layer: `{{srv/cat-service.js}}` - Implements row-level security
- XSUAA Config: `{{xs-security.json}}` - Authentication configuration
- App Router: `{{app/browse/xs-app.json}}` - Route protection
- Database: `{{db/emails.cds}}` - `managed` aspect
