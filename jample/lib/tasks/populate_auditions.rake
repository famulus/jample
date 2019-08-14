require 'shellwords'




task :populate_auditions => :environment do
	Voice.all.each do |voice|

		if voice.auditions.blank? 
	    current_audition  = voice.auditions.create({
	      voice_id: voice.id,
	      track_id: voice.track_id,
				start_onset_index: voice.start_onset_index, 
				stop_onset_index: voice.stop_onset_index, 
				start_onset_time: voice.start_onset_time, 
				stop_onset_time: voice.stop_onset_time, 
				voiced_count: voice.voiced_count, 
	    })
	    voice.current_audition_id = current_audition.id
	    voice.save

		end
	end
end


