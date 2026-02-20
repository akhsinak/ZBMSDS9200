using { cuid, managed } from '@sap/cds/common';

namespace local.email;

entity Emails : cuid, managed {
  address : String(255) @mandatory;
}
