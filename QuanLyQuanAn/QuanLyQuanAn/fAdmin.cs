using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using QuanLyQuanAn.DAO;
using QuanLyQuanAn.DTO;
namespace QuanLyQuanAn
{
    public partial class fAdmin : Form
    {
        BindingSource foodList = new BindingSource();
        BindingSource categoryList = new BindingSource();
        BindingSource tableList = new BindingSource();
        BindingSource accountList = new BindingSource();

        int billPerPage = 12;

        string loginUserName;
        public fAdmin(string LoginUserName)
        {
            this.loginUserName = LoginUserName;
            InitializeComponent();
            Loads();
        }
        void Loads()
        {
            dtgvFood.DataSource = foodList;
            dtgvCategory.DataSource = categoryList;
            dtgvTable.DataSource = tableList;
            dtgvAccount.DataSource = accountList;
            LoadDatetimePickerBill();
            LoadListBillByDate(dtpkFromDate.Value, dtpkToDate.Value, 1);
            LoadListFood();
            AddFoodBinding();
            LoadCategory();
            AddCategoryBinding();
            LoadTable();
            AddTableBinding();
            LoadAccount();
            AddAccountBinding();
        }

        #region Bills
        #region BillMethods
        void LoadDatetimePickerBill()
        {
            DateTime today = DateTime.Now;
            dtpkFromDate.Value = new DateTime(today.Year, today.Month, 1);
            dtpkToDate.Value = dtpkFromDate.Value.AddMonths(1).AddDays(-1);
        }
        void LoadListBillByDate(DateTime checkIn, DateTime checkOut, int pageNumber)
        {
            dtgvBill.DataSource = BillDAO.Instance.GetBillListByDate(checkIn, checkOut, billPerPage, pageNumber);
            FormatDtgvBill();
        }
        void FormatDtgvBill()
        {
            dtgvBill.Columns[0].AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            dtgvBill.Columns[0].Width = 60;
            dtgvBill.Columns[1].AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            dtgvBill.Columns[1].Width = 165;
            dtgvBill.Columns[2].AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            dtgvBill.Columns[2].Width = 165;
            dtgvBill.Columns[3].AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            dtgvBill.Columns[3].Width = 80;
            dtgvBill.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
        }
        int GetMaxPage()
        {
            int totalBill = BillDAO.Instance.GetTotalBill();
            return totalBill / billPerPage + 1;
        }

        private void btnFirst_Click(object sender, EventArgs e)
        {
            LoadListBillByDate(dtpkFromDate.Value, dtpkToDate.Value, 1);
            txbPageNumber.Text = "1";
        }

        private void btnPrevious_Click(object sender, EventArgs e)
        {
            int pageNumber = int.Parse(txbPageNumber.Text);
            if (pageNumber > 1)
            {
                LoadListBillByDate(dtpkFromDate.Value, dtpkToDate.Value, pageNumber - 1);
                txbPageNumber.Text = (pageNumber - 1).ToString();
            }
        }

        private void btnNext_Click(object sender, EventArgs e)
        {
            int pageNumber = int.Parse(txbPageNumber.Text);
            int maxPage = GetMaxPage();
            if (pageNumber < maxPage)
            {
                LoadListBillByDate(dtpkFromDate.Value, dtpkToDate.Value, pageNumber + 1);
                txbPageNumber.Text = (pageNumber + 1).ToString();
            }
        }

        private void btnLast_Click(object sender, EventArgs e)
        {
            int maxPage = GetMaxPage();
            LoadListBillByDate(dtpkFromDate.Value, dtpkToDate.Value, maxPage);
            txbPageNumber.Text = maxPage.ToString();
        }
        #endregion
        #region BillEvents
        private void btnViewBill_Click(object sender, EventArgs e)
        {
            int pageNumber = int.Parse(txbPageNumber.Text);
            LoadListBillByDate(dtpkFromDate.Value, dtpkToDate.Value, pageNumber);
        }
        #endregion
        #endregion
        #region Foods
        #region FoodMethods
        void LoadListFood()
        {
            foodList.DataSource = FoodDAO.Instance.GetListFood();
            cbFoodCategory.DataSource = CategoryDAO.Instance.GetListCategory();
            cbFoodCategory.DisplayMember = "Name";
        }
        Food GetFoodInfo()
        {
            Food foodInfo = new Food();
            if (txbFoodID.Text.ToString().Length > 0)
                foodInfo.Id = int.Parse(txbFoodID.Text);
            foodInfo.CategoryID = (cbFoodCategory.SelectedItem as Category).Id;
            if (txbFoodName.Text.ToString().Length > 0)
                foodInfo.Name = txbFoodName.Text;
            foodInfo.Price = (float)nmFoodPrice.Value;
            return foodInfo;
        }
        void AddFoodBinding()
        {
            txbFoodID.DataBindings.Add(new Binding("Text", dtgvFood.DataSource, "ID", true, DataSourceUpdateMode.Never));
            txbFoodName.DataBindings.Add(new Binding("Text", dtgvFood.DataSource, "Name", true, DataSourceUpdateMode.Never));
            nmFoodPrice.DataBindings.Add(new Binding("Value", dtgvFood.DataSource, "Price", true, DataSourceUpdateMode.Never));
        }
        #endregion
        #region FoodEvents
        private void btnShowFood_Click(object sender, EventArgs e)
        {
            LoadListFood();
        }

        private void txbFoodID_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (dtgvFood.SelectedCells.Count > 0 && dtgvFood.SelectedCells[0].OwningRow.Cells["CategoryID"].Value != null)
                {
                    int categoryID = int.Parse(dtgvFood.SelectedCells[0].OwningRow.Cells["CategoryID"].Value.ToString());
                    cbFoodCategory.SelectedIndex = categoryID - 1;
                }
            }
            catch { MessageBox.Show("Error"); }
        }

        private void btnEditFood_Click(object sender, EventArgs e)
        {
            Food editFood = GetFoodInfo();
            if (FoodDAO.Instance.UpdateFood(editFood))
            {
                MessageBox.Show("Successful!");
                if (updateFood != null)
                    updateFood(this, new EventArgs());
                LoadListFood();
            }
        }

        private void btnAddFood_Click(object sender, EventArgs e)
        {
            Food newFood = GetFoodInfo();
            if (newFood.Price == 0)
            {
                MessageBox.Show("Giá thức ăn phải là một số dương!");
                return;
            }
            if (newFood.Price < 1000)
            {
                if (MessageBox.Show("Giá thấp hơn 1000!\nBạn có muốn nhập lại?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.Cancel)
                    if (FoodDAO.Instance.InsertFood(newFood))
                        MessageBox.Show("Successful");
            }
            else
            {
                if (FoodDAO.Instance.InsertFood(newFood))
                    MessageBox.Show("Successful");
            }
            if (insertFood != null)
                insertFood(this, new EventArgs());
            LoadListFood();
        }

        private void btnDeleteFood_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có muốn xoá món ăn này?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                if (FoodDAO.Instance.DeleteFood(int.Parse(txbFoodID.Text)))
                {
                    MessageBox.Show("Successful");
                    if (deleteFood != null)
                        deleteFood(this, new EventArgs());
                    LoadListFood();
                }
        }
        private event EventHandler insertFood;
        public event EventHandler InsertFood
        {
            add { insertFood += value; }
            remove { insertFood -= value; }
        }
        private event EventHandler deleteFood;
        public event EventHandler DeleteFood
        {
            add { deleteFood += value; }
            remove { deleteFood -= value; }
        }
        private event EventHandler updateFood;
        public event EventHandler UpdateFood
        {
            add { updateFood += value; }
            remove { updateFood -= value; }
        }
        private void btnSearchFood_Click(object sender, EventArgs e)
        {
            string searchKey = txbSearchFoodName.Text;
            foodList.DataSource = FoodDAO.Instance.SearchFood(searchKey);
        }
        #endregion
        #endregion
        #region Categories
        #region CategoryMethods
        void LoadCategory()
        {
            categoryList.DataSource = CategoryDAO.Instance.GetListCategory();
        }
        void AddCategoryBinding()
        {
            txbCategoryID.DataBindings.Add(new Binding("Text", dtgvCategory.DataSource, "ID", true, DataSourceUpdateMode.Never));
            txbCategoryName.DataBindings.Add(new Binding("Text", dtgvCategory.DataSource, "Name", true, DataSourceUpdateMode.Never));
        }
        #endregion
        #region CategoryEvents
        private void btnAddCategory_Click(object sender, EventArgs e)
        {
            string name = txbCategoryName.Text;
            if (CategoryDAO.Instance.IsExistCategoryName(name))
            {
                if (MessageBox.Show("Trùng tên danh mục!\nBạn có muốn tiếp tục?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                    if (CategoryDAO.Instance.AddCategory(name))
                        MessageBox.Show("Successful!");
            }
            else
            {
                if (CategoryDAO.Instance.AddCategory(name))
                    MessageBox.Show("Successful!");
            }
            LoadCategory();
            LoadListFood();
        }

        private void btnDeleteCategory_Click(object sender, EventArgs e)
        {
            int id = int.Parse(txbCategoryID.Text);
            if (MessageBox.Show("Bạn có muốn xoá danh mục này?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                if (CategoryDAO.Instance.DeleteCategory(id))
                {
                    MessageBox.Show("Successful!");
                    LoadCategory();
                    LoadListFood();
                }
        }

        private void btnEditCategory_Click(object sender, EventArgs e)
        {
            int id = int.Parse(txbCategoryID.Text);
            string name = txbCategoryName.Text;
            if (CategoryDAO.Instance.UpdateCategory(id, name))
            {
                MessageBox.Show("Successful!");
                LoadCategory();
            }
        }

        private void btnShowCategory_Click(object sender, EventArgs e)
        {
            LoadCategory();
        }
        #endregion
        #endregion
        #region Tables
        #region TableMethods
        void LoadTable()
        {
            tableList.DataSource = TableDAO.Instance.LoadTableList();
            LoadTableStatus();
        }
        void LoadTableStatus()
        {
            cbTableStatus.DisplayMember = "status";
            cbTableStatus.ValueMember = "value";
            var statuses = new[]
            {
                new{ status = "Bàn Trống", value = "Bàn Trống"},
                new{ status = "Có Người", value = "Có Người"}
            };
            cbTableStatus.DataSource = statuses;
        }
        void AddTableBinding()
        {
            txbTableID.DataBindings.Add(new Binding("Text", dtgvTable.DataSource, "id", true, DataSourceUpdateMode.Never));
            txbTableName.DataBindings.Add(new Binding("Text", dtgvTable.DataSource, "name", true, DataSourceUpdateMode.Never));
            cbTableStatus.DataBindings.Add(new Binding("Text", dtgvTable.DataSource, "status", true, DataSourceUpdateMode.Never));
        }
        #endregion
        #region TableEvents
        private void btnShowTable_Click(object sender, EventArgs e)
        {
            LoadTable();
        }

        private void btnDeleteTable_Click(object sender, EventArgs e)
        {
            int id = int.Parse(txbTableID.Text);
            if (MessageBox.Show("Bạn có muốn xoá bàn này?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                if (TableDAO.Instance.DeleteTable(id))
                    MessageBox.Show("Successful!");
                if (deleteTable != null)
                    deleteTable(this, new EventArgs());
                LoadTable();
            }
        }

        private void btnEditTable_Click(object sender, EventArgs e)
        {
            int id = int.Parse(txbTableID.Text);
            string name = txbTableName.Text;
            string status = cbTableStatus.Text;
            if (TableDAO.Instance.UpdateTable(id, name, status))
                MessageBox.Show("Successful!");
            if (updateTable != null)
                updateTable(this, new EventArgs());
            LoadTable();
        }

        private void btnAddTable_Click(object sender, EventArgs e)
        {
            string name = txbTableName.Text;
            if (TableDAO.Instance.IsExistTableName(name))
            {
                if (MessageBox.Show("Trùng tên bàn!\nBạn có muốn tiếp tục?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    if (TableDAO.Instance.AddTable(name))
                        MessageBox.Show("Successful!");
                }
            }
            else
            {
                if (TableDAO.Instance.AddTable(name))
                    MessageBox.Show("Successful!");
            }
            if (insertTable != null)
                insertTable(this, new EventArgs());
            LoadTable();
        }
        private event EventHandler insertTable;
        public event EventHandler InsertTable
        {
            add { insertTable += value; }
            remove { insertTable -= value; }
        }
        private event EventHandler updateTable;
        public event EventHandler UpdateTable
        {
            add { updateTable += value; }
            remove { updateTable -= value; }
        }
        private event EventHandler deleteTable;
        public event EventHandler DeleteTable
        {
            add { deleteTable += value; }
            remove { deleteTable -= value; }
        }
        #endregion

        #endregion

        #region Accounts
        #region methods
        void LoadAccount()
        {
            accountList.DataSource = AccountDAO.Instance.LoadListAccount();
            LoadAccountCombobox();
        }
        void LoadAccountCombobox()
        {
            cbAccountStatus.DisplayMember = "status";
            cbAccountStatus.ValueMember = "value";
            var statuses = new[]
            {
                new{ status = "Active", value = "active"},
                new{ status = "InActive", value = "inactive"},
                new{ status = "Deleted", value = "deleted"}
            };
            cbAccountStatus.DataSource = statuses;

            cbAccountType.DisplayMember = "type";
            cbAccountType.ValueMember = "value";
            var types = new[]
            {
                new{ type = "Admin", value = "admin"},
                new{ type = "Staff", value = "staff"}
            };
            cbAccountType.DataSource = types;
        }

        void AddAccountBinding()
        {
            txbUserName.DataBindings.Add(new Binding("Text", dtgvAccount.DataSource, "userName", true, DataSourceUpdateMode.Never));
            txbDisplayName.DataBindings.Add(new Binding("Text", dtgvAccount.DataSource, "displayName", true, DataSourceUpdateMode.Never));
            cbAccountType.DataBindings.Add(new Binding("Text", dtgvAccount.DataSource, "type", true, DataSourceUpdateMode.Never));
            cbAccountStatus.DataBindings.Add(new Binding("Text", dtgvAccount.DataSource, "status", true, DataSourceUpdateMode.Never));
        }
        Account getAccountInfo()
        {
            Account acc = new Account();
            acc.UserName = txbUserName.Text;
            acc.DisplayName = txbDisplayName.Text;
            acc.Type = cbAccountType.Text;
            acc.Status = cbAccountStatus.Text;
            return acc;
        }
        #endregion

        #region events
        #endregion
        private void btnAddAccount_Click(object sender, EventArgs e)
        {
            Account newAccount = getAccountInfo();
            if (AccountDAO.Instance.IsExistUserName(newAccount.UserName))
            {
                MessageBox.Show("Trùng tên tài khoản!");
            }
            else
            {
                AccountDAO.Instance.InsertAccount(newAccount);
            }
            LoadAccount();
        }

        private void btnDeleteAccount_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            if (userName.Equals(loginUserName))
            {
                MessageBox.Show("Không thể xoá tài khoản đang đăng nhập!");
            }
            else
            {
                AccountDAO.Instance.DeleteAccount(userName);
                LoadAccount();
            }
        }

        private void btnEditAccount_Click(object sender, EventArgs e)
        {
            Account editedAccount = getAccountInfo();
            string userName = editedAccount.UserName;
            if (MessageBox.Show("Cập nhật tài khoản có tài khoản là: " + userName + " ?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                if (AccountDAO.Instance.IsExistUserName(userName))
                {
                    AccountDAO.Instance.UpdateAccountByAdmin(editedAccount);
                    LoadAccount();
                }
                else
                {
                    MessageBox.Show("Tài khoản không tồn tại!");
                }
            }
        }

        private void btnShowAccount_Click(object sender, EventArgs e)
        {
            LoadAccount();
        }

        private void btnResetPassword_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            if (AccountDAO.Instance.ResetPassword(userName))
            {
                MessageBox.Show("Đặt lại mật khẩu thành công về '123456'");
            }
        }

        #endregion


    }
}
