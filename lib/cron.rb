class Cron

  # activates the cronfile
  def activate(text)
    puts "crontest: testing command #{text}"
    command = "echo '* * * * * #{text} | crontab'"
    %x[#{command}]
    system(command) # to get the result type
  end
  
  # get current crontab
  def current
    %x[crontab -l]
  end 
  
end