class Crontest
  
  def self.run(command, opts)    
    new(command, opts).run  
  end
  
  def initialize(command, opts = {})
    @do_backup = opts[:backup] || true
    @verbose = opts[:verbose] || false

    @command = command
  end
  
  def run
    raise "current directory must be writable" unless pwd_writable?
    
    cron = Cron.new
    crontab_on_enter = cron.current
    @backup = Cronfile.new("crontab-backup-#{Time.now.strftime('%Y%m%d%H%M%S')}", cron.current)
    
    new_cron = @backup.contents + cron.cronify(@command)
    out("testing command #{new_cron}")
    cron.activate(new_cron) || crontab_on_enter.eql?(cron.current) or 
      quit_with_error("command not accepted by crontab")
    
    wait_time = 2 + (60 - Time.now.strftime('%S').to_i)
    out("test will run in #{wait_time} seconds", true)
    sleep(wait_time)
    cron.activate(@backup.contents)

    unless crontab_on_enter.eql?(cron.current)
      quit_with_error("restored crontab doesn't match original")
    end
    
    cleanup(@do_backup)
    out('finished', true)
  end
  
  private
  
  def out(text, always_show = false)
    STDOUT.puts("crontest: #{text}") if (@verbose || always_show)
  end
  
  def quit_with_error(error)
    cleanup(false)
    raise error
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