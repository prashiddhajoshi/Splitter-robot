class MediaConverter


  def do_task(data)
    robot_options = {}
# k = "k"
    robot_options[:from] = "#{data}"    #http://www...../three.mp3
    robot_options[:to] = "wma"
    robot_options[:quality] = 320
    #get extension of the file eg: "three.mp3"
    extension = File.extname(data)  #mp3
    #get file name except extension
    input_file_name = data.chomp(extension) #three
  robot_options[:to] = input_file_name + "." + robot_options[:to]   #three.wma It is not clear what type of folder/file structure is necessary

    # if robot_options[:quality] is empty, use the same quality as input audio/video
    # else use the supplied parameter
    robot_options[:quality] =  robot_options[:quality] || `ffmpeg -i "#{Rails.root}/videos/ten.MOV" 2>&1| grep "bitrate: "| awk -F "bitrate:" '{print $2}' |cut -d " "  -f2`.chomp("\n").to_i
    robot_options[:quality] = robot_options[:quality].to_s + "k"

  if `ffmpeg -i #{robot_options[:from]} 2>&1 | grep "Stream #" | grep "Video"`.blank? && `ffmpeg -i #{robot_options[:from]} 2>&1 | grep hasVideo`.blank?
    #If the media is an audio file
      `ffmpeg -i #{robot_options[:from]} -map_meta_data #{robot_options[:to]}:#{robot_options[:from]} -ab #{robot_options[:quality]} #{robot_options[:to]}`
    else    #If the media is a video file
      `ffmpeg -i #{robot_options[:from]} -b #{robot_options[:quality]} #{robot_options[:to]}`
  end
   return "#{robot_options[:to]}"     # What should be returned from here?
end
end