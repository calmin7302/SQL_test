-- 한 줄 주석
/* ***********************************************************
데이터 정의어
- DDL(Data Definition Language) : 데이터를 정의하는 언어
- CREATE(생성), DROP(삭제), ALTER(수정/변경)
------------------------------------------------------------
- {}:반복가능, []:옵션, |:또는(선택)
CREATE TABLE 테이블명  (
     {컬럼명 데이터타입(크기)
         [NOT NULL | UNIQUE | DEFAULT 기본값 | CHECK 체크조건]
     }    
     [PRIMARY KEY 컬럼명]
     {[FOREIGN KEY 컬럼명 REFERENCES 테이블명(컬럼명)]
     [ON DELETE [CASCADE | SET NULL]
     }
);
------------------------------------------------------------
<제약조건 5종류>
- NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
------------------------------------------------------------
컬럼의 기본 데이터 타입(문자열, 숫자, 날짜)
- VARCHAR2(n) : 문자열 가변길이
- CHAR(n) : 문자열 고정길이
- NUMBER(n) : 숫자타입 정수
  NUMBER(p, s) : 숫자타입 p:전체길이, s:소수점이하 자리수
    예)NUMBER(5,2) : 정수부 3자리, 소수부 2자리 - 전체 5자리
-DATE : 날짜형 년,월,일, 시간 값 저장
------------------------------------------------------------
문자열 처리 : UTF-8 형태로 저장
- 숫자, 알파벳, 특수문자 : 1byte 처리(키보드 자판 글자들)
- 한글 : 3byte 처리
  예) 홍길동 -> 9byte 
*********************************************************** */
--DDL 문 사용 테이블 생성
CREATE TABLE MEMBER (
    ID VARCHAR2(20) PRIMARY KEY, -- NOT NULL + UNIQUE
    NAME VARCHAR2(30) NOT NULL, 
    PASSWORD VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(20),
    ADDRESS VARCHAR2(300)
);
-----------------------------------------------------------
--DML : SELECT, INSERT, UPDATE, DELETE
INSERT INTO MEMBER (ID, NAME, PASSWORD)
VALUES ('HONG', '홍길동', '1234');

--DCL 
ROLLBACK; --임시 처리된 작업 취소
COMMIT; --임시 처리된 작업 최종 적용

insert into member (id, name, password)
Values ('HONG2', '홍길동2', '1234');
COMMIT;
-----------------------------------------------------------
-- 중복 오류 : ORA-00001: unique constraint (MYSTUDY.SYS_C006999) violated
insert into member (id, name, password)
Values ('HONG2', '홍길동222', '123456');
-- NOT NULL 컬럼 데이터 미입력 오류
-- ORA-01400: cannot insert NULL into ("MYSTUDY"."MEMBER"."PASSWORD")
insert into member (id, name)
Values ('HONG3', '홍길동3');
-----------------------------------------------------------
-- 오라클에서는 '' 데이터는 NULL로 처리됨
-- ORA-01400: cannot insert NULL into ("MYSTUDY"."MEMBER"."PASSWORD")
insert into member (id, name, password)
Values ('HONG3', '홍길동3', '');
-----------------------------------------------------------
-- HONG2, hong2 서로 다른 데이터
insert into member (id, name, password)
Values ('hong2', '홍길동22', '12345');
COMMIT;
-----------------------------------------------------------
SELECT * FROM MEMBER;
SELECT ID, NAME, PASSWORD FROM MEMBER;
-----------------------------------------------------------
--입력 : 컬럼명을 명시적으로 쓰지 않고 INSERT문 작성
-- 테이블에 있는 모든 컬럼 사용 + 컬럼 순서대로 데이터를 입력
INSERT INTO MEMBER
VALUES ('HONG3', '홍길동3', '1234'); --SQL 오류: ORA-00947: not enough values
-----------------------------------------------------------
INSERT INTO MEMBER
VALUES ('HONG3', '홍길동3', '1234', '010-3333-3333', '서울');
COMMIT;

INSERT INTO MEMBER
VALUES ('HONG4', '홍길동4', '1234', '부산', '010-4444-4444');
COMMIT;
-----------------------------------------------------------
SELECT * FROM MEMBER; 
-- 컬럼을 명시적으로 작성시 해당 컬럼에 일대일 매칭되어 입력됨
INSERT INTO MEMBER (ID, NAME, PASSWORD, ADDRESS, PHONE)
VALUES ('HONG5', '홍길동5', '1234', '대전', '010-5555-5555');
COMMIT;
-----------------------------------------------------------
-- 수정 : HONG4 전화번호 : '010-4444-4444'로 변경
-- 수정 : HONG4 주소 : '서울시'로 변경
UPDATE MEMBER 
SET PHONE = '010-4444-4444', ADDRESS = '서울시'
WHERE ID = 'HONG4'
;
    
UPDATE MEMBER 
    SET PHONE = '010-4444-4444', ADDRESS = '서울시'
    WHERE ID = 'HONG4'
;
COMMIT;
-----------------------------------------------------------
SELECT * FROM MEMBER;
-- 삭제 : HONG3 데이터 삭제
SELECT * FROM MEMBER WHERE ID = 'HONG3';
DELETE FROM MEMBER WHERE ID = 'HONG3';
DELETE FROM MEMBER WHERE ID = 'HONG5';
COMMIT;
-----------------------------------------------------------
SELECT * FROM MEMBER WHERE ID = 'hong2';
UPDATE MEMBER SET NAME = '홍길동' WHERE ID = 'hong2';
COMMIT;

SELECT * FROM MEMBER WHERE NAME = '홍길동';
DELETE FROM MEMBER WHERE NAME = '홍길동';
COMMIT;
-----------------------------------------------------------
/*(실습) 입력, 수정, 삭제, 조회(검색)
입력 : 아이디-HONG8, 이름-홍길동8, 암호-1111, 주소-서울시 강남구
조회(검색) : 이름이 홍길동8인 사람의 아이디, 이름, 주소, 전화번호 조회
수정 : 아이디가 HONG8 사람의
    전화번호 : 010-8888-8888
    암호 : 8888
    주소 : 서울시 강남구 역삼동
삭제 : 아이디가 HONG2인 사람    
* ***********************************************************/
SELECT * FROM MEMBER;

-- 입력 : 아이디-HONG8, 이름-홍길동8, 암호-1111, 주소-서울시 강남구
INSERT INTO MEMBER 
        (ID, NAME, PASSWORD, ADDRESS)
VALUES ('HONG8', '홍길동8', '1111', '서울시 강남구');
COMMIT;

-- 조회(검색) : 이름이 홍길동8인 사람의 아이디, 이름, 주소, 전화번호 조회
SELECT ID, NAME, address, PHONE 
FROM MEMBER
WHERE NAME = '홍길동8';

-- 수정 : 아이디가 HONG8 사람의전화번호 : 010-8888-8888, 암호 : 8888
UPDATE MEMBER 
    SET PHONE = '010-8888-8888',
    PASSWORD = '8888',
    ADDRESS = '서울시 강남구 역삼동'
    WHERE ID = 'HONG8'
;
COMMIT;

-- 삭제 : 아이디가 HONG2인 사람   
SELECT * FROM MEMBER WHERE ID = 'HONG2';
DELETE FROM MEMBER WHERE ID = 'HONG2';
