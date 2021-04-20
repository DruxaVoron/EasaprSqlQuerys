-- � 43
SELECT 

dr.Code,
dr.NameShort,
d_cl.Name,
CS.INN,
CS.ContNum as '����� ��������',
CS.ContDate as '������� ��������', 
CS.ContDateStart as '������ ��������',
CS.ContDateEnd '�����',
c_agr.AgreeDate'���� ���.���',
AgreeDateFrom '������ ��',
c_agr.AgreeDateTo'���.��� ��',
CS.FlagOff

FROM [mch].[dbo].[ContractServ] CS
INNER JOIN nsi.dbo.D_Rail DR on dr.Code=CS.Rail
inner join mch.dbo.d_client d_cl on cs.idclient=d_cl.code
left join mch.dbo.ContractAgree c_agr on c_agr.FolderNum=CS.FolderNum and c_agr.AgreeDateFrom>CS.ContDateEnd
left join mch.dbo.ContractServ as cs1 on cs1.INN=cs.INN and cs1.ContDateStart>cs.ContDateEnd
where CS.ContDateStart between '2018-01-01' and '2018-12-31' 

order by DR.Code, INN, cs.ContDateStart 
