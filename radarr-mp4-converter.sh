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

if [ ! "$radarr_moviefile_path" ]; then
	>&2 echo "radarr_moviefile_path is not set."
	exit 1
fi

if [ ! -f "$radarr_moviefile_path" ]; then
	>&2 echo "File $radarr_moviefile_path not found."
	exit 1
fi

# No need to convert as it's already an MP4
if [[ $radarr_moviefile_path == *.mp4 ]]; then
	exit 0
fi

destination="${radarr_moviefile_path%.*}.mp4"

if ! ffmpeg -i "$radarr_moviefile_path" -codec copy -y "$destination" &> /dev/null; then
	>&2 echo "Failed to convert $radarr_moviefile_path"
	exit 1
fi

# Remove original file as it's no longer needed
rm "$radarr_moviefile_path"
