-- �� �������
DECLARE @memoid int = 42370918

-- ������� ������� � ������ ���
SELECT *
FROM memo.dbo.analyze_busyPNP_dt_new
WHERE memoIdClean = @memoid or memoIdFeed = @memoid

-- ���� ��������� �������
SELECT * FROM arg.dbo.logMess
WHERE docId = @memoid AND typeMess = 'gu45' AND typeDoc = 'save'

-- ������ � �������� � �������
SELECT pp.* 
FROM arg.dbo.T_ReceiverPPNew AS pp
	INNER JOIN memo.dbo.memo AS m 
		ON m.memoStation = pp.station
			AND m.okpoClient = pp.OKPO
WHERE pp.actual = 1 AND m.memoId = @memoid


-- ������ � ������, � ������� ������� ������ ���� ���� ���������
SELECT mc.memoId, mc.carNum, mc.cargoCode, mc.cargoName, mc.feedDate, mc.cleanDate
	,pnp.*
FROM memo.dbo.memo_car AS mc
	INNER JOIN memo.dbo.memo AS m ON m.memoId = mc.memoId
	
	LEFT JOIN memo.dbo.analyze_busyPNP_dt_new AS pnp
		ON pnp.carNum = mc.carNum AND pnp.memoStation = m.memoStation AND pnp.dateArrive < mc.feedDate AND pnp.memoIdFeed is null

WHERE mc.memoId = @memoid