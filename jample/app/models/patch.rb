  include TimeHelpers
  include Settings


  class Patch
    include Mongoid::Document


    field :patch_index, type: Integer
    field :track_id, type: String
    field :start_onset_index, type: Integer
    field :stop_onset_index, type: Integer

    belongs_to :track

    index({ track_id: 1, start_onset_index: 1, stop_onset_index: 1 }, { unique: true, drop_dups: true })

    # what makes a sample unique? 

    def self.init_16_patches
    	Patch.delete_all
    	(0..15).each do |index|
    		patch = Patch.create({patch_index: index})
    		patch.randomize_patch
    		patch.save

    	end
    	
    end

    def self.grab(patch_index)
    	return Patch.where(patch_index: (patch_index - 1)).first
    end

    def randomize_patch
    	self.track = Track.all.shuffle.first
    	duration_in_slices = 10
    	track_onset_array = self.track.onset_times
    	usable_onset_times = track_onset_array.split(track_onset_array.size - duration_in_slices).first
    	self.start_onset_index = usable_onset_times.shuffle.first
    	self.stop_onset_index = self.start_onset_index + duration_in_slices
    	self.save
  		self.cut_sample(self.patch_index)
    	
    end

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




    def grow_patch_by_one_on_the_end
    		self.stop_onset_index += 1
    		self.save
    		self.cut_sample(self.patch_index)
    end
   
    def shrink_patch_by_one_on_the_end
    		self.stop_onset_index -= 1
    		self.save
    		self.cut_sample(self.patch_index)
    end

    def shift_sample_forward_one_slice
    		self.start_onset_index += 1
    		self.stop_onset_index += 1
    		self.save
    		self.cut_sample(self.patch_index)
    		
  	end	

    def shift_sample_backward_one_slice
    		self.start_onset_index -= 1
    		self.stop_onset_index -= 1
    		self.save
    		self.cut_sample(self.patch_index)
  	end	


  	def copy_patch(desired_patch)
  		desired_patch_object = Patch.where(patch_index: (desired_patch -1) ).first
  		self.track = desired_patch_object.track
  		self.start_onset_index = desired_patch_object.start_onset_index
  		self.start_onset_index = desired_patch_object.start_onset_index
  		self.stop_onset_index = desired_patch_object.stop_onset_index
  		self.save
  		self.cut_sample(self.patch_index)

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
