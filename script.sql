USE [master]
GO
/****** Object:  Database [QuanLyQuanAn]    Script Date: 11/6/2021 10:44:39 PM ******/
CREATE DATABASE [QuanLyQuanAn]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuanLyQuanAn', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\QuanLyQuanAn.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QuanLyQuanAn_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\QuanLyQuanAn_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QuanLyQuanAn] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLyQuanAn].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLyQuanAn] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QuanLyQuanAn] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyQuanAn] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLyQuanAn] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QuanLyQuanAn] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLyQuanAn] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QuanLyQuanAn] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLyQuanAn] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLyQuanAn] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanLyQuanAn] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanLyQuanAn] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [QuanLyQuanAn] SET DELAYED_DURABILITY = DISABLED 
GO
USE [QuanLyQuanAn]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertNString]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConvertNString](@strInput NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
AS
BEGIN     
    IF @strInput IS NULL RETURN @strInput
    IF @strInput = '' RETURN @strInput
    DECLARE @RT NVARCHAR(4000)
    DECLARE @SIGN_CHARS NCHAR(136)
    DECLARE @UNSIGN_CHARS NCHAR (136)

    SET @SIGN_CHARS       = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ'+NCHAR(272)+ NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
    SET @COUNTER = 1
 
    WHILE (@COUNTER <=LEN(@strInput))
    BEGIN   
      SET @COUNTER1 = 1
      --Tim trong chuoi mau
       WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1)
       BEGIN
     IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) )
     BEGIN           
          IF @COUNTER=1
              SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1)                   
          ELSE
              SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER)    
              BREAK         
               END
             SET @COUNTER1 = @COUNTER1 +1
       END
      --Tim tiep
       SET @COUNTER = @COUNTER +1
    END
    RETURN @strInput
END
GO
/****** Object:  Table [dbo].[Account]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[UserName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[PassWord] [nvarchar](100) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK__Account__C9F2845705368738] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckIn] [datetime] NOT NULL,
	[DateCheckOut] [datetime] NULL,
	[idTable] [int] NOT NULL,
	[status] [int] NOT NULL,
	[discount] [int] NULL,
	[totalPrice] [float] NULL,
	[cashier] [nvarchar](50) NULL,
 CONSTRAINT [PK__Bill__3213E83FBE0FBECF] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idBill] [int] NOT NULL,
	[idFood] [int] NOT NULL,
	[count] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Food]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[idCategory] [int] NOT NULL,
	[price] [float] NOT NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableFood]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFood](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type], [Status]) VALUES (N'1', N'1', N'1', N'admin', N'active')
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type], [Status]) VALUES (N'admin', N'Hien', N'123456', N'admin', N'active')
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type], [Status]) VALUES (N'K91', N'Hasagi21', N'123456', N'admin', N'deleted')
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type], [Status]) VALUES (N'staff1', N'Hien', N'1', N'staff', N'active')
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type], [Status]) VALUES (N'staff2', N'Hung', N'1', N'staff', N'active')
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type], [Status]) VALUES (N'staff3', N'Hung', N'123456', N'admin', N'inActive')
GO
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (79, CAST(N'2021-10-24T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 2, 1, 10, 25200, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (80, CAST(N'2021-10-24T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 1, 1, 0, 383000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (81, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 4, 1, 10, 390600, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (82, CAST(N'2021-10-25T00:00:00.000' AS DateTime), NULL, 7, 0, 0, NULL, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (83, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 6, 1, 0, 35000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (84, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 6, 1, 10, 182700, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (85, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 8, 1, 0, 32000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (86, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 9, 1, 0, 48000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (87, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 1, 1, 0, 83000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (88, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 1, 1, 0, 35000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (89, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 8, 1, 0, 48000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (90, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 8, 1, 0, 260000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (91, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 8, 1, 0, 28000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (92, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 2, 1, 0, 35000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (93, CAST(N'2021-10-25T00:00:00.000' AS DateTime), CAST(N'2021-10-25T00:00:00.000' AS DateTime), 5, 1, 0, 1296000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (94, CAST(N'2021-10-25T19:30:46.897' AS DateTime), CAST(N'2021-10-25T19:30:48.023' AS DateTime), 6, 1, 0, 35000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (95, CAST(N'2021-10-25T20:06:34.843' AS DateTime), CAST(N'2021-10-25T20:06:36.190' AS DateTime), 3, 1, 0, 35000, N'staff1')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (96, CAST(N'2021-11-05T21:19:11.443' AS DateTime), CAST(N'2021-11-05T21:25:16.500' AS DateTime), 3, 1, 0, 35000, N'staff2')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (97, CAST(N'2021-11-06T17:56:48.797' AS DateTime), CAST(N'2021-11-06T17:58:56.793' AS DateTime), 1, 1, 0, 35000, N'K9')
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice], [cashier]) VALUES (98, CAST(N'2021-11-06T21:23:07.413' AS DateTime), NULL, 2, 0, 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Bill] OFF
GO
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (138, 81, 10, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (143, 83, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (144, 80, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (145, 80, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (146, 80, 4, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (147, 80, 5, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (148, 80, 7, 8)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (149, 79, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (150, 79, 13, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (151, 81, 7, 8)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (152, 81, 16, 7)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (153, 81, 9, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (154, 84, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (155, 84, 3, 3)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (156, 84, 5, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (157, 84, 14, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (158, 84, 15, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (159, 85, 3, 3)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (160, 86, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (161, 87, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (162, 87, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (163, 88, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (164, 89, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (165, 90, 16, 20)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (166, 91, 10, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (167, 91, 11, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (168, 92, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (169, 93, 3, 3)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (170, 93, 7, 8)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (171, 94, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (172, 95, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (173, 96, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (174, 97, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (175, 98, 1, 1)
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (1, N'Mực một nắng', 1, 35000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (2, N'Càng ghẹ rang muối', 1, 48000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (3, N'Tôm hấp', 1, 32000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (4, N'Canh khổ qua', 3, 30000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (5, N'Lẩu thập cẩm', 3, 120000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (6, N'Canh chua', 3, 80000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (7, N'Heo rừng nướng', 2, 150000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (8, N'Cơm chiên dương châu', 2, 20000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (9, N'Dê hấp', 2, 180000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (10, N'Rau muống xào tỏi', 4, 13000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (11, N'Bắp xú luộc', 4, 15000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (12, N'Cải xào cà chua', 4, 15000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (13, N'7up', 5, 8000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (14, N'Pepsi', 5, 8000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (15, N'Coca', 5, 8000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (16, N'Bia heneiken', 5, 13000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (17, N'Bia Saigon', 5, 11000, 1)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (34, N'Rau muống xào tỏi', 1, 13000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (35, N'Mực một nắng', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (36, N'Mực một nắng', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (37, N'Mực một nắng', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (38, N'Mực một nắng', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (39, N'Mực một nắng', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (40, N'Bia Saigon', 5, 0, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (41, N'Mực một nắng', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (42, N'Bia Saigon', 5, 0, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (43, N'Bia Saigon', 5, 1, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (44, N'Bia Saigon', 5, 0, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (45, N'Mực một nắng', 1, 12, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (46, N'Mực một nắng', 1, 14, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (47, N'1', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (48, N'1', 1, 35000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (49, N'Bia Saigon', 5, 11000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (50, N'1', 1, 11000, 0)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [status]) VALUES (51, N'', 5, 11111, 0)
SET IDENTITY_INSERT [dbo].[Food] OFF
GO
SET IDENTITY_INSERT [dbo].[FoodCategory] ON 

INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (1, N'Hải Sản', 1)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (2, N'Đặc Sản', 1)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (3, N'Món Nước', 1)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (4, N'Rau Củ', 1)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (5, N'Đồ Uống', 1)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (13, N'Hải Sản', 0)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (14, N'Hải Sảna', 0)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (15, N'Hải Sảnn', 0)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (16, N'Hải Sản1', 0)
INSERT [dbo].[FoodCategory] ([id], [name], [status]) VALUES (17, N'Đồ Uống', 0)
SET IDENTITY_INSERT [dbo].[FoodCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[TableFood] ON 

INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (1, N'Bàn 1', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (2, N'Bàn 2', N'Có Người')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (3, N'Bàn 3', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (4, N'Bàn 4', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (5, N'Bàn 5', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (6, N'Bàn 6', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (7, N'Bàn 7', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (8, N'Bàn 8', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (9, N'Bàn 9', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (10, N'Bàn 10', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (11, N'Bàn 11', N'Bàn Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (12, N'Bàn 11', N'Đã xoá')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (13, N'Bàn 12', N'Đã xoá')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (14, N'Bàn 1', N'Đã xoá')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (15, N'Bàn 1', N'Đã xoá')
SET IDENTITY_INSERT [dbo].[TableFood] OFF
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__Display__145C0A3F]  DEFAULT (N'Hung') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__PassWor__15502E78]  DEFAULT ((0)) FOR [PassWord]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__DateCheckI__20C1E124]  DEFAULT (getdate()) FOR [DateCheckIn]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__status__21B6055D]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[BillInfo] ADD  DEFAULT ((0)) FOR [count]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT (N'Chua Dat Ten') FOR [name]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT ((0)) FOR [price]
GO
ALTER TABLE [dbo].[FoodCategory] ADD  DEFAULT (N'Chua Dat Ten') FOR [name]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Ban Chua Co Ten') FOR [name]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Ban Trong') FOR [status]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK__Bill__status__22AA2996] FOREIGN KEY([idTable])
REFERENCES [dbo].[TableFood] ([id])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK__Bill__status__22AA2996]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD  CONSTRAINT [FK__BillInfo__count__267ABA7A] FOREIGN KEY([idBill])
REFERENCES [dbo].[Bill] ([id])
GO
ALTER TABLE [dbo].[BillInfo] CHECK CONSTRAINT [FK__BillInfo__count__267ABA7A]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idFood])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [FK__Food__price__1DE57479] FOREIGN KEY([idCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [FK__Food__price__1DE57479]
GO
/****** Object:  StoredProcedure [dbo].[USP_CheckOut]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[USP_CheckOut]
@id int, @discount int, @totalPrice float, @cashier nvarchar(100)
as 
begin
	declare @isExitBillInfo int
	select @isExitBillInfo = count from dbo.BillInfo where idBill = @id	
	if(@isExitBillInfo > 0)
		update dbo.bill set status = 1, discount = @discount, totalPrice = @totalPrice, DateCheckOut = GETDATE(), cashier = @cashier
		where id = @id
	else
		delete Bill where id = @id
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountByUserName]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetAccountByUserName]
@UserName nvarchar(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @UserName
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDate]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[USP_GetListBillByDate]
@checkIn date, @checkOut date, @billPerPage int, @pageNumber int
as begin
	select t.name as [Bàn], b.DateCheckIn as [Ngày vào], b.DateCheckOut as [Ngày ra], b.discount as [Giảm giá], b.totalPrice as [Tổng tiền], a.DisplayName as [Thu Ngân]
	from Account a, Bill b, TableFood t, (select id, ROW_NUMBER() OVER(ORDER BY id desc) rn from Bill where DateCheckIn >= @checkIn and DateCheckOut <= @checkOut and status = 1 ) temp
	where a.UserName = b.cashier and temp.id = b.id and b.idTable = t.id and temp.rn between (@billPerPage*(@pageNumber-1) + 1) and (@billPerPage*@pageNumber)
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableList]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_GetTableList]
AS SELECT * FROM dbo.TableFood
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBill]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[USP_InsertBill]
@idTable int 
as 
begin
	insert dbo.Bill(DateCheckIn, DateCheckOut, idTable, status, discount)
	values(GETDATE(), null, @idTable, 0, 0)

end
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBillInfo]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[USP_InsertBillInfo]
@idBill int, @idFood int, @count int
as 
begin	
	declare @isExitsBillInfo int
	declare @foodCount int = 1
	select @isExitsBillInfo = id, @foodCount = count	from dbo.BillInfo where idBill = @idBill AND idFood = @idFood
	begin
		if(@isExitsBillInfo > 0)
		begin
			declare @newCount int = @foodcount + @count
			if(@newCount > 0)
				update dbo.BillInfo set count = @newCount where idFood = @idFood
			else
				delete dbo.BillInfo where idBill = @idBill and idFood = @idFood 
		end
		else
		if(@count > 0)
		begin
			insert dbo.BillInfo(idBill, idFood, count)
			values(@idBill, @idFood, @count)
		end
	end
end
GO
/****** Object:  StoredProcedure [dbo].[USP_Login]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_Login]
@userName nvarchar (100) , @passWord nvarchar (100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SwitchTable]    Script Date: 11/6/2021 10:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[USP_SwitchTable]
@idBill1 int, @idBill2 int, @idTable1 int, @idTable2 int
as begin
if(@idBill1 = -1)
	begin
		update Bill set idTable = @idTable1 where id = @idBill2
		update TableFood set status = N'Có Người' where id = @idTable1
		update TableFood set status = N'Bàn Trống' where id = @idTable2
	end
	else
	if(@idBill2 = -1)
	begin
		update Bill set idTable = @idTable2 where id = @idBill1
		update TableFood set status = N'Có Người' where id = @idTable2
		update TableFood set status = N'Bàn Trống' where id = @idTable1
	end
	else
	if( @idBill1 != -1 and @idBill1 != -1)
	begin
		update Bill set idTable = @idTable2 where id = @idBill1
		update Bill set idTable = @idTable1 where id = @idBill2
	end
end
GO
USE [master]
GO
ALTER DATABASE [QuanLyQuanAn] SET  READ_WRITE 
GO
