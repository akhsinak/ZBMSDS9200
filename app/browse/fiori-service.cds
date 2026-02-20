using EmailService from '../../srv/cat-service';

////////////////////////////////////////////////////////////////////////////
//
//	Emails Object Page
//
annotate EmailService.Emails with @(
  Capabilities.InsertRestrictions.Insertable : true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI : {
  HeaderInfo : {
    TypeName       : 'Email',
    TypeNamePlural : 'Emails',
    Title          : { Value: address }
  },
  Identification : [
    { Value: address, Label: 'Email Address' }
  ]
});

annotate EmailService.Emails with {
  ID @Core.Computed;
};


////////////////////////////////////////////////////////////////////////////
//
//	Emails List Page
//
annotate EmailService.Emails with @(UI : {
  SelectionFields : [
    address
  ],
  LineItem        : [
    { Value: address, Label: 'Email Address' },
    { Value: createdAt, Label: 'Created At' },
    { Value: modifiedAt, Label: 'Modified At' },
  ]
});
