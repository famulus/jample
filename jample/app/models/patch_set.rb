class PatchSet
  include Mongoid::Document
  include Mongoid::Timestamps::Created


  field :patch_set_label, type: String
  has_many :patches


  def self.reload_pure_data
    s = TCPSocket.new 'localhost', 4040
    s.puts "reload;"
    s.close

  end

  def self.init_16_patches
    new_patch_set = PatchSet.create({})

    (0..15).each do |index|
      patch = Patch.create({patch_index: index})
      patch.randomize_patch
      patch.patch_set = new_patch_set
      patch.save
    end
    CurrentPatch.set_current_patch_set(new_patch_set)
    new_patch_set.save
    self.reload_pure_data()

  end

  def self.cut_current_patch_set
    new_patch_set = CurrentPatch.get_current_patch_set
    new_patch_set.patches.each do |patch|
      patch.cut_sample(patch.patch_index)
    end


  end

  def self.init_16_patches_as_sequence
    new_patch_set = PatchSet.create({})

    duration_in_slices = 12
    subset_of_track_ids = CurrentPatch.get_current_filter_set
    track_id = subset_of_track_ids.shuffle.first
    track = Track.find(track_id.to_s)
    track_onset_array = track.onset_times
    return if (track_onset_array.size <= (duration_in_slices+1))
    usable_onset_times = track_onset_array[0...(track_onset_array.size - duration_in_slices)]

    start_onset_index = track.onset_times.index( usable_onset_times.shuffle.first)

    (0..15).each do |index|
      patch = Patch.create({
        track: track,
        patch_index: index,
        start_onset_index: start_onset_index+index,
        stop_onset_index: start_onset_index+index+duration_in_slices
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

    duration_in_slices = 1
    subset_of_track_ids = CurrentPatch.get_current_filter_set
    random_start  = (0 .. DurationIndex.count ).to_a.shuffle.first
    DurationIndex.all.sort({:duration => -1}).skip(random_start).limit(16).each_with_index do |duration_index,index|
      patch = Patch.create({
        track: duration_index.track,
        patch_index: index,
        start_onset_index: duration_index.start_onset_index,
        stop_onset_index: (duration_index.start_onset_index + duration_in_slices)
        })
      patch.patch_set = new_patch_set
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


  def previous_patch_set
    mongoid = self.id.to_s
    PatchSet.where(:conditions => {:_id.lt => mongoid}).sort({:_id => -1 }).limit(1).last

  end

  def next_patch_set
    mongoid = self.id
    PatchSet.where(:conditions => {:_id.gt => mongoid}).sort({:_id => 1 }).limit(1).last
  end

  def voiced_count
    self.patches.inject(0){|memo, patch| memo + (patch.voiced_count || 0) }
  end


end
