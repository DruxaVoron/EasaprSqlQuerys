--������� �� 10.246.101.43

SELECT * FROM [mch].[dbo].[D_PRMFactory] WHERE Marka=341
SELECT * FROM [mch].[dbo].[D_PRMMarka] 
WHERE  NAME LIKE '%����%'

-- �������� �� ����
/--------------- --------------/
-- �������� �� ����
DECLARE @idMarka INT, @idFactory int, @Name VARCHAR(100);

SET @Name = '����-42�'; -- ��� ����������� ����� ���������
INSERT INTO [mch].[dbo].[D_PRMMarka] (
    [Name]
   ,[Type]
   ,[Capacity]
   ,[BayLength]
   ,[Lift]
   ,[BucketCapacity]
   ,[Boom]
   ,[Factory]
   ,[kvo5]
) VALUES (
	@Name
   ,'1'			-- [Type] - ��� ���������, ����� ����� �� ��� � ������
   ,'33.5'		-- [Capacity] - ����������������, �� ��������
   ,'32'		-- [BayLength] - ������ �������, �� ��������
   ,'9'			-- [Lift] - ������ �������, �� ��������
   ,''			-- [BucketCapacity] - ����������� �����, �� ��������
   ,''			-- [Boom] - ����������������, ���� ����� ������
   ,'��� '		-- [Factory] - �����-�������������, �� ��������
   ,'1'			-- [kvo5] - ����� ���, ����� ����� �� ��� � ������
 )
  SELECT @idMarka = @@identity
  
  INSERT INTO [mch].[dbo].[D_PRMFactory] (
  	[Name],[Marka]
  ) VALUES (
  	@Name,@idMarka
  )
SELECT @idFactory = @@identity
    
UPDATE [mch].[dbo].[D_PRMMarka] SET fact = @idFactory WHERE id = @idMarka
    
SELECT * FROM [mch].[dbo].[D_PRMMarka] WHERE id = @idMarka
    
    
    
                       