require "hashids"

HashidsRails = Hashids.new(
  ENV.fetch("HASHIDS_SALT", "local-salt"), # Use a secure salt
  8 # Minimum length of the hash
)
