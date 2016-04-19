create procedure dodaj_zawodnika
		@imie varchar(20),
		@nazwisko varchar(20),
		@rok_urodzenia int,
		@narodowosc varchar(20),
		@pozycja varchar(10),
		@waga int,
		@wzrost int
AS
BEGIN
	IF EXISTS (select * from Zawodnicy where imie = @imie and nazwisko = @nazwisko)
	BEGIN
		PRINT 'W bazie istnieje ju¿ zawodnik ' + @imie + ' ' + nazwisko + '.'
		RETURN
	END

	IF NOT (@pozycja = 'bramkarz' or @pozycja = 'obroñca'
			or @pozycja = 'pomocnik' or @pozycja = 'napastnik')
	BEGIN
		PRINT 'Nie ma takiej pozycji.'
		RETURN
	END

	ELSE
	BEGIN
		insert into Zawodnicy
		values(@imie, @nazwisko, @rok_urodzenia, @narodowosc, @pozycja, @waga, @wzrost)
		PRINT @imie + ' ' + @nazwisko + ' zosta³ dodany do bazy zawodników.'
	END
END



create procedure usun_zawodnika
		@imie varchar(20),
		@nazwisko varchar(20)
AS
BEGIN
	delete from Zawodnicy
	where imie = @imie and nazwisko = @nazwisko
END



create procedure zaktualizuj_zawodnika
		@imie varchar(20),
		@nazwisko varchar(20),
		@rok_urodzenia int = NULL,
		@narodowosc varchar(20) = NULL,
		@pozycja varchar(10) = NULL,
		@waga int = NULL,
		@wzrost int = NULL
AS
BEGIN
	IF @rok_urodzenia is not NULL
	BEGIN
		update Zawodnicy
		set rok_urodzenia = @rok_urodzenia
		where imie = @imie and nazwisko = @nazwisko
	END
	IF @narodowosc is not NULL
	BEGIN
		update Zawodnicy
		set narodowosc = @narodowosc
		where imie = @imie and nazwisko = @nazwisko
		PRINT 'Narodowoœæ zosta³a zaktualizowana.'
	END
	IF @pozycja is not NULL
	BEGIN
		IF (@pozycja = 'bramkarz' or @pozycja = 'obroñca'
			or @pozycja = 'pomocnik' or @pozycja = 'napastnik')
		BEGIN
			update Zawodnicy
			set pozycja = @pozycja
			where imie = @imie and nazwisko = @nazwisko
			PRINT 'Pozycja zosta³a zaktualizowana.'
		END
		ELSE PRINT 'Nie ma takiej pozycji.'
	END
	IF @waga is not NULL
	BEGIN
		update Zawodnicy
		set waga = @waga
		where imie = @imie and nazwisko = @nazwisko
		PRINT 'Waga zosta³a zaktualizowana.'
	END
	IF @wzrost is not NULL
	BEGIN
		update Zawodnicy
		set wzrost = @wzrost
		where imie = @imie and nazwisko = @nazwisko
		PRINT 'Wzrost zosta³ zaktualizowany.'
	END
END
