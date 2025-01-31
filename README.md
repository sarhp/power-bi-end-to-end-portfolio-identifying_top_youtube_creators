# identifying_top_youtube_creators

* [Introduction](#introduction)
	* [User Story](#user-story)
	* [Solution](#solution)
	* [Success Criteria (what success looks like to the user)](#success-criteria-what-success-looks-like-to-the-user)
	* [Tools](#tools)
	* [Steps](#steps)
* [SQL](#sql)
	* [Data Cleaning](#data-cleaning)
	* [Data Exploration Notes](#data-exploration-notes)                                                                              
	* [Data Cleaning](#data-cleaning)                                                                                                
	* [Data Quality Check](#data-quality-check)
* [Power BI](#power-bi)
	* [Build a Dashboard with Power BI](nuild-a-dashboard-with-power-bi)
	* [Final Look of the Dashboard](#final-look-of-the-dashboard)
* [Analysis](#analysis)
	* [Findings](#findings)
	* [Calculating YouTube Sponsorship Rate](#calculating-youtube-sponsorship-rate)
	* [Recommendation and Action Plan](#recommendation-and-action-plan)

<br>

# Introduction

Identify the top-performing YouTube content creators of 2023 and collaborate with them to keep New Zealand on the global travel radar. Our aim is to enhancing NZ’s tourism economy, to increase the opportunity to **benefit local businesses**, **boost support for sports teams**, **attract potential investors, influx of foreign money,** and **encourage more influential figures to visit.**

<br>

## User Story
"As the head of marketing, I want to identify top content creators who can effectively promote New Zealand as a destination celebrated for its stunning natural landscapes, peaceful and laid-back lifestyle, humble and friendly people, and world-class outdoor activities. To maximise reach, we aim to collaborate with mega influencers rather than niche content creators.”

<br>

## Solution
Use a dashboard that identifies the ideal performing channels based on metrics like subscriber count, views, and engagement rates.

<br>

## Success Criteria (what success looks like to the user)
•	Users can easily identify the top-performing YouTube channels based on subscriber count, views, and engagement rates.

•	User can assess the potential for successful campaigns with top content creators based on conversion, engagement, and budget.

•	User can make informed decisions on which content creator would be suitable to advance with.

<br>

## Tools
SQL (MySQL): Data Exploration, Cleaning, Testing

Power BI: Visualisation, Dashboard

Excel: Calculation, Generating Findings

<br>

## Steps
**Step 1. Get the data** 

•	Download as csv file from Kaggle. [Excel]

https://www.kaggle.com/datasets/nelgiriyewithana/global-youtube-statistics-2023?resource=download

<br>

**Step 2. Data Exploration, Cleaning / Transforming [SQL]**
  
  •	Explore data and note findings.

  •	Clean data based on the findings from the data exploration notes. 

  •	Check data quality after cleaning.

<br>

**Step 3. Build a Dashboard [Power BI]**

•	Import the virtual data into Power BI.

•	DAX measures. 

•	Build a dashboard.

<br>

**Step 4. Generating Findings** 

•	Generate findings based on the insights.

•	Identify top 3 creators  

<br>

**Step 5. Calculate YouTube Sponsorship Rate [Excel & SQL]**

•	Use both Excel and SQL to calculate sponsorship rate to avoid discrepancies.
<br><br>
**Step 6. Recommendations and Action Plan**

<br>

# SQL

## Data Exploration Notes
•	Data shape: 847 rows 28 cols
•	Data Type:

| Column Name                           | Data Type      | Description                                                                 |
|---------------------------------------|----------------|-----------------------------------------------------------------------------|
| rank                                  | INT            | Overall rank of the YouTuber                                                |
| Youtuber                              | TEXT           | Name of the YouTube channel                                                 |
| subscribers                           | INT            | Number of subscribers                                                        |
| video_views                           | DOUBLE         | Total number of video views                                                  |
| Category                              | TEXT           | Category of the channel (e.g., Entertainment, Gaming)                       |
| Title                                 | TEXT           | Title of the YouTube channel                                                 |
| uploads                               | INT            | Number of videos uploaded                                                    |
| Country                               | TEXT           | Country where the channel is based                                           |
| Abbreviation                          | TEXT           | Country abbreviation (e.g., US, UK)                                          |
| channel_type                          | TEXT           | Type of channel (e.g., Individual, Company)                                  |
| video_views_rank                      | INT            | Rank based on total video views                                             |
| country_rank                          | INT            | Rank within the country                                                      |
| channel_type_rank                     | INT            | Rank based on channel type                                                   |
| video_views_for_the_last_30_days      | BIGINT         | Total video views in the last 30 days                                        |
| lowest_monthly_earnings               | INT            | Estimated lowest monthly earnings                                           |
| highest_monthly_earnings              | DOUBLE         | Estimated highest monthly earnings                                          |
| lowest_yearly_earnings                | DOUBLE         | Estimated lowest yearly earnings                                            |
| highest_yearly_earnings               | DOUBLE         | Estimated highest yearly earnings                                           |
| subscribers_for_last_30_days          | TEXT           | Number of subscribers gained in the last 30 days                            |
| created_year                          | INT            | Year the channel was created                                                |
| created_month                         | TEXT           | Month the channel was created                                               |
| created_date                          | INT            | Day of the month the channel was created                                    |
| Gross tertiary education enrolment (%)| DOUBLE         | Percentage of population enrolled in tertiary education                     |
| Population                            | INT            | Population of the country                                                   |
| Unemployment rate                     | DOUBLE         | Country's unemployment rate                                                 |
| Urban_population                      | INT            | Urban population of the country                                             |
| Latitude                              | DOUBLE         | Latitude coordinates                                                         |
| Longitude                             | DOUBLE         | Longitude coordinates                                                        |

<br>

•	Some characters in the Youtubers column are corrupted.
    
>**Solution**:
Filter out special characters to improve readability:
`DaniRep | +6 Vï¿½ï¿` → `DaniRep`
`AlArabiya ï¿½ï¿½ï` → `AlArabiya`
`!!###@@@` → (removed)
`ýýýýýýýýýýý` → (removed)

<br>

•	There are unnecessary columns that aren’t relevant to this project.
>**Solution:**
Drop `abbreviation`, `video views rank`,  `channel_type_rank`,  `video_views_for_the_last_30_days`, `lowest_monthly_earnings`, `highest_monthly_earnings`,  `subscribers_for_last_30_days`, `created_year`,  `created_month`,  `created_date`,  `Gross tertiary education enrollment (%)`, `Population`, `Unemployment rate`,  `Urban_population`, and `Latitude`

<br>

•	Some content creator categories are not relevant to the goal of this project.
>**Solution:**
Drop values `Trailers`, `Nonprofits & Activism`, `Autos & Vehicles`, `nan`, `shows`, `Music`, `film & Animation`, `News & Politics`, and `Movies`.

<br>

•	There are inconsistencies in terms of case and spacing
>**Solution:**
Convert to lowercase, remove spaces, and replace with underscores.
video views → video_views
Country → country

<br>

•	The data will require a rough estimate of the engagement rate based on the number of views per subscriber.
>**Solution:**
Add a new col `engagement_rate` using the following formula:
engagement_rate = (total_views / subscribers) * 100
(In practice, more data will need to be analysed to improve accuracy)

<br>

•	Kid's channels are not properly classified and are scattered across various categories such as People & Blogs, Entertainment, and Education.
>**Solution:**
Option 1: If there is not much data remaining after cleaning, it is possible to manually review the list to confirm whether they are indeed kids' content. This can involve a quick glance at the channel's content or description.
Option 2: re-categorise these channels accordingly and add a new column to indicate if the channel is a `Kids`.

<br>

## Data Cleaning
We cleaned the data in accordance with the data exploration notes and saved as a virtual table:

```sql
CREATE VIEW virtual_table AS  
SELECT
    `rank` AS overall_rank,
    REGEXP_REPLACE(`Youtuber`, '[^a-zA-Z0-9 ]', '') AS `channel_name`,  
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
AND REGEXP_REPLACE(`Youtuber`, '[^a-zA-Z0-9 ]', '') IS NOT NULL -- Remove blank values and extra spaces resulting from the removal of special characters.
```

Rows and columns after cleaning: 541 rows 11 rols

<br>

## Data Quality Check
Before pushing the cleaned data into Power BI, we want to ensure that it meets the following criteria:

<br>

Criterion 1. Cleaned data should have 541 rows 11 cols

```sql
SELECT 
    (SELECT COUNT(*) FROM `virtual_table`) AS count_rows,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'virtual_table' AND table_schema = DATABASE()) AS count_cols;
```
![image](https://github.com/user-attachments/assets/4bf7773a-398b-448f-a1b3-0259d5c019d7)

<br>

Criterion 2.  No duplicates 

```sql
SELECT channel_name, 
       COUNT(*) AS duplicate_count
FROM virtual_table
GROUP BY channel_name
HAVING COUNT(*) > 1
```
![image](https://github.com/user-attachments/assets/a1a9ba37-dac2-4fd5-ad4d-dddfbfa924cd)

<br>

Criterion 3. Cleaned data should have 10 unique values in the categories column
```sql
-- list unique values
SELECT DISTINCT category 
FROM `virtual_table`;

-- count unique values
SELECT COUNT(DISTINCT category) AS category_count
FROM `virtual_table`;
```
![image](https://github.com/user-attachments/assets/bd2ffdc5-d9c5-4cb7-9ba3-8e7d550daf1f)  ![image](https://github.com/user-attachments/assets/bc6c3324-6c11-49ef-8e84-8d4bd1dd0a42)

<br>

# Power BI

## Build Dashboard
We have pushed the data into Power BI, and calculated the DAX measures used to create the dashboard, including converting large numbers (e.g., billions) into a readable format, such as 22.88M.

DAX Measure: Total Subscribers
```dax
Total Subscribers (M) = 
VAR million = 1000000
VAR sumOfSubscribers = SUM('influencers virtual_table'[subscribers])
VAR totalSubscribers = DIVIDE(sumOfSubscribers, million)

RETURN totalSubscribers
```

DAX Measure: Total Views
```dax
Total Views (B) = 
VAR billion = 1000000000
VAR sumOfTotalViews = SUM('influencers virtual_table'[total_views])
VAR totalViews = DIVIDE(sumOfTotalViews, billion)

RETURN totalViews
```

DAX Measure: Total Videos
```dax
Total Videos = 
VAR totalVideos = SUM('influencers virtual_table'[uploads])

RETURN totalVideos
```

DAX Measure: Average Views Per Video
```dax
Avg Views per Video (M) = 
VAR sumOfTotalViews = SUM('influencers virtual_table'[total_views])
VAR sumOfTotalVideos = SUM('influencers virtual_table'[uploads])
VAR avgViewsPerVideo = DIVIDE(sumOfTotalViews, sumOfTotalVideos, BLANK())
VAR finalAvgViewsPerVideo = DIVIDE(avgViewsPerVideo, 1000000, BLANK())

RETURN finalAvgViewsPerVideo
```

DAX Measure: View Per Subscriber
```dax
Views per Subscriber = 
VAR sumOfTotalViews = SUM('influencers virtual_table'[total_views])
VAR sumOfTotalSubscribers = SUM('influencers virtual_table'[subscribers])
VAR viewsPerSubscriber = DIVIDE(sumOfTotalViews, sumOfTotalSubscribers, BLANK())

RETURN viewsPerSubscriber
```

DAX Measure: Total Videos
```dax
Subscriber Engagement Rate = 
VAR sumOfTotalSubscribers = SUM('influencers virtual_table'[subscribers])
VAR sumOfTotalViews = SUM('influencers virtual_table'[total_views])
VAR subscriberEngRate = DIVIDE(sumOfTotalSubscribers, sumOfTotalViews, blank()) 

RETURN subscriberEngRate * 100
```

<br>

## Final look of the dashboard 

![dashboard_1](https://github.com/user-attachments/assets/1f41a02e-2adb-4c56-b232-a7f776e1e458)

![dashboard_2](https://github.com/user-attachments/assets/c480fd41-b788-4f91-90ae-1fc228547c94)

![dashboard_3](https://github.com/user-attachments/assets/cc55483c-54b3-432d-800b-d852c2acf710)

<br>

# Analysis

## Findings

- Our analysis shows the United States has the most subscribers worldwide.
- Kids' channels, entertainment-related channels, and celebrity channels have the highest views and engagement rates - noisy data - making it difficult for an accurate analysis.

| Channel Name        | Comment                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Mr Beast            | Exceeds the campaign budget.                                            |
| Dude Perfect        | Potential replacement for Mr. Beast.                                    |
| Markiplier          | Focuses primarily on film-related content.                              |
| SSSniperWolf        | Known for reaction videos, which cater to a somewhat niche audience.    |
| Lucas and Marcus    | Only certain videos achieve significant viewership.                     |
| Zhong               | Content is vague and lacks clear focus.                                 |
| Alan Chikin Chow    | Content is not highly relevant to our project aim.                      |
| Smosh               | Each video typically garners fewer than 1M views.                       |
| Mark Rober          | Offers great reach but focuses on a niche audience with science-based content. |
| Preston             | Known for experimentation-style content.                                |


## Calculating YouTube Sponsorship Rate

CPM (Cost Per Mille) based formula:

*Sponsorship Rate = (Average Views Per Video / 1000) × CPM*

<br>

**Mr Beast**

**CPM Range:** $30 to $100+

Estimated Sponsorship Rate = (38,280,000 /1000) * 30

= From $**1,148,400** to $**3,828,000+** per video

<br>

**Dude Perfect**

**CPM Range:** $30 to $80+

Estimated Sponsorship Rate = (41,750,000 / 1000) * 30

= From **$1,252,500** to **$3,340,000**+ per video

<br>

**Preston**

**CPM Range:** $20 to $50+

Estimated Sponsorship Rate = (2,070,000 / 1000) * 20

= From **$41,400** to **$103,500+** per video

<br>

Given Conversion rate is 0.01:

| Top 3 Channel Names | Avg Views   | Campaign Cost Range ($)    | Estimated Conversion |
|---------------------|-------------|----------------------------|----------------------|
| Mr Beast            | 38,280,000  | 1,148,400 - 3,828,000      | 382,800              |
| Dude Perfect        | 41,750,000  | 1,252,500 - 3,340,000      | 417,500              |
| Preston             | 2,070,000   | 41,400 - 103,500      | 20,700               |

<br>

Perform calculations within SQL to confirm the Excel calculations are accurate.

```SQL
-- Declare variables
SET @conversionRate = 0.01; -- Estimated conversion rate at 1%
SET @CPM_MIN_MrBeast = 30; -- Minimum CPM rate for each creator
SET @CPM_MAX_MrBeast = 100; -- Maximum CPM rate for each creator
SET @CPM_MIN_DudePerfect = 30;
SET @CPM_MAX_DudePerfect = 80;
SET @CPM_MIN_Preston = 20;
SET @CPM_MAX_Preston = 50;

-- Check whether they are properly declared
SELECT @conversionRate, @CPM_MIN_MrBeast, @CPM_MAX_MrBeast, @CPM_MIN_DudePerfect, 
			 @CPM_MAX_DudePerfect, @CPM_MIN_Preston, @CPM_MAX_Preston;

-- Create a CTE (Common Table Expression) that rounds the average views per video
WITH data_quality_check AS (
    SELECT 
        channel_name,
        total_views,
        uploads,
        (total_views / uploads) AS avg_views_per_vid, -- Not rounded
        ROUND(total_views / uploads, -4) AS rounded_avg_views_per_vid -- Rounded
    FROM virtual_table
)

-- Select col that are required for the analysis 
-- fiter the results by the youtube chnnels with the highest subscriber bases
-- order by net profit from hightst to lowest 
SELECT 
    channel_name,
    rounded_avg_views_per_vid,
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
    rounded_avg_views_per_vid * @conversionRate AS conversion_rate
FROM data_quality_check
WHERE TRIM(channel_name) IN ('MrBeast', 'Dude Perfect', 'Preston')
ORDER BY conversion_rate DESC;
```

![image](https://github.com/user-attachments/assets/710cc4ed-163b-41c1-a408-1ef308e7d3d0)


Both results (Excel and SQL) are identical.

- **Beast (166M)** would be the best option to maximise reach and ROI due to his large subscriber base, but the campaign cost is extremely high.
- **Dude Perfect (59.50M)** could deliver a similar outcome to Mr. Beast with a slightly lower budget. Despite having a lower subscriber base, their audience is more engaged with the content than Mr Beast’s.
- **Preston (24M)** has the least conversion and engagement, but the channel is still widely known and could be a viable option within a budget-conscious strategy.

<br>

## Recommendation and Action Plan
If the goal is solely to maximise reach and conversions, Mr Beast would be the best option to pursue with. While other channels, like Dude Perfect, have similar or even higher engagement rates than Mr. Beast, his brand awareness makes him the most reliable choice for ROI. For cost-effectiveness, Preston would be the ideal option, although his impact may be less certain compared to Mr Beast.

We will follow up with our client (Head of Marketing) to understand their expectations for this collaboration. Once we predict that we’re on track to hit the KPIs, we will move forward with a potential partnership with one of the creators.

After reaching out and negotiating contracts, we will track each creator's performance against the KPIs. We will review how the campaigns have performed, gather insights, and optimise based on feedback from converted customers and each channel's audience.
