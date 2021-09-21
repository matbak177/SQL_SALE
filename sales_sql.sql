/* 
1 Złączenie tabel | Union all files about sales
2 Suma sprzedaży i zysku w każdym roku | The sum of sales and profit for each year
3 Suma sprzedaży i zysku w każdym miesiącu względem roku | The sum of sales and profit for each month of the year
4 sprzedaż względem po województwie | Sells and profit by province
5 sprzedaż względem płci |  sell by sex
6 sprzedaż względem rynku | sell by segment of the market
7 Sprzedaż i zysk względem kategorii produtu | sell by cathegory product
8 roznica miedzy najwiekszym a najmniejszym zamówieniem | the difference between the largest and the smallest order
9 Łączna ilość zamówień 2 klientów z najczęstszą ilością zamówień | The total order quantity of 2 customers with the most common order quantity
10 Łączna ilość zamówień 2 klientów z najwiekszą ilością zamówień | Total number of orders 2 customers with the largest number of orders
11 sprzedaz z regionu centralnego | Sale from the central region
12 sprzedaz o wartosci pomiedzy 50 i 100 w 2019 | Sale with a value between 50 and 100 in 2019
13 Jaki procent wszystkich zamówień stanowią zamówienia na poczatku nowego roku w 2019| 
   What percentage of all orders are orders at the beginning of the new year in 2019
14 Wyswietl klientów których nazwisko zaczyna się na litere D | Display customers whose last name starts with D
15 Zamówienia wieksze od 500 |  Orders bigger than 500
16 Ilość zamowien w kazdym miesiacu | Number of orders each month
17 Informacje o pierwszym i ostatnim zamówieniu | Information about the first and last order
18 Pokaż wszystkie produkty | Show all products
19 Zamówienie o największej wartości | The order with the highest value
20 Pokaż ostatnie zamówienie dla każdego klienta | Show last order for each customer
21 Pokaż ile zamówień złożył każdy z klientów | Show how many orders each customer has placed
22 Oblicz średnią wartość zamówień | Calculate the average order value
23 Oblicz czy wartość zamówienia jest mniejsza czy większa niż średnia wartość zamówień
   Calculate whether the order value is less or greater than the average order value
24 Oblicz wartość wszystkich zamówień z października | Calculate the value of all orders from October
25 Która kategoria zawiera najwięcej produktów. Wyniki posortuj wg ilości produtków w kategorii malejąco
   Which category contains the most products. Sort the results by the number of products in the descending category
26 Oblicz udział procentowy kazdego wojewodztwa w sprzedazy | Calculate the percentage of each province in sales
*/

-- 1 Union all files about sales
CREATE TABLE sprzedaz
SELECT * FROM s2017
UNION SELECT * FROM s2018
UNION SELECT * FROM s2019
UNION SELECT * FROM s2020;

-- 2 The sum of sales and profit for each year
SELECT YEAR(Data) as Year,ROUND(SUM(Sprzedaż),2) as SumaSprzedazy,ROUND(SUM(Zysk),2) AS SumaZysku FROM s2017
UNION
SELECT YEAR(Data) as Year,ROUND(SUM(Sprzedaż),2) as SumaSprzedazy,ROUND(SUM(Zysk),2) AS SumaZysku FROM s2018
UNION
SELECT YEAR(Data) as Year,ROUND(SUM(Sprzedaż),2) as SumaSprzedazy,ROUND(SUM(Zysk),2) AS SumaZysku FROM s2019
UNION
SELECT YEAR(Data) as Year,ROUND(SUM(Sprzedaż),2) as SumaSprzedazy,ROUND(SUM(Zysk),2) AS SumaZysku FROM s2020;
-- OR
SELECT YEAR(Data) as Year,ROUND(SUM(Sprzedaż),2) as SumaSprzedazy,ROUND(SUM(Zysk),2) AS SumaZysku 
FROM sprzedaz
GROUP BY Year 
ORDER BY Year;

-- 3
SELECT YEAR(Data) as YEAR, MONTH(Data) as month,ROUND(SUM(Sprzedaż),2) as Sprzedaz,ROUND(SUM(Zysk),2) as Zysk
FROM sprzedaz
GROUP BY YEAR(Data),MONTH(Data)
ORDER BY Data;

-- 4 sells and profit by province
SELECT YEAR(Data) as Rok,Klient.Województwo,ROUND(SUM(Sprzedaż),2) as Sprzedaż,ROUND(SUM(Zysk),2) as Zysk 
FROM sprzedaz
JOIN klient ON sprzedaz.`Nr klienta`=klient.`Nr Klienta`
GROUP BY YEAR(Data),Województwo
ORDER BY Województwo,Rok;

-- 5 sell by sex
-- women
SELECT YEAR(Data) as Rok,ROUND(SUM(Sprzedaż),2) as Sprzedaż,ROUND(SUM(Zysk),2) as Zysk 
FROM sprzedaz
JOIN klient ON sprzedaz.`Nr klienta`=klient.`Nr Klienta`
WHERE Klient LIKE '%a'
GROUP BY YEAR(Data);

-- men
SELECT YEAR(Data) as Rok,ROUND(SUM(Sprzedaż),2) as Sprzedaż,ROUND(SUM(Zysk),2) as Zysk 
FROM sprzedaz
JOIN klient ON sprzedaz.`Nr klienta`=klient.`Nr Klienta`
WHERE Klient NOT LIKE '%a'
GROUP BY YEAR(Data);

-- 6 sell by segment of the market
SELECT YEAR(Data) as Rok, Segment,ROUND(SUM(Sprzedaż),2) as Sprzedaż,
ROUND(SUM(Zysk),2) as Zysk 
FROM sprzedaz
GROUP BY Rok, Segment
ORDER BY Segment,Rok;

-- 7 sell by cathegory product
SELECT YEAR(Data) as Rok, `Kategoria Produktu`,
ROUND(SUM(Sprzedaż),2) as Sprzedaż,
ROUND(SUM(Zysk),2) as Zysk 
FROM sprzedaz
GROUP BY Rok, `Kategoria Produktu`
ORDER BY `Kategoria Produktu`,Rok;

-- 8 The difference between the largest and the smallest order
SELECT (
	(SELECT Sprzedaż FROM sprzedaz
	GROUP BY Sprzedaż
	ORDER BY Sprzedaż DESC
	LIMIT 1)
-
	(
	SELECT Sprzedaż FROM sprzedaz
	GROUP BY Sprzedaż
	ORDER BY Sprzedaż
	LIMIT 1)
) AS Różnica;

-- 9 The total order quantity of 2 customers with the most common order quantity
SELECT ROUND(SUM(Sprzedaż),2) AS Suma
FROM (
	SELECT COUNT(`Nr klienta`) AS 'Ilosc zamowien', Sprzedaż FROM sprzedaz
	GROUP BY `Nr klienta`
	ORDER BY COUNT(`Nr klienta`) DESC
	LIMIT 2
) AS subquery; 

-- 10 Total number of orders 2 customers with the largest number of orders
SELECT ROUND(SUM(Sprzedaż),2) AS Sprzedaż 
FROM (
	SELECT `Nr klienta`,Wielkość,SUM(Sprzedaż) AS Sprzedaż FROM sprzedaz
	GROUP BY `Nr klienta`
	ORDER BY Wielkość DESC
	LIMIT 2
) AS subquery;

-- 11 Sale from the central region
SELECT klient.Region, ROUND(SUM(sprzedaz.Sprzedaż),2) AS Suma 
FROM sprzedaz
JOIN klient ON sprzedaz.`Nr klienta`=klient.`Nr klienta`
GROUP BY Region
HAVING Region= 'centralny';

-- 12 Sale with a value between 50 and 100 in 2019
SELECT * FROM s2019
WHERE `Cena jednostkowa` BETWEEN 50 AND 100
ORDER BY `Cena jednostkowa` DESC;

-- 13 What percentage of all orders are orders at the beginning of the new year in 2019
SELECT 
	(SELECT COUNT(*) FROM s2019) AS `Wszystkie zamówienia`,
	(SELECT COUNT(*) FROM s2019
	WHERE DAY(Data) BETWEEN 1 AND 14
    AND MONTH(Data)=1) AS `Zamowienia swiateczne`,
    (SELECT `Zamowienia swiateczne`/`Wszystkie zamówienia`*100) AS Procent;
    
-- 14 Display customers whose last name starts with D
SELECT * FROM (
SELECT substring_index(Klient,' ',-1) as lastname from klient) 
as podzapytanie
WHERE lastname LIKE 'D%';

-- 15 Orders bigger than 500
SELECT
	YEAR(Data) AS ROK,
    MONTH(Data) AS MSC,
    `Nr zamówienia` as zamowienie,
    Sprzedaż
FROM s2019
GROUP BY 
	YEAR(Data),MONTH(Data),Sprzedaż
HAVING
	Sprzedaż > 60000
ORDER BY
1 DESC,2 DESC;

-- 16 Number of orders each month
SELECT MONTH(Data) as Month,COUNT('Nr zamówienia') as Count
FROM s2019
GROUP BY
	MONTH(Data)
ORDER BY
1;

-- 17 Information about the first and last order
SELECT * FROM (
	SELECT 'Pierwsze zamówienie' AS Info,`Nr zamówienia`, Data, Sprzedaż
	FROM s2019
	ORDER BY Data, `Nr wiersza`
	LIMIT 1
) AS SQ
UNION ALL
SELECT * FROM (
	SELECT 'Ostatnie zamówienie' AS Info,`Nr zamówienia`, Data, Sprzedaż
	FROM s2019
	ORDER BY Data DESC, `Nr wiersza` DESC
	LIMIT 1
) AS SQ;

-- 18 Show all products
SELECT `Kategoria Produktu`,`Podkategoria Produktu`,`Nazwa produktu` 
FROM sprzedaz
GROUP BY `Nazwa produktu`
ORDER BY `Kategoria Produktu`,`Podkategoria Produktu`,`Nazwa produktu`;

-- 19 The order with the highest value
SELECT * FROM sprzedaz
ORDER BY Sprzedaż DESC
LIMIT 1;

-- 20 Show last order for each customer
SELECT klient.`Nr klienta` AS NrKlienta,
		sprzedaz.`Nr zamówienia` AS NrZamowienia,
        sprzedaz.`Sprzedaż` as Sprzedaz,
        MAX(CAST(sprzedaz.`Data` AS Date)) AS DataZamowienia
FROM sprzedaz
JOIN klient ON sprzedaz.`Nr klienta`=klient.`Nr klienta`
GROUP BY NrKlienta
ORDER BY NrKlienta;

-- 21 Show how many orders each customer has placed
SELECT `Nr klienta`,COUNT(*) AS `Liczba zamówień`
FROM sprzedaz
GROUP BY `Nr klienta`
ORDER BY `Liczba zamówień` DESC;

-- 22 Calculate the average order value
SELECT ROUND(AVG(Sprzedaż),2) AS Średnia
FROM sprzedaz;

-- 23 Calculate whether the order value is less or greater than the average order value
SELECT `Nr zamówienia`, Sprzedaż,
CASE 
	WHEN Sprzedaż <
		(SELECT AVG(Sprzedaż)
		FROM sprzedaz) THEN 0
	ELSE 1
	END AS `0-mniejsze niż średnia/1-większe niż średnia`
FROM sprzedaz;

-- 24 Calculate the value of all orders from October
SELECT ROUND(SUM(Sprzedaż),2) AS `Suma sprzedaży` 
FROM s2019
WHERE MONTH(Data)=10;
-- WHERE CAST(Data AS DATE) BETWEEN '2019-10-01' AND '2019-10-31'

-- 25 Which category contains the most products. Sort the results by the number of products in the descending category
SELECT `Kategoria Produktu`,COUNT(`Kategoria Produktu`) AS `ilość produktów`
FROM sprzedaz
GROUP BY `Kategoria Produktu`
ORDER BY `ilość produktów` DESC;

-- 26 Calculate the percentage of each province in sales
SELECT Województwo,ilość,
ROUND(ilość/(SELECT COUNT(*) FROM sprzedaz)*100,2) AS `Procent %`
FROM (
SELECT Województwo,Count(Województwo) AS ilość
FROM klient
JOIN sprzedaz ON klient.`Nr klienta`=sprzedaz.`Nr klienta`
GROUP BY Województwo) AS subquery;
