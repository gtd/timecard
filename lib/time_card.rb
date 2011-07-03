module TimeCard
  DEBUG = false

  class << self
    def invoke
      $stderr.puts "=== Welcome to Ruby Timecard! ==="

      @tasks = []
      @new_input = nil

      Signal.trap("INT") do
        dump_tasks
        exit(0)
      end

      state_loop(:ask_task)
    end

    def state_loop(state)
      loop do
        $stderr.puts "Entering state #{state}..." if DEBUG
        state = send(state)
      end
    end

    def ask_task
      $stderr.print "What will you work on now? "

      @task_name = $stdin.readline.chomp
      @tasks << {:name => @task_name, :time_pairs => []}

      :time_loop
    end

    def time_loop
      @start_time = Time.now

      await_input

      loop do
        next_state = process_input { |input| time_loop_transition(input) }
        return next_state if next_state

        elapsed = Time.now - @start_time
        $stderr.print "\r\e[0K*#{format_seconds(sum_time_pairs(@tasks.last) + elapsed)} * #{@task_name} (p = pause, f = done)"
        sleep(0.5)
      end
    end

    def time_loop_transition(command)
      @tasks.last[:time_pairs] << [@start_time, Time.now]
      @start_time = nil

      case command
      when 'p'
        :pause_task
      when 'f'
        :finish_task
      end
    end

    def pause_task
      $stderr.print "\r\e[0K*#{format_seconds(sum_time_pairs(@tasks.last))} * #{@task_name} (paused, any key to resume)"

      await_input

      loop do
        next_state = process_input { |input| :time_loop }
        return next_state if next_state

        sleep(0.5)
      end
    end

    def finish_task
      $stderr.print "\r\e[0K"
      $stdout.puts ">#{format_seconds(sum_time_pairs(@tasks.last))} #{@tasks.last[:name]}"
      return :ask_task
    end

    def dump_tasks
      if @tasks.any?
        puts "\n"
        i = 0
        @tasks.each do |task|
          i += 1
          puts "Task ##{i}: #{task[:name]} #{format_seconds(sum_time_pairs(task))}"
          task[:time_pairs].each { |pair| puts "  " + pair.inspect }
        end
      end
    end

    private

    def format_seconds(seconds)
      seconds = seconds.to_i
      minutes = seconds / 60
      seconds = seconds % 60
      hours = minutes / 60
      minutes = minutes % 60
      sprintf("%2d:%02d:%02d", hours, minutes, seconds)
    end

    def await_input
      Thread.start do
        @new_input = get_char
        $stdin.flush
      end
    end

    def get_char
      system("stty raw -echo") #=> Raw mode, no echo
      char = $stdin.getc
      system("stty -raw echo") #=> Reset terminal mode
      Process.kill("INT", $$) if char == "\u0003"
      char
    end

    def sum_time_pairs(task)
      task[:time_pairs].inject(0){ |sum,p| sum + (p.last - p.first) }
    end

    def process_input
      if @new_input
        input = @new_input
        @new_input = nil
        yield(input)
      end
    end
  end
end
