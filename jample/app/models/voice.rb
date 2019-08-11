class Voice  
  include TimeHelpers

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :track_id, type: String
  field :max_for_live_voice_id, type: String
  field :start_onset_index, type: Integer
  field :stop_onset_index, type: Integer
  field :start_onset_time, type: String
  field :stop_onset_time, type: String
  field :voiced_count, type: Integer

  belongs_to :track, index: true



  def randomize_voice(subset_of_track_ids)

    # return if self.is_frozen?
    duration_in_slices = 12
    track_path = nil
    # debugger
    puts "\n\n\nATTEMPT\n\n"
      track_id = subset_of_track_ids.shuffle.first
      self.track = Track.find(track_id.to_s)
      track_onset_array = self.track.onset_times
    track_path = self.track.escaped_path_and_file
    #   break if (track_onset_array.size > (duration_in_slices + 1))
    # while  # if the track has too few samples, randomly pick another track, until a suitable track is found
    # end
    # track_onset_array.size rescue debugger
    track_onset_array = self.track.onset_times
    puts "\n\n\nTRACK: #{self.track.id}\n\n"
  # debugger

     
    max_start_index = track_onset_array.size - duration_in_slices # figure out the max starting index that won't go out of bounds
    self.start_onset_index = rand(0...max_start_index) # pick a random starting index
    self.stop_onset_index = [(self.start_onset_index + duration_in_slices), (track_onset_array.size - 1)].min

    self.start_onset_time = self.track.onset_times[self.start_onset_index]
    self.stop_onset_time = self.track.onset_times[self.stop_onset_index]
    debugger if self.stop_onset_time.to_i < 1
    duration = (sec_dot_milli_to_milli(self.stop_onset_time) - sec_dot_milli_to_milli(self.start_onset_time) ).round(5)


    shift_slice_forward_one_index = {
      start_onset_index: start_onset_index+1,
      stop_onset_index: stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index+1}/#{stop_onset_index+1}",
    }

    shift_slice_backward_one_index = {
      start_onset_index: start_onset_index-1,
      stop_onset_index: stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index-1}/#{stop_onset_index-1}",

    }
    grow_by_one_index = {
      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index}/#{stop_onset_index+1}",
    }

    shrink_by_one_index = {
      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index}/#{stop_onset_index-1}",

    }

    self.save 

    # debugger #if self.duration < 0
    response = {
      track_id: self.track.id.to_s,
      track_path: track_path,
      title: self.track.title || "NA",
      artist: self.track.artist || "NA",
      album: self.track.album || "NA",
      year: self.track.year || "NA",
      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index,
      start: sec_dot_milli_to_milli(self.start_onset_time), 
      duration: (duration ) ,
      shift_slice_forward_one_index: shift_slice_forward_one_index,
      shift_slice_backward_one_index: shift_slice_backward_one_index,
      grow_by_one_index: grow_by_one_index,
      shrink_by_one_index: shrink_by_one_index,

    }

    ap response
    return response
  end







  def to_json

    if self.stop_onset_time.present?
    duration = (sec_dot_milli_to_milli(self.stop_onset_time) - sec_dot_milli_to_milli(self.start_onset_time) ).round(5)
    end

    shift_slice_forward_one_index = {
      start_onset_index: start_onset_index+1,
      stop_onset_index: stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index+1}/#{stop_onset_index+1}",
    }

    shift_slice_backward_one_index = {
      start_onset_index: start_onset_index-1,
      stop_onset_index: stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index-1}/#{stop_onset_index-1}",

    }
    grow_by_one_index = {
      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index}/#{stop_onset_index+1}",
    }

    shrink_by_one_index = {
      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index}/#{stop_onset_index-1}",

    }


    # debugger #if self.duration < 0
    return {
      track_id: self.track.id.to_s,
      track_path: self.track.escaped_path_and_file,
      title: self.track.title,
      artist: self.track.artist,
      album: self.track.album,
      year: self.track.year,

      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index,
      start: sec_dot_milli_to_milli(self.start_onset_time), 
      duration: (duration ) ,
      shift_slice_forward_one_index: shift_slice_forward_one_index,
      shift_slice_backward_one_index: shift_slice_backward_one_index,
      grow_by_one_index: grow_by_one_index,
      shrink_by_one_index: shrink_by_one_index,

    }
  end


end