
DECLARE @codest int;DECLARE @namest char(32);
set @namest='����������%'
--SET @codest =92004;--���� ���� �� �������

select rtrim(st.code)'��� ��',rtrim(st.name)'����. ��',rtrim(re.Code)'��� ���.',st.coderail+st.CodeNOD'���� "Dcs"',rtrim(re.Name)'����.���.',
tdb.id'�������. ID ���.����.',tdb.Department'������',tdb.name'������� ���������� �� ������ �������'
FROM nsi.dbo.D_Station st
left join nsi.dbo.D_Region re on re.Code=st.Region
LEFT JOIN nsi.dbo.T_DepartmentBranch AS tdb ON tdb.name LIKE '%'+rtrim(re.Name)+'%'
     WHERE st.Code = @codest or 
     st.Name like rtrim(@namest)
/*
SELECT * FROM nsi.dbo.D_Station AS ds WHERE code IN ('','','96383')
                                     
 */
--�����. ���� ������ � ��������������:
select * from nsi.dbo.T_DepartmentBranch where name like '%����������%' OR station='78004'

SELECT * FROM nsi.dbo.d_region WHERE code LIKE '76%'
--�����. ���� �������� � ������ � ����������


     
asdfasdf
-------------
DECLARE @codedep int;
DECLARE @rightKey int;
DECLARE @level int;
DECLARE @parentid int;
DECLARE @department int;

SET @parentid = 65;		-- id �������������, � ������� ������
SET @department = 0;	-- ������
SET @codedep = 65363;	-- ���� ��� �������


    IF NOT EXISTS (
           SELECT *
           FROM   nsi.dbo.T_DepartmentBranch
           WHERE  Station = @codedep
       )
    BEGIN
        SELECT @rightKey = rightKey
              ,@level     = [level]
        FROM   nsi.dbo.T_DepartmentBranch
        WHERE  id         = @parentid;
        UPDATE nsi.dbo.T_DepartmentBranch
        SET    leftKey      = CASE 
                              WHEN leftKey<@rightKey THEN leftKey
                              ELSE leftKey+2
                         END
              ,rightKey     = rightKey+2
        WHERE  rightKey>= @rightKey;
        
        INSERT INTO [nsi].[dbo].[T_DepartmentBranch]
          (
            [name]
           ,[leftKey]
           ,[rightKey]
           ,[level]
           ,[nameshort]
           ,[Department]
           ,[Rail]
           ,[Region]
           ,[Station]
           ,[Dcs]
          )
        SELECT NAME
              ,@rightKey
              ,@rightKey+1
              ,@level+1
              ,NAME
              ,@department
              ,CodeRail
              ,Region
              ,Code
              ,CodeRail+CodeNOd
        FROM   nsi.dbo.D_Station
        WHERE  Code = @codedep
        
        SELECT id
              ,Department
              ,Rail
              ,Region
              ,Station
              ,NAME
        FROM   nsi.dbo.T_DepartmentBranch
        WHERE  Station = @codedep
    END
    ELSE SELECT '����� ������� ��� ����!'


	

DECLARE @namedep CHAR(32) SET @namedep='��������������%'
DECLARE @Rkey INT; DECLARE @Lkey INT;
SET @Rkey=(SELECT rightkey FROM nsi.dbo.T_DepartmentBranch WHERE NAME LIKE rtrim(@namedep)+'%')
SET @Lkey=(SELECT leftkey FROM nsi.dbo.T_DepartmentBranch WHERE NAME LIKE rtrim(@namedep)+'%')
SELECT * FROM nsi.dbo.T_DepartmentBranch AS tdep
WHERE tdep.leftKey>=@Lkey AND tdep.rightkey<=@Rkey
--and LEVEL<='4' 
ORDER BY tdep.leftkey,tdep.[level]



select * from nsi.dbo.T_DepartmentBranch AS tdb
WHERE NAME LIKE '�������%'
