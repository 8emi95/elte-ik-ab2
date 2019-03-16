select * from user_objects; --saját objektumokat látjuk
select * from dba_objects; --ehhez nincs jogunk
--select * from Dba_Objects; --uaz, "-ben más!
select * from all_objects;

create table x (a number);
select * from dba_objects where owner='T6ESML';

select * from dba_objects where owner='BRANYI'; --205
select * from all_objects where owner='BRANYI'; --200, 5 hiányzó database link jelszóval
select * from all_objects where object_name='X';
select * from all_objects where object_name='x';

select * from x;
select * from X;
select * from "X"; -- "-ben nagybetûre vigyázni

select * from "x";
create table "x" (a number);

-- Kinek a tulajdonában van a DBA_TABLES nevû nézet (illetve a DUAL nevû tábla)?
select owner from dba_objects where object_name='DBA_TABLES' and object_type='VIEW';
select owner from dba_objects where object_name='DUAL' and object_type='TABLE';
--DBA rendszertábla nagybetû
--putty: postgres  -> select 1+1
select 1+1 from dual; --1x írja ki (1 sor)
select 1+1 from x; --2x (2 sor)
select 1+1 from "x"; --0x (0 sor)
select 1+1 from sz; --15x

select * from dba_objects where object_name='DUAL' and object_type='TABLE'; --7 sor... kövi sor után 8 (nekem 2...)
create table dual (q varchar2(10));
select 1+1 from dual; --saját (üres) dualt használja, 0 sor az elõbbi 1 helyett
select 1+1 from sys.dual; --1x
select 1+1 from jb9mrj.dual;

select * from dept;
select * from branyi.dept; --grant PUBLIC után jó (kéne h legye...)
select * from sila.dept;

select owner from dba_objects where object_name='DBA_TABLES' and object_type='SYNONYM';
select owner from dba_objects where object_name='DUAL' and object_type='SYNONYM'; --alias, ehhez van jogunk, ha nincs saját dual tábla akk ezt látjuk
--szinonima esetén hosszút 1 akármivel helyettesítjük
select * from dba_synonyms where synonym_name='DUAL';

-- Milyen típusú objektumai vannak az orauser nevû felhasználónak az adatbázisban?
select * from dba_objects where owner='ORAUSER';
select object_type from dba_objects where owner='ORAUSER';
select distinct object_type from dba_objects where owner='ORAUSER';

select count(distinct object_type) from dba_objects;

-- Hány különbözõ típusú objektum van nyilvántartva az adatbázisban? Melyek ezek?
select distinct object_type from dba_objects;
select count(distinct object_type) from all_objects;
select count(distinct object_type) from user_objects;
select count(distinct object_type) from dba_objects;

-- Kinek hányféle objektuma van?
select owner, count(distinct object_type) from dba_objects group by owner;
--group by-nál owner, count(distinct object_type) helyére: milyen szempont alapján csoportosít, * csak countnál aggregációs fveknél VAGY ami group bynál van
select count(*) from dba_objects group by owner;

-- Kik azok a felhasználók, akiknek több mint 10 féle objektumuk van?
select owner, count(distinct object_type) from dba_objects group by owner having count(distinct object_type)>10;
--where a group by elé, utána csak having

-- Kik azok a felhasználók, akiknek van triggere és nézete is?
--natural join nem jó mert egyezõ object_typeot keres
select * from dba_objects where object_type='TRIGGER'
intersect
select * from dba_objects where object_type='VIEW';
--* nem jó
select owner from dba_objects where object_type='TRIGGER'
intersect
select owner from dba_objects where object_type='VIEW';

-- Kik azok a felhasználók, akiknek van nézete, de nincs triggere?
select owner from dba_objects where object_type='TRIGGER'
minus
select owner from dba_objects where object_type='VIEW';

-- kinek hány tábla
select * from dba_objects where object_type='TABLE';
select owner, count(*) from dba_objects where object_type='TABLE' group by owner;
-- Kik azok a felhasználók, akiknek több mint 40 táblájuk, de maximum 37 indexük van?
select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40;
select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37;

select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40
intersect
select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37;
--nem jó megoldás értelmileg

select owner from dba_objects where object_type='TABLE' group by owner having count(*)>40
intersect
select owner from dba_objects where object_type='INDEX' group by owner having count(*)<=37; --feltételezi h van indexe
--még mindig hibás (intersect miatt nem stimmel a szám) ha 0 indexe van akk a 2. indexekben nem lesz benne a neve
--összes userból kivesszük azt akinek van indexe...