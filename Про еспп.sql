DECLARE @StartDate date = '2020-01-01'
       ,@EndDate   date = '2020-05-01'
;
DECLARE @dateTab TABLE (theDate DATE);
DECLARE @sys INT =8; -- 1 ������ �
                      -- 2 ������
                      -- 3 ��
                      -- 4 ����
                      -- 5 ����
                      -- 6 ���
                      -- 7 ����
                      -- 8 ���
                      


WITH theDates AS
     (SELECT @StartDate as theDate
      UNION ALL
      SELECT DATEADD(day, 1, theDate)
        FROM theDates
       WHERE DATEADD(day, 1, theDate) <= @EndDate
     )
 
INSERT @dateTab
SELECT theDate
FROM theDates


SELECT	 td.theDate AS '����'
		,isnull(lb.LeftBefore,0) '������� �� ������'
		,isnull(inc.incoming,0)'������ �� ����'
		,isnull(sh.shitDone,0)'������� �� ����'
		,isnull(lb.LeftBefore,0)+isnull(inc.incoming,0)-isnull(sh.shitDone,0) '������� �� �����'
		,ISNULL(w.wasted,0)'����������'
FROM @dateTab AS td
	LEFT JOIN (
		SELECT td.theDate, COUNT(1) AS leftBefore
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON pe.dateOpen < td.theDate AND (pe.dateClose IS NULL OR pe.dateClose >= td.theDate)

		WHERE pe.systemcode = CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate
	) AS lb ON lb.theDate = td.theDate
	LEFT JOIN (
		SELECT td.theDate, COUNT(1) AS incoming
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON pe.dateOpen = td.theDate

		WHERE pe.dateOpen >=@StartDate AND pe.systemcode = CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate
	) AS inc ON inc.theDate = td.theDate
	LEFT JOIN (
		SELECT td.theDate, COUNT(1) AS shitDone
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON pe.dateClose = td.theDate

		WHERE pe.systemcode = CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate 
	) AS sh ON sh.theDate = td.theDate
	
	LEFT JOIN (
		SELECT td.theDate, COUNT(DISTINCT vpnum) AS wasted
		FROM @dateTab AS TD
			LEFT JOIN analyze.dbo.Pro_ESPP2 AS pe ON td.theDate > pe.dateOpen AND (td.theDate<pe.dateClose OR pe.dateClose IS NULL)

		WHERE pe.isitSNAFU ='1' AND pe.systemcode= CASE WHEN @sys IS NOT NULL THEN @sys ELSE pe.systemcode END
		GROUP BY td.theDate 
	) AS w ON w.theDate = td.theDate

 /* 
UPDATE analyze.dbo.Pro_ESPP2 SET systemcode = CASE WHEN (system like '���_����' or system like '���_���' or system like '���_���' or system like '���_���_���' or system like '���_�����' or system like '���_������_�' or system like '���_��������������' or system like '���_���') THEN 1 --easapr M
WHEN (system like '���_��_������' or system like '���_����') THEN 2 --teskad
WHEN (system like '���_������_��' or system like '���_��_��') THEN 3--sd
WHEN (system like '���_������_����') THEN 4--sfto
WHEN (system like '���_����' or system like '���_����_���') THEN 5 --askm
WHEN (system like '���_������_���') THEN 6-- rzd
WHEN (system like '���_������_����') THEN 7--rzdS
WHEN (system like '���-������-���') THEN 8-- cust
                                              end
                                              
                             */
/*
delete analyze.dbo.pro_espp2
*/                             