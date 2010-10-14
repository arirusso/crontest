class Cronfile
  
  attr_reader :path, :contents
  
  # create temp file with current cron + new cron task in it using current time + @offset second offset
  def initialize(path, contents)
    @contents = contents
    @path = path
    File.open(@path, 'w') {|f| f.write(contents) }
  end
  
  # adds crontask to the file's contents
  def append(text)
    @contents += text
  end
  
  # deletes the file
  def delete
    File.delete(@path)
  end

end