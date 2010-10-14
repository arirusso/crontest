class Cron

  def as_cron(command)
    "echo '* * * * * #{command}' | crontab"
  end
  
  def activate(text)
    Crontest.out "testing command #{text}"
    %x[#{text}]
    system(text) # to get the result type    
  end
  
  # get current crontab
  def current
    %x[crontab -l]
  end 
  
end