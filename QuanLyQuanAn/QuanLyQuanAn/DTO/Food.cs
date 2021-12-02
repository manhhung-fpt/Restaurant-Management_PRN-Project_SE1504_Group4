using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanAn.DTO
{
    public class Food
    {
        public Food(int id, string name, int categoryID, float price)
        {
            this.id = id;
            this.name = name;
            this.categoryID = categoryID;
            this.price = price;
        }
        public Food(DataRow row)
        {
            this.id = (int)row["id"];
            this.name = row["name"].ToString();
            this.categoryID = (int)row["idcategory"];
            this.price = (float)Convert.ToDouble(row["price"].ToString());
        }
        public Food() { }


        private int id;
        private string name;
        private int categoryID;
        private float price;
        public string Name { get => name; set => name = value; }
        public int CategoryID { get => categoryID; set => categoryID = value; }
        public float Price { get => price; set => price = value; }
        public int Id { get => id; set => id = value; }
    }
}
