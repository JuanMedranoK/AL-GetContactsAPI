page 50120 "JK API External Contacts"
{
    ApplicationArea = All;
    Caption = 'JK External Contacts';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "JK API Contacts";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(LastName; Rec.LastName)
                {
                    ApplicationArea = All;
                }
                field(Phone; Rec."Phone Text")
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    APIManagement: Codeunit "JK API Management";
                begin
                    if Confirm('¿Desea consultar la API e importar los contactos?', false) then begin
                        APIManagement.GetExternalContactsAPI();
                        CurrPage.Update(false);
                    end;
                end;
            }

            action(ClearExternalContacts)
            {
                Caption = 'Clear External Contacts';
                Image = Delete;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    APIManagement: Codeunit "JK API Management";
                begin
                    APIManagement.ClearExternalContacts();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
