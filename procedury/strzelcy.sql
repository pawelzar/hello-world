create procedure dodaj_strzelca  -- dzia³a te¿ jako aktualizacja liczby strzelonych goli
		@data date,
		@klub varchar(50),
		@imie varchar(20),
		@nazwisko varchar(20),
		@gole int
AS
BEGIN
	DECLARE @id_zaw as int
	DECLARE @id_meczu as int
	DECLARE @suma_goli as int
	DECLARE @gole_strzelcow as int

	select @id_zaw = id_zawodnika from Zawodnicy where imie = @imie and nazwisko = @nazwisko

	-- je¿eli zawodnik nie nale¿y do podajen dru¿yny to zwracany jest b³¹d
	IF(@id_zaw not in (select id_zawodnika from Kontrakty_zaw where nazwa_klubu = @klub))
	BEGIN
		PRINT @imie + ' ' + @nazwisko + ' nie gra w klubie ' + @klub + '.'
		RETURN
	END

	select @id_meczu = id_meczu from Mecze
	where data = @data and (nazwa_klubu_1 = @klub or nazwa_klubu_2 = @klub)

	-- je¿eli data jest b³êdna to zwracany jest b³¹d
	IF(@id_meczu is NULL)
	BEGIN
		PRINT @klub + ' nie gra³ w tym dniu meczu.'
		RETURN
	END

	-- suma goli strzelonych przez zawodników (tj. wpisanych wczeœniej strzelców)
	-- podanej dru¿yny w danym meczu
	select @gole_strzelcow = SUM(s.liczba_goli) from Strzelcy s
	inner join Kontrakty_zaw k on k.id_zawodnika = s.id_zawodnika
	where id_meczu = @id_meczu and k.nazwa_klubu = @klub

	-- uzyskanie liczby goli strzelonych przez podan¹ dru¿ynê
	IF(@klub = (select nazwa_klubu_1 from Mecze where data = @data))
	BEGIN
		select @suma_goli = liczba_goli_1 from Mecze
		where data = @data and nazwa_klubu_1 = @klub
	END
	IF(@klub = (select nazwa_klubu_2 from Mecze where data = @data))
	BEGIN
		select @suma_goli = liczba_goli_2 from Mecze
		where data = @data and nazwa_klubu_2 = @klub
	END

	-- je¿eli zawodnik jest ju¿ wpisany na listê strzelców w tym meczu to nadpisujemy liczbê goli
	IF EXISTS (select * from Strzelcy where id_zawodnika = @id_zaw and id_meczu = @id_meczu)
	BEGIN
		DECLARE @gole_zawodnika as int
		select @gole_zawodnika = liczba_goli from Strzelcy
		where id_meczu = @id_meczu and id_zawodnika = @id_zaw

		IF((@gole + ISNULL(@gole_strzelcow, 0) - @gole_zawodnika) <= @suma_goli)
		BEGIN
			update Strzelcy
			set liczba_goli = @gole
			where id_meczu = @id_meczu and id_zawodnika = @id_zaw
		END
		ELSE PRINT 'Ta dru¿yna nie strzeli³a tylu goli.'
		RETURN
	END

	-- je¿eli zawodnik nie zosta³ wczeœniej wpisany
	IF((@gole + ISNULL(@gole_strzelcow, 0)) <= @suma_goli)
	BEGIN
		insert into Strzelcy
		values(@id_meczu, @id_zaw, @gole)

	END
	ELSE PRINT 'Ta dru¿yna nie strzeli³a tylu goli.'
END



create procedure usun_strzelca
		@data date,
		@klub varchar(50),
		@imie varchar(20),
		@nazwisko varchar(20)
AS
BEGIN
	DECLARE @id_zaw as int
	DECLARE @id_meczu as int

	select @id_zaw = id_zawodnika from Zawodnicy where imie = @imie and nazwisko = @nazwisko

	-- je¿eli zawodnik nie nale¿y do podanej dru¿yny zwracany jest b³¹d
	IF(@id_zaw not in (select id_zawodnika from Kontrakty_zaw where nazwa_klubu = @klub))
	BEGIN
		PRINT @imie + ' ' + @nazwisko + ' nie gra w klubie ' + @klub + '.'
		RETURN
	END

	select @id_meczu = id_meczu from Mecze
	where data = @data and (nazwa_klubu_1 = @klub or nazwa_klubu_2 = @klub)

	-- je¿eli jest b³êdna data zwracany jest b³¹d
	IF(@id_meczu is NULL)
	BEGIN
		PRINT @klub + ' nie gra³ w tym dniu meczu.'
		RETURN
	END

	delete from Strzelcy
	where id_meczu = @id_meczu and id_zawodnika = @id_zaw
END
