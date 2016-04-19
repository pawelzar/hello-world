-- funkcja licz¹ca punkty za mecze (skalarna)
create function punkty
    (@wygrane int, @remisy int)
    returns int
as
begin
    return @wygrane*3 + @remisy*1
end


-- funkcja wyszukuj¹ca dru¿yny z tego samego miasta (tablicowa)
create function druzyny
    (@m varchar(20))
    returns table
as
    return select * from Kluby where miasto = @m

select * from druzyny('Londyn')


-- funkcja zwracaj¹ca tabelê strzelców w danym meczu
create function strzelcy_meczu
    (@id varchar(20))
    returns table
as
    return select k.nazwa_klubu as 'klub' ,
				  z.imie + ' ' + z.nazwisko as 'zawodnik',
				  s.liczba_goli as 'gole'
		from Zawodnicy z
		inner join Kontrakty_zaw k on k.id_zawodnika = z.id_zawodnika
		inner join Strzelcy s on z.id_zawodnika = s.id_zawodnika
		where s.id_meczu = @id

select * from strzelcy_meczu(5)


-- funkcja zwracaj¹ca tabelê asystentów w danym meczu
create function asystenci_meczu
    (@id varchar(20))
    returns table
as
    return select k.nazwa_klubu as 'klub' ,
				  z.imie + ' ' + z.nazwisko as 'zawodnik',
				  a.liczba_asyst as 'asysty'
		from Zawodnicy z
		inner join Kontrakty_zaw k on k.id_zawodnika = z.id_zawodnika
		inner join Asystenci a on z.id_zawodnika = a.id_zawodnika
		where a.id_meczu = @id

select * from asystenci_meczu(5)


-- funkcja zwracaj¹ca historiê danego zawodnika
create function historia_zawodnika
    (@imie varchar(20), @nazwisko varchar(20))
    returns table
as
    return select k.nazwa_klubu, k.data_rozpoczecia, k.data_zakonczenia from Zawodnicy z
	inner join Kontrakty_zaw k on k.id_zawodnika = z.id_zawodnika
	where z.imie = @imie and z.nazwisko = @nazwisko

drop function historia_zawodnika
select * from historia_zawodnika ('Eden', 'Hazard')


-- funkcja zwracaj¹ca historiê danego trenera
create function historia_trenera
    (@imie varchar(20), @nazwisko varchar(20))
    returns table
as
    return select k.nazwa_klubu, k.data_rozpoczecia, k.data_zakonczenia from Trenerzy t
	inner join Kontrakty_tren k on k.id_trenera = t.id_trenera
	where t.imie = @imie and t.nazwisko = @nazwisko

drop function historia_zawodnika
select * from historia_trenera ('Manuel', 'Pellegrini')


-- funkcja wyszukuj¹ca zawodników o okreœlonej pozycji
create function zawodnicy_pozycja
    (@poz varchar(20))
    returns @nazwiska table
        (klub varchar(50), imie varchar(20), nazwisko varchar(20), pozycja varchar(10))
as
begin
    if @poz in ('bramkarz', 'obroñca', 'pomocnik', 'napastnik')
        insert into @nazwiska
        select klub, imie, nazwisko, pozycja from tabela_kontrakty_zaw where pozycja = @poz
    else
        insert into @nazwiska
        select klub, imie, nazwisko, pozycja from tabela_kontrakty_zaw
return
end

select * from zawodnicy_pozycja('asd')
order by pozycja


-- procedura zwracaj¹ca nazwisko trenera danego klubu
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
        raiserror ('Nie ma takiego klubu.', 11,1)
end try
begin catch
        SELECT ERROR_NUMBER() AS 'NUMER BLEDU', ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
