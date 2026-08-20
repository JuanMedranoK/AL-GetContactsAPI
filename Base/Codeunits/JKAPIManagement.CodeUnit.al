codeunit 50120 "JK API Management"
{
    procedure ClearExternalContacts()
    var
        ContactRecord: Record "JK API Contacts";
    begin
        ContactRecord.DeleteAll();
    end;

    procedure GetExternalContactsAPI()
    var
        ResponseText: Text;
        ContactsArray: JsonArray;
        ContactToken: JsonToken;
        ContactObject: JsonObject;
        ContactRecord: Record "JK API Contacts";
        NameText: Text;
        LastNameText: Text;
        PhoneText: Text;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetExternalContactsAPI(IsHandled);
        if IsHandled then
            exit;

        ResponseText := GetExternalData();

        if not ContactsArray.ReadFrom(ResponseText) then
            Error('The API response could not be parsed as a JSON array.');

        Message('JSON response: %1', ResponseText);

        // ContactRecord.DeleteAll();

        foreach ContactToken in ContactsArray do begin
            ContactObject := ContactToken.AsObject();
            Clear(NameText);
            Clear(LastNameText);
            Clear(PhoneText);

            if ContactObject.Get('nombre', ContactToken) then
                NameText := ContactToken.AsValue().AsText();
            if ContactObject.Get('apellido', ContactToken) then
                LastNameText := ContactToken.AsValue().AsText();
            if ContactObject.Get('telefono', ContactToken) then
                PhoneText := ContactToken.AsValue().AsText();

            if (NameText <> '') or (LastNameText <> '') or (PhoneText <> '') then begin

                Clear(ContactRecord);
                ContactRecord.Init();
                ContactRecord.Name := CopyStr(NameText, 1, MaxStrLen(ContactRecord.Name));
                ContactRecord.LastName := CopyStr(LastNameText, 1, MaxStrLen(ContactRecord.LastName));
                ContactRecord."Phone Text" := CopyStr(PhoneText, 1, MaxStrLen(ContactRecord."Phone Text"));
                ContactRecord.Insert(true);

            end;
        end;
        Message('%1 contacts imported successfully.', ContactsArray.Count());
    end;

    // procedure GetAndParseJsonData()
    // var
    //     ResponseText: Text;
    //     JsonObj: JsonObject;
    //     JsonTok: JsonToken;
    //     PostTitle: Text;
    // begin
    //     // Execute the GET request defined above
    //     ResponseText := GetExternalData();

    //     // Parse the raw text string into a native JSON Object
    //     if not JsonObj.ReadFrom(ResponseText) then
    //         Error('The response could not be parsed into a valid JSON object.');

    //     // Safely extract a specific value using its property key
    //     if JsonObj.Get('title', JsonTok) then begin
    //         PostTitle := JsonTok.AsValue().AsText();
    //         Message('Successfully retrieved post title: %1', PostTitle);
    //     end;
    // end;

    local procedure GetExternalData(): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        IsSuccessful: Boolean;
        ResponseText: Text;
    begin
        IsSuccessful := Client.Get('https://raydelto.org/agenda.php', Response);

        if not IsSuccessful then
            Error('The HTTP call failed completely. Please check the network connectivity or URL.');

        if not Response.IsSuccessStatusCode() then
            Error('The API returned an error status code: %1 (%2)', Response.HttpStatusCode(), Response.ReasonPhrase());

        Response.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetExternalContactsAPI(var IsHandled: Boolean)
    begin
    end;

}
