create procedure dodaj_mecz
		@data date,
		@klub_1 varchar(50),
		@klub_2 varchar(50),
		@gole_1 int = 0,
		@gole_2 int = 0,
		@stadion varchar(20) = NULL
AS
BEGIN
	IF NOT EXISTS (select nazwa_klubu from Kluby where nazwa_klubu = @klub_1)
	BEGIN
		PRINT @klub_1 + ' nie ma w bazie. WprowadŸ¸ poprawn¹ nazwê.'
		RETURN
	END
	IF NOT EXISTS (select nazwa_klubu from Kluby where nazwa_klubu = @klub_2)
	BEGIN
		PRINT @klub_2 + ' nie ma w bazie. WprowadŸ¸ poprawn¹ nazwê.'
		RETURN
	END
	IF (@gole_1 < 0 or @gole_2 < 0)
	BEGIN
		PRINT 'Niepoprawna liczba goli.'
		RETURN
	END
	IF (@klub_1 in (select nazwa_klubu_1 from Mecze where data = @data) or @klub_1 in (select nazwa_klubu_2 from Mecze where data = @data))
	BEGIN
		PRINT @klub_1 + ' by³o ju¿ uczestnikiem innego meczu w tym samym dniu.'
		RETURN
	END
	IF (@klub_2 in (select nazwa_klubu_1 from Mecze where data = @data) or @klub_2 in (select nazwa_klubu_2 from Mecze where data = @data))
	BEGIN
		PRINT @klub_2 + ' by³o ju¿ uczestnikiem innego meczu w tym samym dniu.'
		RETURN
	END
	ELSE BEGIN
		IF(@stadion is NULL) --domyœlnie mecz rozgrywa siê na stadionie pierwszej dru¿yny
		BEGIN
			select @stadion = (select nazwa_stadionu from Kluby where nazwa_klubu = @klub_1)
		END
		insert into Mecze
		values(@data, @klub_1, @klub_2, @gole_1, @gole_2, @stadion)
	END
END



create procedure usun_mecz
		@data date,
		@klub_1 varchar(50),
		@klub_2 varchar(50)
AS
BEGIN
	delete from Mecze
	where data = @data and (nazwa_klubu_1 = @klub_1 and nazwa_klubu_2 = @klub_2)
	or (nazwa_klubu_1 = @klub_2 and nazwa_klubu_2 = @klub_1)
END



create procedure zaktualizuj_mecz
		@data date,
		@klub_1 varchar(50),
		@klub_2 varchar(50),
		@gole_1 int = NULL,
		@gole_2 int = NULL,
		@stadion varchar(20) = NULL
AS
BEGIN
	DECLARE @org_gole_1 as int
	DECLARE @org_gole_2 as int
	DECLARE @org_stadion as varchar(20)

	select @org_gole_1 = liczba_goli_1,
		   @org_gole_2 = liczba_goli_2,
		   @org_stadion = nazwa_stadionu from Mecze
	where data = @data and nazwa_klubu_1 = @klub_1 and nazwa_klubu_2 = @klub_2

	-- je¿eli liczba goli nie zosta³a wprowadzona lub wynik jest taki sam to nie zostanie zaktualizowany
	IF NOT ((@gole_1 is NULL and @gole_2 is NULL) or (@gole_1 = @org_gole_1 and @gole_2 = @org_gole_2))
	BEGIN
		update Mecze
		set liczba_goli_1 = @gole_1, liczba_goli_2 = @gole_2
		where data = @data and nazwa_klubu_1 = @klub_1 and nazwa_klubu_2 = @klub_2
	END

	-- je¿eli nazwa stadionu nie uleg³a zmianie to nie zostanie zaktualizowana
	IF(@stadion is not NULL and @stadion <> @org_stadion)
	BEGIN
		update Mecze
		set nazwa_stadionu = @stadion
		where data = @data and nazwa_klubu_1 = @klub_1 and nazwa_klubu_2 = @klub_2
	END
END
