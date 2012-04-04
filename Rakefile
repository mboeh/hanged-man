require './hanged-man'

task :default do
  HangedMan::Game.new(
    HangedMan::Challenge.new(
      File.read("challenge_complete.txt"),
      File.read("challenge_obscured.txt")
    )
  ).run
end
