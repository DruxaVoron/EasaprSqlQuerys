--������� �� 10.246.101.43

SELECT Prd.[FolderNum] as 'FolderPrd'
     ,n.[NameShort] as '���������'
     ,Prd.[Prd] as '����.����'
     ,Prd.[Date] as 'DatePrd'
     ,Rd.[FolderNum] as 'FolderRd'
     ,Rd.[Rd] as '����.����'
     ,Rd.[Date] as 'DateRd'
     FROM [mu].[dbo].[MuPrd] as Prd
left outer join [mu].[dbo].[MuRd] as Rd on Rd.[InitiatorFolderNum]=Prd.[FolderNum]
left outer join [mu].[dbo].[MuFolder] as f on f.[FolderNum]=Prd.[FolderNum]
left outer join [nsi].[dbo].[D_Rail] as n on f.[Rail]=n.[Code]
where Rd.[Rd]='����.����' or Prd.[Prd]='����.����' order by [DatePrd] desc

SELECT [id]
      ,[FolderNum] as 'FolderPrd'
      ,[Sum]
      ,[Date]
      ,[ToConference]
      ,[Closed]
      ,[SumReason]
FROM [mu].[dbo].[MuPrasG]
where FolderNum ='1533984'

/*
 --������� �������������� ���������������: 
UPDATE [mu].[dbo].[MuPrasG]
SET Closed='0'
where [FolderNum] = '1533984' and id = '7067'

--����� ������� ��� ���������:
UPDATE [mu].[dbo].[MuPrasG]
SET ToConference='0'
where [FolderNum] = 'FolderPrd' and id = 'Id'

--������� �������������� ���������������: 
DELETE FROM [mu].[dbo].[MuPrasG]    
where [FolderNum] = '1377259' and id = '6363'
DELETE FROM [mu].[dbo].[MuPRas]
where [PrasgId] = '6363'

*/