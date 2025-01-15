/*
Table of contents:
1. DATA EXPLORATION
2. DATA CLEANING 
3. DATA QUALITY CHECK AFTER CLEANING 
4. DATA QUALITY CHECK - CONFIRM ACCURACY OF EXCEL CALCULATIONS (FOR SPONSORSHIP RATE AND CONVERSION)
*/

-- 1. DATA EXPLORATION

-- connect to schema
use influencers;

-- data shape
SELECT 
    (SELECT COUNT(*) FROM `global youtube statistics`) AS count_rows,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'global youtube statistics' AND table_schema = DATABASE()) AS count_cols;

-- data type
describe `global youtube statistics`;

-- list unique values in category column
SELECT DISTINCT category 
FROM `global youtube statistics`;

-- Kid's channels are not properly classified
SELECT *
FROM `global youtube statistics`
WHERE Youtuber LIKE '%nursery%' OR Youtuber LIKE '%kid%';


-- 2. DATA CLEANING 
/*
	- Drop irrelevant columns.
	- Drop category values that are not relevant to this project such as
	  Trailers, Nonprofits & Activism, Autos & Vehicles, nan, shows, Music, film & Animation, News & Politics, Movies .
	- Add a new column containing Engagement rate for approximation (subscribers / total_views * 100).
	- Remove entries containing non-meaningful characters, such as repeating characters (ýýýýýýýýýý), 
	  while keeping entries that may be useful e.g Pokï¿½ï¿½ï¿½ï¿½.
	- Save it as a virtual table.
*/

CREATE VIEW virtual_table AS  
SELECT
    `rank` AS overall_rank,
    REGEXP_REPLACE(`Youtuber`, '[^a-zA-Z0-9 ]', '') AS `channel_name`,  -- Clean special characters from Youtuber
    subscribers,
    `video views` AS total_views,
    ROUND((`video views`/subscribers) * 100, 2) AS engagement_rate,
    category, 
    uploads,
    Country AS country,
    channel_type,
    country_rank, 
    channel_type_rank
FROM `global youtube statistics`
WHERE category NOT IN (
    'Trailers', 
    'Nonprofits & Activism', 
    'Autos & Vehicles', 
    'nan', 
    'shows', 
    'Music', 
    'Film & Animation', 
    'News & Politics', 
    'Movies'
)
AND TRIM(REGEXP_REPLACE(`Youtuber`, '[^a-zA-Z0-9 ]', '')) != ''
AND REGEXP_REPLACE(`Youtuber`, '[^a-zA-Z0-9 ]', '') IS NOT NULL;


-- 3. DATA QUALITY CHECK AFTER CLEANING 

-- data shape
SELECT 
    (SELECT COUNT(*) FROM `virtual_table`) AS count_rows,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'virtual_table' AND table_schema = DATABASE()) AS count_cols;

-- check for duplicates 
SELECT channel_name, 
       COUNT(*) AS duplicate_count
FROM virtual_table
GROUP BY channel_name
HAVING COUNT(*) > 1;

-- list unique values in category column
SELECT DISTINCT category 
FROM `virtual_table`;

-- count unique values in category column
SELECT COUNT(DISTINCT category) AS category_count
FROM `virtual_table`;


-- 4. DATA QUALITY CHECK - CONFIRM ACCURACY OF EXCEL CALCULATIONS (FOR SPONSORSHIP RATE AND CONVERSION)

-- declare variables
SET @conversionRate = 0.01; -- Conversion rate at 1%
SET @CPM_MIN_MrBeast = 30.0; -- Minimum CPM rate for each creator
SET @CPM_MAX_MrBeast = 100.0; -- Maximum CPM rate for each creator
SET @CPM_MIN_DudePerfect = 30.0;
SET @CPM_MAX_DudePerfect = 80.0;
SET @CPM_MIN_Preston = 20.0;
SET @CPM_MAX_Preston = 50.0;

-- check if variables are properly declared
SELECT @conversionRate, @CPM_MIN_MrBeast, @CPM_MAX_MrBeast, @CPM_MIN_DudePerfect, @CPM_MAX_DudePerfect, @CPM_MIN_Preston, @CPM_MAX_Preston;

-- create a CTE (Common Table Expression) that rounds the average views per video
WITH data_quality_check AS (
    SELECT 
        channel_name,
        total_views,
        uploads,
        (total_views / uploads) AS avg_views_per_vid, -- Not rounded
        ROUND(total_views / uploads, -4) AS rounded_avg_views_per_vid -- Rounded
    FROM virtual_table
)

-- select columns required for the analysis, and dynamically calculate CPM based on the channel name
SELECT 
    channel_name as top_3_channel_names,
    rounded_avg_views_per_vid as avg_view,
    CASE 
		WHEN TRIM(channel_name) ='MrBeast' THEN (rounded_avg_views_per_vid / 1000) * @CPM_MIN_MrBeast
		WHEN TRIM(channel_name) ='Dude Perfect' THEN (rounded_avg_views_per_vid/1000) * @CPM_MIN_DudePerfect
        WHEN TRIM(channel_name) = 'Preston' THEN (rounded_avg_views_per_vid / 1000) * @CPM_MIN_Preston
    END AS min_campaign_cost, 
    CASE 
        WHEN TRIM(channel_name) = 'MrBeast' THEN (rounded_avg_views_per_vid / 1000) * @CPM_MAX_MrBeast
        WHEN TRIM(channel_name) = 'Dude Perfect' THEN (rounded_avg_views_per_vid / 1000) * @CPM_MAX_DudePerfect
        WHEN TRIM(channel_name) = 'Preston' THEN (rounded_avg_views_per_vid / 1000) * @CPM_MAX_Preston
    END AS max_campaign_cost,
    rounded_avg_views_per_vid * @conversionRate AS conversion
FROM data_quality_check
WHERE TRIM(channel_name) IN ('MrBeast', 'Dude Perfect', 'Preston')
ORDER BY conversion DESC;
