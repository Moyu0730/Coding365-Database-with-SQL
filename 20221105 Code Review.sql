USE GSSWEB
GO

/*
**Questions** - FINISH

1.	請列出每個使用者每年借書數量，並依使用者編號和年度做排序
Table：MEMBER_M、BOOK_LEND_RECORD
Hint：INNER / LEFT / RIGHT JOIN、ORDER BY、COUNT
Sample：
KeeperId	CName	EName	BorrowYear	BorrowCnt
0001	    張三	Andy	2016		12
0001	    張三	Andy	2017		10
0001		張三	Andy	2018		8
0002		李四	Bill	2016		19
0002		李四	Bill	2017		19
0002		李四	Bill	2018		12
*/

/*
**Answers**

SELECT MEM.USER_ID, MEM.USER_CNAME, MEM.USER_ENAME, 
	YEAR(BLR.LEND_DATE) AS BorrowYear, 
	COUNT(BLR.LEND_DATE) AS BorrowCnt,
--	COUNT(*) AS BorrowCnt
FROM MEMBER_M AS MEM LEFT JOIN BOOK_LEND_RECORD AS BLR
	ON BLR.KEEPER_ID = MEM.USER_ID
GROUP BY YEAR(BLR.LEND_DATE), MEM.USER_CNAME, MEM.USER_ENAME, MEM.USER_ID
ORDER BY MEM.USER_ID, YEAR(BLR.LEND_DATE) ASC; --Strictly Decreasing
*/

--INNER / RIGHT JOIN
-- RIGHT JOIN change to LEFT JOIN
----------------------------------------------------------------------------------------------------

/*

**Questions** - FINISH EXCEPT [PS若有數量相同，可以怎麼處理?]

2.	列出最受歡迎的書前五名(借閱數量最多前五名 [PS若有數量相同，可以怎麼處理?]) 

Table：BOOK_LEND_RECORD
Hint：TOP 或 RANK
Sample：
BookId	BookName									QTY
2258	2010.10.18 英文A班							13
1865	高科技產業人力資源管理						10
1984	WRITING SECURE CODE							9
1397	ASP.NET 4.0完美入門--使用VB					8
213		Information Systems							4
		Management In Practice (second edition)	
*/

/*
**Answers**

SELECT TOP 5 WITH TIES BLR.BOOK_ID, BD.BOOK_NAME, 
		 COUNT(BLR.BOOK_ID) AS [Qty]
FROM BOOK_LEND_RECORD AS BLR 
	INNER JOIN BOOK_DATA AS BD ON BLR.BOOK_ID = BD.BOOK_ID
GROUP BY BLR.BOOK_ID, BLR.BOOK_ID, BD.BOOK_NAME
ORDER BY Qty DESC;
*/
--WITH TIES display same amount
--Check if the data amount is same

/*
**Remark**

Still have to deal with the cases of same number
*/

----------------------------------------------------------------------------------------------------

/*
**Questions**

3.	以一季列出2019年每一季書籍借閱書量

 (*進階：考慮未來需求調整對程式的變動幅度，建議使用SPAN_TABLE)
Table：BOOK_LEND_RECORD
Hint：CASE WHEN
Sample：
Quarter				Cnt
2019/01~2019/03		15
2019/04~2019/06		11
2019/07~2019/09		8
2019/10~2019/12		15
*/

/*
**Answers**

SELECT LEND_DATE,
	CASE
		WHEN LEND_DATE BETWEEN '2019-01-01' AND '2019-03-31' THEN '2019 / 01 ~ 2019 / 03'
		WHEN LEND_DATE BETWEEN '2019-04-01' AND '2019-06-30' THEN '2019 / 04 ~ 2019 / 06'
		WHEN LEND_DATE BETWEEN '2019-07-01' AND '2019-09-30' THEN '2019 / 07 ~ 2019 / 09'
		WHEN LEND_DATE BETWEEN '2019-10-01' AND '2019-12-31' THEN '2019 / 10 ~ 2019 / 12'
	END AS A
FROM BOOK_LEND_RECORD
--WHERE LEND_DATE BETWEEN '2019-01-01' AND '2019-12-31'
WHERE YEAR(LEND_DATE) = 2019
*/

/*
SELECT
	CASE DATEPART( q, BLR.LEND_DATE)
		WHEN 1 THEN '2019 / 01 ~ 2019 / 03'
		WHEN 2 THEN '2019 / 04 ~ 2019 / 06'
		WHEN 3 THEN '2019 / 07 ~ 2019 / 09'
		WHEN 4 THEN '2019 / 10 ~ 2019 / 12'
	END AS Quarter, COUNT(YEAR(BLR.LEND_DATE)) AS Cnt
FROM BOOK_LEND_RECORD AS BLR
	INNER JOIN SPAN_TABLE AS ST ON YEAR(BLR.LEND_DATE) = ST.SPAN_YEAR
		AND DATEPART( MM, LEND_DATE ) BETWEEN ST.SPAN_START AND ST.SPAN_END
GROUP BY BLR.LEND_DATE
*/

/*
**Remark**

*/

----------------------------------------------------------------------------------------------------

/*
**Questions** - FINISH

4.	撈出每個分類借閱數量前三名書本及數量

Table：BOOK_LEND_RECORD、BOOK_CLASS、BOOK_DATA
Hint：PARTITION BY、ROW_NUMBER 或 RANK、子查詢
Sample：
Seq	BookClass	BookId	BookName								Cnt
1	Banking		411		信用風險議題與資訊平台規劃#2			3
2	Banking		1980	洞悉金融資訊與支付應用大未來&#9313;		3
3	Banking		130		我國銀行實施客戶別利潤分析之研究		2
1	Database	1984	WRITING SECURE CODE						9
2	Database	504		精通SQL Server 7.0資料庫系統			2
3	Database	511		SQL Server Diagnostics					2

*/

/*
**Answers**

SELECT * 
FROM ( 
	SELECT 
		RANK() OVER( PARTITION BY BC.BOOK_CLASS_NAME ORDER BY COUNT(BLR.LEND_DATE) DESC ) AS Seq,
		BLR.BOOK_ID, 
		BC.BOOK_CLASS_NAME, 
		BD.BOOK_NAME, 
		COUNT(BLR.LEND_DATE) AS Cnt
	FROM BOOK_DATA AS BD
		RIGHT JOIN BOOK_LEND_RECORD AS BLR ON BLR.BOOK_ID = BD.BOOK_ID
		RIGHT JOIN BOOK_CLASS AS BC ON BD.BOOK_CLASS_ID = BC.BOOK_CLASS_ID
	GROUP BY BC.BOOK_CLASS_NAME, BD.BOOK_ID, BD.BOOK_NAME, BLR.BOOK_ID ) AS A
WHERE A.Seq < 4
*/

/*
**Remark**
How to resolve duplicate data which display to choose ?
Notice the defnition of top 3
<4 and <= 3
*/
----------------------------------------------------------------------------------------------------

/*
**Questions**

5.	請列出 2016, 2017, 2018, 2019 各書籍類別的借閱數量比較
Table：BOOK_LEND_RECORD
Hint：COUNT或SUM、GROUP BY、CASE WHEN
Sample：
ClassId		ClassName				CNT2016		CNT2017		CNT2018		CNT2019
ATCD		公司內部各項活動光碟	7			8			8			0
BK			Banking					19			28			28			5
CCS			客戶案例分享			0			0			1			0
CHA			大陸相關書籍			2			3			3			0
DB			Database				25			20			15			2

*/

/*
**Answers**

SELECT A.*, B.Cnt FROM(
		SELECT DISTINCT BC.BOOK_CLASS_ID AS ClassId, BC.BOOK_CLASS_NAME AS ClassName, 
			COUNT( YEAR(BLR.LEND_DATE) ) AS Cnt
		FROM BOOK_DATA AS BD
			RIGHT JOIN BOOK_LEND_RECORD AS BLR ON BLR.BOOK_ID = BD.BOOK_ID
			RIGHT JOIN BOOK_CLASS AS BC ON BD.BOOK_CLASS_ID = BC.BOOK_CLASS_ID
			WHERE YEAR(BLR.LEND_DATE) = 2016
		GROUP BY BC.BOOK_CLASS_ID, BC.BOOK_CLASS_NAME, YEAR(BLR.LEND_DATE)
	) AS A INNER JOIN (
		SELECT DISTINCT BC.BOOK_CLASS_ID AS ClassId, BC.BOOK_CLASS_NAME AS ClassName, 
			COUNT( YEAR(BLR.LEND_DATE) ) AS Cnt
		FROM BOOK_DATA AS BD
			RIGHT JOIN BOOK_LEND_RECORD AS BLR ON BLR.BOOK_ID = BD.BOOK_ID
			RIGHT JOIN BOOK_CLASS AS BC ON BD.BOOK_CLASS_ID = BC.BOOK_CLASS_ID
			WHERE YEAR(BLR.LEND_DATE) = 2017
		GROUP BY BC.BOOK_CLASS_ID, BC.BOOK_CLASS_NAME, YEAR(BLR.LEND_DATE) 
	) AS B ON A.ClassId = B.ClassId
*/

/*
**Remark**
How to solve the problem of dividing by year
*/

----------------------------------------------------------------------------------------------------

/*
**Questions** - FINISH

6.	請查詢出李四(USER_ID =0002)的借書紀錄，其中包含書本ID、購書日期(yyyy/mm/dd)、
	借閱日期(yyyy/mm/dd)、書籍類別(id-name)、借閱人(id-cname(ename))、狀態(id-name)、購書金額
Table：BOOK_DATA、BOOK_LEND_RECORD、BOOK_CLASS、BOOK_CODE
Hint：注意格式、轉型(FORMAT或CONVERT…等)
Sample：
書本ID	購書日期	借閱日期	書籍類別					借閱人				狀態		購書金額
2290	2011/2/8	2016/04/04	LG-Languages				0002-李四(Bill)		B-已借出	11,450元
2152	2007/5/20	2017/04/11	SECD-研討會/產品介紹光碟	0002-李四(Bill)		B-已借出	10,760元
2054	2007/7/26	2017/01/23	MG-Management				0002-李四(Bill)		B-已借出	10,270元
2040	2007/4/23	2017/06/15	OT-Others					0002-李四(Bill)		B-已借出	10,200元
1985	2009/4/30	2017/06/12	TRCD-內部訓練課程光碟		0002-李四(Bill)		B-已借出	9,925元

*/

/*
**Answers**

SELECT
	BLR.BOOK_ID AS 書本ID, 
	CONVERT(char(10), BD.BOOK_BOUGHT_DATE, 111) AS 購書日期, 
	CONVERT(char(10), BLR.LEND_DATE, 111) AS 借閱日期,
	BClass.BOOK_CLASS_ID + '-' + BClass.BOOK_CLASS_NAME AS 書籍類別,
	MEM.USER_ID + '-' + MEM.USER_CNAME + '(' + MEM.USER_ENAME + ')' AS 借閱人,
	CASE BD.BOOK_STATUS 
		WHEN 'A' THEN 'A' 
		WHEN 'B' THEN 'B-已借出'
		WHEN 'U' THEN 'U-不可借出'
	END AS 狀態,
	FORMAT(BD.BOOK_AMOUNT, '###,###,###') + '元' AS 購書金額
FROM BOOK_LEND_RECORD AS BLR
		INNER JOIN BOOK_DATA AS BD ON BLR.BOOK_ID = BD.BOOK_ID
		INNER JOIN MEMBER_M AS MEM ON BLR.KEEPER_ID = MEM.USER_ID
	    INNER JOIN BOOK_CLASS AS BClass ON BD.BOOK_CLASS_ID = BClass.BOOK_CLASS_ID
WHERE MEM.USER_ID = 0002
ORDER BY BLR.BOOK_ID DESC;

SELECT *
FROM BOOK_CODE
*/
----------------------------------------------------------------------------------------------------

/*
**Questions** - FINISH

7.	新增一筆借閱紀錄，借書人為李四，書本ID為2294，借閱日期為2021/01/01，並更新書籍主檔的狀態為已借出且借閱人為李四
Table：BOOK_LEND_RECORD、BOOK_DATA、BOOK_CODE
Sample：
書本ID	購書日期	借閱日期	書籍類別					借閱人				狀態		購書金額
2290	2011/2/8	2019/01/02	LG-Languages				0002-李四(Bill)		B-已借出	11,450元
2152	2007/5/20	2019/01/02	SECD-研討會/產品介紹光碟	0002-李四(Bill)		B-已借出	10,760元
2054	2007/7/26	2019/01/02	MG-Management				0002-李四(Bill)		B-已借出	10,270元
2040	2007/4/23	2019/01/02	OT-Others					0002-李四(Bill)		B-已借出	10,200元
1985	2009/4/30	2019/01/02	TRCD-內部訓練課程光碟		0002-李四(Bill)		B-已借出	9,925元
2294	2008/3/21	2021/01/01	TRCD-內部訓練課程光碟		0002-李四(Bill)		B-已借出	11,470元

*/

/*
**Answers**

INSERT INTO BOOK_LEND_RECORD(BOOK_ID, LEND_DATE, KEEPER_ID) VALUES(2294, '2021/01/01', '0002');
UPDATE BOOK_DATA
   SET BOOK_STATUS = 'B'

SELECT *
FROM BOOK_LEND_RECORD
*/

/*
SELECT
	BLR.BOOK_ID AS 書本ID, 
	CONVERT(char(10), BD.BOOK_BOUGHT_DATE, 111) AS 購書日期, 
	CONVERT(char(10), BLR.LEND_DATE, 111) AS 借閱日期,
	BClass.BOOK_CLASS_ID + '-' + BClass.BOOK_CLASS_NAME AS 書籍類別,
	MEM.USER_ID + '-' + MEM.USER_CNAME + '(' + MEM.USER_ENAME + ')' AS 借閱人,
	CASE BD.BOOK_STATUS 
		WHEN 'A' THEN 'A-可以借出'
		WHEN 'B' THEN 'B-已借出'
		WHEN 'U' THEN 'U-不可借出'
	END AS 狀態,
	FORMAT(BD.BOOK_AMOUNT, '###,###,###') + '元' AS 購書金額
FROM BOOK_LEND_RECORD AS BLR
		INNER JOIN BOOK_DATA AS BD ON BLR.BOOK_ID = BD.BOOK_ID
		INNER JOIN MEMBER_M AS MEM ON BLR.KEEPER_ID = MEM.USER_ID
	    INNER JOIN BOOK_CLASS AS BClass ON BD.BOOK_CLASS_ID = BClass.BOOK_CLASS_ID
WHERE MEM.USER_ID = 0002
ORDER BY BLR.BOOK_ID DESC;
*/

/*
DELETE FROM BOOK_LEND_RECORD
WHERE BOOK_ID = 2294;
*/

/*
**Remark**

SELECT * 
FROM BOOK_LEND_RECORD AS BLR
	INNER JOIN BOOK_DATA AS BD ON BLR.BOOK_ID = BD.BOOK_ID
	INNER JOIN MEMBER_M AS MEM ON BLR.KEEPER_ID = MEM.USER_ID
ORDER BY BLR.BOOK_ID DESC;
*/
----------------------------------------------------------------------------------------------------

/*
**Questions** - FINISH

8.	請將題7新增的借閱紀錄(書本ID=2294)刪除
Sample：
書本ID	購書日期	借閱日期	書籍類別					借閱人				狀態		購書金額
2290	2011/2/8	2019/01/02	LG-Languages				0002-李四(Bill)		B-已借出	11,450元
2152	2007/5/20	2019/01/02	SECD-研討會/產品介紹光碟	0002-李四(Bill)		B-已借出	10,760元
2054	2007/7/26	2019/01/02	MG-Management				0002-李四(Bill)		B-已借出	10,270元
2040	2007/4/23	2019/01/02	OT-Others					0002-李四(Bill)		B-已借出	10,200元
1985	2009/4/30	2019/01/02	TRCD-內部訓練課程光碟		0002-李四(Bill)		B-已借出	9,925元

*/

/*
**Answers**

DELETE FROM BOOK_LEND_RECORD WHERE BOOK_ID = 2294;
*/

----------------------------------------------------------------------------------------------------