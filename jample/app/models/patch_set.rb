class PatchSet
	include Mongoid::Document
  include Mongoid::Timestamps::Created


	has_many :patches

  # add a class attr for current patchset
 
 	

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

  end


  def p(patch_number)
    return self.patches[(patch_number - 1)]
    
  end

end
