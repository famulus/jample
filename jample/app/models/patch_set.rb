class PatchSet
	include Mongoid::Document

	has_many :patches

  # add a class attr for current patchset
 
 	@@current_patch = PatchSet.last

  def self.init_16_patches
  	new_patch_set = PatchSet.create({})

  	(0..15).each do |index|
  		patch = Patch.create({patch_index: index})
  		patch.randomize_patch
  		patch.patch_set = new_patch_set
  		patch.save
  	end
		new_patch_set.become_current_patch
		new_patch_set.save

  end

  def become_current_patch
  	@@current_patch = self.id
  	
  end

  def self.get_current_patch
  	@@current_patch 
  	
  end

  def p(patch_number)
    return self.patches[(patch_number - 1)]
    
  end

end
