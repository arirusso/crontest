class Crontest
  
  def self.run(command, opts)    
    new(command, opts).run  
  end
  
  def initialize(command, opts = {})
    @command = command
    @do_backup = opts[:backup] || true
  end
  
  # the cron test process
  def run
    raise "current directory must be writable" unless dir_writable?
    cron = Cron.new
    crontab_on_enter = cron.current
    @backup = Cronfile.new("crontab-backup-#{Time.now.strftime('%Y%m%d%H%M%S')}", cron.current)
    cron.activate(@backup.contents + cron.as_cron(@command)) || crontab_on_enter.eql?(cron.current) or quit_with_error("command not accepted by crontab")
    
    wait_time = 60 - Time.now.strftime('%S').to_i
    out "waiting #{wait_time} seconds"
    sleep(wait_time)
    
    cron.activate(@backup.contents)

    unless crontab_on_enter.eql?(cron.current)
      p crontab_on_enter
      p cron.current
      quit_with_error("restored crontab doesn't match original")
    end
    cleanup(@do_backup)
    out 'finished'
  end
  
  private
  
  def self.out(text)
    STDOUT.puts("crontext: #{text}")
  end
  
  def out(text)
    Crontest.out(text)
  end
  
  def quit_with_error(error)
    cleanup(false)
    STDERR.puts "crontest: #{error}"
    out "exiting"
    exit
  end
  
  def cleanup(delete_backup)
    unless delete_backup
      out "saved backup file #{Dir.pwd}/#{@backup.path}"
    else
      @backup.delete
    end
  end
  
  # is the current directory writable?
  def dir_writable?
    File.writable?('.')
  end
   
end