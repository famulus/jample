class CurrentPatch

  include Mongoid::Document


  field :patch_index, type: Integer
  field :patch_set_id, type: String
  field :subset_search_string, type: String


  def self.init
    if true #CurrentPatch.count != 1
      CurrentPatch.delete_all
      CurrentPatch.create(patch_index:1, patch_set_id: PatchSet.last.id)

    end
  end

  def self.set_current_patch( patch_index)
    begin
      cp = CurrentPatch.first
      cp.patch_index = patch_index
      # increment the voice count for this patch
      patch = CurrentPatch.get_current_patch_set.patches.detect{|patch| patch.patch_index == patch_index}
      patch.voiced_count = (patch.voiced_count || 0) + 1
      patch.save
      cp.save
    rescue => e
      debugger
    end
  end

  def self.get_current_patch
    patch_index = CurrentPatch.last.patch_index
    patch_set = CurrentPatch.get_current_patch_set
    p = CurrentPatch.get_current_patch_set.patches.detect{|patch| patch.patch_index == patch_index}

    return p
  end

  def self.set_current_patch_set(patch_set)
    cp = CurrentPatch.first
    cp.patch_set_id = patch_set.id
    cp.save
  end


  def self.get_current_patch_set()
    cp = CurrentPatch.first
    ps = PatchSet.find(cp.patch_set_id)
  end

  def self.get_current_filter_set
    puts "\n\nbegin filter\n\n"
    # debugger
    subset_search_string = CurrentPatch.last.subset_search_string
    track_id_lookup = Track.find(subset_search_string) rescue nil
    if track_id_lookup.present?
      subset_of_tracks = [track_id_lookup.id.to_s]
    elsif subset_search_string == ''
      subset_of_tracks = Track.where(track_missing: false).pluck(:id)
    else
      subset_of_tracks = Track.where(path_and_file: /#{subset_search_string}/i, track_missing: false).pluck(:id) # TODO: this line gets slow as the found set grows
      subset_of_tracks = subset_of_tracks +  Track.where(mp3_data_string: /#{subset_search_string}/i, track_missing: false).pluck(:id)
      subset_of_tracks = subset_of_tracks.uniq
    end
    puts "\n\n\nend filter\n\n"
    return subset_of_tracks
  end


end
