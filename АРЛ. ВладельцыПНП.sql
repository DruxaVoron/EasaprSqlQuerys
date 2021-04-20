-- ������������� ��������
DECLARE @docId int = '618702097'

-- �������� �������� � ��������
SELECT	distinct 
		recPP.ContractNum AS '����� ��������',
		recPP.dateBegin AS '���� ������ ��������', 
		recPP.dateEnd AS '���� ��������� ��������',
		CASE 
			WHEN (recPP.actual = 0) THEN '��������'
			WHEN (recPP.actual = 1) THEN '��������'
		END AS '������ ��������',
		recPP.[state] AS '������ �������� ������',
		recPP.station AS '��� �������� ������� ��������',
		ds.Name AS '�������� �������� ������� ��������'
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
INNER JOIN nsi.dbo.D_Station AS ds ON ds.code = recPP.station
WHERE	recPP.pcalid = @docId
		AND recPP.ContractNum IS NOT NULL
		
IF (@@ROWCOUNT = 0)
	SELECT	distinct 
			recPP.ContractNum AS '����� ��������',
			recPP.dateBegin AS '���� ������ ��������', 
			recPP.dateEnd AS '���� ��������� ��������',
			CASE 
				WHEN (recPP.actual = 0) THEN '��������'
				WHEN (recPP.actual = 1) THEN '��������'
			END AS '������ ��������',
			recPP.station AS '��� �������� ������� ��������',
			ds.Name AS '�������� �������� ������� ��������'
	FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
	INNER JOIN nsi.dbo.D_Station AS ds ON ds.code = recPP.station
	WHERE	recPP.pcalid = @docId

--�������������� �������, �� ������� ��������� �������
SELECT	stPP.station2 AS '��� �������������� ������� ��������',
		dsPP.Name AS '��� �������������� ������� ��������'
FROM [arg].[dbo].[D_StationPP] AS stPP
INNER JOIN nsi.dbo.D_Station AS dsPP ON dsPP.Code = stPP.station2
WHERE stPP.pcalid = @docId

--�������� � ��������� ����
--�� ���� ��� ���� 'ID ���������' ������ ���� ������
SELECT	recPP.id AS 'ID ������',
		recPP.Name AS '�������� ����������� - ���������',
		recPP.par AS 'ID ��������� �����',
		CASE 
			WHEN (recPP.actual = 0) THEN '��������'
			WHEN (recPP.actual = 1) THEN '��'
		END AS '������ ��������',
		recPP.[state] AS '������ �������� ������'
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
WHERE	recPP.pcalid = @docId
		AND recPP.typeClient = 'owner'

--�������� � �����������
--�� ���� ��� ���� 'ID ���������' ������ ��������� � ID � ������� ����
SELECT 	recPP.id AS 'ID ����������',
		recPP.Name AS '�������� ����������� - ����������',
		recPP.par AS 'ID ��������� �����',
		CASE 
			WHEN (recPP.actual = 0) THEN '��������'
			WHEN (recPP.actual = 1) THEN '��'
		END AS '������ ��������',
		recPP.[state] AS '������ �������� ������'
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
WHERE	recPP.pcalid = @docId
		AND recPP.typeClient != 'owner'
		
/*
* 
--������ ������� ����������
UPDATE [arg].[dbo].[T_ReceiverPP] set [state] = '85' WHERE id = '32809'

-- ����� �� ID ��������� �����
SELECT 	*
FROM  [arg].[dbo].[T_ReceiverPP] AS recPP
WHERE recPP.pcalid = '350777241'


--�������� ������ �� ��������
DELETE  arg.dbo.T_ReceiverPP WHERE pcalid   in ('350777241')
*/