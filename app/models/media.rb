class Media < ActiveRecord::Base


def self.add_time( time_a, time_b )  #returns a Time object after adding two time objects
  total_seconds_in_time_b = time_b.hour * 3600 + time_b.min * 60 + time_b.sec
  return (time_a + total_seconds_in_time_b.seconds) 
end

def self.subtract_time(time_a, time_b) #returns time in seconds
  return (time_a - time_b)
end

def self.convertor( duration,offset )  #Pass split duration and offset
  start_time = "00:00:00"
  start_of_media = Time.parse(start_time)
  split_duration = Time.parse(duration.to_s)
  offset_duration = Time.parse(offset.to_s)
  #media_duration = `ffmpeg -i videos/video.flv  2>&1 | grep Duration | cut -d ' ' -f4 | sed s/,//`
    media_duration = 500
    media_length = start_of_media + media_duration.seconds
  #media_length = Time.parse(media_duration.to_s)
  splitted_files = {}
    p "reached if condition"
    if (media_length >= split_duration)
      now_convert(split_duration,start_of_media,offset_duration,offset_duration)
        else
          p "The media is too short"
    end
end

def self.now_convert(duration, seek ,offset_left, offset_right)
      ash = {}
      start_time = "00:00:00"
      offset = "00:00:02"
      offset_left = Time.parse(offset)
      offset_right = Time.parse(offset)
      start_of_media = Time.parse(start_time)
      end_of_media = Time.parse(start_time)
      
      #media_duration = `ffmpeg -i videos/video.flv  2>&1 | grep Duration | cut -d ' ' -f4 | sed s/,//`
        media_duration = 300
        media_length = start_of_media + media_duration.seconds
      #media_length = Time.parse(media_duration.to_s)
      
        prev_seek = start_of_media + subtract_time(seek,offset_left).seconds
        next_seek = add_time(start_of_media,add_time(add_time(seek,duration),offset_right))  #compulsion to add only two time objects at once
       
        if prev_seek < start_of_media
            offset_left = start_of_media    #setting offset_left for first split
        elsif next_seek >= media_length   
            offset_right = end_of_media     #setting offset_right for last split
            duration = start_of_media + subtract_time(media_length,seek).seconds
            #actual_duration = start_of_media + (subtract_time(media_length,duration)).seconds
        end
        actual_seek = start_of_media + (subtract_time(seek,offset_left)).seconds
        actual_duration = add_time(start_of_media,add_time(add_time(offset_left,duration),offset_right))
        temp = start_of_media + subtract_time(actual_duration,offset_left).seconds  
        next_duration = start_of_media + subtract_time(temp,offset_right).seconds
        next_duration1 = add_time(next_duration,next_duration)
 
        
        ash = {:actual_seek => actual_seek, :actual_duration => actual_duration, :next_seek => next_seek, :offset_left => offset_left}
        if(offset_right != end_of_media && actual_seek != start_of_media )
            p 'This split is general'
            p ash[:actual_seek].inspect
            p ash[:actual_duration].inspect
            p ash[:next_seek].inspect
            p 'end of general split'
            
            now_convert(next_duration1, next_seek, offset_left, offset_right)
        elsif(offset_right != end_of_media && actual_seek == start_of_media )
              p 'This split is first'
              p ash[:actual_seek].inspect
              p ash[:actual_duration].inspect
              p ash[:next_seek].inspect
              #p ash[:offset_left].inspect
              p 'End of first split' 
              now_convert(next_duration1, next_seek, offset_left, offset_right)
        elsif(next_seek >= media_length)
              p 'This is the last split'
              p ash[:actual_seek]
              p ash[:actual_duration].inspect
              p ash[:next_seek]
              p 'End of last split'
        end
        #return splitted_files
    end
     
end