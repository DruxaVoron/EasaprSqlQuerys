DECLARE @TrainIndex char(13)
DECLARE @DropID int

SET @TrainIndex='2264-030-5331'
SET @DropID=319281--(SELECT top 1 DropID FROM [dt].[dbo].[rpt_cfto0139] WHERE TrainIndex=@TrainIndex ORDER BY CreateDate desc)

--select * from [dt].[dbo].[DtOrder] where TrainIndex='2264-030-5331' ORDER BY [date] --�� ������ ������ "Subquery returned more than 1 value...."

------------------------------���������� �� ������� � ��������� � ������----------------------------
--SELECT DATEDIFF(d,null,'2016-10-19 04:06:00.000')

SELECT DISTINCT rpts.DropID, rpts.SendNum, rpts.uno, rpts.VagNum, isaffected as '��������� ����',deliverydate AS '����.���� ����.', faktdate as '����.���� ��������', 
		CASE 
			WHEN IsAffected=1 AND DATEDIFF(d, DeliveryDate, FaktDate) >0 THEN '�����'
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 1 THEN '�� ����� - ���� �������� �� �������' 
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 0 THEN '�� ����� - ���� �������� �� �������; �� ��������� ���� ���� � ���������, ���� � ����������� ���������� ���� ������������, ���� �� ��������� ������������ �����������' 
			WHEN FaktDate IS NULL AND IsAffected=1 THEN  '��� ���������� �� ��� � �������� ��������'
			WHEN IsAffected = 0 AND DATEDIFF(d, DeliveryDate, FaktDate) > 0 THEN '�� ����� - �� ��������� ���� ���� � ���������, ���� � ����������� ���������� ���� ������������, ���� �� ��������� ������������ �����������'
			WHEN IsAffected = 0 AND FaktDate IS NULL THEN '��� ���������� �� ��� � �������� ��������; �� ����� - �� ��������� ���� ���� � ���������, ���� � ����������� ���������� ���� ������������, ���� �� ��������� ������������ �����������'
			END as Osnovaniya,
		SummToPay, SummPayed, SummPret
			FROM [dt].[dbo].[rpt_cfto0139Sends] rpts
	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=rpts.DropID
	LEFT JOIN [dt].[dbo].[DtInquiry] di ON di.id=do.Inquiry
	LEFT JOIN [dt].[dbo].[DtInquiry_AffectedReceiver] diar ON diar.inqid=di.id
	LEFT JOIN [alpha].[arg].[dbo].[T_ReceiverPP] pp ON pp.id=diar.receiver
	WHERE rpts.DropID=@DropID 
	--WHERE VagNum=''
	--WHERE SendNum=''
	ORDER BY 
	CASE 
			WHEN IsAffected=1 AND DATEDIFF(d, DeliveryDate, FaktDate) >0 THEN '�����'
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 1 THEN '�� ����� - ���� �������� �� �������' 
			WHEN DATEDIFF(d, DeliveryDate, FaktDate) < 1 AND FaktDate IS NOT NULL AND IsAffected = 0 THEN '�� ����� - ���� �������� �� �������; �� ��������� ���� ���� � ���������, ���� � ����������� ���������� ���� ������������, ���� �� ��������� ������������ �����������' 
			WHEN FaktDate IS NULL AND IsAffected=1 THEN  '��� ���������� �� ��� � �������� ��������'
			WHEN IsAffected = 0 AND DATEDIFF(d, DeliveryDate, FaktDate) > 0 THEN '�� ����� - �� ��������� ���� ���� � ���������, ���� � ����������� ���������� ���� ������������, ���� �� ��������� ������������ �����������'
			WHEN IsAffected = 0 AND FaktDate IS NULL THEN '��� ���������� �� ��� � �������� ��������; �� ����� - �� ��������� ���� ���� � ���������, ���� � ����������� ���������� ���� ������������, ���� �� ��������� ������������ �����������'
			END

-----------------------------���������� �� ����������� ���� � ��������, ���������� �� �����-------------------

SELECT DISTINCT rpts.SendNum, rpts.uno, rpts.Receiver'���������� � � �� ������ ��������', pp.Name'����� ��, �� � ���', s.ReceiverCode'��� ���������� �� �������', pp.TGNL'�� ���'
FROM [dt].[dbo].[rpt_cfto0139Sends] rpts
	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=rpts.DropID
	INNER JOIN [dt].[dbo].[shipment] s ON s.carriageId=rpts.VagID
	LEFT JOIN [dt].[dbo].[DtInquiry] di ON di.id=do.Inquiry
	LEFT JOIN [dt].[dbo].[DtInquiry_AffectedReceiver] diar ON diar.inqid=di.id
	LEFT JOIN [alpha].[arg].[dbo].[T_ReceiverPP] pp ON pp.id=diar.receiver
	WHERE rpts.DropID=@DropID
	/*
SELECT do.id 'DtOrder.Id',rpts.DropID'rpts.DropID', s.carriageId's.carriageId',rpts.VagID'rpts.VagID', di.id'di.id',do.Inquiry'do.Inquiry', diar.inqid'diar.inqid',di.id'di.id', pp.id'pp.id',diar.receiver'diar.receiver'
 FROM [dt].[dbo].[rpt_cfto0139Sends] rpts
 	INNER JOIN [dt].[dbo].[DtOrder] do ON do.id=rpts.DropID
	INNER JOIN [dt].[dbo].[shipment] s ON s.carriageId=rpts.VagID
	LEFT JOIN [dt].[dbo].[DtInquiry] di ON di.id=do.Inquiry
	LEFT JOIN [dt].[dbo].[DtInquiry_AffectedReceiver] diar ON diar.inqid=di.id
	LEFT JOIN [alpha].[arg].[dbo].[T_ReceiverPP] pp ON pp.id=diar.receiver
	WHERE rpts.DropID=320062

*/
---------------------------���������� �� �������������-------------------------------

SELECT DISTINCT rpts.SendNum, rpts.VagNum, dueSum, �.cumID, �.cumNumber, �.cumState, �.CumLastOper
	FROM [alpha].[prolong].[dbo].[DropProlong] dp
	INNER JOIN [dt].[dbo].[rpt_cfto0139Sends] rpts ON rpts.DropID=dp.DropOrderId
	LEFT JOIN [cfto].[dbo].[CumulativeDue] cd ON cd.dueEasaprid=dp.aofIdEnd AND dp.sendUno=rpts.uno AND rpts.VagNum=cd.carNumber
	LEFT JOIN [cfto].[dbo].[Cumulative] � ON �.cumID=cd.cumID
	WHERE rpts.DropID=@DropID AND cd.cumID IS NOT NULL
	
	-- AND c.cumState='���������'
	-- AND (c.cumState='����������' OR c.cumState='������' OR c.cumState='�� ����������' OR c.cumState='���������� � �������������' OR c.cumState='�� �������')
	-- AND c.cuMState='���������'
	ORDER BY VagNum, cumLastOper

-----------------------------�������� ���������� �� ������������� �� ID -----------------------------------

DECLARE @CumID int
SET @CumID=''

SELECT cd.cumID, c.cumLastOper, c.cumNumber, cd.carNumber, cd.dueSum, cd.dueEasaprid
	FROM [cfto].[dbo].[CumulativeDue] cd
	INNER JOIN [cfto].[dbo].[Cumulative] c ON c.cumID=cd.cumID
	WHERE cd.cumID=@CumID 
	
	--INSERT INTO dt.dbo.[DtInquiry_AffectedReceiver] (inqid,receiver,pnpowner)	VALUES('100399','64737','64737')
--	update dt.dbo.rpt_cfto0139Sends  SET IsAffected = 0	WHERE uno  in ('649825015', '649827764', '649829812', '649844068', '649846187', '650028999', '650035209', '650038742', '650039952')


