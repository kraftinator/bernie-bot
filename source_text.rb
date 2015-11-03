class SourceText

  attr_accessor :first_part
  attr_accessor :second_part
  attr_accessor :category
  
  def initialize( opts={} )
    @first_part = opts[:first_part]
    @second_part = opts[:second_part]
    @category = opts[:category]
  end
  
end