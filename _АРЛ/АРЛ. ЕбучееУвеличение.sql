 --Ебашить на 10.246.101.18
DECLARE @SendNum char(8)='ЭУ304300'
  /*
	  delete from [arg].[dbo].[ProlongLink]  where [key] ='52247'
	  delete from [arg].[dbo].[ProlongSend]  where [key] IN ('203','4199375')
	  
	  update [arg].[dbo].[ProlongLink]set aofidfinal = null  where sendNum='ЭЫ522828' 
	  update [arg].[dbo].[ProlongSend] set [resultProlong] = 0 where [key] ='6551473'
	  update [aof_oper].[dbo].[aof] set [status]=0 where aktofnum='96853074'

	  114458967
  
	   update [arg].[dbo].[ProlongSend] set [sendStatus] = 2 where [key] ='3942203'
 
  */
  
SELECT * FROM [arg].[dbo].[ProlongLink] where sendNum=@SendNum AND uno IS NOT NULL

Select	[key], SendNum,
		case when parentuno is null then 'Основная' else 'Досылка' end as WTF,
		invID, uno, parentuno, stationFrom, st1.name 'Откуда', stationTo, st2.name 'Куда',
		stationReg + ' ('+RTRIM(st3.Name)+')'as 'Где зарегали', dateReg, dateArrive, resultProlong, resultText,
		CASE WHEN sendStatus = 2 THEN 'Потрачена' ELSE 'Активна' END AS 'Статус'
from (
	SELECT * FROM [arg].[dbo].[ProlongSend] where sendNum = @SendNum
		UNION
	SELECT * FROM [arg].[dbo].[ProlongSend] where uno in(SELECT parentuno FROM [arg].[dbo].[ProlongSend]  where sendNum=@SendNum)
		UNION
	SELECT * FROM [arg].[dbo].[ProlongSend] where invId in(SELECT parentuno FROM [arg].[dbo].[ProlongSend]  where sendNum=@SendNum)
) s
left join nsi.dbo.d_station st1 on st1.code = s.stationFrom 
left join nsi.dbo.d_station st2 on st2.code = s.stationTo 
left join nsi.dbo.d_station st3 on st3.code = s.stationReg 
order by parentuno
