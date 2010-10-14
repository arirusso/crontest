class Crontest::CrontabFile
  
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