public class caseattachment
{
public case objcase{get;set;}
public Attachment myAttachment{get;set;}
public string fileName{get;set;} 
public Blob fileBody{get;set;}

    public caseattachment(Apexpages.standardcontroller controller)
    {
        objcase = new case();
        myAttachment =new Attachment();
    }
    public pagereference save()
    {
        insert objcase;
        System.debug('@@@@@fileBody'+fileBody); 
        if(myAttachment == null) {
    myAttachment = new Attachment();
    myAttachment.body = Blob.valueOf('');
}    
return attachment;    
        myAttachment  = new Attachment();
              Integer i=0;
              myAttachment .clear();
              myAttachment.Body = fileBody; 
              myAttachment.Name = 'Logo_'+objcase.id+'.jpeg' ; 
              myAttachment.ParentId = objcase.id;             
              insert myAttachment;                 
        pagereference pr = new pagereference('/'+objcase.id);                           
        return pr;
    }
}