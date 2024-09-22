<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Approval.aspx.cs" Inherits="FileUploadTest.Approval" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Approval Page</title>
    <style>
        /* Basic styling */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        #preview {
            border: 1px solid #ccc;
            padding: 10px;
        }
        .message {
            color: green;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div>
        <h2>Manager Approval</h2>
        <div id="preview">
            <asp:PlaceHolder ID="PlaceholderPreview" runat="server"></asp:PlaceHolder>
        </div>
        <br />
        <asp:Button ID="ButtonApprove" runat="server" Text="Approve" OnClick="ButtonApprove_Click" />
        <asp:Button ID="ButtonReject" runat="server" Text="Reject" OnClick="ButtonReject_Click" />
        <br /><br />
        <asp:Literal ID="LiteralMessage" runat="server"></asp:Literal>
    </div>
</form>
</body>
</html>