# frozen_string_literal: true

require 'open-uri'
require 'json'

# require_relative 'music_track'
require_relative 'dynamic_class'

def itunes_most_played(num = 100)
  url = "https://rss.applemarketingtools.com/api/v2/jp/music/most-played/#{num}/songs.json"
  # url = './songs.json'

  content = URI.open(url).read
  JSON.parse(content)['feed']['results']
end

def itunes_ranking(num = 30)
  itunes_most_played(num).map { |ele| create_dynamic_class(ele).new }
end

def md_table(*arr)
  "| #{arr.join(' | ')} |\n"
end

def md_link(name, link)
  "[#{name}](#{link})"
end

if __FILE__ == $PROGRAM_NAME

  header = %w[Rank ArtWork Song]
  content = md_table(header)
  content << md_table(Array.new(header.length, '---'))
  itunes_ranking(7).each.with_index(1) do |track, index|
    content << md_table(
      [
        index,
        "![#{track.name}](#{track.artworkUrl100})",
        md_link(track.info, track.url)
      ]
    )
  end

  ref = md_link('RSS Feed Generator', 'https://rss.applemarketingtools.com/')
  content << "\n- #{Time.new}"
  content << "\n- Reference: #{ref}"

  Dir.mkdir('output') unless Dir.exist?('output')
  File.write('output/index.md', content)
  p content[0..100]
end
