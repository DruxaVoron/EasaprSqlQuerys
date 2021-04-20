DECLARE	@StartDate DATETIME, 
		@EndDate DATETIME,
		@TrainIndex CHAR(15)
		
SET @StartDate = DATEADD(day, -3, GETDATE())
SET @EndDate = GETDATE()
SET @TrainIndex =  '5244-043-5331'

SELECT 
	aoc.CarriageNum AS '����� ������',
	ao.AktOfNum AS 'ID ���� �� ������',
	CASE 
		WHEN ao.[Status] = 0 THEN '��������' 
		WHEN ao.[Status] = 1 THEN '��������' 
		ELSE '��������' 
	END AS '������ ���� �� ������',
	
	CASE 
		WHEN (ISNULL(aodtc.AktOfNumEnd,0) >= 0 ) THEN aodtc.AktOfNumEnd 
		ELSE -1 
	END AS 'ID ���� �� ���������',
	
	CASE 
		WHEN aodtc.AktOfNumEnd = -1 THEN '������������� ���� � �������' 
		WHEN aodtc.AktOfNumEnd = -2 THEN '��� �� ������ �������� �������������' 
		WHEN aodtc.AktOfNumEnd = -3 THEN '��� �� ������ �������� ��������, �.�. ������������' 
		ELSE '' 
	END AS '����������'
FROM arg.dbo.AktOf AS ao WITH (NOLOCK)
	INNER JOIN arg.dbo.AktOfDownTimeCar AS aodtc WITH (NOLOCK) ON aodtc.AktOfNum = ao.AktOfNum
	LEFT JOIN arg.dbo.AktOfCarriage AS aoc WITH (NOLOCK) ON aodtc.AktOfNum = ao.AktOfNum AND aoc.AktOfCarriageNum = aodtc.AktOfCarriageNum
WHERE ao.TrainInd = @TrainIndex
	AND ao.TypeAdd = 1131
	AND ao.AktDate BETWEEN @StartDate AND @EndDate --��������� �����
ORDER BY aoc.AktOfNum DESC 






