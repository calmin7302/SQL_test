/*****************************************************************************************
# 트랜잭션(TRANSACTION)
트랜잭션(TRANSACTION) : DBMS에서 데이터를 다루는 논리적인 작업의 단위
<트랜잭션의 정상 종료>
COMMIT : 작업내용을 DB에 반영하고 트랜잭션 종료
<트랜잭션 일부 또는 전체 무효화>
ROLLBACK : 최종 COMMIT/ROLLBACK 시점부터 모든 작업 취소
ROLLBACK TO 세이브포인트 이름 : 세이브포인트 위치까지의 작업 취소 

<세이브 포인트 설정>
SAVEPOINT 세이브포인트이름;
*****************************************************************************************/
SELECT * FROM DEPT;
----------------------------------------------------------------------------------------
CREATE TABLE T_DEPT
AS SELECT * FROM DEPT;
----------------------------------------------------------------------------------------
SELECT * FROM T_DEPT;
----------------------------------------------------------------------------------------
INSERT INTO T_DEPT VALUES ('40', '인사부');
COMMIT;
----------------------------------------------------------------------------------------
-- 테이블에서 ID : 40 삭제
DELETE FROM T_DEPT WHERE ID = '40';
SELECT * FROM T_DEPT;

-- 세이브 포인트 설정 : S1
SAVEPOINT S1;

-- 테이블에서 ID : 30 삭제
DELETE FROM T_DEPT WHERE ID = '30';
SELECT * FROM T_DEPT;

-- 세이브 포인트 설정 : S2
SAVEPOINT S2;

-- 테이블에서 ID : 20 삭제
DELETE FROM T_DEPT WHERE ID = '20';
SELECT * FROM T_DEPT;
----------------------------------------------------------------------------------------
-- 트랜잭션 되돌리기(ROLLBACK)
ROLLBACK; -- 최종COMMIT 시점까지 되돌리기
SELECT * FROM T_DEPT; -- 10

ROLLBACK TO S2;
SELECT * FROM T_DEPT; -- 10, 20

ROLLBACK TO S1;
SELECT * FROM T_DEPT; -- 10, 20, 30

ROLLBACK;
SELECT * FROM T_DEPT; -- 10, 20, 30, 40














