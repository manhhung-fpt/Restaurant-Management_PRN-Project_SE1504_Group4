using QuanLyQuanAn.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanAn.DAO
{
    public class AccountDAO
    {
        private static AccountDAO instance;

        public static AccountDAO Instance
        {
            get { if (instance == null) instance = new AccountDAO(); return instance; }
            private set { instance = value; }
        }
        private AccountDAO() { }

        public bool Login(string userName, string passWord)
        {
            string query = "USP_Login @userName , @passWord";
            DataTable result = DataProvider.Instance.ExecuteQuery(query, new object[] { userName, passWord });
            return result.Rows.Count > 0;
        }
        public bool IsActiveAccount(string userName)
        {
            DataTable result = DataProvider.Instance.ExecuteQuery("select * from Account where userName = N'" + userName + "' and status = 'active'");
            return result.Rows.Count > 0;
        }
        public bool IsExistUserName(string userName)
        {
            DataTable result = DataProvider.Instance.ExecuteQuery("select * from Account where userName = N'" + userName + "'");
            return result.Rows.Count > 0;
        }
        public Account GetAccountByUserName(string userName)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("select * from account where userName = '" + userName + "'");
            foreach (DataRow item in data.Rows)
            {
                return new Account(item);
            }
            return null;
        }
        public void UpdateAccountProfile(string userName, string displayName, string newPass)
        {
            string query = "update Account set DisplayName = N'" + displayName + "', PassWord = '" + newPass + "' where UserName = '" + userName + "'";
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public bool ResetPassword(string userName)
        {
            string query = "update Account set PassWord = '123456' where userName = '" + userName + "'";
            return DataProvider.Instance.ExecuteNonQuery(query)>0;
        }
        public void DeleteAccount(string userName)
        {
            string query = "update Account set Status = N'deleted' where UserName = '" + userName + "'";
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public bool InsertAccount(Account newAcc)
        {
            string query = "insert into Account(userName, displayName, PassWord, Type, Status) values('" + newAcc.UserName + "', N'" + newAcc.DisplayName + "', '123456', '" + newAcc.Type + "', 'active')";
            return DataProvider.Instance.ExecuteNonQuery(query) > 0;
        }
        public void UpdateAccountByAdmin(Account acc)
        {
            string query = "update Account set DisplayName = '" + acc.DisplayName + "', type = '" + acc.Type + "', status ='" + acc.Status + "' where UserName = '" + acc.UserName + "'";
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public DataTable LoadListAccount()
        {
            return DataProvider.Instance.ExecuteQuery("select userName, displayName, type, status from Account where status != N'deleted'");
        }
    }
}
