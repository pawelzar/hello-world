create procedure dodaj_kontrakt_zawodnika
		@imie varchar(20),
		@nazwisko varchar(20),
		@klub varchar(50),
		@data_od date,
		@data_do date
AS
BEGIN
	DECLARE @id_zaw as int
	IF NOT EXISTS (select * from Kluby where nazwa_klubu = @klub)
	BEGIN
		PRINT @klub + ' nie ma w bazie. WprowadŸ poprawn¹ nazwê.'
		RETURN
	END

	IF NOT EXISTS (select * from Zawodnicy where imie = @imie and nazwisko = @nazwisko)
	BEGIN
		PRINT 'W bazie nie ma zawodnika ' + @imie + ' ' + @nazwisko + '.'
		RETURN
	END

	ELSE select @id_zaw = id_zawodnika from Zawodnicy where imie = @imie and nazwisko = @nazwisko

	insert into Kontrakty_zaw
	values(@klub, @id_zaw, @data_od, @data_do)
END



create procedure usun_kontrakt_zawodnika
		@imie varchar(20),
		@nazwisko varchar(20),
		@klub varchar(50)
AS
BEGIN
	DECLARE @id_zaw as int
	IF NOT EXISTS (select * from Kluby where nazwa_klubu = @klub)
	BEGIN
		PRINT @klub + ' nie ma w bazie. WprowadŸ poprawn¹ nazwê.'
		RETURN
	END

	IF NOT EXISTS (select * from Zawodnicy where imie = @imie and nazwisko = @nazwisko)
	BEGIN
		PRINT 'W bazie nie ma zawodnika ' + @imie + ' ' + @nazwisko + '.'
		RETURN
	END

	ELSE select @id_zaw = id_zawodnika from Zawodnicy where imie = @imie and nazwisko = @nazwisko

	delete from Kontrakty_zaw
	where id_zawodnika = @id_zaw and nazwa_klubu = @klub
END



create procedure zaktualizuj_kontrakt_zawodnika
		@imie varchar(20),
		@nazwisko varchar(20),
		@klub varchar(50),
		@data_do date
AS
BEGIN
	DECLARE @id_zaw as int
	IF NOT EXISTS (select * from Kluby where nazwa_klubu = @klub)
	BEGIN
		PRINT @klub + ' nie ma w bazie. WprowadŸ poprawn¹ nazwê.'
		RETURN
	END

	IF NOT EXISTS (select * from Zawodnicy where imie = @imie and nazwisko = @nazwisko)
	BEGIN
		PRINT 'W bazie nie ma zawodnika ' + @imie + ' ' + @nazwisko + '.'
		RETURN
	END

	ELSE select @id_zaw = id_zawodnika from Zawodnicy where imie = @imie and nazwisko = @nazwisko

	update Kontrakty_zaw
	set data_zakonczenia = @data_do
	where id_zawodnika = @id_zaw and nazwa_klubu = @klub
END
