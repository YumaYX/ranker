# frozen_string_literal: true

require 'open-uri'
require 'json'

require_relative 'dynamic_class'

# Fetches the most played songs from the iTunes RSS feed
def fetch_itunes_most_played(num = 100)
  url = "https://rss.applemarketingtools.com/api/v2/jp/music/most-played/#{num}/songs.json"
  content = URI.open(url).read
  JSON.parse(content)['feed']['results']
end

# Generates a list of dynamic class objects representing the top songs
def fetch_itunes_ranking(num = 30)
  fetch_itunes_most_played(num).map { |song_data| create_dynamic_class(song_data).new }
end

# Creates a markdown formatted table row from an array of values
def markdown_table_row(*values)
  "| #{values.join(' | ')} |\n"
end

# Creates a markdown link from a name and URL
def markdown_link(name, url)
  "[#{name}](#{url})"
end

# Generates the markdown content for the ranking table
def generate_markdown_content
  header = %w[Rank ArtWork Song]
  content = markdown_table_row(header)
  content << markdown_table_row(Array.new(header.length, '---'))

  fetch_itunes_ranking(7).each.with_index(1) do |track, index|
    content << markdown_table_row(
      index,
      "!" + markdown_link(track.name, track.artworkUrl100),
      markdown_link(track.info, track.url)
    )
  end

  reference_link = markdown_link('RSS Feed Generator', 'https://rss.applemarketingtools.com/')
  content << "\n- #{Time.now}"
  content << "\n- Reference: #{reference_link}"

  content
end

# Writes the markdown content to a file
def write_markdown_to_file(content)
  Dir.mkdir('output') unless Dir.exist?('output')
  File.write('output/index.md', content)
  puts content[0..100]
end

# Main execution block
if __FILE__ == $PROGRAM_NAME
  markdown_content = generate_markdown_content
  write_markdown_to_file(markdown_content)
end