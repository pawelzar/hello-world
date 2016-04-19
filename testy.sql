EXEC dodaj_mecz
@data = '03-09-2014',
@klub_1 = 'Manchester United',
@klub_2 = 'Arsenal FC',
@gole_1 = 3,
@gole_2 = 2;

EXEC usun_mecz '02-09-2014', 'Manchester United', 'Arsenal FC'

select * from mecze

EXEC zaktualizuj_mecz
@data = '02-09-2014',
@klub_1 = 'Manchester United',
@klub_2 = 'Arsenal FC',
@gole_1 = 3,
@gole_2 = 4,
@stadion = 'Old Trafford'

select * from mecze


EXEC dodaj_zawodnika
@imie = 'Pawel',
@nazwisko = 'Zarebski',
@rok_urodzenia = 1994,
@narodowosc = 'Polska',
@pozycja = 'pomocnik',
@waga = 70,
@wzrost = 175

EXEC usun_zawodnika
@imie = 'Pawel',
@nazwisko = 'Zarebski'

select * from zawodnicy


EXEC zaktualizuj_zawodnika
@imie = 'Pawel',
@nazwisko = 'Zarebski',
@narodowosc = 'Chiny',
@waga = 80,
@pozycja = 'trener'

EXEC dodaj_strzelca
@data = '02-09-2014',
@klub = 'Manchester United',
@imie = 'Juan',
@nazwisko = 'Mata',
@gole = 1

EXEC dodaj_strzelca
@data = '02-09-2014',
@klub = 'Manchester United',
@imie = 'Wayne',
@nazwisko = 'Rooney',
@gole = 2

EXEC usun_strzelca
@data = '02-09-2014',
@klub = 'Manchester United',
@imie = 'Wayne',
@nazwisko = 'Rooney'

select * from mecze where data = '02-09-2014'
select * from strzelcy_meczu(24)


EXEC dodaj_kontrakt_zawodnika
@klub = 'Arsenal FC',
@imie = 'Eden',
@nazwisko = 'Hazard',
@data_od = '03-06-2014',
@data_do = '03-06-2017'

EXEC usun_kontrakt_zawodnika
@klub = 'Arsenal FC',
@imie = 'Eden',
@nazwisko = 'Hazard'

EXEC zaktualizuj_kontrakt_zawodnika
@klub = 'Chelsea FC',
@imie = 'Eden',
@nazwisko = 'Hazard',
@data_do = '03-06-2017'

select * from historia_zawodnika ('Eden', 'Hazard')
