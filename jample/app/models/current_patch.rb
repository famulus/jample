class CurrentPatch

  include Mongoid::Document


  field :patch_index, type: Integer
  field :patch_set_id, type: String


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
    patch_set = PatchSet.where(id: CurrentPatch.last.patch_set_id).last
    p =patch_set.p(patch_index)

    return p
  end

end
