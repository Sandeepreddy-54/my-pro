USE [WellMed_UTR_OneSource]
GO
/****** Object:  Table [dbo].[Audits]    Script Date: 6/16/2022 2:28:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Audits](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[KeyFieldId] [int] NOT NULL,
	[GMPI] [int] NOT NULL,
	[ActionType] [varchar](50) NOT NULL,
	[Tablename] [varchar](50) NOT NULL,
	[Fieldname] [varchar](50) NULL,
	[Previousvalue] [nvarchar](200) NULL,
	[Newvalue] [nvarchar](200) NULL,
	[DateTime] [datetime] NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_dbo.Audits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberAddress]    Script Date: 6/16/2022 2:28:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberAddress](
	[AddressId] [int] IDENTITY(1,1) NOT NULL,
	[GMPI] [int] NOT NULL,
	[CreatedBy] [nvarchar](150) NULL,
	[Address1] [nvarchar](55) NULL,
	[Address2] [nvarchar](55) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[Zip] [nvarchar](50) NULL,
	[AddressBadFlag] [bit] NULL,
	[CreatedTime] [datetime] NULL,
	[UpdatedTime] [datetime] NULL,
	[UpdatedBy] [nvarchar](55) NULL,
 CONSTRAINT [PK_MemberAddress] PRIMARY KEY CLUSTERED 
(
	[AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberEmail]    Script Date: 6/16/2022 2:28:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberEmail](
	[EmailID] [int] IDENTITY(1,1) NOT NULL,
	[GMPI] [int] NOT NULL,
	[CreatedBy] [varchar](150) NULL,
	[EmailAddress] [varchar](55) NULL,
	[EmailBadFlag] [bit] NOT NULL,
	[EmailType] [varchar](30) NULL,
	[CreatedTime] [datetime] NULL,
	[UpdatedTime] [datetime] NULL,
	[UpdatedBy] [varchar](55) NULL,
 CONSTRAINT [PK_MemberEmail] PRIMARY KEY CLUSTERED 
(
	[EmailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberPhone]    Script Date: 6/16/2022 2:28:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberPhone](
	[PhoneID] [int] IDENTITY(1,1) NOT NULL,
	[GMPI] [int] NOT NULL,
	[CreatedBy] [varchar](150) NULL,
	[PhoneNumber] [varchar](15) NULL,
	[PhoneType] [varchar](30) NULL,
	[VerbalAgreementtotext] [bit] NOT NULL,
	[PhoneBadFlag] [bit] NOT NULL,
	[AttemptNotes] [varchar](30) NULL,
	[AttemptDate] [datetime] NULL,
	[CreatedTime] [datetime] NULL,
	[UpdatedTime] [datetime] NULL,
	[UpdatedBy] [varchar](55) NULL,
 CONSTRAINT [PK_MemberPhone] PRIMARY KEY CLUSTERED 
(
	[PhoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberProfile]    Script Date: 6/16/2022 2:28:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberProfile](
	[GMPI] [int] NOT NULL,
	[Gender] [varchar](50) NULL,
	[Source] [varchar](150) NULL,
	[Region] [varchar](150) NULL,
	[Market] [varchar](100) NULL,
	[Clinic Group] [varchar](50) NULL,
	[Clinic] [varchar](130) NULL,
	[PCP Name] [varchar](130) NULL,
	[PCP WellMed Owned] [varchar](50) NULL,
	[Member Name] [varchar](130) NULL,
	[DOB] [datetime] NULL,
	[GAPS] [int] NULL,
	[Outreach Status] [varchar](50) NULL,
	[Last Outreach Date] [datetime] NULL,
	[Do Not Call] [bit] NULL,
	[Do Not Visit] [bit] NULL,
	[Do Not Contact] [bit] NULL,
	[Care Check] [bit] NULL,
	[Care Check Status] [varchar](50) NULL,
	[CreatedTime] [datetime] NULL,
	[UpdatedTime] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_MasterProfileList] PRIMARY KEY CLUSTERED 
(
	[GMPI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 6/16/2022 2:28:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[OptumID] [nvarchar](50) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[ModifiedTime] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[PMMR] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[OneHealthcareEmailId] [nvarchar](50) NOT NULL,
	[OneHealthcareId] [nvarchar](50) NULL,
	[WellMedEmailId] [nvarchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MemberAddress]  WITH CHECK ADD  CONSTRAINT [FK_MemberAddress_MasterProfileList] FOREIGN KEY([GMPI])
REFERENCES [dbo].[MemberProfile] ([GMPI])
GO
ALTER TABLE [dbo].[MemberAddress] CHECK CONSTRAINT [FK_MemberAddress_MasterProfileList]
GO
ALTER TABLE [dbo].[MemberEmail]  WITH CHECK ADD  CONSTRAINT [FK_MemberEmail_MasterProfileList] FOREIGN KEY([GMPI])
REFERENCES [dbo].[MemberProfile] ([GMPI])
GO
ALTER TABLE [dbo].[MemberEmail] CHECK CONSTRAINT [FK_MemberEmail_MasterProfileList]
GO
ALTER TABLE [dbo].[MemberPhone]  WITH CHECK ADD  CONSTRAINT [FK_MemberPhone_MasterProfileList] FOREIGN KEY([GMPI])
REFERENCES [dbo].[MemberProfile] ([GMPI])
GO
ALTER TABLE [dbo].[MemberPhone] CHECK CONSTRAINT [FK_MemberPhone_MasterProfileList]
GO
