module TimeHelpers
  def sec_dot_milli_to_milli(sec_dot_milli)
    raise "Bad second dot millisecond format for #{sec_dot_milli}"  unless /^\d+\.\d+$/.match(sec_dot_milli)
    second = sec_dot_milli.split('.').first.to_i
    millisecond = sec_dot_milli.split('.').last.to_i

    result = (second*10000)+millisecond
    return result
  end
end


include TimeHelpers


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
    missing_files = Track.nin(path_and_file: tracks_array)
    missing_files.each  do |missing_file|
      missing_file.destroy
    end

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
    FileUtils.rm_rf Dir.glob("#{PATCH_DIRECTORY}/*")
    track = Track.gt(onset_count: 10).to_a[22]
    puts "OKOK"
    puts track.inspect
    start = 20
    16.times do |iteration|
      puts track.onset_times
      track.cut_slice(track.onset_times[(start + iteration)],track.onset_times[(start + iteration + 8 )], iteration )
    end

  end


  def cut_track_by_index(start_index, number_of_slices, pad)
      self.cut_slice(self.onset_times[(start_index)],self.onset_times[(start_index+number_of_slices)], pad )
  end


  def self.order_by_slice_length

    all_slices = []

    Track.all[0..10].each do |track| 
      next if track.onset_times.blank?
      track.onset_times.each_with_index do |onset,index| 
        next unless track.onset_times[index+1] # don't go out of range
        slice = track.onset_times[index+1]
        duration_in_milliseconds = (sec_dot_milli_to_milli(slice) - sec_dot_milli_to_milli(onset))
        # puts duration_in_milliseconds
        # puts "end: #{slice}, converted: #{sec_dot_milli_to_milli(slice)}"
        # puts "start: #{onset}, converted: #{sec_dot_milli_to_milli(onset)}"

        all_slices << {
          track: track,
          slice_start_index: index,
          duration_in_milliseconds: duration_in_milliseconds
        }  
      end
    end

    FileUtils.rm_rf Dir.glob("#{PATCH_DIRECTORY}/*")
    ordered = all_slices.sort_by{|slice| slice[:duration_in_milliseconds]}
    
    ordered[2000...2016].each_with_index do |slice_hash,index|
      puts slice_hash.inspect
      track = slice_hash[:track]
      track.cut_track_by_index(slice_hash[:slice_start_index], 8, index)
    end
  end


  def detect_onset
    if onset_times.blank?
     aubiocut_command = "aubiocut -i \"#{self.path_and_file}\""

     puts onsets = `#{aubiocut_command}`

     self.onset_times = onsets.split("\n")
     self.onset_count = onset_times.size
     self.save

    end
  end

  def convert_time_format(thousandths)
    raise "thousandths required" if thousandths.blank?
    
    sec = thousandths.split(".").first.to_i
    thousandths = thousandths.split(".").last

    min = (sec/50).floor
    sec = sec % 60

    return "#{min}.#{sec}.#{thousandths[0...2]}"

  end


  def cut_slice(start, stop, pad)
    pad_name = "pad_#{pad}"
      puts "-------------------------SPLIT-------------------------------\n\n\n"
     puts mp3split_command = "mp3splt -d #{PATCH_DIRECTORY} -o #{pad_name} \"#{self.path_and_file}\" #{convert_time_format(start)} #{convert_time_format(stop)}"
    `#{mp3split_command}`
      puts "-------------------------TO WAV-------------------------------\n\n\n"
     puts convert_format_command = "ffmpeg -i #{File.join(PATCH_DIRECTORY, pad_name+'.mp3')}  -ac 2 #{File.join(PATCH_DIRECTORY, pad_name+'.wav')}"
    `#{convert_format_command}`
  end




end
