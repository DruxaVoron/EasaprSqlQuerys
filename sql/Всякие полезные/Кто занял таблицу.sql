--��� sa Aa123456

SELECT DB_NAME(pr1.dbid) AS 'DB'
      ,pr1.spid AS 'ID ������'
      ,RTRIM(pr1.loginame) AS 'Login ������'
      ,pr2.spid AS 'ID ���������'
      ,RTRIM(pr2.loginame) AS 'Login ���������'
      ,pr1.program_name AS '��������� ������'
      ,pr2.program_name AS '��������� ���������'
      ,txt.[text] AS '������ ���������'
FROM   MASTER.dbo.sysprocesses pr1(NOLOCK)
       JOIN MASTER.dbo.sysprocesses pr2(NOLOCK)
            ON  (pr2.spid = pr1.blocked)
       OUTER APPLY sys.[dm_exec_sql_text](pr2.[sql_handle]) AS txt
WHERE  pr1.blocked <> 0
