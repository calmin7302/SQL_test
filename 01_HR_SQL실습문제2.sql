/* ***** HR DB 데이터 조회 실습 *****************
■1 HR 부서에서 예산 편성 문제로 급여 정보 보고서를 작성하려고 한다. 
  사원정보(Employees) 테이블에서 급여가 $7,000~$10,000 범위 이외인 사람의 
  이름과 성(Name으로 별칭) 및 급여를 급여가 적은 순서로 출력하시오
*/
SELECT EMPLOYEE_ID, FIRST_NAME ||' '|| LAST_NAME AS NAME, SALARY
FROM EMPLOYEES
WHERE SALARY < 7000 OR SALARY > 10000
ORDER BY SALARY
;
SELECT EMPLOYEE_ID, FIRST_NAME ||' '|| LAST_NAME AS NAME, SALARY
FROM EMPLOYEES
WHERE SALARY NOT BETWEEN 7000 AND 10000
ORDER BY SALARY
;
/*
■2 HR 부서에서는 급여(salary)와 수당율(commission_pct)에 대한 지출 보고서를 작성하려고 한다. 
  수당을 받는 모든 사원의 이름과 성(Name으로 별칭), 급여, 업무, 수당율을 출력하시오. 
  이때 급여가 큰 순서대로 정렬하되, 급여가 같으면 수당율이 큰 순서대로 정렬하시오
*/
SELECT EMPLOYEE_ID, FIRST_NAME ||' '|| LAST_NAME AS NAME, 
       SALARY, JOB_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE commission_pct IS NOT NULL
ORDER BY commission_pct DESC
;
/*  
■3 이번 분기에 60번 IT 부서에서는 신규 프로그램을 개발하고 보급하여 회사에 공헌하였다. 
  이에 해당 부서의 사원 급여를 12.3% 인상하기로 하였다. 
  60번 IT 부서 사원의 급여를 12.3% 인상하여 정수만(반올림) 표시하는 보고서를 작성하시오. 
  보고서는 사원번호, 성과 이름(Name으로 별칭), 급여, 인상된 급여(Increase Salary로 별칭)순으로 출력하시오
*/  
SELECT EMPLOYEE_ID, FIRST_NAME ||' '|| LAST_NAME AS NAME, 
       SALARY,
       ROUND(SALARY * 0.123) AS "순수인상금액",
       SALARY + ROUND(SALARY * 0.123) AS "Increase Salary",
       ROUND(SALARY * 1.123) AS "Increase Salary2"
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 60
;
/*
■4 각 사원의 성(last_name)이 's'로 끝나는 사원의 이름과 업무를 아래의 예와 같이 출력하고자 한다. 
  출력 시 이름(first_name)과 성(last_name)은 첫 글자가 대문자, 업무는 모두 대문자로 출력하고 
  머리글(조회컬럼명)은 Employee JOBs.로 표시하시오
  예) FIRST_NAME  LAST_NAME  Employee JOBs.
      Shelley     Higgins    AC_MGR
*/
SELECT FIRST_NAME, LAST_NAME, JOB_ID
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%s';
-----
SELECT INITCAP(FIRST_NAME) AS FIRST_NAME, INITCAP(LAST_NAME) LAST_NAME
     , UPPER(JOB_ID) AS "Employee JOBs."
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%s'
;
/*
■5 모든 사원의 연봉을 표시하는 보고서를 작성하려고 한다. 
  보고서에 사원의 이름과 성(Name으로 별칭), 급여, 수당여부에 따른 연봉을 포함하여 출력하시오. 
  수당여부는 수당이 있으면 "Salary + Commission", 수당이 없으면 "Salary only"라고 표시하고, 
  별칭은 적절히 붙이시오. 또한 출력 시 연봉이 높은 순으로 정렬하시오
*/
SELECT EMPLOYEE_ID, FIRST_NAME ||' '|| LAST_NAME AS NAME, SALARY, COMMISSION_PCT
     , DECODE(COMMISSION_PCT, NULL, 'Salary only', 'Salary + Commission')
       AS COMMISSION_YN
     , SALARY * (1 + NVL(COMMISSION_PCT,0)) * 12 AS SALARY12
FROM EMPLOYEES
--ORDER BY 6 DESC --컬럼 위치값 사용해서 정렬
ORDER BY SALARY12 DESC;
-------
SELECT EMPLOYEE_ID, FIRST_NAME ||' '|| LAST_NAME AS NAME, SALARY, COMMISSION_PCT
     , CASE WHEN COMMISSION_PCT IS NULL
            THEN 'Salary only'
            ELSE 'Salary + Commission'
       END AS COMMISSION_YN
     , SALARY * (1 + NVL(COMMISSION_PCT,0)) * 12 AS SALARY12
FROM EMPLOYEES
--ORDER BY 6 DESC --컬럼 위치값 사용해서 정렬
ORDER BY SALARY12 DESC
;
/*
■6 각 사원이 소속된 부서별로 급여 합계, 급여 평균, 급여 최댓값, 급여 최솟값을 집계하고자 한다. 
  계산된 출력값은 여섯 자리와 세 자리 구분기호, $표시와 함께 출력($123,456) 
  단, 부서에 소속되지 않은 사원에 대한 정보는 제외하고, 출력 시 머리글은 별칭(alias) 처리하시오
*/  
SELECT DEPARTMENT_ID
     , COUNT(*) AS CNT
     , TO_CHAR(SUM(SALARY), '$999,999') AS SUM_SALARY
     , TO_CHAR(AVG(SALARY), '$999,999') AS AVG_SALARY
     , TO_CHAR(MAX(SALARY), '$000,000') AS MAX_SALARY
     , TO_CHAR(MIN(SALARY), '$000,000') AS MIN_SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID
ORDER BY 3 DESC
;
/*
■7 사원들의 업무별 전체 급여 평균이 $10,000보다 큰 경우를 조회하여 
    업무별 급여 평균을 출력하시오. 
  단 업무에 CLERK이 포함된 경우는 제외하고 전체 급여 평균이 높은 순서대로 출력하시오
*/
SELECT DISTINCT JOB_ID
FROM EMPLOYEES
;



/*
■8 HR 스키마에 존재하는 Employees, Departments, Locations 테이블의 구조를 파악한 후 
  Oxford에 근무하는 사원의 이름과 성(Name으로 별칭), 업무, 부서이름, 도시이름을 출력하시오. 
  이때 첫 번째 열은 회사이름인 'HR-Company'이라는 상수값이 출력되도록 하시오
*/



/*
■9 HR 스키마에 있는 Employees, Departments 테이블의 구조를 파악한 후 
  사원수가 다섯 명 이상인 부서의 부서이름과 사원 수를 출력하시오. 
  이때 사원 수가 많은 순으로 정렬하시오
*/



/*
■10 각 사원의 급여에 따른 급여 등급을 보고하려고 한다. 
  급여 등급은 Job_Grades 테이블에 표시된다. 해당 테이블의 구조를 살펴본 후 
  사원의 이름과 성(Name으로 별칭), 업무, 부서이름, 입사일, 급여, 급여등급을 출력하시오.
  
CREATE TABLE JOB_GRADES (
    GRADE_LEVEL VARCHAR2(3),
    LOWEST_SAL NUMBER,
    HIGHEST_SAL NUMBER
);
INSERT INTO JOB_GRADES VALUES ('A', 1000, 2999);
INSERT INTO JOB_GRADES VALUES ('B', 3000, 5999);
INSERT INTO JOB_GRADES VALUES ('C', 6000, 9999);
INSERT INTO JOB_GRADES VALUES ('D', 10000, 14999);
INSERT INTO JOB_GRADES VALUES ('E', 15000, 24999);
INSERT INTO JOB_GRADES VALUES ('F', 25000, 40000);
COMMIT;
********************************/




