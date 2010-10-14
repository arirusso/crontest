module Crontest
  
  VERSION = "0.0.6"
  
  def self.run(command, opts = {})    
    Process.new(command, opts).run  
  end
  
  class Process
    
    def initialize(command, opts = {})
      @do_backup = opts[:backup] || true
      @verbose = opts[:verbose] || false
      @command = command
    end
    
    def run
      raise "current directory must be writable" unless pwd_writable?
      
      crontab_on_enter = CrontabHelper.current_crontab
      @backup = CrontabFile.new("crontab-backup-#{Time.now.strftime('%Y%m%d%H%M%S')}")
      
      new_crontab = @backup.contents + CrontabHelper.cronify(@command)
      out("testing command #{new_crontab}")
      CrontabHelper.activate(new_crontab) || crontab_on_enter.eql?(CrontabHelper.current_crontab) or 
      quit_with_error("command not accepted by cron")
      
      wait_time = calc_wait_time
      out("test will run in #{wait_time} seconds", true)
      sleep(wait_time)
      
      CrontabHelper.activate(@backup.contents) # restore to original crontab
      
      unless crontab_on_enter.eql?(CrontabHelper.current_crontab)
        quit_with_error("restored crontab doesn't match original")
      end
      
      cleanup(@do_backup)

      out('finished', true)
    end
    
    private

    def cleanup(keep_backup)
      keep_backup ? 
        out("saved backup file #{Dir.pwd}/#{@backup.path}") :
	  @backup.delete
    end
    
    def calc_wait_time
      2 + (60 - Time.now.strftime('%S').to_i)
    end
    
    def out(text, always_show = false)
      STDOUT.puts("crontest: #{text}") if (@verbose || always_show)
    end
    
    def quit_with_error(error)
      cleanup(true)
      raise error
    end
    
    def pwd_writable?
      File.writable?('.')
    end
    
  end
  
end
