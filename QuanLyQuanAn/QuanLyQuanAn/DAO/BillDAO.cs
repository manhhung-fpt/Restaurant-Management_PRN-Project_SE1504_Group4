using QuanLyQuanAn.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanAn.DAO
{
    public class BillDAO
    {
        // Singleton
        private static BillDAO instance;

        public static BillDAO Instance 
        {
            get { if (instance == null) instance = new BillDAO(); return BillDAO.instance; } 
            private set => instance = value; 
        }

        private BillDAO() { }
        // Thanh cong : bill ID
        // That bai : -1
        public int GetUncheckBillIDByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM dbo.Bill WHERE idTable = " + id + " AND status = 0");
            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.ID;
            }
            return -1;
        }
        public void InsertBill(int id)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_InsertBill @idTable", new object[] { id });
        }
        public int GetMaxBill()
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("select max(id) from dbo.bill");
            }
            catch
            {
                return 1;
            }
        }
        public void CheckOut(int id, int discount, float totalPrice, string cashier)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_CheckOut @id , @discount , @totalPrice , @cashier", new object[] { id, discount, totalPrice, cashier });
        }
        public DataTable GetBillListByDate(DateTime checkIn, DateTime checkOut, int billPerPage, int pageNumber)
        {
            return DataProvider.Instance.ExecuteQuery("exec USP_GetListBillByDate @checkIn , @checkOut , @billPerPage , @pageNumber", new object[] { checkIn, checkOut, billPerPage, pageNumber });
        }
        public int GetTotalBill()
        {
            return (int)DataProvider.Instance.ExecuteScalar("select count(*) from dbo.bill");
        }
    }
}
