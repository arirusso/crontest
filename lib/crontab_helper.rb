class Crontest::CrontabHelper

  def self.cronify(command)
    "echo '* * * * * #{command}' | crontab"
  end
  
  def self.activate(text)
    command = text.chomp.eql?('') ? 'crontab -r' : text
    %x[#{command}]
    system(command) # to get the result type - is there a better way to do this?    
  end
  
  # get current crontab
  def self.current_crontab
    %x[crontab -l]
  end 
  
end