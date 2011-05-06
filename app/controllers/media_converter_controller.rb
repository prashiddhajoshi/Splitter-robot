class MediaConverterController < ApplicationController

  def index
    @test = MediaConverter.new
    @test.do_task("#{Rails.root}/videos/ten.mp3")
  end
end