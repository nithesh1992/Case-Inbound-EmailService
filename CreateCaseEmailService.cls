global Class CreateCaseEmailService implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                           Messaging.InboundEnvelope envelope) {
                                                               
           Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
           Case newCase = new Case();
           newCase.Status = 'New';
           newCase.Origin = 'Email';
           newCase.Subject = email.subject;
           newCase.Description = email.plainTextBody;
           newCase.SuppliedEmail = envelope.fromAddress;
           try{
               Contact con = [SELECT Id, Name, Email From Contact 
                              Where Email = :envelope.fromAddress LIMIT 1];
               if (con != null){
                   newCase.ContactId = con.Id;
               }
           }
           catch (QueryException e ) {
               System.debug( 'Query Exception: '+ e.getMessage());
           }
           
           
           
           insert newCase;
           System.debug('Case Created with ID: ' + newcase.Id);
           
           return result;
           
       }
    
}