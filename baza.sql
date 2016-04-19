-- drop DATABASE Liga
-- GO

CREATE DATABASE Liga
GO

USE Liga
GO

SET LANGUAGE polski
GO

---------- CREATE

create table Stadiony
(nazwa_stadionu varchar(50) primary key,
miasto varchar(50))

create table Kluby
(nazwa_klubu varchar(50) primary key,
rok_utworzenia int,
miasto varchar(50),
nazwa_stadionu varchar(50) references Stadiony(nazwa_stadionu))

create table Mecze
(id_meczu int IDENTITY(1,1) PRIMARY KEY,
data date,
nazwa_klubu_1 varchar(50) references Kluby(nazwa_klubu),
nazwa_klubu_2 varchar(50) references Kluby(nazwa_klubu),
liczba_goli_1 int default 0,
liczba_goli_2 int default 0,
nazwa_stadionu varchar(50) references Stadiony(nazwa_stadionu),
CHECK (liczba_goli_1 >= 0 and liczba_goli_2 >= 0 and nazwa_klubu_1 != nazwa_klubu_2))

create table Wyniki
(nazwa_klubu varchar(50) references Kluby(nazwa_klubu),
wygrane int default 0,
remisy int default 0,
przegrane int default 0)

create table Zawodnicy
(id_zawodnika int IDENTITY(1,1) PRIMARY KEY,
imie varchar(20),
nazwisko varchar(20),
rok_urodzenia int,
narodowosc varchar(20),
pozycja varchar(10),
waga int,
wzrost int,
CHECK (pozycja = 'bramkarz' or pozycja = 'obrońca' or pozycja = 'pomocnik' or pozycja = 'napastnik'))

create table Trenerzy
(id_trenera int IDENTITY(1,1) PRIMARY KEY,
imie varchar(20),
nazwisko varchar(20),
rok_urodzenia int,
narodowosc varchar(20))

create table Strzelcy
(id_meczu int references Mecze(id_meczu) ON DELETE CASCADE,
id_zawodnika int references Zawodnicy(id_zawodnika) ON DELETE CASCADE,
liczba_goli int
CHECK (liczba_goli > 0))

create table Asystenci
(id_meczu int references Mecze(id_meczu) ON DELETE CASCADE,
id_zawodnika int references Zawodnicy(id_zawodnika) ON DELETE CASCADE,
liczba_asyst int
CHECK (liczba_asyst > 0))

create table Kontrakty_zaw
(nazwa_klubu varchar(50) references Kluby(nazwa_klubu),
id_zawodnika int references Zawodnicy(id_zawodnika) ON DELETE CASCADE,
data_rozpoczecia date,
data_zakonczenia date,
CHECK (data_zakonczenia > data_rozpoczecia))

create table Kontrakty_tren
(nazwa_klubu varchar(50) references Kluby(nazwa_klubu),
id_trenera int references Trenerzy(id_trenera),
data_rozpoczecia date,
data_zakonczenia date,
CHECK (data_zakonczenia > data_rozpoczecia))


---------- INSERT


insert into Stadiony
values('Stamford Bridge', 'Londyn')
insert into Stadiony
values('Etihad Stadium', 'Manchester')
insert into Stadiony
values('Old Trafford', 'Manchester')
insert into Stadiony
values('Emirates Stadium', 'Londyn')
insert into Stadiony
values('Anfield', 'Liverpool')


insert into Kluby
values('Chelsea FC', 1905, 'Londyn', 'Stamford Bridge')
insert into Kluby
values('Manchester City', 1887, 'Manchester', 'Etihad Stadium')
insert into Kluby
values('Manchester United', 1878, 'Manchester', 'Old Trafford')
insert into Kluby
values('Arsenal FC', 1886, 'Londyn', 'Emirates Stadium')
insert into Kluby
values('Liverpool FC', 1892, 'Liverpool', 'Anfield')


insert into Trenerzy
values('José', 'Mourinho', 1963, 'Portugalia')
insert into Trenerzy
values('Manuel', 'Pellegrini', 1953, 'Chile')
insert into Trenerzy
values('Louis', 'van Gaal', 1951, 'Holandia')
insert into Trenerzy
values('Arsène', 'Wenger', 1949, 'Francja')
insert into Trenerzy
values('Brendan', 'Rodgers', 1973, 'Irlandia')


insert into Kontrakty_tren
values('Chelsea FC', 1, '03-06-2013', '03-06-2017')
insert into Kontrakty_tren
values('Manchester City', 2, '14-06-2013', '14-06-2016')
insert into Kontrakty_tren
values('Manchester United', 3, '19-05-2013', '19-05-2016')
insert into Kontrakty_tren
values('Arsenal FC', 4, '30-09-1996', '01-09-2017')
insert into Kontrakty_tren
values('Liverpool FC', 5, '01-06-2012', '01-06-2015')


insert into Zawodnicy
values('Eden', 'Hazard', 1991, 'Belgia', 'pomocnik', 74, 173)
insert into Zawodnicy
values('Cesc', 'Fabregas', 1987, 'Hiszpania', 'pomocnik', 74, 175)
insert into Zawodnicy
values('Didier', 'Drogba', 1978, 'WKS', 'napastnik', 91, 189)
insert into Zawodnicy
values('Diego', 'Costa', 1988, 'Hiszpania', 'napastnik', 85, 188)
insert into Zawodnicy
values('Gary', 'Cahill', 1985, 'Anglia', 'obrońca', 86, 193)
insert into Zawodnicy
values('Kieran', 'Gibbs', 1989, 'Anglia', 'obrońca', 70, 178)
insert into Zawodnicy
values('Olivier', 'Giroud', 1986, 'Francja', 'napastnik', 88, 192)
insert into Zawodnicy
values('Santiago', 'Cazorla', 1984, 'Hiszpania', 'pomocnik', 66, 168)
insert into Zawodnicy
values('Mikel', 'Arteta', 1982, 'Hiszpania', 'pomocnik', 64, 183)
insert into Zawodnicy
values('Per', 'Mertesacker', 1984, 'Niemcy', 'obrońca', 90, 198)
insert into Zawodnicy
values('Mario', 'Balotelli', 1990, 'Belgia', 'napastnik', 88, 189)
insert into Zawodnicy
values('Philippe', 'Coutinho', 1992, 'Brazylia', 'pomocnik', 71, 171)
insert into Zawodnicy
values('Steven', 'Gerrard', 1980, 'Anglia', 'pomocnik', 82, 185)
insert into Zawodnicy
values('Adam', 'Lallana', 1988, 'Anglia', 'pomocnik', 73, 173)
insert into Zawodnicy
values('Raheem', 'Sterling', 1994, 'Anglia', 'pomocnik', 69, 170)
insert into Zawodnicy
values('Sergio', 'Aguero', 1988, 'Argentyna', 'napastnik', 70, 173)
insert into Zawodnicy
values('Edin', 'Dzeko', 1986, 'Bośnia i Hercegowina', 'napastnik', 84, 193)
insert into Zawodnicy
values('Stevan', 'Jovetic', 1989, 'Czarnogóa', 'napastnik', 79, 183)
insert into Zawodnicy
values('Yaya', 'Toure', 1983, 'WKS', 'pomocnik', 90, 189)
insert into Zawodnicy
values('David', 'Silva', 1986, 'Hiszpania', 'pomocnik', 67, 160)
insert into Zawodnicy
values('Wayne', 'Rooney', 1985, 'Anglia', 'napastnik', 78, 178)
insert into Zawodnicy
values('Antonio', 'Valencia', 1985, 'Kolumbia', 'pomocnik', 78, 171)
insert into Zawodnicy
values('Juan', 'Mata', 1988, 'Hiszpania', 'pomocnik', 63, 170)
insert into Zawodnicy
values('Adnan', 'Januzaj', 1995, 'Belgia', 'pomocnik', 75, 180)
insert into Zawodnicy
values('Daley', 'Blind', 1990, 'Holandia', 'obrońca', 72, 180)


insert into Kontrakty_zaw
values('Chelsea FC', 1, '03-06-2013', '03-06-2017')
insert into Kontrakty_zaw
values('Chelsea FC', 2, '14-06-2013', '14-06-2016')
insert into Kontrakty_zaw
values('Chelsea FC', 3, '19-05-2013', '19-05-2016')
insert into Kontrakty_zaw
values('Chelsea FC', 4, '30-09-1996', '01-09-2017')
insert into Kontrakty_zaw
values('Chelsea FC', 5, '01-06-2012', '01-06-2015')
insert into Kontrakty_zaw
values('Arsenal FC', 6, '03-06-2013', '03-06-2017')
insert into Kontrakty_zaw
values('Arsenal FC', 7, '14-06-2013', '14-06-2016')
insert into Kontrakty_zaw
values('Arsenal FC', 8, '19-05-2013', '19-05-2016')
insert into Kontrakty_zaw
values('Arsenal FC', 9, '30-09-1996', '01-09-2017')
insert into Kontrakty_zaw
values('Arsenal FC', 10, '01-06-2012', '01-06-2015')
insert into Kontrakty_zaw
values('Liverpool FC', 11, '03-06-2013', '03-06-2017')
insert into Kontrakty_zaw
values('Liverpool FC', 12, '14-06-2013', '14-06-2016')
insert into Kontrakty_zaw
values('Liverpool FC', 13, '19-05-2013', '19-05-2016')
insert into Kontrakty_zaw
values('Liverpool FC', 14, '30-09-1996', '01-09-2017')
insert into Kontrakty_zaw
values('Liverpool FC', 15, '01-06-2012', '01-06-2015')
insert into Kontrakty_zaw
values('Manchester City', 16, '03-06-2013', '03-06-2017')
insert into Kontrakty_zaw
values('Manchester City', 17, '14-06-2013', '14-06-2016')
insert into Kontrakty_zaw
values('Manchester City', 18, '19-05-2013', '19-05-2016')
insert into Kontrakty_zaw
values('Manchester City', 19, '30-09-1996', '01-09-2017')
insert into Kontrakty_zaw
values('Manchester City', 20, '01-06-2012', '01-06-2015')
insert into Kontrakty_zaw
values('Manchester United', 21, '03-06-2013', '03-06-2017')
insert into Kontrakty_zaw
values('Manchester United', 22, '14-06-2013', '14-06-2016')
insert into Kontrakty_zaw
values('Manchester United', 23, '19-05-2013', '19-05-2016')
insert into Kontrakty_zaw
values('Manchester United', 24, '30-09-1996', '01-09-2017')
insert into Kontrakty_zaw
values('Manchester United', 25, '01-06-2012', '01-06-2015')


insert into Mecze
values('01-09-2014', 'Chelsea FC', 'Arsenal FC', 2, 0, 'Stamford Bridge')
insert into Mecze
values('08-01-2014', 'Chelsea FC', 'Liverpool FC', 4, 1, 'Stamford Bridge')
insert into Mecze
values('15-03-2014', 'Chelsea FC', 'Manchester City', 3, 3, 'Stamford Bridge')
insert into Mecze
values('22-02-2014', 'Chelsea FC', 'Manchester United', 1, 1, 'Stamford Bridge')
insert into Mecze
values('01-05-2014', 'Arsenal FC', 'Chelsea FC', 3, 1, 'Emirates Stadium')
insert into Mecze
values('08-06-2014', 'Arsenal FC', 'Liverpool FC', 2, 1, 'Emirates Stadium')
insert into Mecze
values('15-02-2014', 'Arsenal FC', 'Manchester City', 1, 3, 'Emirates Stadium')
insert into Mecze
values('22-04-2014', 'Arsenal FC', 'Manchester United', 1, 1, 'Emirates Stadium')
insert into Mecze
values('01-01-2014', 'Liverpool FC', 'Chelsea FC', 3, 2, 'Anfield')
insert into Mecze
values('08-03-2014', 'Liverpool FC', 'Arsenal FC', 2, 1, 'Anfield')
insert into Mecze
values('15-02-2014', 'Liverpool FC', 'Manchester City', 2, 2, 'Anfield')
insert into Mecze
values('22-03-2014', 'Liverpool FC', 'Manchester United', 1, 1, 'Anfield')
insert into Mecze
values('01-03-2014', 'Manchester City', 'Chelsea FC', 2, 0, 'Etihad Stadium')
insert into Mecze
values('08-04-2014', 'Manchester City', 'Arsenal FC', 2, 1, 'Etihad Stadium')
insert into Mecze
values('15-01-2014', 'Manchester City', 'Liverpool FC', 1, 1, 'Etihad Stadium')
insert into Mecze
values('22-04-2014', 'Manchester City', 'Manchester United', 5, 2, 'Etihad Stadium')
insert into Mecze
values('01-12-2014', 'Manchester United', 'Chelsea FC', 2, 0, 'Old Trafford')
insert into Mecze
values('08-11-2014', 'Manchester United', 'Arsenal FC', 2, 1, 'Old Trafford')
insert into Mecze
values('15-07-2014', 'Manchester United', 'Liverpool FC', 2, 3, 'Old Trafford')
insert into Mecze
values('22-06-2014', 'Manchester United', 'Manchester City', 1, 1, 'Old Trafford')


insert into Wyniki
values('Chelsea FC', 2, 2, 4)
insert into Wyniki
values ('Manchester City', 3, 4, 1)
insert into Wyniki
values ('Manchester United', 2, 4, 2)
insert into Wyniki
values ('Arsenal FC', 2, 1, 5)
insert into Wyniki
values ('Liverpool FC', 3, 3, 2)


insert into Strzelcy
values(1, 3, 2)
insert into Strzelcy
values(2, 1, 4)
insert into Strzelcy
values(2, 15, 1)
insert into Strzelcy
values(3, 4, 3)
insert into Strzelcy
values(3, 19, 3)
insert into Strzelcy
values(4, 2, 1)
insert into Strzelcy
values(4, 23, 1)
insert into Strzelcy
values(5, 7, 3)
insert into Strzelcy
values(5, 5, 1)
insert into Strzelcy
values(6, 10, 2)
insert into Strzelcy
values(6, 11, 1)
insert into Strzelcy
values(7, 6, 1)
insert into Strzelcy
values(7, 17, 3)
insert into Strzelcy
values(8, 8, 1)
insert into Strzelcy
values(8, 25, 1)
insert into Strzelcy
values(9, 14, 3)
insert into Strzelcy
values(9, 4, 2)
insert into Strzelcy
values(10, 13, 2)
insert into Strzelcy
values(10, 10, 1)
insert into Strzelcy
values(11, 12, 2)
insert into Strzelcy
values(11, 16, 2)
insert into Strzelcy
values(12, 11, 1)
insert into Strzelcy
values(12, 24, 1)
insert into Strzelcy
values(13, 18, 2)
insert into Strzelcy
values(14, 16, 2)
insert into Strzelcy
values(14, 9, 1)
insert into Strzelcy
values(15, 20, 1)
insert into Strzelcy
values(15, 14, 1)
insert into Strzelcy
values(16, 17, 5)
insert into Strzelcy
values(16, 23, 2)
insert into Strzelcy
values(17, 21, 2)
insert into Strzelcy
values(18, 22, 2)
insert into Strzelcy
values(18, 7, 1)
insert into Strzelcy
values(19, 21, 2)
insert into Strzelcy
values(19, 11, 3)
insert into Strzelcy
values(20, 23, 1)
insert into Strzelcy
values(20, 10, 1)


insert into Asystenci
values(1, 4, 2)
insert into Asystenci
values(2, 2, 4)
insert into Asystenci
values(2, 14, 1)
insert into Asystenci
values(3, 3, 3)
insert into Asystenci
values(3, 18, 3)
insert into Asystenci
values(4, 4, 1)
insert into Asystenci
values(4, 24, 1)
insert into Asystenci
values(5, 9, 3)
insert into Asystenci
values(5, 3, 1)
insert into Asystenci
values(6, 9, 2)
insert into Asystenci
values(6, 13, 1)
insert into Asystenci
values(7, 8, 1)
insert into Asystenci
values(7, 19, 3)
insert into Asystenci
values(8, 6, 1)
insert into Asystenci
values(8, 23, 1)
insert into Asystenci
values(9, 12, 3)
insert into Asystenci
values(9, 2, 2)
insert into Asystenci
values(10, 11, 2)
insert into Asystenci
values(10, 8, 1)
insert into Asystenci
values(11, 14, 2)
insert into Asystenci
values(11, 18, 2)
insert into Asystenci
values(12, 13, 1)
insert into Asystenci
values(12, 22, 1)
insert into Asystenci
values(13, 16, 2)
insert into Asystenci
values(14, 18, 2)
insert into Asystenci
values(14, 7, 1)
insert into Asystenci
values(15, 17, 1)
insert into Asystenci
values(15, 12, 1)
insert into Asystenci
values(16, 19, 5)
insert into Asystenci
values(16, 21, 2)
insert into Asystenci
values(17, 23, 2)
insert into Asystenci
values(18, 24, 2)
insert into Asystenci
values(18, 6, 1)
insert into Asystenci
values(19, 23, 2)
insert into Asystenci
values(19, 13, 3)
insert into Asystenci
values(20, 21, 1)
insert into Asystenci
values(20, 7, 1)


---------- SELECT


select * from Stadiony
select * from Kluby
select * from Trenerzy
select * from Kontrakty_tren
select * from Zawodnicy
select * from Kontrakty_zaw
select * from Mecze
select * from Strzelcy
select * from Asystenci
