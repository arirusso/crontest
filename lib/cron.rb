class Cron

  def as_cron(command)
    "echo '* * * * * #{command}' | crontab"
  end
  
  def activate(text)
    command = text.chomp.eql?('') ? 'crontab -r' : text
    %x[#{command}]
    system(command) # to get the result type    
  end
  
  # get current crontab
  def current
    %x[crontab -l]
  end 
  
end