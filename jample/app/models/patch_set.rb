class PatchSet
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  DURATION_IN_SLICES = 12
  NUMBER_OF_PADS = 16


  field :patch_set_label, type: String
  has_many :patches, {:dependent => :destroy}



  def self.reload_pure_data
    begin
      s = TCPSocket.new 'localhost', 4040
      s.puts "reload;"
      s.close
    rescue
      puts "ERROR RELOADING PURE DATA"
    end
  end

  def self.cut_current_patch_set
    new_patch_set = CurrentPatch.get_current_patch_set
    new_patch_set.patches.each do |patch|
      patch.cut_sample(patch.patch_index)
    end
  end


  def self.init_16_patches
    new_patch_set = PatchSet.create({})
    subset_of_track_ids = CurrentPatch.get_current_filter_set
    (0..15).each do |index|
      patch = Patch.create({patch_index: index})
      patch.randomize_patch(subset_of_track_ids)
      patch.patch_set = new_patch_set
      patch.save
    end
    CurrentPatch.set_current_patch_set(new_patch_set)
    new_patch_set.save
    self.reload_pure_data()
  end


  def self.init_16_patches_as_sequence
    new_patch_set = PatchSet.create({})
    subset_of_track_ids = CurrentPatch.get_current_filter_set
    while 
      track_id = subset_of_track_ids.shuffle.first
      track = Track.find(track_id.to_s)
      break if track.onset_times.size > (DURATION_IN_SLICES + NUMBER_OF_PADS)
    end
    track_onset_array = track.onset_times
    max_start_index = (track.onset_times.size - (DURATION_IN_SLICES + NUMBER_OF_PADS))
    start_onset_index = rand(0...max_start_index)
    (0...NUMBER_OF_PADS).each do |index|
      patch = Patch.create({
        track: track,
        patch_index: index,
        start_onset_index: start_onset_index+index,
        stop_onset_index: [(start_onset_index+index+DURATION_IN_SLICES),(track_onset_array.size-1)].min
        })
      patch.patch_set = new_patch_set
      patch.save
      patch.cut_sample(index)
    end
    CurrentPatch.set_current_patch_set(new_patch_set)
    new_patch_set.save
    self.reload_pure_data()
  end


  def self.init_16_patches_as_duration_sequence
    new_patch_set = PatchSet.create({})
    subset_of_track_ids = CurrentPatch.get_current_filter_set
    subset_of_tracks = DurationIndex.where({:track_id.in => subset_of_track_ids})
    random_start  = (0 .. subset_of_tracks.size ).to_a.shuffle.first
    subset_of_tracks.sort({:duration => -1}).skip(random_start).limit(16).each_with_index do |duration_index,index|
      patch = Patch.create({
        track: duration_index.track,
        patch_index: index,
        start_onset_index: duration_index.start_onset_index,
        stop_onset_index: (duration_index.start_onset_index + DURATION_IN_SLICES)
        })
      patch.patch_set = new_patch_set
      patch.save
      patch.cut_sample(index)
    end
    CurrentPatch.set_current_patch_set(new_patch_set)
    new_patch_set.save
    self.reload_pure_data()
  end

  def self.expand_single_patch_to_sequence()
    current_patch_set = CurrentPatch.get_current_patch_set
    seed_patch =  CurrentPatch.get_current_patch
    patch_index = seed_patch.patch_index
    track = seed_patch.track
    track_onset_array = track.onset_times
    first_patch_index = seed_patch.start_onset_index - patch_index
    new_patch_set = PatchSet.create({})
    (0...NUMBER_OF_PADS).each do |index|
      patch = Patch.create({
        track: track,
        patch_index: index,
        start_onset_index: first_patch_index+index,
        stop_onset_index: [(first_patch_index+index+DURATION_IN_SLICES),(track_onset_array.size-1)].min
        })
      patch.patch_set = new_patch_set
      patch.refresh_onset_times
      patch.save
      patch.cut_sample(index)
    end
    CurrentPatch.set_current_patch_set(new_patch_set)
    new_patch_set.save
    self.reload_pure_data()
  end

  def p(patch_index)
    return self.patches[(patch_index - 1)]
  end

  def duplicate_patch_set
    current_patch_set = CurrentPatch.get_current_patch_set
    new_patch_set = PatchSet.create
    current_patch_set.patches.each_with_index do |patch,index| 
      new_patch = patch.clone
      new_patch.patch_set = new_patch_set
      new_patch.save
      new_patch.cut_sample(index)
    end
    new_patch_set.save
    CurrentPatch.set_current_patch_set(new_patch_set)
  end

  def self.shuffle_unfrozen
    current_patch_set = CurrentPatch.get_current_patch_set
    subset_of_track_ids = CurrentPatch.get_current_filter_set
    current_patch_set.patches.each_with_index do |patch, index|
      patch.randomize_patch(subset_of_track_ids)
    end
  end


  def previous_patch_set
    mongoid = self.id.to_s
    PatchSet.where(:_id.lt => self._id).order_by([[:_id, :desc]]).limit(1).first.id.to_s rescue nil
  end


  def next_patch_set
    mongoid = self.id
    PatchSet.where(:_id.gt => self._id).order_by([[:_id, :asc]]).limit(1).first.id.to_s rescue nil
  end


  def voiced_count
    self.patches.inject(0){|memo, patch| memo + (patch.voiced_count || 0) }
  end


end
