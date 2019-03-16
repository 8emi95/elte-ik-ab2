/*instr(hol keressen;mit keressen; )*/

accept x
select tld, nev,instr((select orszagok from nikovits.folyok where nev='&x'),tld) from branyi.vilag_orszagai
where instr((select orszagok from nikovits.folyok where nev='&x'),tld)>0 order by 1;

select nev,orszagok from nikovits.folyok;

/*************************************************************************/


select * from user_objects;
select * from dba_objects; // mindenkire vonatkozó

select * from all_objects;

select * from dba_objects where owner='BRANYI';
select * from Dba_Objects where owner='BRANYI'; /* a kettõ ua */ 

select * from all_objects where owner='BRANYI'; //


select * from all_objects where object_name='X'; //
select * from dba_objects where object_name='x'; //

/**/
create table x(a number);
select * from x;
select * from X;
select * from "X";
/**/
create table "x" (a number);


/*1. Kinek a tulajdonában van a DBA_TABLES nevû nézet (illetve a DUAL nevû tábla)?*/

select * from dba_objects where object_name='DBA_TABLES' and object_type='VIEW';
/*Jó válasz: */ select owner from dba_objects where object_name='DBA_TABLES' and object_type='VIEW';
/*DUAL:*/

select * from dba_objects where object_name='DUAL' and object_type='TABLE';

select 1+1 from dual;

/*Dual: tábla, aminek 1 sora van*/
select 1+1 from x;
select 1+1 from "x";
/*Egy saját dual létrehozása esetén a (select 1+1 from dual) a saját létrehozott táblát használja és mivel 0 soros, nem ír ki semmit*/
select * from sz;
select 1+1 from sz;

select 1+1 from sys.dual;
select 1+1 from v6rkh9.dual;




select * from branyi.dept;
select * from sila.dept;



/*2. Kinek a tulajdonában van a DBA_TABLES nevû szinonima (illetve a DUAL nevû)?
(Az iménti két lekérdezés megmagyarázza, hogy miért tudjuk elérni õket.)*/
select * from dba_objects where object_name='DBA_TABLES' and object_type='SYNONYM';
/*Ha nincs saját dual, akkor a public tulajdonában lévõ dualt látjuk, ami hozzáfárési engedély a sys dual táblájához. 
A puclic szinoníma. A publikot helybõl látjuk, ha enm takarja le valami, pl az általunk létrehozott saját dual tábla*/


select * from dba_synonyms where synonyms_name='DUAL';




/* 3 Milyen típusú objektumai vannak az orauser nevû felhasználónak az adatbázisban?*/
select distinct object_type from dba_objects where owner='ORAUSER';
/* 4 Hány különbözõ típusú objektum van nyilvántartva az adatbázisban?*/
select count(distinct object_type) from dba_objects;
select distinct object_type from dba_objects;


/* 5 Kik azok a felhasználók, akiknek több mint 10 féle objektumuk van?*/

select * from dba_objects;

select owner,count(distinct object_type) as db from dba_objects group by owner having count(distinct object_type)>10;

select owner,count(*) as db from dba_objects group by owner ;
/*(*)-ot csak counttal*/
/*select és a group közé kell, ami alapján csoportosítuink*/

/*
Kik azok a felhasználók, akiknek van triggere és nézete is?*/

select * from dba_objects where object_type='TRIGGER';
select owner from dba_objects where object_type='TRIGGER' intersect select owner from dba_objects where  object_type='VIEW';

/*Kik azok a felhasználók, akiknek van nézete, de nincs triggere?*/
select owner from dba_objects where object_type='VIEW' minus select owner from dba_objects where  object_type='TRIGGER';

/*SQL-ben a kivonás mûvelete: Attól függ...
: egyik a minus
: másik except (szabvány szerint)
*/


/**************************************************************************************************************************************************************************
//Gyakorlat 2 (09.19)


/*Kik azok a felhasználók, akiknek több mint 40 táblájuk, de maximum 37 indexük van?*/

select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40 order by count(*) desc;

select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37 ; /* kevesebb mint 37 index*/



/*MO::: */

select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40 
intersect
(
(select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37)
union
(select owner from dba_objects minus select owner from dba_objects where object_type='INDEX')
);
/******************************************************************************/
select owner, count(*) from dba_objects where object_type='TABLE' group by owner having count(*)>40 
minus
select owner, count(*) from dba_objects where object_type='INDEX' group by owner having count(*)<=37; 

/*ÚJABB RENSZERTÁBLA:::: DBA_TAB_COLUMNS*/
select * from nikovits.emp;

SELECT * FROM DBA_TAB_COLUMNS; /* összes ember összes táblájának összes oszlopa*/
select * from DBA_TAB_COLUMNS where owner='NIKOVITS' and table_name='EMP';
-- nikovits.emp; /*yes-kötelezõ*/
/*DBA_TAB_COLUMNS yes-nem kötelezõ*/

desc nikovits.emp;
/*number(7,2) : 7 jegyû szám 2 tizedes*/

/*
Hány oszlopa van a nikovits.emp táblának?*/
select count(*) from DBA_TAB_COLUMNS where owner='NIKOVITS' and table_name='EMP';

/*Milyen típusú a nikovits.emp tábla 6. oszlopa?*/
select data_type from DBA_TAB_COLUMNS where owner='NIKOVITS' and table_name='EMP' and COLUMN_ID=6;

/*Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek van 'Z' betûvel kezdõdõ oszlopa.*/

select OWNER,TABLE_NAME from DBA_TAB_COLUMNS where COLUMN_NAME like 'Z%';

/*
Adjuk meg azoknak a tábláknak a nevét, amelyeknek legalább 8 darab dátum tipusú oszlopa van.*/
select * from DBA_TAB_COLUMNS where owner='NIKOVITS' and table_name='EMP';
/*count nincs where-ben ->having amihez meg csoportosítani kell*/
select table_name from DBA_TAB_COLUMNS where data_type='DATE' Group by table_name having count(*)>=8; /*több ember összedobta*/

select table_name, count(*) from DBA_TAB_COLUMNS where data_type='DATE' Group by table_name, owner having count(*)>=8; /*kell az owner, hogy emberenként nézze*/

desc WWV_FLOW_WORKSHEET_ROWS;


select distinct table_name from DBA_TAB_COLUMNS 
where data_type='DATE' Group by owner, table_name having count(*)>=8; /*kell az owner, hogy emberenként nézze*/


/*Adjuk meg azoknak a tábláknak a nevét, amelyeknek 1. es 4. oszlopa is VARCHAR2 tipusú.*/

select table_name from DBA_TAB_COLUMNS where column_id=1 and data_type='VARCHAR2' intersect
select table_name from DBA_TAB_COLUMNS where column_id=4 and data_type='VARCHAR2'; /*pl: SÖR tábla nem jó*/

select owner, table_name from DBA_TAB_COLUMNS where column_id=1 and data_type='VARCHAR2' intersect
select owner, table_name from DBA_TAB_COLUMNS where column_id=4 and data_type='VARCHAR2'; /*KELL: owner*/

select * from dba_objects where object_name='SÖR';


/*************************************************2. FELADATSOR*********************************************************************/

create synonym n for nikovits.emp;
select * from n;
select * from dba_synonyms;
select * from SYS.USER_SYNONYMS;
create synonym d for dual;
select * from d;
select 1+1 from d;

select * from dba_synonyms where owner='PUBLIC' and SYNONYM_NAME='DUAL';

create view sz as select * from nikovits.szeret; 
select * from sz;
                                                                    /******/
create view nevsor as select nev from sila.szeret;
create view nevsor2 as select distinct nev from sila.szeret;
select * from nevsor;
select * from nevsor2;
insert into nevsor values('Zelefant'); /*nincs jogosultság sila.szeret táblához*/
/*Van jog, de mégsem lehet bevinni: ha nem lehet NULL érték; ha egy megszorítás megakadályozza [megszorítás]*/

create or replace view f as select sal*deptno x from sila.emp;
select * from f;
insert into f values('Zelefánt',10000); /*nem*/

create view minden as select * from sila.emp natural join sila.dept;

select * from minden; /*deptno 2 táblában van, nem vihetünk fel új adatot*/

select * from user_views;

select * from SYS.DBA_VIEWS;
select * from dba_views;

/*SEQUENCE --- DBA_SEQUENCES*/

create sequence q 
start with 10
increment by 5--hanyasával
nocycle
nocache;

select q from dual; --nem 
select q.currval from dual;
select q.nextval from dual; -- add meg a következõt

select * from X;

insert into X values(q.nextval);
insert into X values(q.currval);

select * from SYS.USER_SEQUENCES;
select * from SYS.DBA_SEQUENCES;



/***********************************GYAK3 ARAMISON FOLYT****************************************************/ 

select * from dba_data_files;/*milyen fileokból áll az adatbázis*/
/*user_data_files- NINCS, nem tudok fileokat tárolni*/
select * from DBA_TEMP_FILES;
select * from DBA_TABLESPACES;/*táblaterek*/
select * from DBA_SEGMENTS;
select * from user_SEGMENTS;

select * from dba_db_links;
select * from user_db_links;

select * from DBA_EXTENTS;
select * from user_EXTENTS;

select * from dba_tables;
select * from user_tables;


/*GYAKORLAT4*/

select * from nikovits.vilag_orszagai where
(select orszagok from nikovits.folyok where nev='Mekong') like '&'||tld||'&';


/*ab2_feladat2.txt--> Nikovits; kövi hétre : ilyen jellegû feladatok a ZH-ban*/

select * from user_tables; /*partitioned: yes: szét van vágva a tábla; nem tudjuk melyik táblatéren van*/
/*Melyik táblatéren van a NIKOVITS felhasználó ELADASOK táblája? (Miért lesz null?): több kicsit részbõl fog állni, nem tudjuk találni 
dba_table-ben nikovits felhasználó 

*/

select * from sila.szeret; 
--http://people.inf.elte.hu/branyi/ora/gyak2/t03/abterv_feladatok3.txt
--select rownum, * from sila.szeret; -- * nélkül mûködik, de a kettõt együtt szeretnénk (sorszám és az összes oszlop tartalmának kiíratása)
--fárasztó lenne az összes oszlop kiírása (* mellé semmit sem lehet írni, akkor mégis hogy lehet mégis rávenni? MO: szeret.*)
--rownum: nem része a sila.szeret táblának, mégis ki lehet íratni
--MO: select rownum, szeret.* from sila.szeret;
--rowid: minden oszlop mellé ez is kérhetõ (nem a tábla része, mégis kérhetõ): 18 jegyû számot ad 
--számrendszer: elterjedt, napi használat: 157.181.6284 (157.181: ELTE-s gépek) (62: gépterem) (84:gép) :: 256-os számrendszer
--216.58.209.163: GOOGLE 256-os számrendszerben
--216*256^3+58*256^2+209*256+163: GOOGLE  10-es számrendszerben
-- 192.168-al kezdõdõ gépeink száma max: 65000 gép kezelhetõ; Több esetvén: 10-esell kezdük és utána a 3 szám
--16-os számrendszer: 0-9 ; A-F
--64-es számrendszer: 64 db számjegy ; magyarázat--> branyi gyak2:feladatok 3


select rowid, szeret.* from sila.szeret;
--elsõ 6 számjegy: AABHsY <=> 293 656-os objektum (meghatározza az objektum azonosítóját): dba_objects megadja az összes objektum azonosítóját
select * from dba_objects;
--AAE (dba_data_files; file_id)
select * from dba_data_files;
--milyen hosszú lehet egy fájl(állomány) 1 blokk: 8kilobájt
--64 kilobájt*blokkok száma*fileok száma; ekkora tárterületet tud kezelni
--utolsó 3 számjegy: blokkon belül hol helyezkedik el az adott sor [select rowid, szeret.* from sila.szeret;] -- sorok száma visszafele nõ

select * from nikovits.cikk;
/*FF: 
A NIKOVITS felhasználó CIKK táblája hány blokkot foglal le az adatbázisban?
(Vagyis hány olyan blokk van, ami ehhez a táblához van rendelve és így
azok már más táblákhoz nem adhatók hozzá?)

--MO vázlat: több válasz is van; kérdés melyik mire jó

A NIKOVITS felhasználó CIKK táblájának adatai hány blokkban helyezkednek el?
(Vagyis a tábla sorai ténylegesen hány blokkban vannak tárolva?)
!!! -> Ez a kérdés nem ugyanaz mint az elõzõ.*/


select blocks from dba_tables where owner='NIKOVITS' and table_name='CIKK'; --egyikre se jó a válasz
select rowid,cikk.* from nikovits.cikk; --utolsó 3 elõtti részt csak kiíratni. 

select substr(rowid,10,6) from nikovits.cikk;
select distinct substr(rowid,10,6) from nikovits.cikk;
select count(distinct substr(rowid,10,6)) from nikovits.cikk; -- 2. kérdésre a válasz; 1000 adat melyik blokkban helyzkedik el? 

--objektum, amelyik tartalmaz adatot: Honnan tudjuk, hogy mennyi helyet foglal el ez az objektum? 
/*select * from DBA_EXTENTS;
select * from DBA_sequment where owner='NIKOVITS' and sequment_NAME='CIKK' and sequment_TYPE='TABLE';
select * from user_seqments;---rossz*/

--1-1 blokkban hány sor van? 
select substr(rowid,10,6),count(*) from nikovits.cikk group by substr(rowid,10,6);


select substr(rowid,10,6) from nikovits.cikk;
select rowid,cikk.* from nikovits.cikk;
--Objektum: lehet partitioned, nem jó a mo (FFF megváltozott közben)

--MO:
select substr(rowid,1,15) from nikovits.cikk; -- figyelembe veszi, hogy hanyag fileban van
select substr(rowid,1,15), count(*) from nikovits.cikk group by substr(rowid,1,15); -- jó megoldás (KÉRDÉS:Az egyes blokkokban hány sor van?)


/*Hozunk létre egy táblát az EXAMPLE táblatéren, amelynek szerkezete azonos a nikovits.cikk 
tábláéval és pontosan 128 KB helyet foglal az adatbázisban. Foglaljunk le manuálisan egy 
újabb 128 KB-os extenst a táblához.*/
select * from nikovits.cikk;

drop table cikkt;
CREATE TABLE cikkt
tablespace example
as select * from nikovits.cikk where 0=1; -- kell a feltétel, hogy nem lemásolja a táblát
--megszorításokat pótolni kell

select * from cikkt;

select * from user_tables;
select * from user_segments; --ures tábla nincs benne
select * from user_objects;

insert into cikkt values(1,'x','szin',2);


--MOST kell: ne 64-et hanem 128:: storage initial
CREATE TABLE cikkt
tablespace example
storage (initial 128K)
as select * from nikovits.cikk where 0=1;

--Foglaljunk le még 128-at: (utólagos foglalás): ALTER TABLE

alter table cikkt allocate extent (size 128);

--+ PLSQL programmal feltölteni??? 


/*GYAK 6- 2017.10.17*/





/*B+ fa index
-----------
Az alábbi feladatban a tankönyben leírt és az elõadáson is bemutatott algoritmussal 
építsünk fel egy B+ fát!

Tegyük fel, hogy egy B+ fa blokkjaiba 3 kulcs fér el plusz 4 mutató. A kulcsok 
különbözõek. Szúrjuk be a B+ fába az alábbi kulcsértékeket a megadott sorrendben:
39,15,50,70,79,83,72,43,75,45
Adjuk meg a B+ fa minden olyan állapotát, amikor egy csomópont kettéosztására volt szükség.
Például, az elsõ kettéosztás utáni állapot:
                          50
                    15|39    50|70

Egy kis segítség:
----------------

Levél csúcs kettéosztásakor minden kulcsot megõrzünk a régi és az új (szomszédos) csúcsban.
1 új kulcs-mutató párt küldünk felfelé a szülõ csúcsba, amit ott kell elhelyezni.

Belsõ csúcs kettéosztásakor (N,M csúcsra) a mutatók elsõ fele az N-be kerül, a második az M-be.
A kulcsok elsõ fele az N-be kerül a második fele az M-be, de középen kimarad egy kulcs,
ami az M-en keresztül (elsõ gyermekén keresztül) elérhetõ legkisebb kulcsot tartalmazza. 
Ez nem kerül sem N-be, sem M-be, hanem ez megy fölfelé N és M közös szülõjébe az M-re mutató
mutatóval együtt.


Bitmap index
------------

DKOD DNEV   FIZETES  FOGLALKOZAS  BELEPES  OAZON
---------------------------------------------------
1    SMITH     800   CLERK        1980     20   
2    ALLEN    1600   SALESMAN     1981     30	   
3    WARD     1250   SALESMAN     1981     30	   
4    JONES    2975   MANAGER      1981     20	   
5    MARTIN   1250   SALESMAN     1981     30	   
6    BLAKE    2850   MANAGER      1981     30	   
7    CLARK    2450   MANAGER      1981     10	   
8    SCOTT    3000   ANALYST      1982     20	   
9    KING     5000   PRESIDENT    1981     10	   
10   TURNER   1500   SALESMAN     1981     30	   
11   ADAMS    1100   CLERK        1983     20	   
12   JAMES     950   CLERK        1981     30	   
13   FORD     3000   ANALYST      1981     20	   
14   MILLER   1300   CLERK        1982     10	 


Készítsen bitmap indexet a dolgozó tábla OAZON oszlopára és adja meg a bitvektorokat.

Tegyük fel, hogy a FOGLALKOZAS, a BELEPES és az OAZON oszlopokra létezik bitmap index (3 index).
Készítsük el az alábbi lekérdezésekhez szükséges bitvektorokat, majd végezzük el rajtuk a szükséges 
mûveleteket, és adjuk meg azt az elõállt bitvektort, ami alapján a végeredmény sorok megkaphatók.
Ellenõrzésképpen adjuk meg a lekérdezést SQL-ben is.
 
- Adjuk meg azoknak a dolgozóknak a nevét, akik 1981-ben léptek be és a foglalkozásuk hivatalnok (CLERK),
  vagy a 20-as osztályon dolgoznak és a foglalkozásuk MANAGER.

- Adjuk meg azoknak a dolgozóknak a nevét, akik nem 1981-ben léptek be és a 10-es vagy a 30-as 
  osztályon dolgoznak.

Tömörítse a következõ bitvektort a szakaszhossz kódolással. (lásd UW_szakaszhossz_kodolas.doc)
0000000000000000000000010000000101

Fejtsük vissza a következõ, szakaszhossz kódolással tömörített bitvektort:
1111010101001011



Oracle indexek  
--------------
(DBA_INDEXES, DBA_IND_COLUMNS, DBA_IND_EXPRESSIONS)

Hozzunk létre egy vagy több táblához több különbözõ indexet, legyen köztük több oszlopos,
csökkenõ sorrendû, bitmap, függvény alapú stb. (Ehhez használhatók az ab2_oracle.doc
állományban szereplõ példák, vagy a cr_index.txt-ben szereplõk.)
Az alábbi lekérdezésekkel megállapítjuk az iménti indexeknek mindenféle tulajdonságait a 
katalógusokból.

Adjuk meg azoknak a tábláknak a nevét, amelyeknek van csökkenõ sorrendben indexelt oszlopa.
--------------------------------------------------------------------------------
SELECT * FROM dba_ind_columns WHERE descend='DESC' AND index_owner='NIKOVITS';

Miért ilyen furcsa az oszlopnév?
-> lásd DBA_IND_EXPRESSIONS

Adjuk meg azoknak az indexeknek a nevét, amelyek legalább 9 oszloposak.
(Vagyis a táblának legalább 9 oszlopát vagy egyéb kifejezését indexelik.)
--------------------------------------------------------------------------------
SELECT index_owner, index_name FROM dba_ind_columns 
GROUP BY index_owner, index_name HAVING count(*) >=9;

Adjuk meg az SH.SALES táblára létrehozott bitmap indexek nevét.
--------------------------------------------------------------------------------
SELECT index_name FROM dba_indexes 
WHERE table_owner='SH' AND table_name='SALES' AND index_type='BITMAP';

Adjuk meg azon kétoszlopos indexek nevét és tulajdonosát, amelyeknek legalább 
az egyik kifejezése függvény alapú .
--------------------------------------------------------------------------------
SELECT index_owner, index_name FROM dba_ind_columns 
GROUP BY index_owner, index_name HAVING count(*) >=2
 INTERSECT
SELECT index_owner, index_name FROM dba_ind_expressions;

Adjuk meg az egyikükre, pl. az OE tulajdonában lévõre, hogy milyen kifejezések szerint 
vannak indexelve a soraik. (Vagyis mi a függveny, ami alapján a bejegyzések készülnek.)
--------------------------------------------------------------------------------
SELECT * FROM dba_ind_expressions WHERE index_owner='OE';

Adjuk meg a NIKOVITS felhasználó tulajdonában levõ index-szervezett táblák nevét.
(Melyik táblatéren vannak ezek a táblák? -> miért nem látható?)
--------------------------------------------------------------------------------
SELECT owner, table_name, iot_name, iot_type FROM dba_tables 
WHERE owner='NIKOVITS' AND iot_type = 'IOT';

Adjuk meg a fenti táblák index részét, és azt, hogy ezek az index részek (szegmensek) 
melyik táblatéren vannak?
--------------------------------------------------------------------------------
SELECT table_name, index_name, index_type, tablespace_name FROM dba_indexes 
WHERE table_owner='NIKOVITS' AND index_type LIKE '%IOT%TOP%';

Keressük meg a szegmensek között az elõzõ táblákat illetve indexeket, és adjuk
meg a méretüket.
--------------------------------------------------------------------------------
SELECT table_name, index_name, index_type, s.bytes
FROM dba_indexes i, dba_segments s 
WHERE i.table_owner='NIKOVITS' AND i.index_type LIKE '%IOT%TOP%'
AND i.index_name=s.segment_name AND s.owner='NIKOVITS';

Keressük meg az adatbázis objektumok között a fenti táblákat és indexeket, és adjuk
meg az objektum azonosítójukat és adatobjektum azonosítójukat (DATA_OBJECT_ID).

Adjuk meg a fenti táblák túlcsordulási részeit (ha van).
--------------------------------------------------------------------------------
SELECT owner, table_name, iot_name, iot_type FROM dba_tables 
WHERE owner='NIKOVITS' AND iot_type = 'IOT_OVERFLOW';

Keressük meg a túlcsordulási részeket a szegmensek között és adjuk meg a méretüket.
--------------------------------------------------------------------------------
SELECT t.owner, t.table_name, t.iot_name, t.iot_type, s.bytes 
FROM dba_tables t, dba_segments s
WHERE t.owner='NIKOVITS' AND t.iot_type = 'IOT_OVERFLOW'
AND s.owner='NIKOVITS' AND s.segment_name=t.table_name;

Keressük meg az objektum azonosítóikat és az adatobjektum azonosítóikat is.

Írjunk meg egy plsql procedúrát, amelyik a paraméterül kapott index szervezett 
tábláról kiírja a tábla méretét. 
   PROCEDURE iot_meret(p_owner VARCHAR2, p_tabla VARCHAR2) 
Vigyázzunk, mert a táblának lehet index és túlcsordulási szegmense is.

Adjuk meg azokat az index szervezett táblákat, amelyeknek pontosan 
1 dátum típusú oszlopa van.
--------------------------------------------------------------------------------
SELECT owner, table_name FROM dba_tables WHERE iot_type = 'IOT'
 INTERSECT
SELECT owner, table_name FROM dba_tab_columns
WHERE data_type='DATE' GROUP BY owner, table_name
HAVING count(*) = 1;

Adjuk meg, hogy mennyi a blokkolási faktora (a blokkban lévõ sorok átlagos száma) 
a következõ tábláknak. (Az üres blokkokat ne vegyük figyelembe.)
NIKOVITS.CIKK, SH.CUSTOMERS*/



--3-as feladatsor (Nikovits)

/*Hozzunk létre egy táblát az EXAMPLE táblatéren, amelynek szerkezete azonos a nikovits.cikk 
tábláéval és pontosan 128 KB helyet foglal az adatbázisban. Foglaljunk le manuálisan további 
128 KB helyet a táblához. 

Vigyünk fel sorokat addig, amig az elsõ blokk tele nem 
lesz, és 1 további sora lesz még a táblának a második blokkban.
(A felvitelt plsql programmal végezzük és ne kézzel, mert úgy kicsit sokáig tartana.)
*/
/*ha 2 blokkot használna a gép, álljon le*/

-- INSERT: tnév VALUES -- egy sor bevitelére 
-- INSERT tnév SELECT 
--into valtozo (a select értéke kerüljön a változóba) 
select * from nikovits.cikk;
select count(distinct substr(rowid,10,6)) from cikkt;


declare 
db number;
begin 

for i in 1..1000 loop 
insert into cikkt select * from nikovits.cikk where i=ckod;
select count(distinct substr(rowid,10,6)) into db from cikkt;
if db>1 then exit;
end if;
end loop;
END;
/


select * from cikkt;

/*4-es feladatsor__ NIKOVITS*/

/*
INDEX létrehozása: CREATE index ON (+ milyen táblában, milyen szempot alapján legyen)
(lehet--bitmap;B+fa)

*/
--EGYSZERÛ NORMÁL INDEX

create index cikksor on cikkt(ckod); --index ckod alapján a cikkt táblában
--INDEX jó: adatokat megkeresni ; 
select * from cikkt order by ckod;


create index szinindex on cikkt(szin);
select * from cikkt order by szin;

create index szinvisszasor on cikkt(szin desc); --fv-szerû (SYS_NC00006--figyelmeztetés, másik "táblára mutat--> user_ind_expressions;" )
create index sulyvissza on cikkt(szin,suly desc)

create index szin2sor cikkt(substr(szin,2,1)); --szin 2. betûre alapján rakja sorrendbe

create index szin2sor cikkt(substr(szin,2,1)||substr(szin,5,1));
--sin alapján is sorba lehet rakni 
create index sinindexsuly cikkt(sin(suly));
--indexek kiíratása
select * from user_indexes order by index_type;
select * from dba_indexes; -- ki csinált indexet

select * from user_ind_columns; -- indexek oszlopa, hány szempontot adtunk ()-ben

select * from user_ind_expressions; --mi volt a képlet ; csak a fv-esek jelennek meg




Adjuk meg azoknak az indexeknek a nevét, amelyek legalább 9 oszloposak.
(Vagyis a táblának legalább 9 oszlopát vagy egyéb kifejezését indexelik.)
--------------------------------------------------------------------------------
SELECT index_owner, index_name FROM dba_ind_columns 
GROUP BY index_owner, index_name HAVING count(*) >=9;--költséges mo
--mo 2:
select distinct index_owner, index_name FROM dba_ind_columns where column_position>=9;


Adjuk meg azoknak a tábláknak a nevét, amelyeknek van csökkenõ sorrendben indexelt oszlopa.
--------------------------------------------------------------------------------
SELECT * FROM dba_ind_columns WHERE descend='DESC' AND index_owner='NIKOVITS';


Adjuk meg az SH.SALES táblára létrehozott bitmap indexek nevét.
--------------------------------------------------------------------------------
SELECT index_name FROM dba_indexes 
WHERE table_owner='SH' AND table_name='SALES' AND index_type='BITMAP';



Adjuk meg azon kétoszlopos indexek nevét és tulajdonosát, amelyeknek legalább 
az egyik kifejezése függvény alapú .
--------------------------------------------------------------------------------
SELECT index_owner, index_name FROM dba_ind_columns 
GROUP BY index_owner, index_name HAVING count(*) >=2  -- 2 vagy annál több
 INTERSECT
SELECT index_owner, index_name FROM dba_ind_expressions;

-- jó MO: 

SELECT index_owner, index_name FROM dba_ind_columns 
GROUP BY index_owner, index_name HAVING count(*) =2
 INTERSECT
SELECT index_owner, index_name FROM dba_ind_expressions;

Adjuk meg az egyikükre, pl. az OE tulajdonában lévõre, hogy milyen kifejezések szerint 
vannak indexelve a soraik. (Vagyis mi a függveny, ami alapján a bejegyzések készülnek.)
--------------------------------------------------------------------------------
SELECT * FROM dba_ind_expressions WHERE index_owner='OE';


************************************************************************************************
************************************************
************************************************


Adjuk meg a NIKOVITS felhasználó tulajdonában levõ index-szervezett táblák nevét.
(Melyik táblatéren vannak ezek a táblák? -> miért nem látható?)
--------------------------------------------------------------------------------
SELECT owner, table_name, iot_name, iot_type FROM dba_tables 
WHERE owner='NIKOVITS' AND iot_type = 'IOT';
