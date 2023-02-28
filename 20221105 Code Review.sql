USE GSSWEB
GO

/*
**Questions** - FINISH

1.	�ЦC�X�C�ӨϥΪ̨C�~�ɮѼƶq�A�ę̀ϥΪ̽s���M�~�װ��Ƨ�
Table�GMEMBER_M�BBOOK_LEND_RECORD
Hint�GINNER / LEFT / RIGHT JOIN�BORDER BY�BCOUNT
Sample�G
KeeperId	CName	EName	BorrowYear	BorrowCnt
0001	    �i�T	Andy	2016		12
0001	    �i�T	Andy	2017		10
0001		�i�T	Andy	2018		8
0002		���|	Bill	2016		19
0002		���|	Bill	2017		19
0002		���|	Bill	2018		12
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

**Questions** - FINISH EXCEPT [PS�Y���ƶq�ۦP�A�i�H���B�z?]

2.	�C�X�̨��w�諸�ѫe���W(�ɾ\�ƶq�̦h�e���W [PS�Y���ƶq�ۦP�A�i�H���B�z?]) 

Table�GBOOK_LEND_RECORD
Hint�GTOP �� RANK
Sample�G
BookId	BookName									QTY
2258	2010.10.18 �^��A�Z							13
1865	����޲��~�H�O�귽�޲z						10
1984	WRITING SECURE CODE							9
1397	ASP.NET 4.0�����J��--�ϥ�VB					8
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

3.	�H�@�u�C�X2019�~�C�@�u���y�ɾ\�Ѷq

 (*�i���G�Ҽ{���ӻݨD�վ��{�����ܰʴT�סA��ĳ�ϥ�SPAN_TABLE)
Table�GBOOK_LEND_RECORD
Hint�GCASE WHEN
Sample�G
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

4.	���X�C�Ӥ����ɾ\�ƶq�e�T�W�ѥ��μƶq

Table�GBOOK_LEND_RECORD�BBOOK_CLASS�BBOOK_DATA
Hint�GPARTITION BY�BROW_NUMBER �� RANK�B�l�d��
Sample�G
Seq	BookClass	BookId	BookName								Cnt
1	Banking		411		�H�έ��Iĳ�D�P��T���x�W��#2			3
2	Banking		1980	�}�x���ĸ�T�P��I���Τj����&#9313;		3
3	Banking		130		�ڰ�Ȧ��I�Ȥ�O�Q����R����s		2
1	Database	1984	WRITING SECURE CODE						9
2	Database	504		��qSQL Server 7.0��Ʈw�t��			2
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

5.	�ЦC�X 2016, 2017, 2018, 2019 �U���y���O���ɾ\�ƶq���
Table�GBOOK_LEND_RECORD
Hint�GCOUNT��SUM�BGROUP BY�BCASE WHEN
Sample�G
ClassId		ClassName				CNT2016		CNT2017		CNT2018		CNT2019
ATCD		���q�����U�����ʥ���	7			8			8			0
BK			Banking					19			28			28			5
CCS			�Ȥ�רҤ���			0			0			1			0
CHA			�j���������y			2			3			3			0
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

6.	�Ьd�ߥX���|(USER_ID =0002)���ɮѬ����A�䤤�]�t�ѥ�ID�B�ʮѤ��(yyyy/mm/dd)�B
	�ɾ\���(yyyy/mm/dd)�B���y���O(id-name)�B�ɾ\�H(id-cname(ename))�B���A(id-name)�B�ʮѪ��B
Table�GBOOK_DATA�BBOOK_LEND_RECORD�BBOOK_CLASS�BBOOK_CODE
Hint�G�`�N�榡�B�૬(FORMAT��CONVERT�K��)
Sample�G
�ѥ�ID	�ʮѤ��	�ɾ\���	���y���O					�ɾ\�H				���A		�ʮѪ��B
2290	2011/2/8	2016/04/04	LG-Languages				0002-���|(Bill)		B-�w�ɥX	11,450��
2152	2007/5/20	2017/04/11	SECD-��Q�|/���~���Х���	0002-���|(Bill)		B-�w�ɥX	10,760��
2054	2007/7/26	2017/01/23	MG-Management				0002-���|(Bill)		B-�w�ɥX	10,270��
2040	2007/4/23	2017/06/15	OT-Others					0002-���|(Bill)		B-�w�ɥX	10,200��
1985	2009/4/30	2017/06/12	TRCD-�����V�m�ҵ{����		0002-���|(Bill)		B-�w�ɥX	9,925��

*/

/*
**Answers**

SELECT
	BLR.BOOK_ID AS �ѥ�ID, 
	CONVERT(char(10), BD.BOOK_BOUGHT_DATE, 111) AS �ʮѤ��, 
	CONVERT(char(10), BLR.LEND_DATE, 111) AS �ɾ\���,
	BClass.BOOK_CLASS_ID + '-' + BClass.BOOK_CLASS_NAME AS ���y���O,
	MEM.USER_ID + '-' + MEM.USER_CNAME + '(' + MEM.USER_ENAME + ')' AS �ɾ\�H,
	CASE BD.BOOK_STATUS 
		WHEN 'A' THEN 'A' 
		WHEN 'B' THEN 'B-�w�ɥX'
		WHEN 'U' THEN 'U-���i�ɥX'
	END AS ���A,
	FORMAT(BD.BOOK_AMOUNT, '###,###,###') + '��' AS �ʮѪ��B
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

7.	�s�W�@���ɾ\�����A�ɮѤH�����|�A�ѥ�ID��2294�A�ɾ\�����2021/01/01�A�ç�s���y�D�ɪ����A���w�ɥX�B�ɾ\�H�����|
Table�GBOOK_LEND_RECORD�BBOOK_DATA�BBOOK_CODE
Sample�G
�ѥ�ID	�ʮѤ��	�ɾ\���	���y���O					�ɾ\�H				���A		�ʮѪ��B
2290	2011/2/8	2019/01/02	LG-Languages				0002-���|(Bill)		B-�w�ɥX	11,450��
2152	2007/5/20	2019/01/02	SECD-��Q�|/���~���Х���	0002-���|(Bill)		B-�w�ɥX	10,760��
2054	2007/7/26	2019/01/02	MG-Management				0002-���|(Bill)		B-�w�ɥX	10,270��
2040	2007/4/23	2019/01/02	OT-Others					0002-���|(Bill)		B-�w�ɥX	10,200��
1985	2009/4/30	2019/01/02	TRCD-�����V�m�ҵ{����		0002-���|(Bill)		B-�w�ɥX	9,925��
2294	2008/3/21	2021/01/01	TRCD-�����V�m�ҵ{����		0002-���|(Bill)		B-�w�ɥX	11,470��

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
	BLR.BOOK_ID AS �ѥ�ID, 
	CONVERT(char(10), BD.BOOK_BOUGHT_DATE, 111) AS �ʮѤ��, 
	CONVERT(char(10), BLR.LEND_DATE, 111) AS �ɾ\���,
	BClass.BOOK_CLASS_ID + '-' + BClass.BOOK_CLASS_NAME AS ���y���O,
	MEM.USER_ID + '-' + MEM.USER_CNAME + '(' + MEM.USER_ENAME + ')' AS �ɾ\�H,
	CASE BD.BOOK_STATUS 
		WHEN 'A' THEN 'A-�i�H�ɥX'
		WHEN 'B' THEN 'B-�w�ɥX'
		WHEN 'U' THEN 'U-���i�ɥX'
	END AS ���A,
	FORMAT(BD.BOOK_AMOUNT, '###,###,###') + '��' AS �ʮѪ��B
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

8.	�бN�D7�s�W���ɾ\����(�ѥ�ID=2294)�R��
Sample�G
�ѥ�ID	�ʮѤ��	�ɾ\���	���y���O					�ɾ\�H				���A		�ʮѪ��B
2290	2011/2/8	2019/01/02	LG-Languages				0002-���|(Bill)		B-�w�ɥX	11,450��
2152	2007/5/20	2019/01/02	SECD-��Q�|/���~���Х���	0002-���|(Bill)		B-�w�ɥX	10,760��
2054	2007/7/26	2019/01/02	MG-Management				0002-���|(Bill)		B-�w�ɥX	10,270��
2040	2007/4/23	2019/01/02	OT-Others					0002-���|(Bill)		B-�w�ɥX	10,200��
1985	2009/4/30	2019/01/02	TRCD-�����V�m�ҵ{����		0002-���|(Bill)		B-�w�ɥX	9,925��

*/

/*
**Answers**

DELETE FROM BOOK_LEND_RECORD WHERE BOOK_ID = 2294;
*/

----------------------------------------------------------------------------------------------------