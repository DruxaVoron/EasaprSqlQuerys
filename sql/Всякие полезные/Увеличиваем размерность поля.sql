
--��������� ������� ������������ ������� � ������ � ���������� "2"
USE prolong 
ALTER TABLE dbo.DropProlong ADD Sender2 varchar(255), receiver2 varchar(255)
ALTER TABLE dbo.DropProlong_spoiled ADD Sender2 varchar(255), receiver2 varchar(255)

-- ��������� ����� (��� ���� �����)
USE prolong 
EXECUTE sp_refreshview N'dbo.DropProlongAll'; 

-- ��������� ��������
UPDATE dbo.DropProlong SET Sender2 = sender, receiver2 = receiver
UPDATE dbo.DropProlong_spoiled SET Sender2 = sender, receiver2 = receiver

-- ��������������� "������" ������� � 3�
-- ��������������� 2� ������� � "�����"
USE prolong 
EXEC sp_rename 'dbo.DropProlong.sender', 'sender3', 'COLUMN'
EXEC sp_rename 'dbo.DropProlong.sender2', 'sender', 'COLUMN'
GO

USE prolong 
EXEC sp_rename 'dbo.DropProlong.receiver', 'receiver3', 'COLUMN'
EXEC sp_rename 'dbo.DropProlong.receiver2', 'receiver', 'COLUMN'
GO


-- ������� ������ 3� ������
USE prolong 
ALTER TABLE dbo.DropProlong DROP COLUMN Sender3, receiver3
ALTER TABLE dbo.DropProlong_spoiled DROP COLUMN Sender3, receiver3


-- ��������� ����� (��� ���� �����)
USE prolong 
EXECUTE sp_refreshview N'dbo.DropProlongAll'; 