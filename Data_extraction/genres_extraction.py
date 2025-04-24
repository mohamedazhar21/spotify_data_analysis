from spotipy.oauth2 import SpotifyClientCredentials
import spotipy
import pandas as pd
import re

# Initialize Spotify API
sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(
    client_id='xxxx',
    client_secret='yyyy'
))

# List of track URLs
track_urls = [
    "https://open.spotify.com/track/6SZgnc7BvRmSXErk0hyXkq",
    "https://open.spotify.com/track/2JlzHPGIVaLNAppX1viq7f",
    "https://open.spotify.com/track/361FMJC5uRSXzato4NE5Zg",
    "https://open.spotify.com/track/1uQU9b93tlMlMoZ0h2bRgf",
    "https://open.spotify.com/track/0Vh3jGxKhm9KxzQgnfnIV6",
    "https://open.spotify.com/track/6g3pwMsCrqV5HcxF6p99GB",
    "https://open.spotify.com/track/3MELuNUntwMZwsNK9zNxJi",
    "https://open.spotify.com/track/6DhffBxB0edyANDTYtKSbI",
    "https://open.spotify.com/track/2SD9x7M7leWlQr2JCm0iH4",
    "https://open.spotify.com/track/67Wp0iVQWeH3lwQAuIdthY",
    "https://open.spotify.com/track/3YH8zD0ycqxKtk6xTyW4w3",
    "https://open.spotify.com/track/12zT7djETGfDeL6JIVjM2b",
    "https://open.spotify.com/track/7HmYlNxtnnLdHQb7U9pFxm",
    "https://open.spotify.com/track/3jixbQHg5vDuZRNqzordcI",
    "https://open.spotify.com/track/3dHP1GUSR19PB1baWz37LN",
    "https://open.spotify.com/track/5vUumh0QzTwWlla9hK1XJd",
    "https://open.spotify.com/track/1LhiESiiI929TNIdxLBV61",
    "https://open.spotify.com/track/1iY0uzOBbKkIyL56HLwqc3",
    "https://open.spotify.com/track/7dIovld3QsNhYseLcwMJHj",
    "https://open.spotify.com/track/2sThPnkC1gTl1nKhX7ewzZ",
    "https://open.spotify.com/track/28rtWBDUGP8JLEuJ57cwdv",
    "https://open.spotify.com/track/5zgalMo7LWrUPbnv9tgupN",
    "https://open.spotify.com/track/7qw72jXJNBeqIMsqzvBft5",
    "https://open.spotify.com/track/3vxjyhcguZvf5qcX5YNyc8",
    "https://open.spotify.com/track/1kmJ0EvXClJAt0fSSQLX1m",
    "https://open.spotify.com/track/6uHuw5ynf6PFpJ2adWprxu",
    "https://open.spotify.com/track/60NKtVtW65UhstCQHZx0WY",
    "https://open.spotify.com/track/2109dBho14Lqh2wr8goqAP",
    "https://open.spotify.com/track/0MTdYgTZ25sLCO6kVnDoje",
    "https://open.spotify.com/track/7KB0zREYCrQU3refE5x0M3",
    "https://open.spotify.com/track/79Aa3LFIeZpMWTXs8y3Qgk",
    "https://open.spotify.com/track/5mLQsi5t349Wdm9sB07so0",
    "https://open.spotify.com/track/3h9UdkxpoUQxNqS8IeTC4Z",
    "https://open.spotify.com/track/4Dd5XLOdAAmURIZSLThPvH",
    "https://open.spotify.com/track/2PKjUxmdIhPjKS1wwEVqHp",
    "https://open.spotify.com/track/6CvW7N8JjBHmwEfGz2Yxhk",
    "https://open.spotify.com/track/1zzejMGRYKP5XOa3FmzXfa",
    "https://open.spotify.com/track/1hHrBEkN0JIaeFPegy4Xak",
    "https://open.spotify.com/track/0xN4nwgOWg59k0t94CJAj4",
    "https://open.spotify.com/track/1a1xLj9W8libnO9PvJf6ao",
    "https://open.spotify.com/track/35qzjEf7XtwRM7cjfgF55n",
    "https://open.spotify.com/track/5DgY6Ab0vpyUMKnY9ubFOF",
    "https://open.spotify.com/track/13ZISM2bmrMBCRlMzl669x",
    "https://open.spotify.com/track/4uwUk23qJYXHWFJgXWPg9T",
    "https://open.spotify.com/track/161BGczu2fn59QR7EYdjWB",
    "https://open.spotify.com/track/5eSoySxUnx3xsm0FHFgHiv",
    "https://open.spotify.com/track/09ihDlGHKhAKrIqK6JUWNy",
    "https://open.spotify.com/track/7Et1EN5V7xAyPjYOk8nSh3",
    "https://open.spotify.com/track/45THyhjDbYhNU7bDrTTUK6",
    "https://open.spotify.com/track/1pTkmFDgxz09fg6Mu1mBpH",
    "https://open.spotify.com/track/3dHP1GUSR19PB1baWz37LN"
]

# Store genre data
all_genres_data = []

for url in track_urls:
    try:
        # Extract Track ID
        track_id = re.search(r'track/([a-zA-Z0-9]+)', url).group(1)
        track = sp.track(track_id)

        # Get primary artist ID and genre
        artist_id = track['artists'][0]['id']
        artist = sp.artist(artist_id)

        # Prepare data
        genre_data = {
            'Track Name': track['name'],
            'Artist Name': artist['name'],
            'Genres': ', '.join(artist['genres']) if artist['genres'] else 'N/A'
        }

        all_genres_data.append(genre_data)

    except Exception as e:
        print(f"Failed to process {url}: {e}")

# Create DataFrame
df_genres = pd.DataFrame(all_genres_data)

# Display and save
print(df_genres.head())
df_genres.to_csv("spotify_genres(Trending_Now_tamil).csv", index=False)
