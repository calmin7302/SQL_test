/* ** 실습문제 : HR유저(DB)에서 요구사항 해결 **********
--1) 사번(employee_id)이 100인 직원 정보 전체 보기
--2) 월급(salary)이 15000 이상인 직원의 모든 정보 보기
--3) 월급이 15000 이상인 사원의 사번, 이름(LAST_NAME), 입사일(hire_date), 월급여 정보 보기
--4) 월급이 10000 이하인 사원의 사번, 이름(LAST_NAME), 입사일, 월급여 정보 보기
---- (급여가 많은 사람부터)
--5) 이름(first_name)이 john인 사원의 모든 정보 조회
--6) 이름(first_name)이 john인 사원은 몇 명인가?
--7) 2008년에 입사한 사원의 사번, 성명('first_name last_name'), 월급여 정보 조회
---- 성명 출력예) 'Steven King'
--8) 월급여가 20000~30000 구간인 직원 사번, 성명(last_name first_name), 월급여 정보 조회
--9) 관리자ID(MANAGER_ID)가 없는 사람 정보 조회
--10) 직종(job_id)코드 'IT_PROG'에서 가장 많은 월급여는 얼마
--11) 직종별 최대 월급여 검색
--12) 직종별 최대 월급여 검색하고, 최대 월급여가 10000이상인 직종 조회
--13) 직종별 평균급여 이상인 직원 조회
**********************************************************/
--1) 사번(employee_id)이 100인 직원 정보 전체 보기
SELECT * 
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 100
;
--2) 월급(salary)이 15000 이상인 직원의 모든 정보 보기
SELECT * 
FROM EMPLOYEES
WHERE SALARY >= 15000
ORDER BY SALARY
;
--3) 월급이 15000 이상인 사원의 사번, 이름(LAST_NAME), 입사일(hire_date), 월급여 정보 보기
SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE, SALARY 
FROM EMPLOYEES
WHERE SALARY >= 15000
ORDER BY SALARY DESC
;
--4) 월급이 10000 이하인 사원의 사번, 이름(LAST_NAME), 입사일, 월급여 정보 보기
---- (급여가 많은 사람부터)
SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE, SALARY 
FROM EMPLOYEES
WHERE SALARY <= 10000
ORDER BY SALARY DESC
;
--5) 이름(first_name)이 john인 사원의 모든 정보 조회
SELECT * FROM EMPLOYEES
WHERE FIRST_NAME = INITCAP('john') --데이터가 표준화 되어있는 경우
;
SELECT * FROM EMPLOYEES
WHERE LOWER(FIRST_NAME) = LOWER('JOHN') --데이터가 표준화가 안되어 있는 경우
;
SELECT FIRST_NAME, LOWER(FIRST_NAME), UPPER(FIRST_NAME), INITCAP(UPPER(FIRST_NAME))
FROM EMPLOYEES
;
--6) 이름(first_name)이 john인 사원은 몇 명인가?
SELECT COUNT(*) 
FROM EMPLOYEES
WHERE FIRST_NAME = INITCAP('john') --데이터가 표준화 되어있는 경우
;
--7) 2008년에 입사한 사원의 사번, 성명('first_name last_name'), 월급여 정보 조회
---- 성명 출력예) 'Steven King'
SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME AS NAME, SALARY, HIRE_DATE 
FROM EMPLOYEES
WHERE HIRE_DATE BETWEEN TO_DATE('2008-01-01', 'YYYY-MM-DD')
                    AND TO_DATE('2008/12/31', 'YYYY/MM/DD')
ORDER BY HIRE_DATE
;
SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME AS NAME, SALARY
     , HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY')
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY') = '2008'
ORDER BY HIRE_DATE
;
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD HH24:MI:SS') FROM EMPLOYEES;
SELECT TO_DATE('2008-01-01', 'YYYY-MM-DD')
     , TO_DATE('2008/12/31', 'YYYY/MM/DD')
FROM DUAL
;
--8) 월급여가 20000~30000 구간인 직원 사번, 성명(last_name first_name), 월급여 정보 조회
SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME AS NAME, SALARY
FROM EMPLOYEES
WHERE SALARY BETWEEN 20000 AND 30000
;
--9) 관리자ID(MANAGER_ID)가 없는 사람 정보 조회
SELECT * FROM EMPLOYEES WHERE MANAGER_ID IS NULL; --NULL 인 사람
SELECT * FROM EMPLOYEES WHERE MANAGER_ID IS NOT NULL; --MANAGER 있는 사람

--10) 직종(job_id)코드 'IT_PROG'에서 가장 많은 월급여는 얼마
SELECT MAX(SALARY)
FROM EMPLOYEES
WHERE JOB_ID = 'IT_PROG'
;
--11) 직종별 최대 월급여 검색
SELECT JOB_ID, MAX(SALARY)
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY MAX(SALARY) DESC
;
--12) 직종별 최대 월급여 검색하고, 최대 월급여가 10000이상인 직종 조회
SELECT JOB_ID, MAX(SALARY)
FROM EMPLOYEES
GROUP BY JOB_ID
HAVING MAX(SALARY) >= 10000
ORDER BY MAX(SALARY) DESC
;
--13) 직종별 평균급여 이상인 직원 조회
SELECT AVG(SALARY) FROM EMPLOYEES; --전직원평균급여: 6461
SELECT AVG(SALARY) FROM EMPLOYEES
WHERE JOB_ID = 'IT_PROG'
;
SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME AS NAME, JOB_ID, SALARY
     , (SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = E.JOB_ID) AVG_SALARY
--SELECT *
FROM EMPLOYEES E
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = E.JOB_ID)
ORDER BY JOB_ID, SALARY
;
--직종별 평균 급여
SELECT JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY JOB_ID
;
--EMPLOYEES, 직종별평균급여 조인 처리
SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME AS NAME, E.JOB_ID, SALARY
     , A.AVG_SALARY
FROM EMPLOYEES E,
     (SELECT JOB_ID, AVG(SALARY) AS AVG_SALARY
      FROM EMPLOYEES
      GROUP BY JOB_ID) A
WHERE E.JOB_ID = A.JOB_ID
  AND E.SALARY >= A.AVG_SALARY
;







