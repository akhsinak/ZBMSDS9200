using { local.email as my } from '../db/emails';

@path: 'email'
service EmailService {
  @odata.draft.enabled
  entity Emails as projection on my.Emails;
}
