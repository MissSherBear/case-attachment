# Custom Case Creation Form
This is a custom visualforce form to create new cases in Salesforce. This form enables the user to upload a file during the initial creation of the Case instead of having to add a file after the Case record has been created. 
## CaseAttachment Markup 
```html
<apex:page lightningStylesheets="true" standardController="case" extensions="caseattachment,FileUploadController">

    <apex:form enctype="multipart/form-data">
        <apex:pageMessages />
        <apex:pageBlock title="New Ticket: Service Request">
            <apex:pageBlockSection title="Details" collapsible="false" dir="LTR">

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="Subject" />
                    <apex:inputField value="{!objcase.Subject}" />
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="Description" />
                    <apex:inputField value="{!objcase.Description}" />
                </apex:pageBlockSectionItem>

            </apex:pageBlockSection>
            <apex:pageBlockSection title="Case Information" collapsible="false">
                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="Case Owner" />
                    <apex:outputlabel value="{!$User.FirstName} {!$User.LastName}" />
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="Plan" />
                    <apex:inputField value="{!objcase.Plan__c}" />
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="Priority" />
                    <apex:inputField value="{!objcase.Priority}" />
                </apex:pageBlockSectionItem>

                <apex:inputField value="{!objcase.Category__c}" />
                <apex:inputField value="{!objcase.Due_Date__c}" />
                <apex:inputField value="{!objcase.Origin}" />
                <apex:inputField value="{!objcase.Sub_Category__c}" />
            </apex:pageBlockSection>
            <apex:pageBlockSection title="Attachments" collapsible="false" columns="2" id="block1">

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="File Name" for="fileName" />
                    <apex:inputText value="{!document.name}" id="fileName" />
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="File" for="file" />
                    <apex:inputFile value="{!document.body}" filename="{!document.name}" id="file" />
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="Description" for="description" />
                    <apex:inputTextarea value="{!document.description}" id="description" />
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem>
                    <apex:outputLabel style="color:blueviolet;font-weight:bold;" value="Keywords" for="keywords" />
                    <apex:inputText value="{!document.keywords}" id="keywords" />
                </apex:pageBlockSectionItem>

            </apex:pageBlockSection>

            <apex:pageBlockButtons>
                <apex:commandButton style="background-color:blueviolet;color:white;font-weight:bold;" action="{!upload}"
                    value="Save" />
            </apex:pageBlockButtons>

        </apex:pageBlock>
    </apex:form>
</apex:page>
```
## CaseAttachment Apex Class:
```java 
public class caseattachment {
public case objcase{get;set;}
public Attachment myAttachment{get;set;}
public string fileName{get;set;} 
public Blob fileBody{get;set;}

    public caseattachment(Apexpages.standardcontroller controller) {
        objcase = new case();
        myAttachment =new Attachment();
    }
    public pagereference save() {
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
```
## FileUploadController:
```java
public with sharing class FileUploadController {

    public FileUploadController(ApexPages.StandardController controller) {

    }
  public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }
 
  public PageReference upload() {
 
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder
 
    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
      return null;
    } finally {
      document.body = null; // clears the viewstate
      document = new Document();
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    return null;
  }
 
}
```
