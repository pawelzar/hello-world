-- informacje o zawodnikach
create view zawodnicy_informacje (imie, nazwisko, rok_urodzenia, narodowosc, pozycja, waga, wzrost)
as
select imie,
	   nazwisko,
	   rok_urodzenia as 'urodzony',
	   narodowosc, pozycja,
	   cast (waga as varchar(10)) + ' kg' as 'waga',
	   cast (wzrost as varchar(10)) + ' cm' as 'wzrost'
from Zawodnicy


-- informacje o klubach
create view kluby_informacje (nazwa, rok, miasto, stadion, trener)
as
select k.nazwa_klubu,
	   k.rok_utworzenia,
	   k.miasto,
	   k.nazwa_stadionu,
	   t.imie + ' ' + t.nazwisko as 'trener'
from Kluby k
inner join Kontrakty_tren m on m.nazwa_klubu = k.nazwa_klubu
inner join Trenerzy t on m.id_trenera = t.id_trenera

select * from kluby_informacje


-- tabela kontraktów zawodników
create view tabela_kontrakty_zaw(klub, imie, nazwisko, pozycja, wiek, od, do)
as
select k.nazwa_klubu,
	   z.imie, z.nazwisko,
	   z.pozycja, YEAR(GETDATE()) - z.rok_urodzenia as 'wiek',
	   n.data_rozpoczecia, n.data_zakonczenia
from Zawodnicy z
inner join Kontrakty_zaw n on z.id_zawodnika = n.id_zawodnika
inner join Kluby k on n.nazwa_klubu = k.nazwa_klubu
where n.data_rozpoczecia < getdate() and n.data_zakonczenia > getdate()

select * from tabela_kontrakty_zaw
order by klub


-- tabela kontraktów trenerów
create view tabela_kontrakty_tren(klub, imie, nazwisko, wiek, narodowosc, od, do)
as
select k.nazwa_klubu,
	   t.imie, t.nazwisko,
	   YEAR(GETDATE()) - t.rok_urodzenia as 'wiek',
	   t.narodowosc,
	   n.data_rozpoczecia,
	   n.data_zakonczenia
from Trenerzy t
inner join Kontrakty_tren n on t.id_trenera = n.id_trenera
inner join Kluby k on n.nazwa_klubu = k.nazwa_klubu
where n.data_rozpoczecia < getdate() and n.data_zakonczenia > getdate()

select * from tabela_kontrakty_tren
order by klub


-- liczba goli ka¿dego strzelca
create view tabela_strzelcow(klub, imie, nazwisko, gole)
as
select k.nazwa_klubu,
	   z.imie, z.nazwisko,
	   SUM(s.liczba_goli) as 'gole'
from Strzelcy s
inner join Zawodnicy z on s.id_zawodnika = z.id_zawodnika
inner join Kontrakty_zaw k on k.id_zawodnika = z.id_zawodnika
group by k.nazwa_klubu, z.imie, z.nazwisko

select * from tabela_strzelcow
order by gole desc


-- liczba asyst ka¿dego asystenta
create view tabela_asystentow(klub, imie, nazwisko, asysty)
as
select k.nazwa_klubu,
	   z.imie, z.nazwisko,
	   SUM(a.liczba_asyst) as 'asysty'
from Asystenci a
inner join Zawodnicy z on a.id_zawodnika = z.id_zawodnika
inner join Kontrakty_zaw k on k.id_zawodnika = z.id_zawodnika
group by k.nazwa_klubu, z.imie, z.nazwisko

select * from tabela_asystentow
order by asysty desc


-- liczba wszystkich goli ka¿dej dru¿yny
create view tabela_druzyn_gole(klub, strzelone, stracone)
as
select klub as 'nazwa klubu',
	   SUM(gole) as 'gole strzelone',
	   SUM(stracone) as 'gole stracone'
from (select k.nazwa_klubu as 'klub',
			 SUM(m1.liczba_goli_1) as 'gole',
			 SUM(m1.liczba_goli_2) as 'stracone'
	  from Kluby k, Mecze m1
	  where m1.nazwa_klubu_1 = k.nazwa_klubu
	  group by k.nazwa_klubu
	  union all
	  select k.nazwa_klubu as 'klub',
			 SUM(m2.liczba_goli_2) as 'gole',
			 SUM(m2.liczba_goli_1) as 'stracone'
	  from Kluby k, Mecze m2
	  where m2.nazwa_klubu_2 = k.nazwa_klubu
	  group by k.nazwa_klubu) a group by klub

select * from tabela_druzyn_gole


-- liczba goli u siebie
create view tabela_druzyn_dom(klub, strzelone, stracone)
as
select k.nazwa_klubu,
	   SUM(m1.liczba_goli_1) as 'strzelone',
	   SUM(m1.liczba_goli_2) as 'stracone'
from Kluby k
inner join Mecze m1 on m1.nazwa_klubu_1 = k.nazwa_klubu
group by k.nazwa_klubu

select * from tabela_druzyn_dom


-- liczba goli na wyjeŸdzie
create view tabela_druzyn_wyjazd(klub, strzelone, stracone)
as
select k.nazwa_klubu,
	   SUM(m2.liczba_goli_2) as 'strzelone',
	   SUM(m2.liczba_goli_1) as 'stracone'
from Kluby k
inner join Mecze m2 on m2.nazwa_klubu_2 = k.nazwa_klubu
group by k.nazwa_klubu

select * from tabela_druzyn_wyjazd


-- tabela wyników i goli
create view tabela_druzyn_ogolna(klub, wygrane, remisy, przegrane, strzelone, stracone, punkty)
as
select w.nazwa_klubu,
	   w.wygrane,
	   w.remisy,
	   w.przegrane,
	   t.strzelone,
	   t.stracone,
	   dbo.punkty(w.wygrane, w.remisy) as 'punkty'
from Wyniki w
inner join tabela_druzyn_gole t on w.nazwa_klubu = t.klub
group by w.nazwa_klubu, w.wygrane, w.remisy, w.przegrane, t.strzelone, t.stracone

select * from tabela_druzyn_ogolna
order by punkty desc

drop view tabela_druzyn_ogolna


-- tabela rozegranych meczów
create view tabela_meczow
as
select data,
	   nazwa_stadionu as 'Stadion',
	   nazwa_klubu_1 as 'Klub 1',
	   liczba_goli_1 as 'Gole 1',
	   liczba_goli_2 as 'Gole 2',
	   nazwa_klubu_2 as 'Klub 2'
from mecze

select * from tabela_meczow
