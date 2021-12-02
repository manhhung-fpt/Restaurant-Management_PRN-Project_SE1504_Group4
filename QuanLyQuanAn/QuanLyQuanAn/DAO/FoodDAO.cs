using QuanLyQuanAn.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanAn.DAO
{
    public class FoodDAO
    {
        private static FoodDAO instance;
        public static FoodDAO Instance
        {
            get
            {
                if (instance == null) instance = new FoodDAO();
                return FoodDAO.instance;
            }
            private set
            {
                FoodDAO.instance = value;
            }
        }
        private FoodDAO() { }
        public List<Food> GetFoodByCategoryID(int id)
        {
            List<Food> list = new List<Food>();
            string query = "select * from Food where idCategory = " + id + " and status = 1";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);
            foreach(DataRow item in data.Rows)
            {
                Food food = new Food(item);
                list.Add(food);
            }
            return list;
        }
        public List<Food> GetListFood()
        {
            List<Food> list = new List<Food>();
            string query = "select * from Food where status = 1";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);
            foreach(DataRow item in data.Rows)
            {
                Food food = new Food(item);
                    list.Add(food);
            }
            return list;
        }
        public bool UpdateFood(Food updateFood)
        {
            string query = "update dbo.Food set name = N'" + updateFood.Name + "', idCategory = " + updateFood.CategoryID + ", price = " + updateFood.Price + " where id = " + updateFood.Id;
            return DataProvider.Instance.ExecuteNonQuery(query) > 0;
        }
        public bool InsertFood(Food newFood)
        {
            string query = "insert into dbo.Food(name, idCategory, price, status) values(N'"+ newFood.Name + "', " + newFood.CategoryID + ", " + newFood.Price + ", 1)";
            return DataProvider.Instance.ExecuteNonQuery(query) > 0;
        }
        public bool DeleteFood(int id)
        {
            string query = "update dbo.Food set status = 0 where id = " + id;
            query  += " delete from BillInfo where id in (select bi.id from bill b, BillInfo bi where bi.idBill = b.id and b.status = 0 and bi.idFood = "+ id + ")";
            return DataProvider.Instance.ExecuteNonQuery(query) > 0;
        }
        public List<Food> SearchFood(string searchKey)
        {
            List<Food> list = new List<Food>();
            string query = "select * from dbo.Food where dbo.ConvertNString(name) like N'%' + dbo.ConvertNString(N'" + searchKey +"') + '%' and status = 1";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);
            foreach(DataRow item in data.Rows)
            {
                Food food = new Food(item);
                list.Add(food);
            }
            return list;
        }
    }
}
