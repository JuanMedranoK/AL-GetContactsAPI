page 50120 "JK API External Contacts"
{
    ApplicationArea = All;
    Caption = 'External Contacts';
    PageType = Card;
    UsageCategory = Lists;
    SourceTable = "JK API Contacts";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(LastName; Rec.LastName)
                {
                    ToolTip = 'Specifies the value of the LastName field.', Comment = '%';
                }
                field(Phone; Rec.Phone)
                {
                    ToolTip = 'Specifies the value of the Phone field.', Comment = '%';
                }
            }

        }
    }

    actions
    {
        area(processing)
        {
            action(GetExternalContacts)
            {
                Caption = 'Get External Contacts';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    APIManagement: Codeunit "JK API Management";
                begin
                    // TODO: Llamar al codeunit o procedimiento que obtenga contactos desde la API externa
                    APIManagement.GetExternalContacts();
                end;
            }
        }
    }
}
