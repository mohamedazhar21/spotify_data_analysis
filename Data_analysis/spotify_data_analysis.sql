
/* 
  Spotify Data Analysis SQL Project
  ----------------------------------
  This SQL script analyzes a cleaned dataset of Spotify tracks using various 
  window functions, aggregations, and joins. It covers:
    - Track popularity buckets
    - Artist and album performance trends
    - Genre-based popularity insights
    - Release patterns and activity over time
    - Popularity extremes and duration analysis
*/

--1. Track Popularity Analysis

--1.1 Identify the most popular track for each artist.

With temp_rnk as
(select artist_name,
track_name,
track_popularity,
RANK() over (partition by artist_name order by track_popularity desc) as rnk
from
spotify_data.tracks_cleaned)

select temp_rnk.artist_name,
temp_rnk.track_name 
from
temp_rnk
where temp_rnk.rnk = 1;


--1.2. Find tracks whose popularity is below the average popularity of their respective artists.

SELECT 
    track_name, 
    artist_name, 
    track_popularity
FROM 
    spotify_data.tracks_cleaned t
WHERE 
    track_popularity < (
        SELECT AVG(track_popularity)
        FROM spotify_data.tracks_cleaned
        WHERE artist_name = t.artist_name
    )
ORDER BY 
    artist_name, track_popularity;

--1.3. Categorize tracks into Low (0–40), Medium (41–70), and High (71–100) popularity bands and count how many fall into each category.

SELECT
  CASE
    WHEN track_popularity BETWEEN 0 AND 40 THEN 'Low_Popularity'
    WHEN track_popularity BETWEEN 41 AND 70 THEN 'Medium_Popularity'
    ELSE 'High_Popularity'
  END AS popularity_bucket,
  COUNT(*) AS count_popularity_bucket
FROM
  spotify_data.tracks_cleaned
GROUP BY
  popularity_bucket;

/*There are 20 in High_Popularity,29 in Medium_Popularity, and 1 in Low_Popularity */


--2. Artist & Album Performance

--2.1. Identify artists who have more than 3 tracks with popularity greater than 70.

with temp_table as (
  select
    artist_name,
    track_name,
    track_popularity,
    COUNT(track_popularity) over (partition by artist_name) as cnt_popularity
  from
    spotify_data.tracks_cleaned
  where
    track_popularity >= 70
)
select
  distinct temp_table.artist_name
from
  temp_table
where
  temp_table.cnt_popularity > 3;

/* Anirudh Ravichander and G. V. Prakash have more than 3 tracks with popularity greater than 70 */


--2.2. For each track, calculate the difference between its popularity and the average popularity of its album

with temp_diff as
(select
    track_name,
    album_name,
    track_popularity,
    ROUND(avg(track_popularity) over(partition by album_name),0) as avg_popularity_album
    from
    spotify_data.tracks_cleaned)

SELECT 
    track_name,
    album_name,
    track_popularity,
    avg_popularity_album,
    track_popularity - avg_popularity_album AS popularity_diff
FROM temp_diff;

-- 2.3. Find albums where all tracks have popularity greater than 70

SELECT 
    album_name
FROM 
    spotify_data.tracks_cleaned
GROUP BY 
    album_name
HAVING 
    MIN(track_popularity) > 70;


-- 3. Genre & Popularity Analysis

--3.1. List the top 3 most popular tracks per genre.
    
with ranked_tracks as (
  select
    g.genres,
    tc.track_name,
    ROW_NUMBER() OVER(
      partition by g.genres
      order by
        tc.track_popularity DESC
    ) as rnk
  from
    spotify_data.tracks_cleaned tc
    left join spotify_data.genres g on g.trending_rank = tc.trending_rank
)
select
  ranked_tracks.genres,
  ranked_tracks.track_name
from
  ranked_tracks
where
  ranked_tracks.rnk <= 3;


-- 3.2. Popular Genres by Track Popularity

SELECT 
    g.genres,
    ROUND(AVG(t.track_popularity),2) AS avg_track_popularity
FROM 
    spotify_data.tracks_cleaned t
LEFT JOIN 
    spotify_data.genres g 
ON 
    t.trending_rank = g.trending_rank
group by 
    g.genres
order by 
    avg_track_popularity desc;

/* Genres like Tamil pop, Tamil Indie consistently having higher popularity, indicating strong listener engagement */


--4. Artist Activity & Track Release Trends

--4.1. Identify the first and latest release for each artist

SELECT 
    artist_name, 
    MIN(release_date) AS first_release, 
    MAX(release_date) AS latest_release
FROM 
    spotify_data.tracks_cleaned
GROUP BY 
    artist_name;

--4.2. For each artist, calculate the cumulative number of tracks released over time

SELECT 
  artist_name,
  release_date,
  track_name,
  COUNT(*) OVER (
    PARTITION BY artist_name 
    ORDER BY release_date
  ) AS cumulative_track_count
FROM 
  spotify_data.tracks_cleaned
ORDER BY 
  artist_name,
  release_date;


--4.3. Determine which month had the highest number of track releases

WITH monthly_counts AS (
    SELECT 
        TO_CHAR(release_date::DATE, 'YYYY-MM') AS year_month,
        COUNT(*) AS count_of_tracks
    FROM spotify_data.tracks_cleaned
    GROUP BY TO_CHAR(release_date::DATE, 'YYYY-MM')
),
ranked_months AS (
    SELECT *,
           RANK() OVER (ORDER BY count_of_tracks DESC) AS rnk
    FROM monthly_counts
)
SELECT year_month, count_of_tracks
FROM ranked_months
WHERE rnk = 1;

/*  January 2025, December 2024, and March 2025 had the highest number of track releases, each with 4 releases */


-- 5. Popularity Extremes
 
-- 5.1. Popularity Over Time 
with T as(
select 
track_name,
to_char(release_date::DATE, 'yyyy-mm') as year_month
from
spotify_data.tracks_cleaned)

select 
T.year_month,
COUNT(T.year_month) as count_of_tracks,
(select COUNT(*) from T as total_count),
ROUND(((COUNT(T.year_month)::numeric)/(select COUNT(*) from T as total_count) * 100),2) as total_percent
from T
group by T.year_month
order by T.year_month desc;

-- 5.2. Track Popularity by Release Month

select
  track_name,
  TO_CHAR(release_date:: DATE, 'yyyy-mm') as year_month,
  ROUND(AVG(track_popularity), 2) AS avg_track_popularity
FROM
  spotify_data.tracks_cleaned
group by
  track_name,
  year_month
order by
  year_month desc;


--5.3. Tracks with Highest and Lowest Popularity

  select
  track_name,
  track_popularity
from
  spotify_data.tracks_cleaned
where
  track_popularity = (
    select
      MAX(track_popularity)
    from
      spotify_data.tracks_cleaned
  )
  or track_popularity = (
    select
      Min(track_popularity)
    from
      spotify_data.tracks_cleaned
  )
order by
  track_popularity desc;

/* The track "Aasa Kooda - From 'Think Indie'" is the most popular with a score of 77, while "Kannadi Poove" is the least popular with a score of 37, highlighting a significant variance in track engagement. */


-- 6. Additional Insights

--6.1. Does followers count affect artist popularity

select
  artist_name,
  artist_popularity,
  SUM(artist_followers) as total_followers
from
  spotify_data.artists
group by
  artist_name,
  artist_popularity
order by
  total_followers desc;

/*In many cases, artists with higher follower counts tend to have greater popularity, but exceptions exist due to other influencing factors such as viral moments or promotions */


--6.2. Does duration impact the popularity?

select
  artist_name,
  track_popularity,
  AVG("duration_(in_minutes)") as avg_duration
from
  spotify_data.tracks_cleaned
group by
  artist_name,
  track_popularity
order by
  track_popularity desc;
  
/* On a average, 3 mins durated songs tends to be more popular */


--6.3a. Artist with most appearance in top 50
select
  artist_name,
  COUNT(artist_name) as total_cnt_in_top50,
  ROUND(AVG("duration_(in_minutes)":: int), 2) as avg_duration
from
  spotify_data.tracks_cleaned
group by
  artist_name
order by
  total_cnt_in_top50 desc;
/* In this case, Anirudh Ravichander appeared 11 times in the top 50 tracks, which accounts for 20% of the total appearances in the top 50. This indicates that he is one of the most consistently popular artists in the dataset.*/

--6.3b. Album with most appearance in top 50
  
select
  album_name,
  COUNT(album_name) as total_cnt_in_top50
from
  spotify_data.tracks_cleaned
group by
  album_name
order by
  total_cnt_in_top50 desc;
  
/* The album "Dragon" appeared 3 times in the top 50 tracks */ 

--6.4. Artist Popularity vs. Track Popularity
  
SELECT 
    a.artist_name,
    a.artist_popularity,
    ROUND(AVG(t.track_popularity),2) AS avg_track_popularity
FROM 
    spotify_data.tracks_cleaned t
LEFT JOIN 
    spotify_data.artists a 
ON 
    t.artist_name = a.artist_name
GROUP BY 
    a.artist_name, a.artist_popularity
ORDER BY 
    artist_popularity DESC;

/*Insight: Artist popularity doesn't necessarily determine the popularity of individual tracks — there are many cases where less popular artists have high-performing tracks */

--6.5. Top Tracks by Popularity and Release Date
    
  SELECT track_name,track_popularity,release_date
  FROM spotify_data.tracks_cleaned
  order by track_popularity DESC;
  
/*This helps identify which tracks gained the most traction, regardless of release period. */

 
