using QuanLyQuanAn.DAO;
using QuanLyQuanAn.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyQuanAn
{
    public partial class fAccountProfile : Form
    {
        private Account loginAccount;
        public Account LoginAccount
        {
            get { return loginAccount; }
            set { loginAccount = value; ChangeAccount(loginAccount); }
        }
        public fAccountProfile(Account acc)
        {
            InitializeComponent();
            LoginAccount = acc;
        }
        void ChangeAccount(Account acc)
        {
            txbUserName.Text = acc.UserName;
            txtDisplayName.Text = acc.DisplayName;
        }
        void update(string newPass)
        {
            AccountDAO.Instance.UpdateAccountProfile(LoginAccount.UserName, txtDisplayName.Text, newPass);
            MessageBox.Show("Cập nhật thành công!");
            if(updateAccount != null)
            {
                updateAccount(this, new AccountEvent(AccountDAO.Instance.GetAccountByUserName(LoginAccount.UserName)));
            }
        }
        private void fAccountProfile_Load(object sender, EventArgs e)
        {

        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            string password = txbPassWord.Text;
            if (password.Equals(LoginAccount.Password))
            {
                string newPass = txbNewPass.Text;
                if (MessageBox.Show("Cập nhật thông tin cá nhân?", "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    if (txbNewPass.Text.Length != 0)
                    {
                        if (!newPass.Equals(txbReEnterPass.Text))
                        {
                            MessageBox.Show("Mật khẩu nhập lại không khớp!");
                        }
                        else
                        {
                            update(newPass);
                        }
                    }
                    else
                    {
                        update(password);
                    }
                }
            }
            else
            {
                MessageBox.Show("Sai mật khẩu!");
            }
        }

        private event EventHandler<AccountEvent> updateAccount;
        public event EventHandler<AccountEvent> UpdateAccount
        {
            add { updateAccount += value; }
            remove { updateAccount -= value; }
        }

    }
    public class AccountEvent : EventArgs
    {
        private Account acc;

        public Account Acc { get => acc; set => acc = value; }
        public AccountEvent(Account acc)
        {
            this.Acc = acc;
        }
    }
}
