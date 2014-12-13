class Track
  include Mongoid::Document


  field :path_and_file, type: String
  field :file_contents_hash, type: String
  field :onset_times, type: Array
  field :onset_count, type: Integer


    PATCH_DIRECTORY = "/Users/clean/Documents/essample/pure_data/tmp/patch"

  def self.import_tracks
  	track_list_string = `mdfind -name \.mp3`
  	puts "OKOK"
  	# puts track_list
  	tracks_array = track_list_string.split("\n")
  	puts tracks_array.size

  	tracks_array.each do |track_path|
  		 track_path
  		file_contents_hash = Digest::MD5.file(track_path).hexdigest
  		track = Track.find_or_create_by(file_contents_hash: file_contents_hash)
  		track.path_and_file = track_path
  		track.save
  		track.detect_onset
      # track.cut_nth_slice(1) rescue nil
  	end
  end

  def self.cut_16_patches
    track = Track.first
    16.times do |iteration|
      # puts track.onset_times_padded
      start = 20
      track.cut_slice(track.onset_times_padded[(start + iteration)],track.onset_times_padded[(start + iteration + 8 )], iteration )
    end

  end

  def onset_times_padded
      self.onset_times.unshift("0.0000")

  end

  def detect_onset
    if onset_times.blank?
     aubiocut_command = "aubiocut -i \"#{self.path_and_file}\""

     onsets = `#{aubiocut_command}`

     self.onset_times = onsets.split("\n")
     self.onset_count = onset_times.size
     self.save

    end
  end

  def convert_time_format(hundredths)
    throw "hundredths required" if hundredths.blank?
    
    sec = hundredths.split(".").first.to_i
    hundredths = hundredths.split(".").last

    min = (sec/50).floor
    sec = sec % 60

    return "#{min}.#{sec}.#{hundredths[0...2]}"

  end

  def get_nth_slice(n)
    throw "The given slice is out of range at #{n}" if (n > self.onset_count.size)
     # puts onset_times_padded[n+1]
     start_stop =  [onset_times_padded[n], onset_times_padded[(n+1)]]
     return start_stop
  end

  def cut_slice(start, stop, pad)
    pad_name = "pad_#{pad}"
    puts mp3split_command = "mp3splt -d #{PATCH_DIRECTORY} -o #{pad_name} \"#{self.path_and_file}\" #{convert_time_format(start)} #{convert_time_format(stop)}"
    `#{mp3split_command}`
    puts convert_format_command = "ffmpeg -i #{File.join(PATCH_DIRECTORY, pad_name+'.mp3')}  -ac 2 #{File.join(PATCH_DIRECTORY, pad_name+'.wav')}"
    `#{convert_format_command}`
  end




end
