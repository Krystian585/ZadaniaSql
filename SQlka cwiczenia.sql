/*nazwisko, imiê, pesel i p³eæ tych pacjentów,
którzy w pierwszym pó³roczu 2013 byli w diabetologa lub chirurga. */
SELECT 
	P.Nazwisko
	,P.Imie
	,P.Pesel
	,P.plec
	,S.NazwaSpecjalizacji
	,W.DataWizyty
FROM Pacjenci as P Join Wizyty as W
		ON P.IdPacjenta=W.IdPacjenta
		JOIN Lekarze as L
		ON W.IdLekarza=L.IdLekarza
		JOIN Specjalizacje as S
		ON L.IdLekarza=S.idspecjalizacji
WHERE NazwaSpecjalizacji='diabetolog' or NazwaSpecjalizacji='chirurg' and W.DataWizyty between '20130101' and '20130630'
ORDER BY NazwaSpecjalizacji


/* lekarz, nazwisko i imiê pacjenta, data wizyty i kwota op³aty za wizytê
dla wizyt  z marca 2013  w których lekarz by³ tej samej p³ci
co pacjent i by³ od niego straszy. 
Wynik wed³ug  daty wizyty rosn¹co. */
SELECT
	L.Nazwisko+' '+L.Imie as Lekarz
	,P.Nazwisko+' '+P.Imie as Pacjent
	,W.DataWizyty
	,W.Oplata
FROM Pacjenci as P JOIN Wizyty as w
		ON P.IdPacjenta=W.IdPacjenta
		JOIN Lekarze as L
		ON W.IdLekarza=L.IdLekarza
WHERE W.DataWizyty between '20130301' and '20130331' and L.CzyKobieta=P.CzyKobieta and L.DataUrodzenia>P.DataUrodzenia
ORDER BY W.DataWizyty


/*nazwisko, imiê  i Pesel pacjenta oraz liczba  
wizyt danego pacjenta w II pó³roczu 2013.
W wyniku tylko pacjenci, którzy byli przynajmniej 3 razy u lekarza. 
Wynik malej¹co wed³ug liczby wizyt */


USE TRPrzychodnia
SELECT
	P.Nazwisko
	,P.Imie
	,P.Pesel
	,COUNT(Pesel) as LiczbaWizyt
	FROM Pacjenci as P JOIN Wizyty as W
		ON P.IdPacjenta=W.IdPacjenta
	Where W.DataWizyty between '20130701' and '20131231'
	GROUP BY P.Nazwisko,P.Imie,p.Pesel
	Having count(*)>2
	ORDER BY LiczbaWizyt DESC


/*nazwa przedmiotu oraz liczba ocen bardzo dobrych wystawionych 
	studentkom w roku 2013 z tego  przedmiotu. 
	Wynik malej¹co wed³ug liczby ocen. */
USE TRUczelnia
SELECT
	P.Nazwa as NazwaPrzedmiotu
	,O.Ocena
	,count(*) as LiczbaOcen
	FROM OCENY as O JOIN Przedmioty as P
		ON O.IdPrzedmiotu=P.IdPrzedmiotu
		JOIN Studenci as S
		ON O.IdStudenta=S.IdStudenta
	WHERE S.CzyKobieta=1 and O.DataOceny between '20130101' and '20131231' and O.Ocena>4.50
	GROUP BY P.Nazwa,O.Ocena
	ORDER BY LiczbaOcen DESC

/*nazwisko, imiê  i numer ewidencyjny lekarza oraz liczbê wizyt, dla tych lekarzy, 
którzy w roku 2015 przyjêli w ramach wizyt co najmniej
50 ró¿nych kobiet w wieku powy¿ej 75 lat. 
Wynik malej¹co wg. liczby wizyt. */
--SELECT *
--FROM(
	SELECT 
		--L.Nazwisko as NazwiskoLekarza
		--,L.Imie as ImieLekarza
		--,L.NrEwid 
		L.IdLekarza
		,COUNT(W.IdWizyty) as ilewizyt
		,COUNT( distinct P.idpacjenta) as ilepacjentow
	From Wizyty as W Join Pacjenci as P
		ON W.IdPacjenta=P.IdPacjenta
		JOIN Lekarze as L
		ON W.IdLekarza=L.IdLekarza
	WHERE DataWizyty between '20150101' and '20151231' and P.CzyKobieta=1 and DATEDIFF(year,P.DataUrodzenia,W.DataWizyty)>75 -- liczy te ktore w trakcie wizyty mia³y powyzej 75
	Group By 
	--L.Nazwisko
	--,L.Imie
	--,L.NrEwid
	L.IdLekarza
--	HAVING  COUNT(DISTINCT P.idpacjenta)>50
	ORDER BY ilewizyt DESC
--WHERE ile>30
--Order by ILE desc




 