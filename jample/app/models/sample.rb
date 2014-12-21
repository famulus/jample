include TimeHelpers
include Settings


class Sample
  include Mongoid::Document


  field :track_id, type: String
  field :start_onset_index, type: Integer
  field :stop_onset_index, type: Integer

  belongs_to :track

  index({ track_id: 1, start_onset_index: 1, stop_onset_index: 1 }, { unique: true, drop_dups: true })

  # what makes a sample unique? 


  def start_onset_time
    return nil unless valid_sample?
    start_onset_time = self.track.onset_times[self.start_onset_index]
  end

  def stop_onset_time
    return nil unless valid_sample?
    stop_onset_time = self.track.onset_times[self.stop_onset_index]
  end

  def duration
    return nil if start_onset_time.blank? || stop_onset_time.blank?
    duration = sec_dot_milli_to_milli(stop_onset_time) - sec_dot_milli_to_milli(start_onset_time) 
    return duration
  end

  def cut_sample(pad)
    return nil unless valid_sample?
    
    pad_name = "pad_#{pad}"
    # Thread.new do 
      puts "-------------------------SPLIT-------------------------------\n\n\n"
      puts mp3split_command = "mp3splt -d #{PATCH_DIRECTORY} -o #{pad_name} \"#{self.track.path_and_file}\" #{convert_time_format(self.start_onset_time)} #{convert_time_format(self.stop_onset_time)}"
      `#{mp3split_command}`
      puts "-------------------------TO WAV-------------------------------\n\n\n"
      puts convert_format_command = "ffmpeg -y -i #{File.join(PATCH_DIRECTORY, pad_name+'.mp3')}  -ac 2 #{File.join(PATCH_DIRECTORY, pad_name+'.wav')}"
      `#{convert_format_command}`
    # end

  end




  def valid_sample?
     return nil unless self.start_onset_index.present? && self.track.present? && self.track.onset_times.present?
     return true
  end



end
