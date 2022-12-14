--============================================================================================--
-- Better City Defenses
--============================================================================================--
INSERT  INTO IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
SELECT  'BCDMOD_ICON_ATLAS', 256, 'BCDmodIconAtlas256.dds', 4, 1 UNION ALL
SELECT  'BCDMOD_ICON_ATLAS', 128, 'BCDmodIconAtlas128.dds', 4, 1 UNION ALL
SELECT  'BCDMOD_ICON_ATLAS', 64, 'BCDmodIconAtlas64.dds', 4, 1 UNION ALL
SELECT  'BCDMOD_ICON_ATLAS', 45, 'BCDmodIconAtlas45.dds', 4, 1;

CREATE  TABLE IF NOT EXISTS BCDBuildings (BCDType TEXT NOT NULL);

INSERT  INTO BCDBuildings
SELECT  'PALISADES' UNION ALL
SELECT  'WEAPONS_DEPOT' UNION ALL
SELECT  'DEFENSE_SATELLITE' UNION ALL
SELECT  'SATELLITE_NETWORK';

INSERT  INTO BuildingClasses (Type, DefaultBuilding, Description)
SELECT  'BUILDINGCLASS_' || BCDType,
        'BUILDING_' || BCDType,
        'TXT_KEY_BUILDING_' || BCDType
        FROM BCDBuildings;

INSERT  INTO Buildings (Type, BuildingClass, Description, Help, Strategy, Civilopedia)
SELECT  'BUILDING_' || BCDType,
        'BUILDINGCLASS_' || BCDType,
        'TXT_KEY_BUILDING_' || BCDType,
        'TXT_KEY_BUILDING_' || BCDType || '_HELP',
        'TXT_KEY_BUILDING_' || BCDType || '_STRATEGY',
        'TXT_KEY_CIV5_BUILDINGS_' || BCDType || '_TEXT'
        FROM BCDBuildings;


-- Palisades
UPDATE  Buildings SET
        -- Important bit
        Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_MONUMENT'),
        HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_MONUMENT'),
        Defense = 400,
        ExtraCityHitPoints = 25,
        CitySupplyModifier = 5,
        EmpireSizeModifierReduction = -5,

        -- Not so important bit
        PrereqTech = 'TECH_AGRICULTURE',
        FreeStartEra = 'ERA_MEDIEVAL',
        NeverCapture = 1,
        ArtDefineTag = NULL,
        IconAtlas = 'BW_ATLAS_1',
        PortraitIndex = 32
        WHERE Type = 'BUILDING_PALISADES';

INSERT  INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT  'BUILDING_PALISADES', 'FLAVOR_CITY_DEFENSE', 30;

UPDATE  Buildings SET
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 0
        WHERE Type = 'BUILDING_WALLS';

DELETE  FROM Building_ClassesNeededInCity
        WHERE BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS');

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
        SELECT DISTINCT Type, 'BUILDINGCLASS_PALISADES' FROM Buildings
        WHERE Type IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS');

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_PALISADES',
        'Palisades' UNION ALL
SELECT  'TXT_KEY_BUILDING_PALISADES_HELP',
        '[ICON_SILVER_FIST] Military Units Supplied by this City''s population increased by 5%.[NEWLINE]'||
        '[NEWLINE][ICON_CITY_STATE] Empire Size Modifier is reduced by 5% in this City.' UNION ALL
SELECT  'TXT_KEY_BUILDING_PALISADES_STRATEGY',
        '{TXT_KEY_BUILDING_PALISADES} increase City''s Defense Strength and Hit Points, making the City harder to capture on early-game. Increases Military Units supplied by this City''s population by 5%. Also helps with managing the Empire Size Modifier in this City.[NEWLINE]'||
        '[NEWLINE]{TXT_KEY_BUILDING_PALISADES} are the first step in building a City''s defense along a civilization''s frontier.' UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_PALISADES_TEXT',
        'A palisade—sometimes called a stakewall or a paling—is typically a fence or wall made from wooden stakes or tree trunks and used as a defensive structure or enclosure.[NEWLINE]'||
        '[NEWLINE]Typical construction consisted of small or mid-sized tree trunks aligned vertically, with no free space in between. '||
        'The trunks were sharpened or pointed at the top, and were driven into the ground and sometimes reinforced with additional construction. '||
        'The height of a palisade ranged from a few feet to nearly ten feet. As a defensive structure, palisades were often used in conjunction with earthworks.[NEWLINE]'||
        '[NEWLINE]Palisades were an excellent option for small forts or other hastily constructed fortifications. '||
        'Since they were made of wood, they could often be quickly and easily built from readily available materials. '||
        'They proved to be effective protection for short-term conflicts and were an effective deterrent against small forces. However, because they were wooden constructions they were also vulnerable to fire and siege weapons.[NEWLINE]'||
        '[NEWLINE]Often, a palisade would be constructed around a castle as a temporary wall until a permanent stone wall could be erected. They were frequently used in New France.[NEWLINE]'||
        '[NEWLINE]Both the Greeks and Romans created palisades to protect their military camps. The Roman historian Livy describes the Greek method as being inferior to that of the Romans during the Second Macedonian War. '||
        'The Greek stakes were too large to be easily carried and were spaced too far apart. This made it easy for enemies to uproot them and create a large enough gap in which to enter. '||
        'In contrast, the Romans used smaller and easier to carry stakes which were placed closer together, making them more difficult to uproot.';
/*
UPDATE  Language_en_US
        SET Text = 'City Walls'
        WHERE Tag = 'TXT_KEY_BUILDING_WALLS'
        AND Tag IN (SELECT Strategy FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS');
*/
UPDATE  Language_en_US
        SET Text = Text || ' The City already must possess {TXT_KEY_BUILDING_PALISADES} before {TXT_KEY_BUILDING_WALLS} can be constructed.'
        WHERE Tag IN (SELECT Strategy FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS');

-- Weapons Depot
UPDATE  Buildings SET
        -- Important bit
        Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_MILITARY_BASE'),
        GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_MILITARY_BASE'),
        HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_MILITARY_BASE'),
        Defense = 1000,
        ExtraCityHitPoints = 125,
        CitySupplyModifier = 30,
        CityAirStrikeDefense = 10,
        AllowsRangeStrike = 1,
        HealRateChange = 15,
        EmpireSizeModifierReduction = -5,
        NukeImmune = 1,

        -- Not so important bit
        PrereqTech = 'TECH_COMBINED_ARMS',
        NeverCapture = 1,
        ArtDefineTag = NULL,
        IconAtlas = 'BW_ATLAS_1',
        PortraitIndex = 9
        WHERE Type = 'BUILDING_WEAPONS_DEPOT';

INSERT  INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT  'BUILDING_WEAPONS_DEPOT', 'FLAVOR_CITY_DEFENSE', 30 UNION ALL
SELECT  'BUILDING_WEAPONS_DEPOT', 'FLAVOR_ANTIAIR', 30 UNION ALL
SELECT  'BUILDING_WEAPONS_DEPOT', 'FLAVOR_OFFENSE', 20;

UPDATE  Buildings SET
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 1
        WHERE Type = 'BUILDING_ARSENAL';

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT  'BUILDING_WEAPONS_DEPOT', 'BUILDINGCLASS_ARSENAL';

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_WEAPONS_DEPOT',
        'Weapons Depot' UNION ALL
SELECT  'TXT_KEY_BUILDING_WEAPONS_DEPOT_HELP',
        '+10[ICON_STRENGTH] Damage to Air Units during Air Strikes on City. [ICON_SILVER_FIST] Military Units Supplied by this City''s population increased by 30%, and garrisoned Units receive an additional 15 Health when healing in this City.[NEWLINE]'||
        '[NEWLINE][ICON_CITY_STATE] Empire Size Modifier is reduced by 5% in this City.' UNION ALL
SELECT  'TXT_KEY_BUILDING_WEAPONS_DEPOT_STRATEGY',
        'The {TXT_KEY_BUILDING_WEAPONS_DEPOT} is an Atomic-era building which increase City''s Defensive Strength and Hit Points, and improves defense against Air Units. '||
        'Garrisoned units receive an additional 15 Health when healing in this City. Increases Military Units supplied by this City''s population by 30%. Also helps with managing the Empire Size Modifier in this City.[NEWLINE]'||
        '[NEWLINE]The City must already possess an {TXT_KEY_BUILDING_ARSENAL} before a {TXT_KEY_BUILDING_WEAPONS_DEPOT} can be constructed.' UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_WEAPONS_DEPOT_TEXT',
        'The weapons depot is a larger and more extensive armory, containing an army''s bigger and more dangerous weapons systems - tanks, artillery, high-explosive ammunition, and so forth. '||
        'Weapons depot are even more heavily-guarded than armories, since nobody wants anybody stealing a tank or an 88-mm explosive shell.';

-- Defense Satellites
UPDATE  Buildings SET
        -- Important bit
        Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY'),
        GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY') + 2,
        HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY'),
        NumCityCostMod = 2,
        GlobalDefenseMod = 1,
        RangedStrikeModifier = 5,
        CityRangedStrikeRange = 2,
        CityAirStrikeDefense = 15,
        NukeInterceptionChance = 20,
        CityIndirectFire = 1,
        AllowsRangeStrike = 1,
        NukeImmune = 1,

        -- Not so important bit
        PrereqTech = 'TECH_SATELLITES',
        NeverCapture = 1,
        ArtDefineTag = NULL,
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 2
        WHERE Type = 'BUILDING_DEFENSE_SATELLITE';

UPDATE  BuildingClasses SET MaxPlayerInstances = 5
        WHERE Type = 'BUILDINGCLASS_DEFENSE_SATELLITE';

INSERT  INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT  'BUILDING_DEFENSE_SATELLITE', 'FLAVOR_CITY_DEFENSE', 30 UNION ALL
SELECT  'BUILDING_DEFENSE_SATELLITE', 'FLAVOR_ANTIAIR', 25 UNION ALL
SELECT  'BUILDING_DEFENSE_SATELLITE', 'FLAVOR_SCIENCE', 10;

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT  'BUILDING_DEFENSE_SATELLITE', 'BUILDINGCLASS_MILITARY_BASE';

INSERT  INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType, Cost)
SELECT  'BUILDING_DEFENSE_SATELLITE', 'RESOURCE_ALUMINUM', 1;

INSERT  INTO Building_BuildingClassYieldChanges
SELECT  'BUILDING_DEFENSE_SATELLITE', 'BUILDINGCLASS_DEFENSE_SATELLITE', 'YIELD_SCIENCE', 2;

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_DEFENSE_SATELLITE',
        'Defense Satellites' UNION ALL
SELECT  'TXT_KEY_BUILDING_DEFENSE_SATELLITE_HELP',
        '+1%[ICON_STRENGTH] Combat Strength for all Cities. All owned {TXT_KEY_BUILDING_DEFENSE_SATELLITE} gain +2 [ICON_RESEARCH] Science. +15[ICON_STRENGTH] Damage to Air Units during Air Strikes on City. '||
        'Increase City''s [ICON_RANGE_STRENGTH] Ranged Strike Range by 2 and [ICON_RANGE_STRENGTH] Ranged Strike Damage by 5%. Allows the City''s [ICON_RANGE_STRENGTH] Ranged Strike to ignore Line of Sight.[NEWLINE]'||
        '[NEWLINE]20% chance to detonate nuclear weapons [COLOR_POSITIVE_TEXT]early[ENDCOLOR]. Early detonations destroy Atomic Bombs outright and make Nuclear Missiles only as effective as Atomic Bombs.[NEWLINE]'||
        '[NEWLINE]Requires 1 [ICON_RES_ALUMINUM] Aluminum.[NEWLINE]'||
        '[NEWLINE]The [ICON_PRODUCTION] Production Cost increase based on the number of cities you own.[NEWLINE]'||
        '[NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_DEFENSE_SATELLITE') || ' of these satellites in your Empire.' UNION ALL
SELECT  'TXT_KEY_BUILDING_DEFENSE_SATELLITE_STRATEGY',
        '{TXT_KEY_BUILDING_DEFENSE_SATELLITE} is a late-game building which provides an Empire-wide [ICON_STRENGTH] Combat Strength bonus, and has the ability to defend against Air Units effectively. '||
        'Increases the City''s [ICON_RANGE_STRENGTH] Ranged Strike Range by 2 and Damage by 5%, so it covers the whole 5-tile radius around the City, and also inflicts extra damage to the enemy. It allows the City to Ranged Strike indirectly, ignoring Line of Sight.'||
        'Also have a 20% chance to detonate nuclear weapons early, which destroys Atomic Bombs outright and makes Nuclear Missiles only as effective as Atomic Bombs (with total of 70% chance when stacked with {TXT_KEY_BUILDING_BOMB_SHELTER}).[NEWLINE]'||
        '[NEWLINE]The City must already possess a {TXT_KEY_BUILDING_MILITARY_BASE} before {TXT_KEY_BUILDING_DEFENSE_SATELLITE} can be constructed. '||
        'Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_DEFENSE_SATELLITE') || ' of these satellites in your Empire, so make sure to place these in strategic cities.' UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_DEFENSE_SATELLITE_TEXT',
        '{TXT_KEY_BUILDING_DEFENSE_SATELLITE} are one of the types of military reconnaissance satellite designed to help safeguard cities by providing real-time data on the position of nearby enemy forces and their tactical capability. '||
        'They provide detailed intelligence and dramatically decrease the response time of a City''s defense force, which can change the outcome of a siege.[NEWLINE]'||
        '[NEWLINE]The first military use of satellites was for reconnaissance. In the United States the first formal military satellite programs, Weapon System 117L, was developed in the mid 1950s. '||
        'Within this program a number of sub-programs were developed including Corona. Satellites within the Corona program carried different code names. The first launches were code named Discoverer. '||
        'This mission was a series of reconnaissance satellites, designed to enter orbit, take high-resolution photographs and then return the payload to Earth via parachute. '||
        'Discoverer 1, the first mission, was launched on 28 February 1959 although it didn''t carry a payload being intended as a test flight to prove the technology. The Corona program continued until 25 May 1972. '||
        'Corona was followed by other programs including Canyon (seven launches between 1968 and 1977), Aquacade and Orion (stated by US Government sources to be extremely large). '||
        'There have also been a number of subsequent programs including Magnum and Trumpet, but these remain classified and therefore many details remain speculative.[NEWLINE]'||
        '[NEWLINE]The Soviet Union began the Almaz program in the early 1960s. This program involved placing space stations in Earth orbit as an alternative to satellites. '||
        'Three stations were launched between 1973 and 1976: Salyut 2, Salyut 3 and Salyut 5. '||
        'Following Salyut 5, the Soviet Ministry of Defence judged in 1978 that the time consumed by station maintenance outweighed the benefits relative to automatic reconnaissance satellites.';

-- Satellite Network Headquarters
UPDATE  Buildings SET
        -- Important bit
        Cost = 125,
        NumCityCostMod = 10,
        GlobalDefenseMod = 10,
        NationalPopRequired = 70,

        -- Not so important bit
        PrereqTech = 'TECH_SATELLITES',
        NeverCapture = 1,
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 3
        WHERE Type = 'BUILDING_SATELLITE_NETWORK';

UPDATE  BuildingClasses SET MaxPlayerInstances = 1
        WHERE Type = 'BUILDINGCLASS_SATELLITE_NETWORK';

INSERT  INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT  'BUILDING_SATELLITE_NETWORK', 'FLAVOR_CITY_DEFENSE', 40 UNION ALL
SELECT  'BUILDING_SATELLITE_NETWORK', 'FLAVOR_WONDER', 25 UNION ALL
SELECT  'BUILDING_SATELLITE_NETWORK', 'FLAVOR_SCIENCE', 10 UNION ALL
SELECT  'BUILDING_SATELLITE_NETWORK', 'FLAVOR_PRODUCTION', 5;

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT  'BUILDING_SATELLITE_NETWORK', 'BUILDINGCLASS_DEFENSE_SATELLITE';

INSERT  INTO Building_BuildingClassYieldChanges
SELECT  'BUILDING_DEFENSE_SATELLITE', 'BUILDINGCLASS_SATELLITE_NETWORK', 'YIELD_SCIENCE', 3 UNION ALL
SELECT  DISTINCT 'BUILDING_SATELLITE_NETWORK', bc.Type, 'YIELD_SCIENCE', 2 FROM BuildingClasses bc
        WHERE bc.Type IN ('BUILDINGCLASS_ARSENAL', 'BUILDINGCLASS_MILITARY_BASE', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_BOMB_SHELTER', 'BUILDINGCLASS_DEFENSE_SATELLITE') UNION ALL
SELECT  DISTINCT 'BUILDING_SATELLITE_NETWORK', bc.Type, 'YIELD_PRODUCTION', 1 FROM BuildingClasses bc
        WHERE bc.Type IN ('BUILDINGCLASS_ARSENAL', 'BUILDINGCLASS_MILITARY_BASE', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_BOMB_SHELTER', 'BUILDINGCLASS_DEFENSE_SATELLITE');

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_SATELLITE_NETWORK',
        'Satellite Network Headquarters' UNION ALL
SELECT  'TXT_KEY_BUILDING_SATELLITE_NETWORK_HELP',
        '+10%[ICON_STRENGTH] Combat Strength for all Cities. +1 [ICON_PRODUCTION] Production and +2 [ICON_RESEARCH] Science to all owned post-Industrial defense buildings. +3 [ICON_RESEARCH] Science from all owned {TXT_KEY_BUILDING_DEFENSE_SATELLITE}.[NEWLINE]'||
        '[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of cities you own.' UNION ALL
SELECT  'TXT_KEY_BUILDING_SATELLITE_NETWORK_STRATEGY',
        'With its large boost to Empire-wide [ICON_STRENGTH] Combat Strength, the {TXT_KEY_BUILDING_SATELLITE_NETWORK} is a great choice to help secure your cities when dealing with militaristic neighbors. '||
        '{TXT_KEY_BUILDING_SATELLITE_NETWORK} also provides additional [ICON_PRODUCTION] Production and [ICON_RESEARCH] Science for all post-Industrial defense buildings within the Empire. '||
        'This can indirectly aide in any type of victory. The value of {TXT_KEY_BUILDING_SATELLITE_NETWORK} increases as you built more {TXT_KEY_BUILDING_DEFENSE_SATELLITE} within the Empire. Build it in your heartland where it will likely be safe.' UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_SATELLITE_NETWORK_TEXT',
        'A Satellite Network Headquarters coordinates a state''s {TXT_KEY_BUILDING_DEFENSE_SATELLITE} to maximize their capabilities, allowing high level decisions to be made quickly to aide in a City''s defense. '||
        'They contain the latest computer and satellite uplink technology, so that the decision makers on the ground can receive current information from the {TXT_KEY_BUILDING_DEFENSE_SATELLITE} and quickly issue orders in how to use the one on site to help protect a City. '||
        'The facility is sometimes built underground for safety but its radio dishes are hard to disguise.';

-- Add additional defense buildings to Military-Industrial Complex (Autocracy) tenet
INSERT  INTO Policy_BuildingClassYieldChanges
	(PolicyType, BuildingClassType, YieldType, YieldChange)
        SELECT DISTINCT bcyc.PolicyType, bc.Type, bcyc.YieldType, bcyc.YieldChange
        FROM BuildingClasses bc, Policy_BuildingClassYieldChanges bcyc
        WHERE bc.Type IN ('BUILDINGCLASS_PALISADES', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_DEFENSE_SATELLITE')
        AND bcyc.PolicyType = 'POLICY_MOBILIZATION';

-- Add additional defense buildings to Defender of Faith belief
-- +1 Faith and +2 Culture for all of these buildings.
INSERT  INTO Belief_BuildingClassYieldChanges
        (BeliefType, BuildingClassType, YieldType, YieldChange)
        SELECT DISTINCT bcyc.BeliefType, bc.Type, bcyc.YieldType, bcyc.YieldChange
        FROM BuildingClasses bc, Belief_BuildingClassYieldChanges bcyc
        WHERE bc.Type IN ('BUILDINGCLASS_PALISADES', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_DEFENSE_SATELLITE')
        AND bcyc.BeliefType = 'BELIEF_DEFENDER_FAITH';

-- Add additional defense buildings to Oda Nobunaga's Ubique Ability (Japan)
-- +1 Faith and Culture for all of these buildings.
INSERT  INTO Trait_BuildingClassYieldChanges
        (TraitType, BuildingClassType, YieldType, YieldChange)
        SELECT DISTINCT bcyc.TraitType, bc.Type, bcyc.YieldType, bcyc.YieldChange
        FROM BuildingClasses bc, Trait_BuildingClassYieldChanges bcyc
        WHERE bc.Type IN ('BUILDINGCLASS_PALISADES', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_DEFENSE_SATELLITE')
        AND bcyc.TraitType = 'TRAIT_FIGHT_WELL_DAMAGED';

DROP TABLE BCDBuildings;

--============================================================================================--
-- Base defense buildings balancing
-- (Less HP, more CS, but more layer of buildings!)
--      Hit Points:
--              OLD: 1000 HP (VP) + 150 HP (BCD) = 1150 HP
--              NEW: 650 HP (VP) + 150 HP (BCD) = 800 HP
--      Combat Strengths:
--              OLD: 61 CS (VP) + 14 CS (BCD) = 75 CS
--              NEW: 41 CS (VP) + 14 CS (BCD) = 65 CS
--============================================================================================--
-- Walls (-50 HP, -1 CS)
UPDATE  Buildings SET
        Defense = Defense - 100,
        ExtraCityHitPoints = ExtraCityHitPoints - 50
        WHERE BuildingClass = 'BUILDINGCLASS_WALLS';

CREATE TRIGGER BCD_WallsChanges
AFTER INSERT ON Civilization_BuildingClassOverrides
WHEN NEW.BuildingClassType = 'BUILDINGCLASS_WALLS'
AND NEW.BuildingType IS NOT NULL
BEGIN
        INSERT  OR REPLACE INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
        SELECT  DISTINCT NEW.BuildingType, 'BUILDINGCLASS_PALISADES';
END;

-- Castle (-75 HP, -2 CS)
UPDATE  Buildings SET
        Defense = Defense - 200,
        ExtraCityHitPoints = ExtraCityHitPoints - 75
        WHERE BuildingClass = 'BUILDINGCLASS_CASTLE';

-- Bastion Fort (-50 HP, -2 CS)
UPDATE  Buildings SET
        Defense = Defense - 200,
        ExtraCityHitPoints = ExtraCityHitPoints - 50
        WHERE BuildingClass = 'BUILDINGCLASS_FORTRESS';

-- Arsenal (-50 HP, -1 CS)
UPDATE  Buildings SET
        Defense = Defense - 100,
        ExtraCityHitPoints = ExtraCityHitPoints - 50
        WHERE BuildingClass = 'BUILDINGCLASS_ARSENAL';

UPDATE  Language_en_US SET
        Text = 'An arsenal is a place where arms and ammunition are made, maintained and repaired, stored, or issued, in any combination, whether privately or publicly owned. '||
        'Arsenal and armory are mostly regarded as synonyms, although subtle differences in usage exist. The word descends from an Arabic term meaning ''manufacturing shop''.[NEWLINE]'||
        '[NEWLINE]Sub-armory is a place of temporary storage or carrying of weapons and ammunition, like any temporary Post or patrol vehicle which is only operational in certain times of the day.[NEWLINE]'||
        '[NEWLINE]A lower-class arsenal, which can furnish the materiel and equipment of a small army, may contain a laboratory, gun and carriage factories, small-arms ammunition, small-arms, harness, saddlery tent and powder factories; in addition, it must possess great store-houses. '||
        'In a second-class arsenal, the factories would be replaced by workshops. The situation of an arsenal should be governed by strategic considerations. '||
        'If of the first class, it should be situated at the base of operations and supply, secure from attack, not too near a frontier, and placed so as to draw in readily the resources of the country. '||
        'The importance of a large arsenal is such that its defences would be on the scale of those of a large fortress.'
        WHERE Tag = 'TXT_KEY_CIV5_BUILDINGS_ARSENAL_TEXT';

-- Military Base (-75 HP, -4 CS, -15 Heal HP, -10 Supply Modifier, -10 CS to Air Strike) --this building is too OP
UPDATE  Buildings SET
        CityIndirectFire = 1,
        Defense = Defense - 400,
        ExtraCityHitPoints = ExtraCityHitPoints - 75,
        CityAirStrikeDefense = CityAirStrikeDefense - 10,
        CitySupplyModifier = CitySupplyModifier - 10,
        HealRateChange = HealRateChange - 15
        WHERE BuildingClass = 'BUILDINGCLASS_MILITARY_BASE';

UPDATE  Building_Flavors SET
        Flavor = Flavor - 20
        WHERE FlavorType = 'FLAVOR_ANTIAIR'
        AND BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_MILITARY_BASE');

UPDATE  Language_en_US SET
        Text = REPLACE(Text, 'increased by 20%', 'increased by 10%')
        WHERE Tag = 'TXT_KEY_BUILDING_MILITARY_BASE_HELP';

UPDATE  Language_en_US SET
        Text = REPLACE(Text, 'additional 20 Health', 'additional 5 Health')
        WHERE Tag = 'TXT_KEY_BUILDING_MILITARY_BASE_HELP';

UPDATE  Language_en_US SET
        Text = REPLACE(Text, '+15 [ICON_STRENGTH] Damage', '+5[ICON_STRENGTH] Damage')
        WHERE Tag = 'TXT_KEY_BUILDING_MILITARY_BASE_HELP';

UPDATE  Language_en_US SET
        Text = REPLACE(Text, 'additional 20 Health', 'additional 5 Health')
        WHERE Tag = 'TXT_KEY_BUILDING_MILITARY_BASE_STRATEGY';

UPDATE  Language_en_US SET
        Text = REPLACE(Text, 'by 20%', 'by 10%')
        WHERE Tag = 'TXT_KEY_BUILDING_MILITARY_BASE_STRATEGY';

-- Strategic Defense System (-50 HP)
UPDATE  Buildings SET
        ExtraCityHitPoints = ExtraCityHitPoints - 50
        WHERE BuildingClass = 'BUILDINGCLASS_BOMB_SHELTER';

/* -- It's not working
CREATE TRIGGER BCD_RequirePalisadesText_AfterInsert
AFTER INSERT ON Language_en_US
WHEN NEW.Tag IN (
        SELECT Strategy
        FROM Buildings
        WHERE BuildingClass = (
                        SELECT BuildingClassType
                        FROM Civilization_BuildingClassOverrides
                        WHERE BuildingClassType = 'BUILDINGCLASS_WALLS'
                                AND BuildingType IS NOT NULL
                        )
                )
BEGIN
        UPDATE  LocalizedText
                SET Text = Text || '[NEWLINE][NEWLINE]The city must possess {TXT_KEY_BUILDING_PALISADES} before {TXT_KEY_BUILDING_WALLS} can be constructed.'
                WHERE Language = 'en_US' AND Tag = NEW.Tag;
END;*/
