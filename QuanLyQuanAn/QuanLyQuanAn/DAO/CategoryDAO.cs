using QuanLyQuanAn.DTO;
using System.Collections.Generic;
using System.Data;

namespace QuanLyQuanAn.DAO
{
    public class CategoryDAO
    {
        private static CategoryDAO instance;
        public static CategoryDAO Instance
        {
            get
            {
                if (instance == null) instance = new CategoryDAO();
                return CategoryDAO.instance;
            }
            private set
            {
                CategoryDAO.instance = value;
            }
        }
        private CategoryDAO() { }
        public List<Category> GetListCategory()
        {
            List<Category> list = new List<Category>();
            string query = "select * from FoodCategory where status = 1";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);
            foreach(DataRow item in data.Rows)
            {
                Category category = new Category(item);
                list.Add(category);
            }
            return list;
        }
        public Category GetCategoryByID(int id)
        {
            Category c = null;
            string query = "select * from FoodCategory where status = 1 and id = " + id;
            DataTable data = DataProvider.Instance.ExecuteQuery(query);
            foreach (DataRow item in data.Rows)
            {
                c = new Category(item);
            }
            return c;
        }
        public bool AddCategory(string name)
        {
            return DataProvider.Instance.ExecuteNonQuery("insert into FoodCategory(name, status) values(N'" + name + "', 1)") > 0;
        }
        public bool UpdateCategory(int id, string name)
        {
            return DataProvider.Instance.ExecuteNonQuery("update FoodCategory set name = N'" + name + "' where id = " + id) > 0;
        }
        public bool DeleteCategory(int id)
        {
            return DataProvider.Instance.ExecuteNonQuery("update FoodCategory set status = 0 where id = " + id) > 0;
        }
        public bool IsExistCategoryName(string name)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("Select * from FoodCategory where name = N'" + name + "'");
            foreach (DataRow item in data.Rows)
            {
                return true;
            }
            return false;
        }

    }
}
