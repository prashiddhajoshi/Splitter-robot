require 'date'

OVERLAPPING_TIME = 5

class MediaSplitter
   def do_task(bulk = false, data, data_option)
     #input_file file path ../videos/ten.mov
     input_file = data

     #user given slice time
     given_slice_time = data_option

     #finding time duration of media
     time_duration = `ffmpeg -i #{input_file} 2>&1 | grep "Duration" | cut -d ' ' -f 4 | sed s/,//`

     #calculating duration in seconds
     if dt = DateTime.parse(time_duration) rescue false
       duration = dt.hour * 3600 + dt.min * 60 + dt.sec     #duration gives length fo original media
     end

      #distributing remaining media time
      no_of_slice = duration/given_slice_time
      remainder = duration%given_slice_time
      bonus_time = remainder/no_of_slice.to_f
      slice_time = given_slice_time + bonus_time

      #getting original extension of the file
      ext = File.extname(input_file)  #ext=.mov
      #getting remaining part except extension
      file = input_file.chomp(ext)   #../videos/ten


      #start time of first slice
      start_time = `ffmpeg -i #{input_file} 2>&1 | grep "start" | cut -d ' ' -f 6 | sed s/,//`
      start_time = start_time.to_f


      `rm -rf "#{file}"`
      #making dir of the file name
      Dir.mkdir("#{file}")
      # changing pwd
      Dir.chdir("#{file}")
      #storing pwd for use
      p = Dir.pwd


      #second_start_time = (start_time + slice_time) - OVERLAPPING_TIME
      second_end_time = 0.0

      i = 1  #to name files serially

      (ext == ".avi")?hack_it = "-ac 2 -ab 320k" : hack_it = "-acodec copy"
      new_ext = ext

      while start_time < duration do

        #creating temp file name
        outfilename = "#{file}-#{i}-#{start_time}-#{start_time + slice_time + OVERLAPPING_TIME }#{new_ext}"

        # getting file name
        filename = outfilename.split("/").last

        #actual file with path to directory of storage
        out = File.join("#{p}","#{filename}")

        #actual code to split
       `ffmpeg -i #{input_file} -ss #{start_time} -t #{slice_time + OVERLAPPING_TIME} #{hack_it} -vcodec copy #{out}`

       start_time = (start_time + slice_time) - OVERLAPPING_TIME

       #double the start time
       #second_start_time = (start_time + timespan) - OVERLAPPING_TIME

       second_end_time = (start_time + slice_time + slice_time) - OVERLAPPING_TIME
       i+=1

      if second_end_time > duration
        outfilename = "#{file}-#{i}#{new_ext}"
        filename = outfilename.split("/").last
        out = File.join("#{p}","#{filename}")

        `ffmpeg -i #{input_file} -ss #{start_time} -t #{duration} #{hack_it} -vcodec copy #{out}`
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



