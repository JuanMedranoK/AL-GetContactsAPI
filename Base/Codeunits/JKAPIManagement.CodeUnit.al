codeunit 50120 "JK API Management"
{
    procedure GetExternalContacts()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        OutString: Text;
        ContactRecord: Record "JK API Contacts";
    begin
        Request.SetRequestUri('https://raydelto.org/agenda.php'); // Replace with your actual API endpoint
        Request.Method := 'GET';
        if Client.Send(Request, Response) then
            // Process the response
            if response.IsSuccessStatusCode() then begin
                response.Content().ReadAs(OutString);
                Message('%1', response.Content.ReadAs(OutString));
            end else
                Error('Error in API call: %1', Response.HttpStatusCode());

    end;
}
