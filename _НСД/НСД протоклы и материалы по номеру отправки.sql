DECLARE @le_number CHAR(8)='��005608', @stage VARCHAR(10);

IF EXISTS (SELECT * FROM delaypaid.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delaypaid
else IF EXISTS (SELECT * FROM delayisk.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delayisk
else IF EXISTS (SELECT * FROM delaypret.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delaypret
else IF EXISTS (SELECT * FROM delay.dbo.DelaySend AS ds WHERE ds.SendNum=@le_number)
	USE delay



	USE delaypaid
--	USE delayisk
--	USE delaypret
--	USE delay


SELECT wm.id,wmids.[service] AS 'ids.id',ids.DateAdded'���������� � ids',ids.ParentId'����. ids.id',wm.number AS '� ���������',wm.[date] AS '���� ���������',
case when wm.Closed='1' THEN '������' ELSE '������'end AS '��������',wm.CloseDate AS '���� �������� ���������',
case when wmids.NotReviewed ='1' THEN '�� �����������' ELSE '�����������'end AS '� ���������',
case ids.[Status] 
		WHEN 0 THEN '���������'
		WHEN 3 THEN '�������� ��'
		when 4 THEN '����. �� ��'
	ELSE '��'
END AS '������',

idp.number AS '����������', idp.closed ,idp.CloseDate AS '���� �������� ���������',
CASE wm.stage
 WHEN 'delay' THEN '���������������' 
 WHEN 'delaypret' THEN '�������������'  
 WHEN 'delayisk' THEN '�������'   
 WHEN 'delaypaid' THEN '�������(�������)' ELSE idp.stage end 

AS'���� ���������'

 FROM DelaySend AS ds
INNER JOIN investdelayservice ids ON ds.sendid=ids.sendid
left JOIN delaycommon.dbo.WgMaterial_InvestDelayService AS wmids ON wmids.[service]=ids.id --AND wmids.Protocol IS NOT null
left JOIN delaycommon.dbo.WgMaterial AS wm ON wm.id=wmids.wgmaterial AND wm.stage=db_name()
left JOIN delaycommon.dbo.InvestDelayProtocol AS idp ON idp.id=wm.protocolid
WHERE ds.SendNum  =@le_number

ORDER BY wmids.[service], wm.[date]

SELECT * FROM delaypaid.dbo.InvestDelayService AS ids WHERE ids.id='1286591' OR ids.parentid='1399873'
OR sendid='408194'

SELECT * FROM delaycommon.dbo.WgMaterial_InvestDelayService AS wmids WHERE wmids.sendid='445870'
SELECT TOP 100* FROM delaycommon.dbo.InvestDelayProtocol AS idp
/*
 SELECT * FROM 	delaycommon.dbo.WgMaterial_InvestDelayService where wgmaterial='1359'
 SELECT count(*) FROM 	delaycommon.dbo.WgMaterial_InvestDelayService where wgmaterial='1359'
 and notreviewed='1'
 */
 
 /*
 use delay
 SELECT * FROM delaysend WHERE SendNum='��504577'
 SELECT * FROM InvestDelayService AS ids WHERE Sendid='4103369'
 SELECT * FROM delaycommon.dbo.WgMaterial_InvestDelayService AS wmids WHERE wmids.[service] IN (9350452
,9577426)


SELECT*FROM delaycommon.dbo.WgMaterial AS wm WHERE number ='�-��1-���-15/2016'

SELECT*FROM delaycommon.dbo.InvestDelayProtocol AS idp WHERE  number ='�-���-1/2016'
*/




--SELECT*FROM delaycommon.dbo.WgMaterial AS wm WHERE number ='�-��1-���-11/2016'
--SELECT * FROM delaycommon.dbo.WgMaterial_InvestDelayService AS wmids WHERE wmids.wgmaterial='1455'