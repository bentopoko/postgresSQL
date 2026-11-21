-- 1 
SELECT t.name_type type, COUNT(*)
FROM types_pk t
JOIN pokemontype pkt
	ON pkt.type_id = t.type_id
GROUP BY 1
ORDER BY 2 DESC;

-- 2
SELECT name, base_total
FROM pokemon
WHERE base_total > 600
ORDER BY 2 DESC;

-- 3
SELECT t.name_type type, AVG(pk.base_total)
FROM types_pk t
JOIN pokemontype pkt
	ON pkt.type_id = t.type_id
JOIN pokemon pk
	ON pk.pokedex_number = pkt.pokedex_number
GROUP BY 1
ORDER BY 2, 1;

-- 4
SELECT pk.name, pk.base_total
FROM pokemon pk
JOIN pokemonability pka
	ON pka.pokedex_number = pk.pokedex_number
JOIN abilities ab
	ON ab.ability_id = pka.ability_id
WHERE ab.ability_id = 1
GROUP BY 1, 2
ORDER BY 2 DESC, 1;

-- 5
SELECT pk.name, MIN(t.name_type) primary_type,
	CASE 
		WHEN MAX(t.name_type) != MIN(t.name_type) THEN MAX(t.name_type) 
		ELSE NULL
	END secondary_type
FROM pokemon pk
JOIN pokemontype pkt
	ON pk.pokedex_number = pkt.pokedex_number
JOIN types_pk t
	ON t.type_id = pkt.type_id
GROUP BY 1
ORDER BY 1;

-- 6
WITH avg_stats AS (
    SELECT AVG(hp + attack + defense + speed + sp_attack + sp_defense) AS avg_total
    FROM stats
)
SELECT pk.name,
       pk.generation,
       st.hp + st.attack + st.defense + st.speed + st.sp_attack + st.sp_defense AS total_stats
FROM pokemon pk
JOIN stats st ON pk.pokedex_number = st.pokedex_number
CROSS JOIN avg_stats avgst
WHERE st.hp + st.attack + st.defense + st.speed + st.sp_attack + st.sp_defense > avgst.avg_total
ORDER BY 2;

-- 7
WITH fire_pokemon AS (
	SELECT pk.name, pk.pokedex_number
	FROM pokemon as pk
	JOIN pokemontype pkt
		ON pk.pokedex_number = pkt.pokedex_number
	JOIN types_pk t
		ON pkt.type_id = t.type_id
	WHERE t.type_id = 3
)

SELECT pk.name, st.attack
FROM fire_pokemon pk
JOIN stats st
	ON pk.pokedex_number = st.pokedex_number
WHERE st.attack > 100;

-- 8
WITH avg_stats AS (
	SELECT AVG(hp + attack + defense + speed + sp_attack + sp_defense) AS avg_total
	FROM stats
)

SELECT 
	pk.name pokemon_name, 
	pk.generation pokemon_generation, 
	st.hp + st.attack + st.defense + st.speed + st.sp_attack + st.sp_defense total_stats,
	CASE
		WHEN st.hp + st.attack + st.defense + st.speed + st.sp_attack + st.sp_defense > avgst.avg_total
			THEN 'Higher or equal to the average'
		ELSE 'Lower than the average'	
	END total_stats_comparison
FROM pokemon pk
JOIN stats st
	ON pk.pokedex_number = st.pokedex_number
CROSS JOIN avg_stats avgst
ORDER BY 2;

