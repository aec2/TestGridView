<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FileUploadTest.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Document List</title>
    <style type="text/css">
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .gridview-header th {
            background-color: #f2f2f2;
            padding: 10px;
            text-align: left;
            border-bottom: 2px solid #ddd;
            cursor: pointer;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .gridview-row td, .gridview-alternaterow td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            word-wrap: break-word;
            word-break: break-word;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: normal;
        }

        .gridview-row:hover, .gridview-alternaterow:hover {
            background-color: #f9f9f9;
        }

        .gridview-pager {
            text-align: center;
            padding: 10px;
        }

        .filter-container {
            margin-bottom: 20px;
        }

            .filter-container input[type="text"] {
                padding: 5px;
                margin-right: 10px;
                width: 150px;
            }

            .filter-container button {
                padding: 5px 10px;
            }

        @media screen and (max-width: 768px) {
            .gridview, .gridview-header, .gridview-row, .gridview-alternaterow {
                display: block;
            }

                .gridview-header th, .gridview-row td, .gridview-alternaterow td {
                    display: block;
                    width: 100%;
                    box-sizing: border-box;
                }
        }

        .gridview-row-selected {
            background-color: #e0e0e0;
        }

        .status-label {
            padding: 5px 10px;
            border-radius: 4px;
            color: #fff;
            /*font-weight: bold;*/
            display: inline-block;
        }

            .status-label.approved {
                background-color: #d4edda; /* Light green */
                color: #155724; /* Dark green for text */
            }

            .status-label.pending {
                background-color: #fff3cd; /* Light yellow */
                color: #856404; /* Dark yellow for text */
            }

            .status-label.rejected {
                background-color: #f8d7da; /* Light red */
                color: #721c24; /* Dark red for text */
            }

            .status-label.inreview {
                background-color: #d1ecf1; /* Light blue */
                color: #0c5460; /* Dark blue for text */
            }


        /* Action Button Styles */
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }

        .action-button {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            color: #fff;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            white-space: nowrap;
        }

            .action-button.view {
                background-color: #007bff; /* Blue */
            }

            .action-button.edit {
                background-color: #28a745; /* Green */
            }

            .action-button.delete {
                background-color: #dc3545; /* Red */
            }

            .action-button:hover {
                opacity: 0.9;
            }

            .action-button::before {
                margin-right: 5px;
            }

            .action-button.view::before {
                content: '\1F441';
            }

            .action-button.edit::before {
                content: '\270E';
            }

            .action-button.delete::before {
                content: '\1F5D1';
            }

        /* Column Widths */
        .col-documentid {
            width: 10%;
        }

        .col-date {
            width: 10%;
        }

        .col-status {
            width: 10%;
        }

        .col-actions {
            width: 10%;
        }

        .filter-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px; /* Space between elements */
            margin-bottom: 20px; /* Spacing below the filter section */
            align-items: center;
        }

        .filter-input {
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background-color: #f8f9fa;
            font-size: 14px;
            width: 150px;
            transition: border-color 0.3s ease;
        }

            .filter-input:focus {
                border-color: #80bdff;
                outline: none;
            }

        .filter-button {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            background-color: #007bff;
            color: white;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

            .filter-button:hover {
                background-color: #0056b3;
            }

        .clear-button {
            background-color: #6c757d;
        }

            .clear-button:hover {
                background-color: #5a6268;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <!-- Filtering options -->
            <div class="filter-container">
                <asp:TextBox ID="txtFilterDocumentID" runat="server" CssClass="filter-input" Placeholder="Document ID"></asp:TextBox>
                <asp:TextBox ID="txtFilterDate" runat="server" CssClass="filter-input" Placeholder="Date"></asp:TextBox>
                <asp:TextBox ID="txtFilterStatus" runat="server" CssClass="filter-input" Placeholder="Status"></asp:TextBox>
                <asp:Button ID="btnFilter" runat="server" CssClass="filter-button" Text="Filter" OnClick="btnFilter_Click" />
                <asp:Button ID="btnClearFilter" runat="server" CssClass="filter-button clear-button" Text="Clear" OnClick="btnClearFilter_Click" />
            </div>


            <!-- GridView -->
            <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="False"
                AllowSorting="True" AllowPaging="True" PageSize="10"
                OnSorting="gvDocuments_Sorting" OnPageIndexChanging="gvDocuments_PageIndexChanging"
                OnRowCommand="gvDocuments_RowCommand"
                CssClass="gridview" HeaderStyle-CssClass="gridview-header" RowStyle-CssClass="gridview-row"
                AlternatingRowStyle-CssClass="gridview-alternaterow" PagerStyle-CssClass="gridview-pager">

                <Columns>
                    <asp:BoundField DataField="DocumentID" HeaderText="Document ID" SortExpression="DocumentID">
                        <HeaderStyle CssClass="col-documentid" />
                        <ItemStyle CssClass="col-documentid" />
                    </asp:BoundField>

                    <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date" DataFormatString="{0:yyyy-MM-dd}">
                        <HeaderStyle CssClass="col-date" />
                        <ItemStyle CssClass="col-date" />
                    </asp:BoundField>

                    <asp:TemplateField HeaderText="Status" SortExpression="Status">
                        <HeaderStyle CssClass="col-status" />
                        <ItemStyle CssClass="col-status" />
                        <ItemTemplate>
                            <span class='<%# "status-label " + Eval("Status").ToString().ToLower() %>'>
                                <%# Eval("Status") %>
                        </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <HeaderStyle CssClass="col-actions" />
                        <ItemStyle CssClass="col-actions" />
                        <ItemTemplate>
                            <div class="action-buttons">
                                <asp:LinkButton ID="lnkView" runat="server" CommandName="View" CommandArgument='<%# Eval("DocumentID") %>' CssClass="action-button view">View</asp:LinkButton>
                                <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" CommandArgument='<%# Eval("DocumentID") %>' CssClass="action-button edit">Edit</asp:LinkButton>
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("DocumentID") %>' CssClass="action-button delete" OnClientClick="return confirm('Are you sure you want to delete this document?');">Delete</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

        </div>
    </form>
</body>
</html>
