create procedure dodaj_klub
		@nazwa_klubu varchar(50),
		@rok_utworzenia int,
		@miasto varchar(50),
		@nazwa_stadionu varchar(50)
AS
BEGIN
	IF EXISTS (select * from Kluby where nazwa_klubu = @nazwa_klubu)
	BEGIN
		PRINT 'W bazie istnieje ju¿ klub ' + @nazwa_klubu + '.'
		RETURN
	END

	-- je¿eli w bazie nie ma podanego stadionu to jest on tworzony
	IF NOT EXISTS (select * from Stadiony where nazwa_stadionu = @nazwa_stadionu)
	BEGIN
		insert into Stadiony
		values(@nazwa_stadionu, @miasto)
	END

	insert into Kluby
	values(@nazwa_klubu, @rok_utworzenia, @miasto, @nazwa_stadionu)
END



create procedure zaktualizuj_klub
		@nazwa_klubu varchar(50),
		@rok_utworzenia int = NULL,
		@miasto varchar(50) = NULL,
		@nazwa_stadionu varchar(50) = NULL
AS
BEGIN
	IF NOT EXISTS (select * from Kluby where nazwa_klubu = @nazwa_klubu)
	BEGIN
		PRINT 'W bazie nie ma klubu ' + @nazwa_klubu + '.'
		RETURN
	END

	-- je¿eli w bazie nie ma podanego stadionu to jest on tworzony
	IF(@nazwa_stadionu is not NULL)
	BEGIN
		IF NOT EXISTS (select * from Stadiony where nazwa_stadionu = @nazwa_stadionu)
		BEGIN
			insert into Stadiony
			values(@nazwa_stadionu, @miasto)
		END
		ELSE BEGIN
			update Kluby
			set nazwa_stadionu = @nazwa_stadionu
			where nazwa_klubu = @nazwa_klubu
			PRINT 'Stadion zosta³ zaktualizowany.'
		END
	END

	IF(@rok_utworzenia is not NULL)
	BEGIN
		update Kluby
		set rok_utworzenia = @rok_utworzenia
		where nazwa_klubu = @nazwa_klubu
		PRINT 'Rok utworzenia zosta³ zaktualizowany.'
	END
	
	IF(@miasto is not NULL)
	BEGIN
		update Kluby
		set miasto = @miasto
		where nazwa_klubu = @nazwa_klubu
		PRINT 'Miasto zosta³o zaktualizowane.'
	END
END
