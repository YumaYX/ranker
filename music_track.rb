# frozen_string_literal: true

class MusicTrack
  attr_reader :title, :artist
  attr_accessor :ranking

  def initialize(title, artist)
    @title = title
    @artist = artist
  end

  def info
    "#{@title} - #{@artist}"
  end
end
