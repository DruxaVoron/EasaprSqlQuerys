DECLARE @st CHAR(5), @rail CHAR(2), @depo INT;
 
SELECT @st = '06150', @rail = '01', @depo = 317;

IF NOT EXISTS (SELECT * FROM nsi.dbo.D_Depo WHERE station = @st AND depo = @depo AND rail = @rail)
INSERT INTO [nsi].[dbo].[D_Depo] VALUES (
	'����-4 �������',
	'���������������� �������� ���� �������',
	@st,@depo,@rail
)

SELECT * FROM nsi.dbo.D_Depo WHERE station = @st AND depo = @depo AND rail = @rail