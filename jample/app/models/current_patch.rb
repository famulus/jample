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
    cp = CurrentPatch.first
    cp.patch_index = patch_index
    # cp.patch_set = patch_set
    cp.save
  end

  def self.get_current_patch
    patch_index = CurrentPatch.last.patch_index
    patch_set = CurrentPatch.get_current_patch_set
    p =patch_set.p(patch_index)

    return p
  end

  def self.set_current_patch_set(patch_set)
    cp = CurrentPatch.first
    cp.patch_set_id = patch_set.id
    cp.save
  end


  def self.get_current_patch_set()
    cp = CurrentPatch.first
    ps= PatchSet.find(cp.patch_set_id)
  end

  def self.get_current_filter_set
    subset_search_string = CurrentPatch.last.subset_search_string
    subset_of_tracks = Track.where(path_and_file: /#{subset_search_string}/i, track_missing: false)
    subset_of_tracks = subset_of_tracks +  Track.where(mp3_data_string: /#{subset_search_string}/i, track_missing: false)
    subset_of_tracks = subset_of_tracks.uniq
  end


end
