task :import_tracks => :environment do
  Track.import_tracks
end


task :init => :environment do
     
  cp = CurrentPatch.create 
  cp.set_current_patch (Patch.create)
  # CurrentPatch.init
end


task :reset => :environment do
  # FileUtils.mkpath( PATCH_DIRECTORY)
  Track.destroy_all
  Audition.destroy_all
  Voice.destroy_all
  CurrentPatch.init
end