require 'date'

class MediaSplitter
  def do_task(file_path,slice_time)
    #input file path ../videos/ten.mov
    infile = file_path
    timespan = slice_time.to_i
    
    #getting extension of the file
    ext = File.extname(infile)  #ext=.mov
    #getting remaining part except extension 
    file = infile.chomp(ext)   #../videos/ten
    
    #getting duration of infile
    time_duration = `ffmpeg -i #{infile} 2>&1 | grep "Duration" | cut -d ' ' -f 4 | sed s/,//`

    if dt = DateTime.parse(time_duration.to_s) rescue false 
      duration = dt.hour * 3600 + dt.min * 60 + dt.sec     #duration gives length fo original media
    end
    
    #start time of first slice
    start_time = `ffmpeg -i #{infile} 2>&1 | grep "start" | cut -d ' ' -f 6 | sed s/,//`
    start_time = start_time.to_i
    
    #making dir of the file name
     Dir.mkdir("#{file}")
    # changing pwd
     Dir.chdir("#{file}")
    #storing pwd for use
     p = Dir.pwd
     
    while start_time < duration do
      outfilename = "#{file}-#{start_time}#{ext}"   
      # spliting file name 
      filename = outfilename.split("/").last 
      out = File.join("#{p}","#{filename}")
      `ffmpeg -i #{infile} -vcodec copy -acodec copy -ss #{start_time} -t #{timespan + 5} #{out}`
      start_time = (start_time + timespan) - 5
    end
  end
end


