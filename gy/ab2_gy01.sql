select * from user_objects; --saj�t objektumokat l�tjuk
select * from dba_objects; --ehhez nincs jogunk
--select * from Dba_Objects; --uaz, "-ben m�s!
select * from all_objects;

create table x (a number);
select * from dba_objects where owner='T6ESML';

select * from dba_objects where owner='BRANYI'; --205
select * from all_objects where owner='BRANYI'; --200, 5 hi�nyz� database link jelsz�val
select * from all_objects where object_name='X';
select * from all_objects where object_name='x';

select * from x;
select * from X;
select * from "X"; -- "-ben nagybet�re vigy�zni

select * from "x";
create table "x" (a number);

-- Kinek a tulajdon�ban van a DBA_TABLES nev� n�zet (illetve a DUAL nev� t�bla)?
select owner from dba_objects where object_name='DBA_TABLES' and object_type='VIEW';
select owner from dba_objects where object_name='DUAL' and object_type='TABLE';
--DBA rendszert�bla nagybet�
--putty: postgres  -> select 1+1
select 1+1 from dual; --1x �rja ki (1 sor)
select 1+1 from x; --2x (2 sor)
select 1+1 from "x"; --0x (0 sor)
select 1+1 from sz; --15x

select * from dba_objects where object_name='DUAL' and object_type='TABLE'; --7 sor... k�vi sor ut�n 8 (nekem 2...)
create table dual (q varchar2(10));
select 1+1 from dual; --saj�t (�res) dualt haszn�lja, 0 sor az el�bbi 1 helyett
select 1+1 from sys.dual; --1x
select 1+1 from jb9mrj.dual;

select * from dept;
select * from branyi.dept; --grant PUBLIC ut�n j� (k�ne h legye...)
select * from sila.dept;

select owner from dba_objects where object_name='DBA_TABLES' and object_type='SYNONYM';
select owner from dba_objects where object_name='DUAL' and object_type='SYNONYM'; --alias, ehhez van jogunk, ha nincs saj�t dual t�bla akk ezt l�tjuk
--szinonima eset�n hossz�t 1 ak�rmivel helyettes�tj�k
select * from dba_synonyms where synonym_name='DUAL';

-- Milyen t�pus� objektumai vannak az orauser nev� felhaszn�l�nak az adatb�zisban?
select * from dba_objects where owner='ORAUSER';
select object_type from dba_objects where owner='ORAUSER';
select distinct object_type from dba_objects where owner='ORAUSER';

select count(distinct object_type) from dba_objects;

-- H�ny k�l�nb�z� t�pus� objektum van nyilv�ntartva az adatb�zisban? Melyek ezek?
select distinct object_type from dba_objects;
select count(distinct object_type) from all_objects;
select count(distinct object_type) from user_objects;
select count(distinct object_type) from dba_objects;

-- Kinek h�nyf�le objektuma van?
select owner, count(distinct object_type) from dba_objects group by owner;
--group by-n�l owner, count(distinct object_type) hely�re: milyen szempont alapj�n csoportos�t, * csak countn�l aggreg�ci�s fvekn�l VAGY ami group byn�l van
select count(*) from dba_objects group by owner;

-- Kik azok a felhaszn�l�k, akiknek t�bb mint 10 f�le objektumuk van?
select owner, count(distinct object_type) from dba_objects group by owner having count(distinct object_type)>10;
--where a group by el�, ut�na csak having

-- Kik azok a felhaszn�l�k, akiknek van triggere �s n�zete is?
--natural join nem j� mert egyez� object_typeot keres
select * from dba_objects where object_type='TRIGGER'
intersect
select * from dba_objects where object_type='VIEW';
--* nem j�
select owner from dba_objects where object_type='TRIGGER'
intersect
select owner from dba_objects where object_type='VIEW';

-- Kik azok a felhaszn�l�k, akiknek van n�zete, de nincs triggere?
select owner from dba_objects where object_type='TRIGGER'
minus
select owner from dba_objects where object_type='VIEW';

-- kinek h�ny t�bla
select * from dba_objects where object_type='TABLE';
select owner, count(*) from dba_objects where object_type='TABLE' group by owner;
-- Kik azok a felhaszn�l�k, akiknek t�bb mint 40 t�bl�juk, de maximum 37 index�k van?
select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40;
select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37;

select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40
intersect
select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37;
--nem j� megold�s �rtelmileg

select owner from dba_objects where object_type='TABLE' group by owner having count(*)>40
intersect
select owner from dba_objects where object_type='INDEX' group by owner having count(*)<=37; --felt�telezi h van indexe
--m�g mindig hib�s (intersect miatt nem stimmel a sz�m) ha 0 indexe van akk a 2. indexekben nem lesz benne a neve
--�sszes userb�l kivessz�k azt akinek van indexe...