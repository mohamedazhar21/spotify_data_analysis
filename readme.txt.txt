# Spotify Real Time Data Analysis

This project presents an in-depth analysis of real-time Spotify track data, focusing on artist performance, genre popularity, release patterns, and more using advanced SQL techniques. The goal is to uncover musical trends through structured SQL queries applied on a well-modeled dataset.

The dataset includes key track metadata such as popularity scores, duration, album release year, associated genres, and artist information. Data was extracted using Python via the Spotify Web API, cleaned, and structured into relational tables to enable robust SQL-based analysis.

Playlist Analyzed: Trending Now Tamil

Playlist URL: https://open.spotify.com/playlist/37i9dQZF1DX4Im4BTs2WMg

Data Extraction Date: April 23, 2025

## Folder Structure

├── data_analysis/
│   └── spotify_data_analysis.sql  # Core SQL script for trend analysis and insights
│
├── data_extraction/
│   ├── tracks_extraction.py       # track-level metadata
│   ├── artists_extraction.py      # artist details and popularity
│   └── genres_extraction.py       # Maps artists to genres
│
└── readme.txt                     # A plain text version of this README file


## Key Insights

1. Track Popularity Buckets: Group tracks into different popularity levels and analyze how each group performs across various parameters.

2. Artist and Album Performance Trends: Track the performance of artists and albums over time, identifying patterns and shifts in popularity.

3. Genre-Based Popularity Insights: Discover the top-performing genres, exploring how they trend and evolve over time.

4. Release Patterns and Activity Over Time: Analyze trends in artist releases, including seasonal or monthly patterns of track drops.

5. Popularity Extremes: Identify the highest and lowest popularity tracks, studying factors that contribute to their extremes.


## Tools Used

SQL (PostgreSQL): For entire Data analysis

Python: For data extraction using the Spotify Web API

VS Code: For Python scripting and transformation

DBeaver: For executing queries and reviewing results

## Author
Nathar Mohamed Azharudeen
Data Analyst | Business Intelligence Engineer | SQL & ETL Enthusiast

LinkedIn: https://www.linkedin.com/in/natharmohamedazharudeen/
Email: mohamedazhar21@gmail.com
