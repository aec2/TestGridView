using OpenXmlPowerTools;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using DocumentFormat.OpenXml.Packaging;

namespace FileUploadTest
{
    public partial class Default : System.Web.UI.Page
    {
        private DataTable DocumentsTable
        {
            get
            {
                if (ViewState["DocumentsTable"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("DocumentID", typeof(int));
                    dt.Columns.Add("Date", typeof(DateTime));
                    dt.Columns.Add("Status", typeof(string));

                    // Sample data with varied statuses
                    for (int i = 1; i <= 100; i++)
                    {
                        string status;
                        switch (i % 4)
                        {
                            case 0: status = "Approved"; break;
                            case 1: status = "Pending"; break;
                            case 2: status = "Rejected"; break;
                            default: status = "InReview"; break;
                        }
                        dt.Rows.Add(i, DateTime.Now.AddDays(-i), status);
                    }

                    ViewState["DocumentsTable"] = dt;
                }

                return ViewState["DocumentsTable"] as DataTable;
            }
            set
            {
                ViewState["DocumentsTable"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            DataView dv = new DataView(DocumentsTable);
            // Apply filtering
            string filterExpression = GetFilterExpression();
            if (!string.IsNullOrEmpty(filterExpression))
            {
                dv.RowFilter = filterExpression;
            }
            // Apply sorting
            if (ViewState["SortExpression"] != null)
            {
                dv.Sort = ViewState["SortExpression"].ToString();
            }
            gvDocuments.DataSource = dv;
            gvDocuments.DataBind();
        }

        private string GetFilterExpression()
        {
            string filter = "";

            if (!string.IsNullOrEmpty(txtFilterDocumentID.Text))
            {
                filter += string.Format("Convert(DocumentID, 'System.String') LIKE '%{0}%'", txtFilterDocumentID.Text.Replace("'", "''"));
            }
            if (!string.IsNullOrEmpty(txtFilterDate.Text))
            {
                if (filter.Length > 0) filter += " AND ";
                filter += string.Format("Convert(Date, 'System.String') LIKE '%{0}%'", txtFilterDate.Text.Replace("'", "''"));
            }
            if (!string.IsNullOrEmpty(txtFilterStatus.Text))
            {
                if (filter.Length > 0) filter += " AND ";
                filter += string.Format("Status LIKE '%{0}%'", txtFilterStatus.Text.Replace("'", "''"));
            }

            return filter;
        }

        protected void gvDocuments_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortExpression = e.SortExpression;
            string direction = "ASC";

            if (ViewState["SortExpression"] != null)
            {
                string[] sortData = ViewState["SortExpression"].ToString().Split(' ');
                if (sortData[0] == sortExpression)
                {
                    direction = sortData[1] == "ASC" ? "DESC" : "ASC";
                }
            }

            ViewState["SortExpression"] = sortExpression + " " + direction;
            BindGrid();
        }

        protected void gvDocuments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDocuments.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvDocuments.PageIndex = 0;
            BindGrid();
        }

        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            txtFilterDocumentID.Text = "";
            txtFilterDate.Text = "";
            txtFilterStatus.Text = "";
            BindGrid();
        }

        protected void gvDocuments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int documentID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "View")
            {
                // Redirect to view page
                Response.Redirect("ViewDocument.aspx?DocumentID=" + documentID);
            }
            else if (e.CommandName == "Edit")
            {
                // Redirect to edit page
                Response.Redirect("EditDocument.aspx?DocumentID=" + documentID);
            }
            else if (e.CommandName == "Delete")
            {
                // Delete the document
                DeleteDocument(documentID);
                BindGrid();
            }
        }

        private void DeleteDocument(int documentID)
        {
            // Implement your delete logic here
            DataRow[] rows = DocumentsTable.Select("DocumentID = " + documentID);
            if (rows.Length > 0)
            {
                DocumentsTable.Rows.Remove(rows[0]);
            }
        }
    }
}