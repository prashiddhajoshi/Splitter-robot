require 'date'

OVERLAPPING_TIME = 5

class MediaSplitter
   def do_task(data, data_option)
     #input file path ../videos/ten.mov
     infile = data
     given_slice_time = data_option

     #FINDING TIME DURATION OF ORIGINAL FILE
     time_duration = `ffmpeg -i #{infile} 2>&1 | grep "Duration" | cut -d ' ' -f 4 | sed s/,//`

     if dt = DateTime.parse(time_duration) rescue false
       duration = dt.hour * 3600 + dt.min * 60 + dt.sec     #duration gives length fo original media
     end

      #CALCULATIONS FOR REMAINING MEDIA
      no_of_slice = duration/given_slice_time
      remainder = duration%given_slice_time
      bonus_time = remainder/no_of_slice.to_f
      slice_time = given_slice_time + bonus_time
      timespan = slice_time






      #getting original extension of the file
      ext = File.extname(infile)  #ext=.mov
      #getting remaining part except extension
      file = infile.chomp(ext)   #../videos/ten


      #start time of first slice
      start_time = `ffmpeg -i #{infile} 2>&1 | grep "start" | cut -d ' ' -f 6 | sed s/,//`
      start_time = start_time.to_f


      `rm -rf "#{file}"`
      #making dir of the file name
      Dir.mkdir("#{file}")
      # changing pwd
      Dir.chdir("#{file}")
      #storing pwd for use
      p = Dir.pwd


      second_start_time = (start_time + timespan) - OVERLAPPING_TIME
      second_end_time = 0.0
      i = 1

      (ext == ".avi")?new_ext=".mp4":new_ext = ext


      while start_time < duration do
        # outfilename = "#{file}-#{i}-#{start_time}-#{start_time + timespan + OVERLAPPING_TIME}#{final_ext}"
        outfilename = "#{file}-#{i}#{new_ext}"
        #  -#{start_time}-#{start_time + timespan + OVERLAPPING_TIME }
        # spliting file name
        filename = outfilename.split("/").last

        out = File.join("#{p}","#{filename}")

      i = i + 1

    `ffmpeg -i #{infile} -ss #{start_time} -t #{timespan + OVERLAPPING_TIME} -acodec copy -vcodec copy #{out}`


      start_time = (start_time + timespan) - OVERLAPPING_TIME

      #double the start time

      second_start_time = (start_time + timespan) - OVERLAPPING_TIME
      second_end_time = (start_time + timespan + timespan) - OVERLAPPING_TIME

      if second_end_time > duration
                   outfilename = "#{file}-#{i}#{new_ext}"
                  # -#{duration-start_time}#
                   filename = outfilename.split("/").last
                   out = File.join("#{p}","#{filename}")
                   `ffmpeg -i #{infile} -ss #{start_time} -t #{duration} -acodec copy -vcodec copy #{out}`
                  break
                end
  end
return out
end

def data_option
  options = self.get_options
  {:slice_time => options[:split_time]} if options.keys.include?(:from_column)
 end
end



