using QuanLyQuanAn.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanAn.DAO
{
    public class TableDAO
    {
        private static TableDAO instance;

        public static TableDAO Instance 
        { 
            get { if (instance == null) instance = new TableDAO(); return TableDAO.instance; }
            private set { TableDAO.instance = value; } 
        }
        public static int TableWidth = 100;
        public static int TabeHeight = 100;

        private TableDAO() { }

        public List<Table> LoadTableList()
        {
            List<Table> tableList = new List<Table>();
            DataTable data = DataProvider.Instance.ExecuteQuery("select * from dbo.TableFood where status != N'Đã xoá'");

            foreach(DataRow item in data.Rows)
            {
                Table table = new Table(item);
                tableList.Add(table);
            }

            return tableList;
        }
        public void UpdateTableStatus(int id, string status)
        {
            string query = "UPDATE dbo.TableFood SET status = N'" + status + "' WHERE id = " + id;
            DataProvider.Instance.ExecuteNonQuery(query);
        }
        public void SwitchTable(int idBill1, int idBill2, int idTable1, int idTable2)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_SwitchTable @idBill1 , @idBill2 , @idTable1 , @idTabl2", new object[] { idBill1, idBill2, idTable1, idTable2 });
        }
        public bool DeleteTable(int id)
        {
            return DataProvider.Instance.ExecuteNonQuery("Update TableFood set status = N'Đã xoá' where id = " + id) > 0;
        }
        public bool UpdateTable(int id, string name, string status)
        {
            return DataProvider.Instance.ExecuteNonQuery("Update TableFood set name = N'" + name + "', status = N'" + status + "' where id = " + id) > 0;
        }
        public bool AddTable(string name)
        {
            return DataProvider.Instance.ExecuteNonQuery("Insert into TableFood(name, status) values(N'" + name + "', N'Bàn Trống')") > 0;
        }
        public bool IsExistTableName(string name)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("Select * from TableFood where name = N'" + name + "'");
            foreach(DataRow item in data.Rows)
            {
                return true;
            }
            return false;
        }

    }
}
