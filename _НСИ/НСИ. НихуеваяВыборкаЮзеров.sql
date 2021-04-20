SELECT 
       U.[Name] as '�.�.�.'
      ,D.[Name] as '��������������'
      ,U.[AppNum] as '����� ������'
      ,'���� ������' = CONVERT (char,U.[AppDate],104) 
      ,'���� �����������' = CONVERT (char,U.[DateIns],104)      
     -- ,U.code
      ,rail.[NameShort] as '������'
      ,nod.[Name] as '���'
      ,st.[Name] as '�������'    
      ,'���� ���������� �����'=CONVERT(char, max (IP.[Date]),104) 
      
FROM [admin].[dbo].[D_User] as U
left outer join [admin].[dbo].[D_Department] as D on D.Code=U.[Department]
left outer join [admin].[dbo].[D_UserIP] as IP on IP.[User]=U.[Code]
left outer join [nsi].[dbo].[D_Station] as st on st.[code]=U.[Station]
left outer join [nsi].[dbo].[D_NOD] as nod on U.[Nod]=nod.Code
left outer join [nsi].[dbo].[D_Rail] as rail on U.[Rail]=rail.[Code]

 
   where Rail='28' and Department=0 and Del is null
   
   group by u.Code,u.name,u.AppDate,u.Rail,st.Name,d.Name,u.DateIns ,u.AppNum, nod.[Name],rail.[NameShort]
   
   
   order by U.code