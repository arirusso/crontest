class Crontest
  
  def self.run(command, opts)    
    new(command, opts).run  
  end
  
  def initialize(command, opts = {})
    @command = command
    @do_backup = opts[:backup] || true
  end
  
  def run
    raise "current directory must be writable" unless pwd_writable?
    
    cron = Cron.new
    crontab_on_enter = cron.current
    @backup = Cronfile.new("crontab-backup-#{Time.now.strftime('%Y%m%d%H%M%S')}", cron.current)
    
    new_cron = @backup.contents + cron.as_cron(@command)
    out("testing command #{new_cron}")
    cron.activate(new_cron) || crontab_on_enter.eql?(cron.current) or 
      quit_with_error("command not accepted by crontab")
    
    wait_time = 60 - Time.now.strftime('%S').to_i
    out("test will run in #{wait_time} seconds")
    sleep(wait_time)
    cron.activate(@backup.contents)

    unless crontab_on_enter.eql?(cron.current)
      quit_with_error("restored crontab doesn't match original")
    end
    
    cleanup(@do_backup)
    out('finished')
  end
  
  private
  
  def out(text)
    STDOUT.puts("crontest: #{text}")
  end
  
  def quit_with_error(error)
    cleanup(false)
    STDERR.puts("crontest: #{error}")
    out("exiting")
    exit
  end
  
  def cleanup(delete_backup)
    delete_backup ?
      @backup.delete:
        out("saved backup file #{Dir.pwd}/#{@backup.path}")
        
  end
  
  def pwd_writable?
    File.writable?('.')
  end
   
end