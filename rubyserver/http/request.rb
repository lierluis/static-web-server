# receives a stream in constructor, & parses content into members
class Request
  attr_reader :verb,:uri,:query,:version,:headers,:body,:socket,:extension
  
  def initialize(stream)
    @socket = stream
  end
  
  def parse
    request_line = @socket.gets.split(" ")
    puts request_line.join(" ")
    
    path, @extension = request_line[1].split(".")
    path, query = request_line[1].split("?")
    
    @verb    = request_line[0]
    @uri     = request_line[1]
    @query   = query
    @version = request_line[2]
    @headers = Hash.new
    
    # get headers up until blank line
    while (header = @socket.gets) != "\r\n"
      key, value = header.split(": ")
      @headers.store(key, value)
    end
    
    @headers.map{|key, value| puts "#{key}: #{value}"}
    puts "\r\n" # blank line
    
    # print body if 'Content-Length' header exists
    if @headers.has_key?('Content-Length')
      content_length = @headers.values_at('Content-Length')[0].to_i
      @body = @socket.read(content_length)
      puts @body
    end
  
  end
end
