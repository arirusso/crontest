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
    raise "crontest: current directory must be writable" unless dir_writable?
    cron = Cron.new
    enter_crontab = cron.current
    @backup = Cronfile.new("crontab-backup-#{Time.now.strftime('%Y%m%d%H%M%S')}", cron.current)
    cron.activate(@backup.contents + @command) or error(false)
    wait
    cron.activate(@backup.contents)
    exit_crontab = cron.current
    unless enter_crontab.eql?(exit_crontab)
      puts "crontest: ** there has been a problem, please check your crontab **"
      @do_backup = true # if there's a problem, don't delete the backup
    end
    cleanup(@do_backup)
    puts 'crontest: finished'
  end
  
  private
  
  def error(delete_backup)
    cleanup(delete_backup)
    puts "crontest: exiting"
    exit
  end
  
  def cleanup(delete_backup)
    unless delete_backup
      puts "crontest: saved backup file #{Dir.pwd}/#{@backup.path}"
    else
      @backup.delete
    end
  end
  
  # pause @offset seconds
  def wait
    sleep(60)
  end
  
  # is the current directory writable?
  def dir_writable?
    File.writable?('.')
  end
   
end