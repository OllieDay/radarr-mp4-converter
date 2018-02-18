#!/bin/bash

if ! command -v ffmpeg > /dev/null; then
	>&2 echo "FFmpeg is not installed."
	exit 1
fi

if [ ! $radarr_eventtype ]; then
	>&2 echo "radarr_eventtype is not set."
	exit 1
fi

# Skip all events except Download
if [ $radarr_eventtype != "Download" ]; then
	exit 0
fi

if [ ! "$radarr_movie_path" ]; then
	>&2 echo "radarr_movie_path is not set."
	exit 1
fi

if [ ! -f "$radarr_movie_path" ]; then
	>&2 echo "File $radarr_movie_path not found."
	exit 1
fi

destination="${radarr_movie_path%.*}.mp4"

if ! ffmpeg -i "$radarr_movie_path" -codec copy -y "$destination" &> /dev/null; then
	>&2 echo "Failed to convert $radarr_movie_path"
	exit 1
fi

# Remove original file as it's no longer needed
rm "$radarr_movie_path"
