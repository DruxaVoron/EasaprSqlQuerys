USE nsi
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[D_MetodEtranWeigh](
	[Code] [int] NULL,
	[Name] [varchar](50) NULL,
	[actual] [bit] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[D_MetodEtranWeigh] ADD  CONSTRAINT [DF_D_MetodEtranWeigh_actual]  DEFAULT ((1)) FOR [actual]
GO


INSERT INTO nsi.dbo.d_metodetranweigh (code,name)
VALUES ('01','�� �������� ����� (50 ��)'),
('02','�� ���������'),
('03','�� ���������'),
('04','�� ������'),
('05','��������� �����'),
('06','�������'),
('07','����������� ����� ������ �����'),
('08','�� �������� �����'),
('09','�� �������� ����� (100 ��)'),
('10','�� ����������� �����'),
('11','�������'),
('12','�������� � ��� �������'),
('13','������������� ����')