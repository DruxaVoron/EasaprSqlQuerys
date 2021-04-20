/*
*		������� �� 10.246.101.42
	0 - ��������� ������ ������
	1 - ��������� ������ � ������� ���������
	2 - ��������� ����������
*/
SELECT TOP 100 CONVERT(char(13),[date],120) + ' ���' AS '����������, +1 ���',
	sum( CASE WHEN processed = 0 THEN 1 END ) AS '0',
	sum( CASE WHEN processed = 1 THEN 1 END ) AS '1',
	sum( CASE WHEN processed = 2 THEN 1 END ) AS '2'
FROM que.dbo.input_que
GROUP BY CONVERT(char(13),[date],120)
ORDER BY CONVERT(char(13),[date],120) desc