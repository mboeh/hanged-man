module HangedMan; end

class HangedMan::Challenge

  def initialize(original = nil, obscured = nil)
    self.original_text = original
    self.obscured_text = obscured
  end

  def original_text=(value)
    @original_text = value
    @obscured_text = value
  end

  def obscured_text=(value)
    raise ArgumentError, "obscured text doesn't line up with original text" unless correctly_obscured?(value)
    @obscured_text = value
    reset
  end

  def ready?
    @original_text and @obscured_text
  end

  def reset
    @current_game = @obscured_text.dup
  end

  def cheat
    @current_game = @original_text.dup
  end

  def try(c)
    matched = false
    @original_text.each_char.with_index do |orig_c,i|
      if orig_c == c
        @current_game[i] = c
        matched = true
      end
    end
    matched
  end
  
  def to_s
    @current_game
  end
  
  def correctly_obscured?(value)
    @original_text =~ Regexp.new(Regexp.escape(value).gsub('_', '.'))
  end

end

class HangedMan::PoorSoul

  PARTS = %w[head trunk left-arm right-arm left-leg right-leg frown]

  def initialize
    @parts = []
  end
  
  def fail
    @parts << next_part
  end
  
  def dead?
    @parts.length == PARTS.length
  end

  def to_s
    "#{@parts.join("\n")}" + (dead? ? "\n ** OW :( **" : "")
  end

  def reset
    @parts = []
  end

  private

  def next_part
    PARTS[@parts.length]
  end

end

class HangedMan::Game

  def initialize(challenge)
    @challenge = challenge
    @hanged_man = HangedMan::PoorSoul.new
  end

  def run
    until @done
      system("clear")
      puts "\n\n## CHALLENGE ##\n"
      puts @challenge
      puts "\n\n## MAN ##\n"
      puts @hanged_man
      puts
      puts @message
      msg
      print "> "
      command = STDIN.gets
      unless command =~ /^\s*$/
        if command =~ /^[^ ]\s*$/
          try command.chars.first
        else
          begin
            send(*command.chomp.split(/\s+/))
          rescue NoMethodError
            msg ["WHAT YOU SAY?", "SOMEONE SET UP US THE BOMB", "YOU HAVE NO CHANCE TO SURVIVE MAKE YOUR TIME"].sample
          end
        end
      end
    end
  end

  def try(c)
    unless @challenge.try c[/^./]
      @hanged_man.fail
      msg ["NOPE", "NOT A CHANCE", "NO WAY", "HARDLY", "SORRY"].sample
      msg "WHAT A SHAME" if @hanged_man.dead?
    else
      msg "NOT BAD"
    end
  end

  def reset(*)
    @hanged_man.reset
    @challenge.reset
    msg "*BAMF*"
  end

  def cheat(*)
    @challenge.cheat
    msg "*POOF*"
  end

  def help(*)
    msg <<-EOF
try X - try letter "X"
X - try letter "X"
reset - reset man and puzzle
cheat - show the completed puzzle
exit - end the game
help - what do you think?
    EOF
  end
  private

  def msg(message = nil)
    @message = message
  end

end
