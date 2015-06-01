namespace :clean_up do
  desc "Remove searches that are a week old"
  task :remove_searches, [:num] => :environment do |task, args|
    days_ago = args[:num].to_i.days.ago
    Search.where(["created_at < ?", days_ago]).map(&:destroy)


  end

  desc "TODO"
  task remove_xl_files: :environment do

  end

end
