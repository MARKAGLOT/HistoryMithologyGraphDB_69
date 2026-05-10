/*
Created: 10.05.2026
Modified: 10.05.2026
Model: HistoryGraphDB_69
Database: MS SQL Server 2019
*/


-- Create tables section -------------------------------------------------

-- Table God

--Пункт 1

CREATE TABLE [God]
(
 [id] Int NOT NULL PRIMARY KEY,
 [name] Nvarchar(50) NOT NULL,
 [pantheon] Nvarchar(30) NULL,
 [powerType] Nvarchar(50) NULL
)
AS NODE
go


-- Table Creature

CREATE TABLE [Creature]
(
 [creatureId] Int NOT NULL PRIMARY KEY,
 [species] Nvarchar(50) NOT NULL,
 [ishostile] Bit NULL
)
AS NODE
go


-- Table Location

CREATE TABLE [Location]
(
 [locationId] Int NOT NULL PRIMARY KEY,
 [locationName] Nvarchar(50) NOT NULL,
 [realmType] Nvarchar(30) NULL
)
AS NODE
go


--Пункт 2

-- Table parentOf

CREATE TABLE [parentOf]
(
 [relationType] Nvarchar(20) NULL
)
AS EDGE
go
ALTER TABLE parentOf 
ADD CONSTRAINT EC_ParentOf CONNECTION (God TO God);

-- Table DwellsIn

CREATE TABLE [DwellsIn]
(
 [sinceEpoch] Nvarchar(20) NULL
)
AS EDGE
go
ALTER TABLE DwellsIn 
ADD CONSTRAINT EC_DwellsIn CONNECTION (God TO Location, Creature TO Location);

-- Table FoughtWith

CREATE TABLE [FoughtWith]
(
 [battleName] Nvarchar(100) NULL,
 [winnerID] Int NULL,
 [outcome] Nvarchar(50) NULL
)
AS EDGE
go
ALTER TABLE FoughtWith 
ADD CONSTRAINT EC_FoughtWith CONNECTION (God TO Creature, God TO God, Creature TO God);

--Пункт 3

-- Заполнение Богов
INSERT INTO [God] (id, name, pantheon, powerType) VALUES 
(1, N'Зевс', N'Греческий', N'Гром и небо'),
(2, N'Посейдон', N'Греческий', N'Море'),
(3, N'Аид', N'Греческий', N'Подземный мир'),
(4, N'Геракл', N'Греческий', N'Сила'),
(5, N'Афина', N'Греческий', N'Мудрость'),
(6, N'Персей', N'Греческий', N'Герой'),
(7, N'Один', N'Скандинавский', N'Мудрость'),
(8, N'Тор', N'Скандинавский', N'Молния'),
(9, N'Локи', N'Скандинавский', N'Хитрость'),
(10, N'Бальдр', N'Скандинавский', N'Свет'),
(11, N'Кронос', N'Греческий', N'Время'),
(12, N'Борей', N'Греческий', N'Северный ветер');

-- Заполнение Существ
INSERT INTO [Creature] (creatureId, species, ishostile) VALUES 
(1, N'Медуза Горгона', 1),
(2, N'Гидра', 1),
(3, N'Цербер', 1),
(4, N'Минотавр', 1),
(5, N'Пегас', 0),
(6, N'Хирон (Кентавр)', 0),
(7, N'Фенрир', 1),
(8, N'Ёрмунганд', 1),
(9, N'Слейпнир', 0),
(10, N'Химера', 1),
(11, N'Пифон', 1);

-- Заполнение Локаций
INSERT INTO [Location] (locationId, locationName, realmType) VALUES 
(1, N'Олимп', N'Небеса'),
(2, N'Тартар', N'Бездна'),
(3, N'Асгард', N'Небеса'),
(4, N'Лерна', N'Болото'),
(5, N'Мидгард', N'Земля'),
(6, N'Элизум', N'Рай'),
(7, N'Нифльхейм', N'Лед'),
(8, N'Лабиринт', N'Подземелье'),
(9, N'Остров Горгон', N'Остров'),
(10, N'Ётунхейм', N'Мир великанов');


--Пункт 4

-- Связи ParentOf (Кто чей родитель)
INSERT INTO parentOf ($from_id, $to_id, relationType) VALUES 
((SELECT $node_id FROM God WHERE id = 11), (SELECT $node_id FROM God WHERE id = 1), N'Отец'), -- Кронос -> Зевс
((SELECT $node_id FROM God WHERE id = 1), (SELECT $node_id FROM God WHERE id = 4), N'Отец'),  -- Зевс -> Геракл
((SELECT $node_id FROM God WHERE id = 1), (SELECT $node_id FROM God WHERE id = 5), N'Отец'),  -- Зевс -> Афина
((SELECT $node_id FROM God WHERE id = 1), (SELECT $node_id FROM God WHERE id = 6), N'Отец'),  -- Зевс -> Персей
((SELECT $node_id FROM God WHERE id = 7), (SELECT $node_id FROM God WHERE id = 8), N'Отец'),  -- Один -> Тор
((SELECT $node_id FROM God WHERE id = 7), (SELECT $node_id FROM God WHERE id = 10), N'Отец'); -- Один -> Бальдр

-- Связи DwellsIn (Кто где живет/находится)
INSERT INTO DwellsIn ($from_id, $to_id, sinceEpoch) VALUES 
((SELECT $node_id FROM God WHERE id = 1), (SELECT $node_id FROM Location WHERE locationId = 1), N'Вечность'),
((SELECT $node_id FROM God WHERE id = 3), (SELECT $node_id FROM Location WHERE locationId = 2), N'Вечность'),
((SELECT $node_id FROM Creature WHERE creatureId = 3), (SELECT $node_id FROM Location WHERE locationId = 2), N'Всегда'), -- Цербер в Тартаре
((SELECT $node_id FROM Creature WHERE creatureId = 2), (SELECT $node_id FROM Location WHERE locationId = 4), N'Античность'), -- Гидра в Лерне
((SELECT $node_id FROM Creature WHERE creatureId = 4), (SELECT $node_id FROM Location WHERE locationId = 8), N'Мифы'), -- Минотавр в Лабиринте
((SELECT $node_id FROM God WHERE id = 7), (SELECT $node_id FROM Location WHERE locationId = 3), N'Эпоха Асов'),
((SELECT $node_id FROM Creature WHERE creatureId = 8), (SELECT $node_id FROM Location WHERE locationId = 5), N'До Рагнарёка'),
((SELECT $node_id FROM God WHERE name = N'Геракл'), (SELECT $node_id FROM Location WHERE locationId = 1), N'После смерти');


-- Связи FoughtWith (Кто с кем сражался)
INSERT INTO FoughtWith ($from_id, $to_id, battleName, outcome) VALUES 
((SELECT $node_id FROM God WHERE id = 4), (SELECT $node_id FROM Creature WHERE creatureId = 2), N'Лернейская Гидра', N'Победа Геракла'),
((SELECT $node_id FROM God WHERE id = 6), (SELECT $node_id FROM Creature WHERE creatureId = 1), N'Охота на Горгону', N'Победа Персея'),
((SELECT $node_id FROM God WHERE id = 8), (SELECT $node_id FROM Creature WHERE creatureId = 8), N'Рагнарёк', N'Взаимная гибель'),
((SELECT $node_id FROM God WHERE id = 1), (SELECT $node_id FROM God WHERE id = 11), N'Титаномахия', N'Победа богов'),
((SELECT $node_id FROM God WHERE id = 4), (SELECT $node_id FROM Creature WHERE creatureId = 3), N'12-й подвиг', N'Победа Геракла')


--Пункт 5 

-- 1. Найти всех "внуков" Кроноса (Цепочка: Бог -> Бог -> Бог)
SELECT 
    GrandParent.name AS [Дед], 
    Parent.name AS [Родитель], 
    Child.name AS [Внук/Потомок]
FROM God AS GrandParent, parentOf AS p1, God AS Parent, parentOf AS p2, God AS Child
WHERE MATCH(GrandParent-(p1)->Parent-(p2)->Child);

-- 2. Найти богов, чьи дети сражались с монстрами (Цепочка: Бог -> Бог -> Существо)
SELECT 
    Father.name AS [Бог-Отец], 
    Hero.name AS [Герой-Сын], 
    Enemy.species AS [Противник]
FROM God AS Father, parentOf AS p, God AS Hero, FoughtWith AS f, Creature AS Enemy
WHERE MATCH(Father-(p)->Hero-(f)->Enemy);

-- 3. Найти локации, где живут существа, с которыми сражались боги (Цепочка: Бог -> Существо -> Локация)
SELECT 
    G.name AS [Бог-Победитель], 
    C.species AS [Монстр], 
    L.locationName AS [Место обитания]
FROM God AS G, FoughtWith AS f, Creature AS C, DwellsIn AS d, Location AS L
WHERE MATCH(G-(f)->C-(d)->L);

-- 4. Найти богов, их противников и места обитания этих противников
-- Цепочка: Бог -> (Сражался) -> Существо -> (Живет в) -> Локация
SELECT 
    G.name AS [Бог-Герой], 
    C.species AS [Противник], 
    L.locationName AS [Логово врага]
FROM God AS G, FoughtWith AS f, Creature AS C, DwellsIn AS d, Location AS L
WHERE MATCH(G-(f)->C-(d)->L);

-- 5. Найти существ, живущих в тех же локациях, что и боги (Цепочка: Бог -> Локация -> Существо)
SELECT 
    G.name AS [Божество], 
    L.locationName AS [Общий дом], 
    C.species AS [Мифическое существо]
FROM God AS G, DwellsIn AS d1, Location AS L, DwellsIn AS d2, Creature AS C
WHERE MATCH(G-(d1)->L<-(d2)-C);


--пункт 6 


-- 1. Путь от Кроноса до потомков
SELECT 
    G1.name AS [Начало],
    STRING_AGG(G2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS [Путь],
    LAST_NODE(G2.name) WITHIN GROUP (GRAPH PATH) AS [Конец]
FROM God AS G1, parentOf FOR PATH AS p, God FOR PATH AS G2
WHERE MATCH(SHORTEST_PATH(G1(-(p)->G2){1,3}))
AND G1.name = N'Кронос';

-- 2. Путь Геракла к целям
SELECT 
    G.name AS [Герой],
    STRING_AGG(C.species, ' -> ') WITHIN GROUP (GRAPH PATH) AS [Цели],
    LAST_NODE(C.species) WITHIN GROUP (GRAPH PATH) AS [Финал]
FROM God AS G, FoughtWith FOR PATH AS f, Creature FOR PATH AS C
WHERE MATCH(SHORTEST_PATH(G(-(f)->C)+))
AND G.name = N'Геракл';
GO

