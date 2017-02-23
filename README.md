# Transcoding content into HLS using ffmpeg, mediafilesegmenter and variantplaylistcreator

Assume we have downloaded hls.sh and have a directory abcde that has a video file (.mp4 etc.)

Run script like:

bash hls.sh abcdef source

# How it works

It has 3 main parts

# 1. Transcoding from mp4 to high, low and medium bitrates and appropriate resolutions mp4 files
# 2. Genrate segments (HLS transport segments) using mediafilesegmenter
# 3. Generate master m3u8 or playlist using variantplaylistcreator
