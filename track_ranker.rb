# frozen_string_literal: true

require 'open-uri'
require 'json'
require_relative 'music_track'

def itunes_most_played(num=100)
  url = "https://rss.applemarketingtools.com/api/v2/jp/music/most-played/#{num}/songs.json"
  # url = './songs.json'
  content = URI.open(url).read
  JSON.parse(content)['feed']['results']
end

def itunes_ranking(num=30)
  tracks = []
  index = 1
  itunes_most_played(num).each do |ele|
    track = MusicTrack.new(ele['name'], ele['artistName'])

    next if tracks.any? { |i| i.info.eql?(track.info) }

    track.ranking = index
    tracks << track
    index += 1
  end
  tracks
end

def md_table(*arr)
  "| #{arr.join(' | ')} |\n"
end

if __FILE__ == $PROGRAM_NAME
  content = md_table(%w[Rank Songs])
  content << md_table(['---', '---'])
  itunes_ranking.each do |track|
    content << md_table([track.ranking, track.info])
  end

  File.write('index.md', content)
end
