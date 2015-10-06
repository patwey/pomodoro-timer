class Pomodoro
  attr_accessor :pomodoros, :p_interval, :b_interval,
                :pom_msg, :break_msg

  def initialize(p_interval = 25, b_interval = 5)
    @pomodoros = 0
    @p_interval = p_interval
    @b_interval = b_interval
    @pom_msg = 'take a break'
    @break_msg = 'back to work'
  end

  def header(pomodoros)
    "Pomodoro Timer\t\t [ #{pomodoros} ]\n------------------------------"
  end

  def prompt
    "~ "
  end

  def get_input(question)
    # returns downcased input
    puts question.ljust(50)
    print prompt
    gets.chomp.downcase
  end

  def timer(interval)
    start = Time.now
    finish = start + interval
    ts = timestamp(finish)
    loop do
      ts = timestamp(finish)
      print formatted_timestamp(ts)
      break if Time.now > finish
    end
  end

  def formatted_timestamp(timestamp)
    "\t       " + timestamp + "\r"
  end

  def timestamp(finish)
    remaining = ((finish - Time.now) / 60).round
    return " <1 minute left" if remaining < 1
    return "  1 minute left" if remaining < 2
    return " #{remaining} minutes left" if remaining < 10
    "#{remaining} minutes left"
  end

  def minutes(seconds)
    seconds * 60
  end

  def take_pomodoro
    timer(minutes(p_interval))
    @pomodoros += 1
    system("say #{pom_msg}")
  end

  def take_break
    timer(minutes(b_interval))
    system("say #{break_msg}")
  end

  def clear_terminal
    print `clear`
  end

  def start
    loop do
      clear_terminal
      puts header(pomodoros)
      input = get_input("start timer? (or quit)")
      break if input.include?('q')
      take_pomodoro

      clear_terminal
      puts header(pomodoros)
      input = get_input("take a break? (or skip / quit)")
      break if input.include?('q')
      take_break unless input.include?('s')
    end
  end
end

# customize timer:
if $0 == __FILE__
  # Pomodoro.new(pomodoro length in minutes, break length in minutes)
  pomodoro = Pomodoro.new(10, 5)
  pomodoro.pom_msg = 'take a break' # set post-pomodoro message
  pomodoro.break_msg = 'back to work' # set post-break message
  pomodoro.start # start program
end
