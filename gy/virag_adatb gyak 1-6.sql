-- 4 hiányzás max
-- 2x2 db(papíros, gépes) zh
-- 2. zh gyorsabb javítás, ergo könnyebb lesz(??) remélem
-- megint a vizsgaidõszak 1. 2 hetében lehet javítani (hétfõ-csüt., dec.18. - 1. hét, jan. 1. hete - 2. hét, 1 alkalommal 2-t lehet a 4-bõl)
-- 2. zh: sql parancsot kapunk, találjuk ki mit csinál a gép

-- http://people.inf.elte.hu/branyi/ora/gyak2/t01/abterv_feladatok1.txt

-- Adatb 1-en ezeket tanultuk/vettük

create table x (a number);

select * from user_objects; -- kiveszi csak a sajátunkat, de csak a sajátot tudjuk megjeleníteni, kihozza az összes sajátot
select * from dba_objects; -- ehhez nincs jogunk
select * from all_objects; -- kicsit kevesebb infót ad meg

select * from dba_objects where owner='OGEH67'; -- kihozza az összes sajátot
select * from all_objects where owner='OGEH67'; -- hiányzik belõle pár

select * from dba_objects where owner='BRANYI'; -- 205 adat
select * from all_objects where owner='BRANYI'; -- 200 adat, a maradék 5 database link jelszóval

select * from all_objects where object_name='X';
select * from all_objects where object_name='x';

select * from x;
select * from X;
select * from "x"; -- macskakörömmel számít a kis és nagybetû, különben nem;minden számít!!!
select * from "X";

create table "X" (a number); -- ha így createlünk, akkor csak nagy x-el tudunk hivatkozni
select * from "X"; -- magyarul így

select * from dba_objects where object_name='DBA_TABLES' and object_type='VIEW';
select owner from dba_objects where object_name='DBA_TABLES' and object_type='VIEW';
select owner from dba_objects where object_name='DUAL' and object_type='TABLE';

select 1+1 from dual; -- 1 sora van olyan tábla, tulajdon:
select 1+1 from x; -- 2 sora van
select 1+1 from "x"; -- 1sora sincs, nem kapuk meg az eredményt
select 1+1 from branyi.sz;
select * from branyi.sz;
-- dual: 

select * from dba_objects where object_name='DUAL' and object_type='TABLE';
create table dual (q varchar2(10));
select 1+1 from dual; -- saját dualt használja, ami üres, elõzõleg jó volt, itt meg nem, mert: a sajátot használja 
select 1+1 from sys.dual;
select 1+1 from jb9mrj.dual;

select * from dept;
select * from branyi.dept;
select * from sila.dept;

select 1+1 from dual;

select * from dba_objects where object_name='DBA_TABLES' and object_type='SYNONYM';
select * from dba_objects where object_name='DUAL' and object_type='SYNONYM'; -- a sys dualt sys.dualként kell meghívni, a publicot simán, helyettünk begépeli a gép
-- fogjuk venni a szinoníma készítést
select * from dba_synonyms where synonym_name='DUAL';

select * from dba_objects where owner='ORAUSER';
select object_type from dba_objects where owner='ORAUSER';
select distinct object_type from dba_objects where owner='ORAUSER';

select distinct object_type from dba_objects; -- kiírfja az összeset
select count(distinct object_type) from all_objects;
select count(distinct object_type) from user_objects;
select count(distinct object_type) from dba_objects; -- az kell nekünk hány darab


-- Kik azok a felhasználók, akiknek több mint 10 féle objektumuk van?
-- Ki hány féle objektumot használ?
select count(*) from dba_objects group by owner; -- aggregációs függvények: count, max
select owner, count(distinct object_type) from dba_objects group by owner;
select owner, count(distinct object_type) from dba_objects group by owner having count(distinct object_type)>10;

-- Kik azok a felhasználók, akiknek van triggere és nézete is?
select owner from dba_objects where object_type='TRIGGER'; -- nekik van triggerük
-- Descartes szorzat nem lenne rossz
select owner from dba_objects where object_type='TRIGGER' intersect select owner from dba_objects where object_type='VIEW';

-- Kik azok a felhasználók, akiknek van nézete, de nincs triggere?
select owner from dba_objects where object_type='VIEW' minus select owner from dba_objects where object_type='TRIGGER';

-- Kik azok a felhasználók, akiknek több mint 40 táblájuk, de maximum 37 indexük van?
select * from dba_objects where object_type='TABLE';
select owner, count(*) from dba_objects where object_type='TABLE' group by owner;
select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40;
-- de maximum 37 indexük van?
select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37;

select owner from dba_objects where object_type='TABLE' group by owner having count(*)>40
  intersect
  select owner from dba_objects where object_type='INDEX' group by owner having count(*)<=37; -- nem max 37, de 0<  <37
  -- a nulla indexûekkel van probléma
-- NEM JÓ A MEGOLDÁS!!!!! ha valakinek nulla indexe van, akkor az nem kerül be
-- Jó megoldás, hosszú
select owner from dba_objects where object_type='TABLE' group by owner having count(*)>40 intersect
((select owner from dba_objects where object_type='INDEX' group by owner having count(*)<=37)
union
(select owner from dba_objects minus select owner from dba_objects where object_type='INDEX'));
-- Jó megoldás rövid
select owner from dba_objects where object_type='TABLE' group by owner having count(*)>40
minus
select owner from dba_objects where object_type='INDEX' group by owner having count(*)<=37;











-- 2. gyakorlat

-- http://people.inf.elte.hu/branyi/ora/gyak2/t01/abterv_feladatok1.txt
select * from emp;
select * from nikovits.emp;

-- Táblák oszlopai
---------------
-- (DBA_TAB_COLUMNS)
select * from dba_tab_columns;
select * from user_tab_columns;
select * from dba_tab_columns where owner='NIKOVITS' and table_name='EMP';

desc nikovits.emp

-- Hány oszlopa van a nikovits.emp táblának?
select count(*) from dba_tab_columns where owner='NIKOVITS' and table_name='EMP';

-- Milyen típusú a nikovits.emp tábla 6. oszlopa?
select data_type from dba_tab_columns where owner='NIKOVITS' and table_name='EMP' and column_id=6;

-- Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek van 'Z' betûvel kezdõdõ oszlopa.
select distinct owner, table_name from dba_tab_columns where column_name like 'Z%';
-- ha nincs a distinct, akkor annyiszor fog megjelenni a táblanév ahány z-velkezdõdõ oszlopa van

-- Adjuk meg azoknak a tábláknak a nevét, amelyeknek legalább 8 darab dátum tipusú oszlopa van.
-- Nem jó megoldás: hiba: a táblában 8 db dátum típus kellene, de nikovitséban csak 1 van; több ember dobja így össze, ezért van benne az emp tábla ebbe, 28 db
select table_name from dba_tab_columns where data_type='DATE' group by table_name having count(*)>=8;
-- így mostmár tulajdonos szerint is csoportosít: 22 db
select table_name from dba_tab_columns where data_type='DATE' group by owner, table_name having count(*)>=8;
select owner, table_name, count(*) from dba_tab_columns where data_type='DATE' group by owner, table_name having count(*)>=8;
desc APEX_030200.WWV_FLOW_WORKSHEET_ROWS
-- jó megoldás adjuk meg azon táblák nevét, melynek legalább 8 dátum típusú oszlopa van: 21 db
select distinct table_name from dba_tab_columns where data_type='DATE' group by owner, table_name having count(*)>=8;

-- Adjuk meg azoknak a tábláknak a nevét, amelyeknek 1. es 4. oszlopa is VARCHAR2 tipusú.
-- Hibás megoldás :(, nem ugyanaz a 2 tábla
select table_name from dba_tab_columns where column_id=1 and data_type='VARCHAR2'
intersect
select table_name from dba_tab_columns where column_id=4 and data_type='VARCHAR2';
-- jó megoldás
select owner, table_name from dba_tab_columns where column_id=1 and data_type='VARCHAR2'
intersect
select owner, table_name from dba_tab_columns where column_id=4 and data_type='VARCHAR2';
desc sz

select * from dba_objects where object_name='SÖR';
select * from sila.sör;

-- HÁZI FELADAT
------------
-- Írjunk meg egy plsql procedúrát, amelyik a paraméterül kapott táblára kiírja az õt létrehozó CTREATE TABLE utasítást. 
--   PROCEDURE cr_tab(p_owner VARCHAR2, p_tabla VARCHAR2) 
-- Elég ha az oszlopok típusát és DEFAULT értékeit kíírja, és elég ha a következõ típusú oszlopokra mûködik.
-- CHAR, VARCHAR2, NCHAR, NVARCHAR2, BLOB, CLOB, NCLOB, NUMBER, FLOAT, BINARY_FLOAT, DATE, ROWID

-- Teszteljétek a procedúrát az alábbi táblával.
-- CREATE TABLE tipus_proba(c10 CHAR(10) DEFAULT 'bubu', vc20 VARCHAR2(20), nc10 NCHAR(10), 
--   nvc15 NVARCHAR2(15), blo BLOB, clo CLOB, nclo NCLOB, num NUMBER, num10_2 NUMBER(10,2), 
--   num10 NUMBER(10) DEFAULT 100, flo FLOAT, bin_flo binary_float DEFAULT '2e+38', 
--   bin_doub binary_double DEFAULT 2e+40,
--   dat DATE DEFAULT TO_DATE('2007.01.01', 'yyyy.mm.dd'), rid ROWID);
  


-- 2. feladatsor
-- http://people.inf.elte.hu/branyi/ora/gyak2/t02/abterv_feladatok2.txt
-- Egyéb objektumok (szinonima, szekvencia, adatbázis-kapcsoló)
-- ----------------
-- (DBA_SYNONYMS, DBA_VIEWS, DBA_SEQUENCES, DBA_DB_LINKS)

select * from nikovits.emp;
create synonym n for nikovits.emp;

select * from n;
select * from dba_synonyms;
select * from user_synonyms;

create synonym d for sys.dual;
select 1+1 from d;

select * from dba_synonyms where owner='PUBLIC' and synonym_name='DUAL';

select * from sila.szeret;

create view nevsor as select nev from sila.szeret;
select * from nevsor;

-- nincs jogunk más táblájába belenyúlni
insert into nevsor values('Zelefánt');

-- legtöbb esetben nem használható a nézet tábla bevitelre
-- nézet táblába mikor tudunk beleírni? meggátolhatja: 
-- distinct megtiltja a selectnek, hogy bevigyen adatot
create view nevsor2 as select distinct nev from sila.szeret;
insert into nevsor values('Zelefánt');
-- branyinál
-- x virtuális oszlop, nem tudja felbontani különbözõ részre
select * from emp;
create or replace view f as select ename, sal*deptno x from emp;
select * from f;
insert into f values('Zelefánt', 10000);
-- descartes szorzat, natural join is gátolja
create view minden as select * from emp natural join dept;
select * from minden;

create or replace force view "BRANYI"."ALMATSZERETOK" ("N", "GY") AS
  select "N", "GY" from sz where gy='alma';
select * from almatszeretok;
-- bekerül, de nem a nézetbe, hanem a szeretbe, bevinni engedni, de visszaengedni nem
-- a tárolás egtörténik
insert into almatszeretok values('Valaki', 'Valamit');

select * from user_views;
select * from dba_views;


-- DBA_SEQUENCES
create sequence qq
start with 10
increment by 5
nocycle
nocache;

select qq from dual;
-- nem mûködik, létrehozza a változót
select qq.currval from dual; -- jelenlegi adat
select qq.nextval from dual; -- következõ adat

select * from x;
insert into x values(qq.nextval);
insert into x values(qq.currval);

select * from user_sequences;
select * from dba_sequences;









-- 3. gyakorlat

-- grides gépen ezt írjuk be, mert nem használható az aramis
create database link aramis1 connect to ogeh67 IDENTIFIED by ogeh67 -- a végén kell a jelszó
using 'aramis';
create database link ax connect to ogeh67 IDENTIFIED by ogeh67 -- a végén kell a jelszó
using 'aramis.inf.elte.hu:1521/eszakigrid97';

select * from x;
select * from x@aramis1;
select * from x@aramis2;
select * from "x"@aramis2;

select * from NIKOVITS.VILAG_ORSZAGAI;
select * from NIKOVITS.folyok; -- nem látjuk
select * from NIKOVITS.folyok@aramis1; -- csak így látjuk, ha hivatkozunk

select * from NIKOVITS.VILAG_ORSZAGAI;


-- Feladatok
-- http://people.inf.elte.hu/nikovits/AB2/ab2_feladat2.txt

-- Adjuk meg azoknak az országoknak a nevét, amelyeket a Mekong nevû folyó érint.
select orszagok from NIKOVITS.folyok@aramis1 where nev='Mekong'; -- a rövidítést írja ki, nem az országnevet, nem is 
-- abc sorrendben szeretnénk, hanem olyan sorrendben, ahogy a táblában szerepel
-- select ... from ; -- ehhez tavaly tanultunk függvényt

select * from dba_db_links;
select * from user_db_links;

select * from DBA_DATA_FILES;
select * from DBA_temp_FILES;
select * from dba_tablespaces;

select * from DBA_SEGMENTS;
select * from user_SEGMENTS;

select * from dba_extens;
select * from user_extens;

-- select * from 
-- HIÁNYZIK!!!!!










-- 4. gyakorlat

-- házi feladat nem teljesen jó megoldása
select * from nikovits.folyok where nev='Mekong';
select orszagok from nikovits.folyok where nev='Mekong';
-- abc szerint
select * from nikovits.vilag_orszagai where (select orszagok from nikovits.folyok where nev='Mekong') like '%'||tld||'%';
select tld, nev from nikovits.vilag_orszagai where (select orszagok from nikovits.folyok where nev='Mekong') like '%'||tld||'%';
-- Kína legyen az elsõ, minden ország kap helyezést is, a listában hol helyezkedik el
-- ez lenne a jó megoldás, ezt kell megoldani

select * from user_tables;
-- megcsinálni a feladatokat, ilyenek lesznek a zh-n
-- http://people.inf.elte.hu/nikovits/AB2/ab2_feladat2.txt



-- http://people.inf.elte.hu/branyi/ora/gyak2/t03/abterv_feladatok3.txt

select * from sila.szeret;

select rownum, * from sila.szeret; -- nem mûködik így

select rownum, szeret.* from sila.szeret;
select rowid, szeret.* from sila.szeret;

-- google.hu: 216*256^3+58*256^2+209*256+163===3627733411 ezt az eredményt kell beírni a címsorba
-- google.hu: 216.58.209.163

select * from dba_objects where owner='SILA' and object_name='SZERET';
select * from dba_data_files;
select * from dba_tablespaces;

-- AABHsY|     AAE   |AAA    B   R t |AAA
-- 293656|     (4)   |     64^2 64 1
--       |users01.dbf|
-- 0-9   A-F   16
-- users01.dbf: 0, 1, 2, 3, ..., 1860000
--              ________________________
--              |_|_|_|_|.............|_|
-- blokkban: alulról felfele töltjük az adatokat
-- Oracle_storage_2.ppt: egyszer össze fog érni a 2 és akkor talik be



-- nikovitsos cikk táblás feladatok
-- zh: nikovits egyik táblájáról mit tudunk megadni
select * from nikovits.cikk;
select * from dba_tables where owner='NIKOVITS' and table_name='CIKK';
select blocks from dba_tables where owner='NIKOVITS' and table_name='CIKK';
select rowid, cikk.* from nikovits.cikk;
select substr(rowid, 10, 6) from nikovits.cikk;
select distinct substr(rowid, 10, 6) from nikovits.cikk;

-- A NIKOVITS felhasználó CIKK táblájának adatai hány blokkban helyezkednek el?
-- (Vagyis a tábla sorai ténylegesen hány blokkban vannak tárolva?)
-- !!! -> Ez a kérdés nem ugyanaz mint az elõzõ.
select count(distinct substr(rowid, 10, 6)) from nikovits.cikk; -- itt megkaptuk, hogy 4-ben már van adat


-- feladat: A NIKOVITS felhasználó CIKK táblája hány blokkot foglal le az adatbázisban?
-- (Vagyis hány olyan blokk van, ami ehhez a táblához van rendelve és így azok már más táblákhoz nem adhatók hozzá?)
-- mennyi helyet foglal el a lemezen nikovits cikk táblája

select * from dba_segments where owner='NIKOVITS' and segment_name='CIKK' and segment_type='TABLE';
select blocks from dba_segments where owner='NIKOVITS' and segment_name='CIKk' and segment_type='TABLE';

select * from dba_extents where owner='NIKOVITS' and segment_name='CIKK' and segment_type='TABLE'; 
-- 1 db 8 blokkos részbõl áll

select * from user_extens;
select *from user_segments;

select * from nikovits.cikk;
select rowid from nikovits.cikk;

-- Feladat
-- Az egyes blokkokban hány sor van?
select substr(rowid, 10, 6), count(*) from nikovits.cikk group by substr(rowid, 10, 6);
select count(distinct substr(rowid, 1, 15)) from nikovits.cikk; -- melyik fájlban melyik blokkban
--az azonos blokkokat tudja kezelni
select substr(rowid, 1, 15), count(*) from nikovits.cikk group by substr(rowid, 1, 15);
-- a 18 számjegybõl az utolsó 3-at nem veszi figyelembe, nincs rá szükség
-- melyikben hány sor van, azt megkapjuk ebbõl
-- hibás megoldás, kicsit


-- Feladat
-- Hozunk létre egy táblát, melynek szerkezete azonos a nikovits.cikk 
-- tábláéval és pontosan 128 KB helyet foglal az adatbázisban. Foglaljunk le manuálisan egy 
-- újabb 128 KB-os extenst a táblához. Vigyünk fel sorokat addig, amig az elsõ blokk tele nem 
-- lesz, és 1 további sora lesz még a táblának a második blokkban.
-- (A felvitelt plsql programmal végezzük és ne kézzel, mert úgy kicsit sokáig tartana.)

drop table cikkt;
create table cikkt
as select * from nikovits.cikk;
-- hogy kéne úgy másolni, hogy az adatok ne kerüljenek bele

select * from cikkt;
create table cikkt
as select * from nikovits.cikk where 0=1; -- csak a séma, adatok nélkül

select * from user_segments; -- nem jeleníti meg a táblánkat
select * from user_objects; -- megjeleníti a táblánkat
-- üres a tábla, de ezek után már megfogja, mert van benne adat
insert into cikkt values(1, 'x', 'szin', 2);
drop table cikkt;
-- aller table...

create table cikkt
tablespace example
storage (initial 128K)
as select * from nikovits.cikk where 1=0;
select * from cikkt;

select * from user_tables;
select * from user_objects;
select * from user_segments;

insert into cikkt values(1, 'valami', 'szin', 0);

select * from user_extents;
alter table cikkt allocate extent (size 128K);










-- 5. gyakorlat

-- újra ugyanaz a házi 
select * from branyi.vilag_orszagai where (select orszagok from nikovits.folyok where nev='Mekong') like '%'|| tld||'%';

select tld, nev from branyi.vilag_orszagai where (select orsszagok from nikovits.folyok where nev='Mekong') like '%'||tld||'%';

select tld, nev, instr ((select orszagok from nikovits.folyok where nev='Mekong'), tld) from branyi.vilag_orszagai
where instr((select orszagok from nikovits.folyok where nev='Mekong'), tld)>0;

select tld, nev, instr ((select orszagok from nikovits.folyok where nev='Mekong'), tld) from branyi.vilag_orszagai
where instr((select orszagok from nikovits.folyok where nev='Mekong'), tld)>0 order by 3;

accept x
select tld, nev, instr ((select orszagok from nikovits.folyok where nev='&x'), tld) from branyi.vilag_orszagai
where instr((select orszagok from nikovits.folyok where nev='&x'), tld)>0 order by 3;

-- ezután a papíros ZH-ra gyakoroltunk
-- http://people.inf.elte.hu/nikovits/AB2/ab2_feladat3.txt
-- fizika.ppt

/*k=0
n=0
m=0
i=0
küszöbszám 2,4
ha n>2^i*/

-- dinamikus tördelés (nikovits, .doc)
-- lineáris tördelés (fizika.ppt - 18. dia)
-- B+ fa (-- http://people.inf.elte.hu/nikovits/AB2/ab2_feladat4.txt)
-- addig kapunk pontot, amíg el nem rontjuk és a vágások azok plusz 1 pontot érnek
-- fizika.ppt (

-- bitmap
-- http://people.inf.elte.hu/branyi/ora/gyak2/t04/Adatok%20t%f6m%f6r%edt%e9se.htm

















-- 6. gyakorlat

select * from nikovits.folyok;

-- házit néztük, de nem kaptunk új megoldást

-- select rowid...
-- 4. gyak végét mutogatta, cikkt táblás feladattal foglalkoztunk
-- http://people.inf.elte.hu/branyi/ora/gyak2/t03/abterv_feladatok3.txt
-- az oldalon fent vannak a megoldások is

-- Feladat
-- Hozunk létre egy táblát az EXAMPLE táblatéren, amelynek szerkezete azonos a nikovits.cikk 
-- tábláéval és pontosan 128 KB helyet foglal az adatbázisban. Foglaljunk le manuálisan egy 
-- újabb 128 KB-os extenst a táblához. Vigyünk fel sorokat addig, amig az elsõ blokk tele nem 
-- lesz, és 1 további sora lesz még a táblának a második blokkban.
-- (A felvitelt plsql programmal végezzük és ne kézzel, mert úgy kicsit sokáig tartana.)

pctfree 10
pctused 30

alter table cikkt allocate extent (size 128K);

declare
db number;
begin
for i in 1..1000 loop
insert into cikkt select * from nikovits.cikk where i=ckod;
select count(distinct substr(rowid, 10, 6)) into db from cikkt;
-- select count(distinct substr(rowid, 10, 6)) from cikkt;
if db>1 then exit; end if;
end loop;
end;
/
-- ha select count(distinct substr(rowid, 10, 6)) from nikovits cikk; -- ide NEM lehet betenni ilyet
-- ezért hozunk létre változót

select substr(rowid, 10, 6), count(*) from cikkt group by substr(rowid, 10, 6);

delete from cikkt where ckod=1;
insert into cikkt values(1, 'x', 'szin', 2);

delete from cikkt where ckod<100;

create index cikksor on cikkt(ckod);
select * from cikkt;

create index cikksor on cikkt(ckod);
select * from cikkt order by ckod;

create index szinsor on cikkt(szin);
select * from cikkt order by szin;
create index szincnevsor on cikkt(szin, cnev);

create index szinvisszasulyeloresor on cikkt(szin desc, suly);
select * from cikkt order by szin desc, suly;
create index szinsulyvisszasor on cikkt(szin, suly desc);

create index szin2sor on cikkt(substr(szin, 2, 1));
select * from cikkt order by substr(szin, 2, 1);

create index sinsulysor on cikkt(sin(suly));
select cikkt.*, sin(suly) from cikkt order by sin(suly);
--sinusok alapján nagysági sorrend
-- select * from cikkt order by sin(suly);
-- súly szinusza alapján rakja sorba az adatokat
create szin2es5sor on cikkt(substr(szin, 2, 1)||substr(szin, 5, 1));
select cikkt.*, substr(szin, 2, 1) || substr(szin, 5, 1) from cikkt order by substr(szin, 2, 1) || substr(szin, 5, 1);
create index szinsulyvisszasor on cikkt(szin, suly desc);
-- desc: csökkenõ sorrend

select * from user_indexes;
-- amiket létrehoztunk meg tudjuk nézni ezzel
select dba_indexes;

select * from user_ind_columns;
-- hány oszlopot adtunk meg
-- hány oszlopos táblája van: user_tab_columns
select * from dba_ind_columns;

select * from user_ind_expressions;
select * from dba_ind_expressions;

select * from dba_ind_columns where descend='DESC';

select distinct table_name from dba_ind_columns where descend='DESC';

-- http://people.inf.elte.hu/branyi/ora/gyak2/t04/abterv_feladatok4.txt
--nikovits válasza nem jó erre
-- Adjuk meg azoknak a tábláknak a nevét, amelyeknek van csökkenõ sorrendben indexelt oszlopa.
select distinct table_owner, table_name from dba_ind_columns where descend='DESC';

select index_owner, index_name from dba_ind_columns
group by index_owner, index_name having count(*)>=9;

-- Adjuk meg azoknak az indexeknek a nevét, amelyek legalább 9 oszloposak.
-- (Vagyis a táblának legalább 9 oszlopát vagy egyéb kifejezését indexelik.)
select distinct index_owner, index_name from dba_ind_columns where column_position>=9;

-- Adjuk meg az SH.SALES táblára létrehozott bitmap indexek nevét.
-- tábla neve, tulajdonos, milyen indexek vannak hozzá
select index_name from dba_indexes
where table_owner='SH' and table_name='SALES' and index_type='BITMAP';

-- Adjuk meg azon kétoszlopos indexek nevét és tulajdonosát, amelyeknek legalább az egyik kifejezése függvény alapú.
-- hibás megint nikovitsé
-- 2 részre bontjuk a megoldást, elõször az egyiket oldjuk meg, majd a másikat
select index_owner, index_name from dba_ind_columns
group by index_owner, index_name having count(*)=2
intersect
select index_owner, index_name from dba_ind_expressions;

-- Adjuk meg az egyikükre, pl. az OE tulajdonában lévõre, hogy milyen kifejezések szerint vannak indexelve a soraik. 
-- (Vagyis mi a függveny, ami alapján a bejegyzések készülnek.)
select * from dba_ind_expressions where index_owner='OE';

drop index SYS_C00112782;