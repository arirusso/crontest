module Crontest
  
  VERSION = "0.0.11"
  
  def self.run(command, opts = {})    
    Process.new(command, opts).run  
  end
  
  class CrontabFile
  
    attr_reader :path, :contents
  
    # create temp file with current cron + new cron task in it using current time + @offset second offset
    def initialize(path)
      @contents = Crontest::CrontabHelper.current_crontab
      @path = path
      File.open(@path, 'w') {|f| f.write(@contents) }
    end
  
    # deletes the file
    def delete
      File.delete(@path)
    end

  end
  
  class CrontabHelper

    def self.cronify(command)
      "* * * * * #{command}"
    end
  
    def self.activate(text, time)
      if text.chomp.eql?('') 
        %x[crontab -r]
      else
        tmpfile = "/tmp/cron-#{time}"
        %x[echo \"#{text}\" >> #{tmpfile}]
        %x[crontab #{tmpfile}]
        result = system("crontab #{tmpfile}") # to get the result type - is there a better way to do this?
        %x[rm #{tmpfile}]
        result
      end
    end
  
    # get current crontab
    def self.current_crontab
      %x[crontab -l]
    end 
  
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
      time = Time.now.strftime('%Y%m%d%H%M%S')
      @backup = CrontabFile.new("crontab-backup-#{time}")
      
      new_crontab = @backup.contents + CrontabHelper.cronify(@command)
      out("testing command #{new_crontab}")
      CrontabHelper.activate(new_crontab, time) || crontab_on_enter.eql?(CrontabHelper.current_crontab) or 
        quit_with_error("command not accepted by cron")
      
      wait_time = calc_wait_time
      out("test will run in #{wait_time} seconds", true)
      sleep(wait_time)
      
      CrontabHelper.activate(@backup.contents, time) # restore to original crontab
      
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
