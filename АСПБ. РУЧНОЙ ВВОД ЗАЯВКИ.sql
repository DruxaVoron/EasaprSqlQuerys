DECLARE @ID int, @ClaimID int, @CurID int


select @CurID = max([ClaimID]) from [dt].[dbo].[Claim2] WHERE ContractID=1
INSERT INTO [dt].[dbo].[Claim2] ([ContractID],[ContractNum],[ContractDateFrom],[ContractDateTo],[Client],[ClaimID],[ClaimNum],[Date],[DateFrom],[DateTo],
[DownTime],[Rail],[AgreedRail],[AgreedDate],[Status],[ForCD],[Cancelled],[IsActive])
		VALUES

(
'1', --id ��������
'1028', -- ����� ��������
'2015-12-29 00:00:00.000', -- ���� ������ ��������
'2099-12-31 00:00:00.000', -- ���� ��������� ��������
'��� ���� ���������', -- ������������ �������
@CurID+1, -- ����������� �� ������� ��� ������ ����������
'109', -- ����� ������
GETDATE(), -- �� �������!
NULL, 
'2016-12-20 23:59:00.000',  -- ���� ��������� ������ 23 59
NULL, -- ���������� ���� ������� �� ������
'96', -- ������ ��������
'96 ', -- ���� ��������� ������ ��������
GETDATE(), -- �� �������
1,0,0,1 -- �� �������
); SET @ID=SCOPE_IDENTITY();

SET @ClaimID=(SELECT ClaimID FROM [dt].[dbo].[Claim2] WHERE id=@ID)
INSERT INTO [dt].[dbo].[ClaimLinks2] ([ClaimID],[SendID],[VagID]) VALUES (@ClaimID, 1,1)
