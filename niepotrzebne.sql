-- trigger sprawdzaj¹cy poprawnoœæ wyniku meczu
CREATE TRIGGER zly_wynik ON Mecze
FOR INSERT, UPDATE
AS
DECLARE @gole_1 INT, @gole_2 INT, @klub_1 varchar(50), @klub_2 varchar(50)
SELECT @gole_1 = liczba_goli_1 FROM inserted
SELECT @gole_2 = liczba_goli_2 FROM inserted
IF (@gole_1 < 0 or @gole_2 < 0)
BEGIN
	ROLLBACK
	PRINT 'Wynik meczu nie mo¿e byæ ujemny!'
END


-- trigger sprawdzaj¹cy poprawnoœæ nazw
CREATE TRIGGER zla_nazwa_druzyn ON Mecze
FOR INSERT, UPDATE
AS
DECLARE @klub_1 varchar(50), @klub_2 varchar(50)
SELECT @klub_1 = nazwa_klubu_1 FROM inserted
SELECT @klub_2 = nazwa_klubu_2 FROM inserted
IF (@klub_1 = @klub_2)
BEGIN
	ROLLBACK
	PRINT 'W jednym meczu nie mog¹ graæ dwie takie same dru¿yny!'
END


-- trigger usuwaj¹cy strzelców i asystentów usuniêtego meczu
CREATE TRIGGER usun_wydarzenia ON Mecze
FOR DELETE
AS
DECLARE @id int
SELECT @id = id_meczu from deleted
DELETE FROM Strzelcy
WHERE id_meczu = @id
DELETE FROM Asystenci
WHERE id_meczu = @id


-- trigger sprawdzaj¹cy poprawnoœæ strzelonych bramek przez zawodnika
CREATE TRIGGER zla_liczba_strzelcy ON Strzelcy
FOR INSERT, UPDATE
AS
DECLARE @gole INT
SELECT @gole = liczba_goli from inserted
IF (@gole < 0)
BEGIN
	ROLLBACK
	PRINT 'Liczba nie mo¿e byæ ujemna!'
END
ELSE IF (@gole = 0)
BEGIN
	ROLLBACK
	PRINT 'Strzelec bez bramek to nie strzelec...'
END


-- trigger sprawdzaj¹cy poprawnoœæ asyst
CREATE TRIGGER zla_liczba_asystenci ON Asystenci
FOR INSERT, UPDATE
AS
DECLARE @asysty INT
SELECT @asysty = liczba_asyst from inserted
IF (@asysty < 0)
BEGIN
	ROLLBACK
	PRINT 'Liczba nie mo¿e byæ ujemna!'
END
ELSE IF (@asysty = 0)
BEGIN
	ROLLBACK
	PRINT 'Ten asystent nikomu nie asystowa³...'
END


-- trigger sprawdzajacy datê
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



CREATE PROCEDURE trener_klubu
    @klub varchar(20),
    @nazwisko varchar(20) OUTPUT
AS
begin try
    if exists (select * from Kluby where nazwa_klubu = @klub)
    begin
        select @nazwisko = imie + ' ' + nazwisko
        from Trenerzy
        where id_trenera = (select id_trenera from Kontrakty_tren where nazwa_klubu = @klub)
    end
    else
        raiserror ('Nie ma takiego klubu', 11,1)
end try
begin catch
        SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch

drop procedure trener_klubu

-- bez b³êdu:

declare @nazw varchar(20)
exec trener_klubu 'Chelsea FC', @nazw OUTPUT
print @nazw

-- z b³êdem

declare @nazw varchar(20)
exec trener_klubu 'Wis³a', @nazw OUTPUT
print @nazw


-- funkcja zwracaj¹ca historiê danego zawodnika
create function historia_zawodnika
    (@imie varchar(20), @nazwisko varchar(20))
    returns table
as
    return select k.nazwa_klubu, k.data_rozpoczecia, k.data_zakonczenia from Zawodnicy z
	inner join Kontrakty_zaw k on k.id_zawodnika = z.id_zawodnika
	inner join Strzelcy s on s.id_zawodnika = z.id_zawodnika
	inner join Asystenci a on a.id_zawodnika = z.id_zawodnika
	inner join Mecze m on m.id_meczu = s.id_meczu or m.id_meczu = a.id_meczu
	where z.imie = @imie and z.nazwisko = @nazwisko
		  and m.data > k.data_rozpoczecia and m.data < k.data_zakonczenia
