class MediaSplitterController < ApplicationController

  def index
    @test = MediaSplitter.new

    @test.do_task("#{Rails.root}/videos/123.MKV", 10)
  end
end