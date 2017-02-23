#!/bin/bash

# Script to generate adaptive HLS content
# It has 3 main parts
# 1. Transcoding from mp4 to high, low and medium bitrates, resolutions
# 2. Genrate file segments using mediafilesegmenter
# 3. Generate master m3u8 or playlist using variantplaylistcreator

##### Main
dirName=$1
inputFile=$2

cd $dirName

# Bitrate guidance from https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StreamingMediaGuide/UsingHTTPLiveStreaming/UsingHTTPLiveStreaming.html#//apple_ref/doc/uid/TP40008332-CH102-SW7
# Table 2-3  Additional main profile encoder settings, 16:9 aspect ratio
cp $inputFile.mp4 $inputFile-ao.mp4

/usr/local/bin/ffmpeg -i $inputFile.mp4 -s 1280x720 -b:v 1500K -c:a copy $inputFile-high.mp4
/usr/local/bin/ffmpeg -i $inputFile-high.mp4 -s 960x540 -b:v 1800K -c:a copy $inputFile-mid.mp4
/usr/local/bin/ffmpeg -i $inputFile-mid.mp4 -s 640x360 -b:v 1200K -c:a copy $inputFile-low.mp4
/usr/local/bin/ffmpeg -i $inputFile.mp4 -vn -acodec copy $inputFile-ao.aac

mkdir hls

mkdir hls/high
mkdir hls/mid
mkdir hls/low
mkdir hls/ao

# Generating playlist file $inputFile.plist
mediafilesegmenter -f hls/high -i index.m3u8 -B media- -I $inputFile-high.mp4
mediafilesegmenter -f hls/mid -i index.m3u8 -B media- -I $inputFile-mid.mp4
mediafilesegmenter -f hls/low -i index.m3u8 -B media- -I $inputFile-low.mp4
mediafilesegmenter -f hls/ao -a -i index.m3u8 -B media- -I $inputFile-ao.aac

# Generating master m3u8
variantplaylistcreator -o hls/index.m3u8 high/index.m3u8 $inputFile-high.plist -iframe-url higs/iframe_index.m3u8 mid/index.m3u8 $inputFile-mid.plist -iframe-url mid/iframe_index.m3u8  low/index.m3u8 $inputFile-low.plist -iframe-url low/iframe_index.m3u8 ao/index.m3u8 $inputFile-ao.plist
