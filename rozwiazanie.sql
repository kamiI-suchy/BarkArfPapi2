-- ============================================================
-- ROZWIĄZANIE - Zastosowanie SQL (2) (LibreOffice / OpenOffice Base)
-- Silnik: HSQLDB (wbudowany)
-- Uwagi:
--   - literały dat: {d 'YYYY-MM-DD'}
--   - nazwy UPPER CASE (Base automatycznie konwertuje)
--   - YEAR() → EXTRACT(YEAR FROM ...)
--   - różnica dat: (END_DATE - START_DATE) → liczba dni
-- ============================================================


-- ============================================================
-- ZADANIE 1: Adresy wszystkich lokalizacji wraz z pełną nazwą kraju
-- ============================================================

SELECT L.STREET_ADDRESS, L.POSTAL_CODE, L.CITY, L.STATE_PROVINCE,
       C.COUNTRY_NAME
FROM LOCATIONS L
JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID;


-- ============================================================
-- ZADANIE 2: Imiona i nazwiska pracowników oraz ID i nazwy
--            działów do nich przypisanych
-- ============================================================

SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;


-- ============================================================
-- ZADANIE 3: Imiona i nazwiska pracowników pracujących w Londynie
--            wraz z ID pracy oraz ID i nazwami departamentów
-- ============================================================

SELECT E.FIRST_NAME, E.LAST_NAME, E.JOB_ID,
       D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE L.CITY = 'London';


-- ============================================================
-- ZADANIE 4: ID oraz nazwisko pracownika razem z ID i nazwiskiem
--            jego kierownika (managera)
-- ============================================================

SELECT E.EMPLOYEE_ID, E.LAST_NAME,
       M.EMPLOYEE_ID AS MANAGER_ID, M.LAST_NAME AS MANAGER_LAST_NAME
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;


-- ============================================================
-- ZADANIE 5: Imiona, nazwiska oraz daty zatrudnienia pracowników,
--            którzy zatrudnili się później niż pracownik o nazwisku Jones
-- ============================================================

SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE > (SELECT MAX(HIRE_DATE) FROM EMPLOYEES WHERE LAST_NAME = 'Jones');


-- ============================================================
-- ZADANIE 6: Nazwy działów oraz liczba pracowników danego działu
-- ============================================================

SELECT D.DEPARTMENT_NAME, COUNT(E.EMPLOYEE_ID) AS LICZBA_PRACOWNIKOW
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;


-- ============================================================
-- ZADANIE 7: ID pracownika, nazwa stanowiska, liczba przepracowanych
--            dni dla różnych stanowisk w dziale o ID = 90
-- ============================================================

SELECT JH.EMPLOYEE_ID, J.JOB_TITLE,
       (JH.END_DATE - JH.START_DATE) AS DNI_PRZEPRACOWANE
FROM JOB_HISTORY JH
JOIN JOBS J ON JH.JOB_ID = J.JOB_ID
JOIN EMPLOYEES E ON JH.EMPLOYEE_ID = E.EMPLOYEE_ID
WHERE E.DEPARTMENT_ID = 90;


-- ============================================================
-- ZADANIE 8: ID oraz nazwa działu wraz z ID i imionami
--            przypisanych kierowników
-- ============================================================

SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME,
       E.EMPLOYEE_ID, E.FIRST_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID;


-- ============================================================
-- ZADANIE 9: Nazwy działów, imiona kierowników oraz nazwy miast
-- ============================================================

SELECT D.DEPARTMENT_NAME, E.FIRST_NAME, L.CITY
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID;


-- ============================================================
-- ZADANIE 10: Nazwy stanowisk pracy oraz średnie zarobki
--             przypisanych do nich pracowników
-- ============================================================

SELECT J.JOB_TITLE, AVG(E.SALARY) AS SREDNIE_ZAROBKI
FROM JOBS J
LEFT JOIN EMPLOYEES E ON J.JOB_ID = E.JOB_ID
GROUP BY J.JOB_TITLE;


-- ============================================================
-- ZADANIE 11: Nazwa stanowiska, imię i nazwisko pracownika
--             oraz różnica między MIN_SALARY a MAX_SALARY
-- ============================================================

SELECT J.JOB_TITLE, E.FIRST_NAME, E.LAST_NAME,
       (J.MAX_SALARY - J.MIN_SALARY) AS ROZNICA_ZAROBKOW
FROM EMPLOYEES E
JOIN JOBS J ON E.JOB_ID = J.JOB_ID;


-- ============================================================
-- ZADANIE 12: Historia zatrudnienia pracowników o zarobkach > 10000
-- ============================================================

SELECT JH.EMPLOYEE_ID, JH.START_DATE, JH.END_DATE,
       JH.JOB_ID, JH.DEPARTMENT_ID
FROM JOB_HISTORY JH
JOIN EMPLOYEES E ON JH.EMPLOYEE_ID = E.EMPLOYEE_ID
WHERE E.SALARY > 10000;


-- ============================================================
-- ZADANIE 13: Imiona, nazwiska, daty zatrudnienia oraz zarobki
--             kierowników (szefów działów), którzy przepracowali
--             więcej niż 15 lat
-- ============================================================

SELECT E.FIRST_NAME, E.LAST_NAME, E.HIRE_DATE, E.SALARY
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.EMPLOYEE_ID = D.MANAGER_ID
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM E.HIRE_DATE) > 15;
