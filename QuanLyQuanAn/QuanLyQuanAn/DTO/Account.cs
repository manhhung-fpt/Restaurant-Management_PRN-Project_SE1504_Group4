using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanAn.DTO
{
    public class Account
    {
        public Account(string userName, string displayName, string type, string password = null)
        {
            this.userName = userName;
            this.displayName = displayName;
            this.type = type;
            this.password = password;
        }
        public Account(DataRow row)
        {
            this.userName = row["userName"].ToString();
            this.displayName = row["displayName"].ToString();
            this.type = row["type"].ToString();
            this.password = row["password"].ToString();
        }
        public Account() { }
        string userName;
        string displayName;
        string password;
        string type;
        string status;
        public string UserName { get => userName; set => userName = value; }
        public string DisplayName { get => displayName; set => displayName = value; }
        public string Password { get => password; set => password = value; }
        public string Type { get => type; set => type = value; }
        public string Status { get => status; set => status = value; }
    }
}
