global_seeds_path = File.join(Rails.root, "db", "seeds", "global")
Dir[File.join(global_seeds_path, "*.rb")].sort.each do |seed|
  if File.exist?(seed)
    p "Seeding global: " + File.basename(seed, ".*")
    load(seed)
  end
end

environment_seeds_path = File.join(Rails.root, "db", "seeds/#{Rails.env.downcase}")
Dir[File.join(environment_seeds_path, "*.rb")].sort.each do |seed|
  if File.exist?(seed)
    p "Seeding for " + File.basename(seed, ".*")
    load(seed)
  end
end
