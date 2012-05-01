require './hanged-man'

task :hangman do
  raise ArgumentError, "need challenge=name on command line" unless ENV['challenge']
   HangedMan::Game.new(
    HangedMan::Challenge.new(
      File.read("challenges/" + ENV['challenge'] + "/complete.txt"),
      File.read("challenges/" + ENV['challenge'] + "/obscured.txt")
    )
  ).run
end

task :new do
  raise ArgumentError, "need challenge=name on command line" unless ENV['challenge']
  mkdir_p "challenges/#{ENV['challenge']}"
  touch "challenges/#{ENV['challenge']}/complete.txt"
  touch "challenges/#{ENV['challenge']}/obscured.txt"
end

task :default do
  HangedMan::Game.new(
    HangedMan::Challenge.new(
      File.read("challenge_complete.txt"),
      File.read("challenge_obscured.txt")
    )
  ).run
end
 
