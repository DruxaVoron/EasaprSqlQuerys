SELECT *
  FROM [admin].[dbo].[Forum]
  
  where MsgDate > '2014-03-30'
  and MsgText like '������������. �� ������� ������ ���� �������� �� ����������. ���������� ��� ��� ����������. ���� �������� ����������� ���������� � ��� ����� ����.'
  --or ParentId='105382'
  
--  delete from admin.dbo.Forum  where MsgNumRec='113040'