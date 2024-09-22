using System;
using System.IO;
using System.Web.UI;
using System.Xml.Linq;
using DocumentFormat.OpenXml.Packaging;
using OpenXmlPowerTools;

namespace FileUploadTest
{
    public partial class Approval : System.Web.UI.Page
    {
        // Path to store approved documents
        private string approvedDocsPath;
        // Session key for storing the generated document filename
        private const string GeneratedDocSessionKey = "GeneratedDocFileName";

        protected void Page_Load(object sender, EventArgs e)
        {
            approvedDocsPath = Server.MapPath("~/ApprovedDocs/");
            if (!Directory.Exists(approvedDocsPath))
            {
                Directory.CreateDirectory(approvedDocsPath);
            }

            if (!IsPostBack)
            {
                // Retrieve the document filename from session
                string fileName = Session[GeneratedDocSessionKey] as string;
                if (string.IsNullOrEmpty(fileName))
                {
                    LiteralMessage.Text = "<div class='message'>No document pending for approval.</div>";
                    ButtonApprove.Visible = false;
                    ButtonReject.Visible = false;
                    return;
                }

                string docPath = Server.MapPath("~/GeneratedDocs/" + fileName);
                // Convert DOCX to HTML for preview
                string htmlString = ConvertDocxToHtml(docPath);
                PlaceholderPreview.Controls.Add(new LiteralControl(htmlString));
            }
        }

        private string ConvertDocxToHtml(string docxFilePath)
        {
            try
            {
                byte[] byteArray = File.ReadAllBytes(docxFilePath);
                using (MemoryStream mem = new MemoryStream())
                {
                    mem.Write(byteArray, 0, byteArray.Length);
                    using (WordprocessingDocument doc = WordprocessingDocument.Open(mem, true))
                    {
                        HtmlConverterSettings settings = new HtmlConverterSettings()
                        {
                            PageTitle = "Preview"
                        };
                        XElement htmlElement = HtmlConverter.ConvertToHtml(doc, settings);
                        string html = htmlElement.ToString(SaveOptions.DisableFormatting);
                        return html;
                    }
                }
            }
            catch (Exception ex)
            {
                return "<div class='message'>Error converting DOCX to HTML: " + ex.Message + "</div>";
            }
        }

        protected void ButtonApprove_Click(object sender, EventArgs e)
        {
            string fileName = Session[GeneratedDocSessionKey] as string;
            if (!string.IsNullOrEmpty(fileName))
            {
                string sourcePath = Server.MapPath("~/GeneratedDocs/" + fileName);
                string destPath = Path.Combine(approvedDocsPath, fileName);
                File.Move(sourcePath, destPath);
                LiteralMessage.Text = "<div class='message'>Document approved and available for download.</div>";
                // Clear session
                Session[GeneratedDocSessionKey] = null;
            }
            ButtonApprove.Visible = false;
            ButtonReject.Visible = false;
        }

        protected void ButtonReject_Click(object sender, EventArgs e)
        {
            string fileName = Session[GeneratedDocSessionKey] as string;
            if (!string.IsNullOrEmpty(fileName))
            {
                string sourcePath = Server.MapPath("~/GeneratedDocs/" + fileName);
                if (File.Exists(sourcePath))
                {
                    File.Delete(sourcePath);
                }
                LiteralMessage.Text = "<div class='message'>Document rejected.</div>";
                // Clear session
                Session[GeneratedDocSessionKey] = null;
            }
            ButtonApprove.Visible = false;
            ButtonReject.Visible = false;
        }
    }
}
