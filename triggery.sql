-- trigger aktualizuj¹cy tabelê wyników po meczu
CREATE TRIGGER aktualizacja_wynikow ON Mecze
AFTER INSERT, UPDATE
AS
DECLARE @gole_1 INT, @gole_2 INT, @klub_1 varchar(50), @klub_2 varchar(50)
SELECT @klub_1 = nazwa_klubu_1 FROM inserted
SELECT @klub_2 = nazwa_klubu_2 FROM inserted
SELECT @gole_1 = liczba_goli_1 FROM inserted
SELECT @gole_2 = liczba_goli_2 FROM inserted
IF (@gole_1 > @gole_2)
BEGIN
	UPDATE Wyniki
	SET wygrane = wygrane + 1 where nazwa_klubu = @klub_1
	UPDATE Wyniki
	SET przegrane = przegrane + 1 where nazwa_klubu = @klub_2
END
ELSE IF (@gole_1 < @gole_2)
BEGIN
	UPDATE Wyniki
	SET wygrane = wygrane + 1 where nazwa_klubu = @klub_2
	UPDATE Wyniki
	SET przegrane = przegrane + 1 where nazwa_klubu = @klub_1
END
ELSE IF (@gole_1 = @gole_2)
BEGIN
	UPDATE Wyniki
	SET remisy = remisy + 1 where nazwa_klubu = @klub_1 or nazwa_klubu = @klub_2
END

drop trigger aktualizacja_wynikow


-- trigger aktualizuj¹cy wyniki po usuniêciu meczu
CREATE TRIGGER aktualizacja_wynikow_usuniecie ON Mecze
AFTER DELETE
AS
DECLARE @gole_1 INT, @gole_2 INT, @klub_1 varchar(50), @klub_2 varchar(50)
SELECT @klub_1 = nazwa_klubu_1 FROM deleted
SELECT @klub_2 = nazwa_klubu_2 FROM deleted
SELECT @gole_1 = liczba_goli_1 FROM deleted
SELECT @gole_2 = liczba_goli_2 FROM deleted
IF (@gole_1 > @gole_2)
BEGIN
	UPDATE Wyniki
	SET wygrane = wygrane - 1 where nazwa_klubu = @klub_1
	UPDATE Wyniki
	SET przegrane = przegrane - 1 where nazwa_klubu = @klub_2
END
ELSE IF (@gole_1 < @gole_2)
BEGIN
	UPDATE Wyniki
	SET wygrane = wygrane - 1 where nazwa_klubu = @klub_2
	UPDATE Wyniki
	SET przegrane = przegrane - 1 where nazwa_klubu = @klub_1
END
ELSE IF (@gole_1 = @gole_2)
BEGIN
	UPDATE Wyniki
	SET remisy = remisy - 1 where nazwa_klubu = @klub_1 or nazwa_klubu = @klub_2
END


-- trigger sprawdzaj¹cy datê
CREATE TRIGGER powtorzona_data ON Mecze
FOR INSERT, UPDATE
AS
DECLARE @data date, @klub_1 varchar(50), @klub_2 varchar(50)
BEGIN
SELECT @data = i.data FROM inserted i
SELECT @klub_1 = i.nazwa_klubu_1 FROM inserted i
SELECT @klub_2 = i.nazwa_klubu_2 FROM inserted i
IF (@klub_1 in (select nazwa_klubu_1 from Mecze where data = @data)
	or @klub_1 in (select nazwa_klubu_2 from Mecze where data = @data))
BEGIN
	ROLLBACK
	PRINT @klub_1 + ' by³o ju¿ uczestnikiem innego meczu w tym samym dniu.'
END
ELSE IF (@klub_2 in (select nazwa_klubu_1 from Mecze where data = @data)
		 or @klub_2 in (select nazwa_klubu_2 from Mecze where data = @data))
BEGIN
	ROLLBACK
	PRINT @klub_2 + ' by³o ju¿ uczestnikiem innego meczu w tym samym dniu.'
END
END

drop trigger powtorzona_data


-- trigger aktualizuj¹cy kontrakty zawodników
CREATE TRIGGER aktualizacja_kontraktow_zaw ON Kontrakty_zaw
FOR INSERT
AS
DECLARE @data_od date, @data_do date, @id_zaw int
SELECT @id_zaw = id_zawodnika from inserted
SELECT @data_od = data_rozpoczecia from inserted
SELECT @data_do = (select MAX(data_zakonczenia) from Kontrakty_zaw where id_zawodnika = @id_zaw)
BEGIN
IF (@data_od < @data_do)
BEGIN
	UPDATE Kontrakty_zaw
	SET data_zakonczenia = @data_od
	where data_zakonczenia = @data_do and id_zawodnika = @id_zaw
END
END


-- trigger aktualizuj¹cy kontrakty trenerów
CREATE TRIGGER aktualizacja_kontraktow_tren ON Kontrakty_tren
FOR INSERT
AS
DECLARE @data_od date, @data_do date, @id_tren int
SELECT @id_tren = id_trenera from inserted
SELECT @data_od = data_rozpoczecia from inserted
SELECT @data_do = (select MAX(data_zakonczenia) from Kontrakty_tren where id_trenera = @id_tren)
BEGIN
IF (@data_od < @data_do)
BEGIN
	UPDATE Kontrakty_tren
	SET data_zakonczenia = @data_od
	where data_zakonczenia = @data_do and id_trenera = @id_tren
END
END



insert into Kontrakty_zaw
values('Arsenal FC', 1, '03-06-2014', '03-06-2017')
select * from historia_zawodnika ('Eden', 'Hazard')
