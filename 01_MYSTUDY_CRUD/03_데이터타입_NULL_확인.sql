/* 컬럼의 기본 데이터 타입(문자열, 숫자, 날짜)
- VARCHAR2(n) : 문자열 가변길이
- CHAR(n) : 문자열 고정길이
- NUMBER(n) : 숫자타입 정수
  NUMBER(p, s) : 숫자타입 p:전체길이, s:소수점이하 자리수
     예)NUMBER(5,2) : 정수부 3자리, 소수부 2자리 - 전체 5자리
- DATE : 날짜형 년,월,일, 시간 값 저장    
-----------------
문자열 처리 : UTF-8 형태로 저장
- 숫자, 알파벳, 특수문자 : 1 byte 처리(키보드 자판 글자들)
- 한글 : 3 byte 처리
  예) 홍길동 -> 9 byte
************************ */
-- 컬럼 특성(데이터 타입)을 확인하기 위한 테이블
CREATE TABLE TEST (
    NUM NUMBER(5, 2), --숫자타입 전체자리수 5, 정수부 3, 소수부 2
    STR1 CHAR(10), --고정길이 문자열
    STR2 VARCHAR2(10), --가변길이 문자열
    DATE1 DATE --날짜데이터 : 년월일시분초
);
SELECT * FROM TEST;
INSERT INTO TEST VALUES (100.454, 'ABC', 'ABC', SYSDATE);
INSERT INTO TEST VALUES (100.455, 'ABC2', 'ABC2', SYSDATE);
INSERT INTO TEST VALUES (100.456, 'ABCDE', 'ABCDE', SYSDATE);
COMMIT;

--ORA-01438: value larger than specified precision allowed for this column
--INSERT INTO TEST VALUES (1234.456, 'ABCDE', 'ABCDE', SYSDATE);

INSERT INTO TEST VALUES (123.456, 'ABCDEEFGHI', 'ABCDEEFGHI', SYSDATE);
COMMIT;
SELECT * FROM TEST;
------
-- 문자열 붙이기 부호(||) 사용
SELECT '-'|| STR1 ||'-', '-'|| STR2 ||'-' FROM TEST;
SELECT STR1, LENGTHB(STR1), STR2, LENGTHB(STR2) FROM TEST;
---------------------
-- CHAR 타입 
SELECT * FROM TEST WHERE STR1 = STR2; --조회된 데이터 10자리 모두 같은데이터
SELECT * FROM TEST WHERE STR1 = 'ABC'; --오라클에서는 조회됨
SELECT * FROM TEST WHERE STR1 = 'ABC       '; --모든 DB에서 조회됨
SELECT * FROM TEST WHERE STR1 = 'ABC  '; --오라클에서는 조회됨
-- VARCHAR2 타입
SELECT * FROM TEST WHERE STR2 = 'ABC';
SELECT * FROM TEST WHERE STR2 = 'ABC       '; --없음
--=============================================================
--숫자타입
SELECT * FROM TEST WHERE NUM = 100.45; --NUMBER VS NUMBER
SELECT * FROM TEST WHERE NUM = '100,45'; --NUMBER VS 문자
SELECT * FROM TEST WHERE NUM = '100.45AAAA'; --ORA-01722: invalid number
----------------------------------------------------------------
--===========================
--날짜 타입 DATE는 내부에 년울일시분초 데이터 저장되어 있음
SELECT * FROM TEST;
SELECT DATE1, TO_CHAR(DATE1, 'YYYY-MM-DD HH24:MI:SS') FROM TEST;
SELECT DATE1, TO_CHAR(DATE1, 'YYYY-MM-DD HH24:MI:SS') FROM TEST;
SELECT DATE1, TO_CHAR(DATE1, 'YYYY-MM-DD HH24:MI:SS') FROM TEST;
--====================================
-- 한글 데이터 처리(UTF-8) : ASCII 코드 1 BYTE, 한글 1글자 3BYTE 사용
INSERT INTO TEST (STR1, STR2) VALUES ('ABCDE67890', 'ABCDE67890');
INSERT INTO TEST (STR1, STR2) VALUES ('1234567890', '홍길동'); --한글 1글자 -> 3BYTE 
--ORA-12899: value too large for column "MYSTUDY"."TEST"."STR2" (actual: 12, maximum: 10)
INSERT INTO TEST (STR1, STR2) VALUES ('1234567890', '대한민국'); --한글 4글자 -> 12 BYTE
SELECT STR1, LENGTHB(STR1), STR2, LENGTHB(STR2) FROM TEST;

--====================================================================
/* NULL의 특성
-- NULL : 데이터가 없는 상태를 의미하는 값
-- NULL과의 연산 결과는 항상 NULL (연산의 의미X)
-- NULL은 비교처리가 안됨 : =,  <> OR != (다르다), >, <, >=, <= //비교 결과 NULL
-- NULL값에 대한 조회(검색)은 IS NULL, IS NOT NULL 키워드로 처리
*********************************************************************/
SELECT * FROM TEST;
SELECT * FROM TEST WHERE NUM = 100.45;
SELECT * FROM TEST WHERE NUM = NULL; -- 조회X (비교연산)
SELECT * FROM TEST WHERE NUM IS NULL; -- IS NULL로 검색

SELECT * FROM TEST WHERE NUM != 100.46;
SELECT * FROM TEST WHERE NUM != NULL; -- 조회X (비교연산)
SELECT * FROM TEST WHERE NUM IS NOT NULL; -- IS NOT NULL
-----------------------------------------------------------------------------
-- NULL과의 연산처리 결과 --> 항상 NULL(연산 의미 없음)
SELECT * FROM DUAL; -- DUAL 테이블 일명 DUMMY 테이블(오라클에서 제공)
SELECT 100 + 200, 111 + 222 FROM DUAL;
SELECT 100 + NULL, 100 - NULL, 100 * NULL, 100 / NULL FROM DUAL;

SELECT * FROM TEST;
SELECT NUM, NUM + 100 FROM TEST;
SELECT NUM, NVL(NUM, 0), NVL(NUM,0) + 100 FROM TEST; --값이 NULL이면 0으로 치환
-----------------------------------------------------------------------------
-- 정렬 시 NULL
SELECT * FROM TEST ORDER BY STR2 ASC; --기본 오름차순 정렬 (ASC 키워드 생략가능)
SELECT * FROM TEST ORDER BY STR2 DESC; -- 기본 내림차순 정렬

-- 정렬시 가장 큰 값으로 처리
-- NULL 값 조회 순서 조정: NULLS FIRST, NULLS LAST 사용
SELECT * FROM TEST ORDER BY NUM; -- NULL 데이터 뒷쪽에 위치
SELECT * FROM TEST ORDER BY NUM NULLS FIRST; --NULL 데이터 앞쪽에 위치

SELECT * FROM TEST ORDER BY NUM DESC; -- NULL 데이터 앞쪽에 위치
SELECT * FROM TEST ORDER BY NUM DESC NULLS LAST; -- NULL 데이터 뒷쪽에 위치

--========================================================================
/* (실습) 테이블(TABLE) 만들기(테이블명 :TEST2)
    NO : 숫자타입 5자리, PRIMARY KEY 선언
    ID : 문자타입 10자리(영문10자리), 값이 반드시 존재(NULL 허용X)
    NAME : 한글 10자리 저장 가능, 값이 반드시 존재
    EMAIL : 영문, 숫자, 특수문자 포함 30자리
    INUM : 숫자타입 정수부 7자리, 소수부 3자리(1234567.123)
    REGDATE : 날짜타입
***********************************************************************/

CREATE TABLE TEST2 (
    NO NUMBER(5) PRIMARY KEY,
    ID VARCHAR2(10) NOT NULL,
    NAME VARCHAR2(30) NOT NULL,
    EMAIL VARCHAR2(30),
    INUM NUMBER(10, 3),
    REGDATE DATE
--  REGDATE DATE DEFAULT SYSDATE
);    

-- DROP TABLE TEST2;
-- ALTER TABLE TEST2 ADD (NAME VARCHAR2 (30) NOT NULL);

INSERT INTO TEST2
       (NO, ID, NAME, EMAIL, INUM, REGDATE)
VALUES ('1', 'A', '김유신', 'yushin@gmail.com', 1234567.123, SYSDATE);
COMMIT;

INSERT INTO TEST2
       (NO, ID, NAME, EMAIL, INUM, REGDATE)
VALUES ('2', 'B', '홍길동', 'gildong@gmail.com', 1234567.124, SYSDATE);
COMMIT;

INSERT INTO TEST2
       (NO, ID, NAME, EMAIL, INUM, REGDATE)
VALUES ('3', 'C', '이순신', 'sunsin@gmail.com', 1234567.125, SYSDATE);
COMMIT;

SELECT * FROM TEST2;
--============================================================================
-- 특정 테이블의 테이블 구조와 데이터를 함꼐 복사
CREATE TABLE TEST3 
AS 
SELECT * FROM TEST2;
------------------------------------------------------------------------------
SELECT * FROM TEST2;
SELECT * FROM TEST3;
--=============================================================================
--특정 테이블의 특정컬럼과 특정 데이터만 복사해서 테이블 생성
CREATE TABLE TEST4
AS
SELECT NO, ID, NAME, EMAIL 
FROM TEST2
WHERE NAME = '홍길동'
;
SELECT * FROM TEST4;
--=============================================================================
-- 특정 테이블의 구조만 복사(데이터는 복사하지 않음)
CREATE TABLE TEST5
AS
SELECT * FROM TEST2 WHERE 1 = 2;
SELECT * FROM TEST5;
--=============================================================================
SELECT * FROM TEST2;
-- 테이블 데이터 전체 삭제
DELETE FROM TEST2 WHERE NAME = '홍길동';
DELETE FROM TEST2; -- 테이블 전체 데이터 삭제
ROLLBACK; -- 취소가능(DELETE 명령 사용시)

-- TRUNCATE 명령문 : 테이블 전체 데이터 삭제(ROLLBACK 복구 안됨)
TRUNCATE TABLE TEST2;
SELECT * FROM TEST2;
--=============================================================================
--ALTER TABLE TEST2 RENAME COLUMN INUM TO NUM;
--ALTER TABLE TEST2 MODIFY (ID VARCHAR2(15 BYTE) );
--ALTER TABLE TEST2 DROP COLUMN REGDATE;





