require 'active_support'
require_relative 'source_text'
## require '../project/bernie-bot/bernie_bot'

class BernieBot

  MAX_CHARS = 140
  
  attr_accessor :texts
  
  def initialize( client )
    @texts = source_texts( client )
  end
  
  def tweet_length(text)
    ActiveSupport::Multibyte::Chars.new(text).normalize(:c).length 
  end
  
  def valid_tweet?(text)
    return false if text.nil?
    tweet_length(text) <= MAX_CHARS ? true : false
  end
  
  def build_text
    first_text = @texts.shuffle.first
    second_texts = @texts.find_all { |t| t.category == first_text.category }
    second_texts.delete_if { |t| ( t.first_part == first_text.first_part ) or ( !valid_tweet?("#{first_text.first_part} #{t.second_part}") ) }
    return false, "NOT POSSIBLE: #{first_text.first_part}" if second_texts.empty?
    second_text = second_texts.shuffle.first
    result = "#{first_text.first_part} #{second_text.second_part}"
    
    ## Return false if too many colons
    return false, "TOO MANY COLONS: #{result}" if result.count(':') > 1
    
    ## Return false for certain word combos 
    return false, "INVALID WORD COMBO: #{result}" if result =~ /because for/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /because is/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /because was/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /because has/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /but of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /can have to/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /from teens pleads/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /it should it/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /look which all/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /might it/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /one who aren't/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /shall of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /should do that is/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /sure which the/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /their will/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /\. to /
    return false, "INVALID WORD COMBO: #{result}" if result =~ /we should it/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when is to/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when here/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when also/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when was/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when would/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /which also to/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /while is/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /while of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will for/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will it be/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when was/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when would/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /which also to/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /while is/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /while of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will for/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will it be/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /would as/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /being on with/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /fuck/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /retard/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /shit/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /butt-hurt/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /butthurt/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /butt hurt/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ / via @/i
    
    
    ################
    ## Edit result
    ################
    
    # Double quotation marks
    result.gsub!('“', '"')
    result.gsub!('”', '"')
    
    # Single quotaion marks
    result.gsub!(" '", " ")
    result.gsub!("' ", " ")
    
    result.gsub!(" ’", " ")
    result.gsub!("’ ", " ")

    result.gsub!(" ‘", " ")
    result.gsub!("‘ ", " ")

    result.gsub!("'.", ".")
    result.gsub!("’.", ".")
    result.gsub!("‘.", ".")
    
    ## Validate parentheses
    left_parentheses = result.count("(")
    right_parentheses = result.count(")")
    return false, "INVALID PARENTHESES: #{result}" if left_parentheses != right_parentheses
    
    quote_count = result.count('"')
    return false, "INVALID QUOTES: #{result}" if quote_count > 0 and quote_count.odd?
    
    return false, "INVALID CHARACTERS: #{result}" if result =~ /…/
    
    ## Remove extra period
    result.gsub!("?.", "?")
    result.gsub!("!.", "!")
    result.gsub!(":.", ":")
    result.gsub!(";.", ".")
    result.gsub!("-.", ".")
    result.gsub!("..", ".")
    result.gsub!(",.", ".")
    result.gsub!(".\".", ".\"")
    if result.split(//).last(2).join == ".." and result.split(//).last(3).join != "..."
      result = result.chomp(".")
    end

    if result[0] == '@'
      result = ".#{result}"
    end
    
    ## If result ends with colon, replace colon with period.
    if result.last == ':'
      result = result.chomp(":")
      result = "#{result}."
    end
    
    ## Unescape result
    result = CGI.unescapeHTML( result )
    
    if valid_tweet?(result)
      return true, result
    else
      return false, "TOO LONG"
    end
  end
    
  def source_texts( client )
    
    @texts = []
    
    tweets = []
    tweets << client.search("from:BernieSanders -rt", result_type: "recent").take(100)
    tweets << client.search("from:SenSanders -rt", result_type: "recent").take(100)
    tweets.flatten!

    ## Build corpus
    corpus_list = []
    tweets.each do |tweet|
      text = tweet.text
      next if text[0] == '@'
      next if text[1] == '@'
      #next if text =~ /\?/
      next if text =~ /\n/
      next if text =~ /\=/
      words = text.split(' ')
      next if words.size < 5
      text = text.gsub(/https:\/\/[\w\.:\/]+/, '').squeeze(' ')
      corpus_list << "#{text.strip}."
    end
    
    build_source_texts( corpus_list ) 
 
    texts
    
  end
  
  def parse_text( corpus, category, keyword )
    m = corpus.match( / #{keyword} /i )
    if m
      location = corpus =~ /#{keyword}/i
      return false if location < 15
      return false if (corpus.size-location < 15)
      
      words = keyword.split(' ')
      if words.size == 1
        @texts << SourceText.new({
          first_part: "#{m.pre_match}#{m.to_s}".strip,
          second_part: "#{m.post_match}",
          category: category
        })
      elsif words.size == 2
        @texts << SourceText.new({
          first_part: "#{m.pre_match} #{words[0]}".strip,
          second_part: "#{words[1]} #{m.post_match}",
          category: category
        })
      else
        return false
      end
      
      return true    
    end
    false
  end
  
  def build_source_texts( corpus_list )
    
    corpus_list.each do |corpus|
      
      ###############################
      ## Zeta - OFFICIAL
      ###############################
      category = "zeta"
      next if parse_text( corpus, category, "from" )

      ###############################
      ## Epsilon - OFFICIAL
      ###############################
      category = "epsilon"
      next if parse_text( corpus, category, "with" )
      
      ###############################
      ## Alpha - OFFICIAL
      ###############################
      category = 'alpha'
      next if parse_text( corpus, category, "to address" )
      next if parse_text( corpus, category, "to admit" )
      next if parse_text( corpus, category, "to advance" )
      next if parse_text( corpus, category, "to allow" )
      next if parse_text( corpus, category, "to answer" )
      next if parse_text( corpus, category, "to assassinate" )
      next if parse_text( corpus, category, "to attack" )
      next if parse_text( corpus, category, "to attend" )
      next if parse_text( corpus, category, "to avoid" )
      next if parse_text( corpus, category, "to battle" )
      next if parse_text( corpus, category, "to be" )
      next if parse_text( corpus, category, "to beg" )
      next if parse_text( corpus, category, "to blow" )
      next if parse_text( corpus, category, "to bomb" )
      next if parse_text( corpus, category, "to boycott" )
      next if parse_text( corpus, category, "to break" )
      next if parse_text( corpus, category, "to build" )
      next if parse_text( corpus, category, "to buy" )
      next if parse_text( corpus, category, "to call" )
      next if parse_text( corpus, category, "to change" )
      next if parse_text( corpus, category, "to close" )
      next if parse_text( corpus, category, "to commemorate" )
      next if parse_text( corpus, category, "to control" )
      next if parse_text( corpus, category, "to cover" )
      next if parse_text( corpus, category, "to create" )
      next if parse_text( corpus, category, "to criminalize" )
      next if parse_text( corpus, category, "to cut" )
      next if parse_text( corpus, category, "to deliver" )
      next if parse_text( corpus, category, "to defend" )
      next if parse_text( corpus, category, "to depend" )
      next if parse_text( corpus, category, "to deport" )
      next if parse_text( corpus, category, "to destroy" )
      next if parse_text( corpus, category, "to determine" )
      next if parse_text( corpus, category, "to develop" ) 
      next if parse_text( corpus, category, "to dig" ) 
      next if parse_text( corpus, category, "to discover" ) 
      next if parse_text( corpus, category, "to discuss" ) 
      next if parse_text( corpus, category, "to donate" )
      next if parse_text( corpus, category, "to drive" )
      next if parse_text( corpus, category, "to drop" )
      next if parse_text( corpus, category, "to dump" ) 
      next if parse_text( corpus, category, "to eat" )  
      next if parse_text( corpus, category, "to end" )  
      next if parse_text( corpus, category, "to endorse" )
      next if parse_text( corpus, category, "to ensure" )
      next if parse_text( corpus, category, "to exit" )
      next if parse_text( corpus, category, "to expand" )   
      next if parse_text( corpus, category, "to fight" )
      next if parse_text( corpus, category, "to find" )
      next if parse_text( corpus, category, "to follow" )
      next if parse_text( corpus, category, "to fund" )
      next if parse_text( corpus, category, "to get" )
      next if parse_text( corpus, category, "to give" )
      next if parse_text( corpus, category, "to grasp" )
      next if parse_text( corpus, category, "to guarantee" )
      next if parse_text( corpus, category, "to have" )  
      next if parse_text( corpus, category, "to hear" ) 
      next if parse_text( corpus, category, "to hold" ) 
      next if parse_text( corpus, category, "to import" )
      next if parse_text( corpus, category, "to integrate" )
      next if parse_text( corpus, category, "to invite" )
      next if parse_text( corpus, category, "to join" )
      next if parse_text( corpus, category, "to judge" )
      next if parse_text( corpus, category, "to jump" )
      next if parse_text( corpus, category, "to keep" )
      next if parse_text( corpus, category, "to kidnap" )
      next if parse_text( corpus, category, "to kill" )
      next if parse_text( corpus, category, "to learn" )
      next if parse_text( corpus, category, "to legalize" )
      next if parse_text( corpus, category, "to lift" )
      next if parse_text( corpus, category, "to limit" )
      next if parse_text( corpus, category, "to make" )
      next if parse_text( corpus, category, "to mandate" )
      next if parse_text( corpus, category, "to mention" )
      next if parse_text( corpus, category, "to move" )
      next if parse_text( corpus, category, "to obey" )
      next if parse_text( corpus, category, "to offend" )
      next if parse_text( corpus, category, "to offshore" )
      next if parse_text( corpus, category, "to operate" )
      next if parse_text( corpus, category, "to oppose" )
      next if parse_text( corpus, category, "to pander" )
      next if parse_text( corpus, category, "to pass" )
      next if parse_text( corpus, category, "to plow" )
      next if parse_text( corpus, category, "to prevent" )
      next if parse_text( corpus, category, "to produce" )
      next if parse_text( corpus, category, "to promote" )
      next if parse_text( corpus, category, "to protect" )
      next if parse_text( corpus, category, "to pull" )
      next if parse_text( corpus, category, "to push" )
      next if parse_text( corpus, category, "to punish" )
      next if parse_text( corpus, category, "to pursuade" )
      next if parse_text( corpus, category, "to pursue" )
      next if parse_text( corpus, category, "to quit" )
      next if parse_text( corpus, category, "to raise" )
      next if parse_text( corpus, category, "to read" )
      next if parse_text( corpus, category, "to rebuild" )
      next if parse_text( corpus, category, "to receive" )
      next if parse_text( corpus, category, "to reduce" )
      next if parse_text( corpus, category, "to refuse" )
      next if parse_text( corpus, category, "to return" )
      next if parse_text( corpus, category, "to revoke" )
      next if parse_text( corpus, category, "to see" )
      next if parse_text( corpus, category, "to sell" )
      next if parse_text( corpus, category, "to share" )
      next if parse_text( corpus, category, "to shut" )
      next if parse_text( corpus, category, "to spend" )
      next if parse_text( corpus, category, "to stay" )
      next if parse_text( corpus, category, "to stop" )
      next if parse_text( corpus, category, "to subsidize" )
      next if parse_text( corpus, category, "to support" )
      next if parse_text( corpus, category, "to scrap" )
      next if parse_text( corpus, category, "to understand" )
      next if parse_text( corpus, category, "to take" )
      next if parse_text( corpus, category, "to target" )
      next if parse_text( corpus, category, "to terminate" )
      next if parse_text( corpus, category, "to think" )
      next if parse_text( corpus, category, "to throw" )
      next if parse_text( corpus, category, "to trample" )
      next if parse_text( corpus, category, "to treat" )
      next if parse_text( corpus, category, "to tweet" )
      next if parse_text( corpus, category, "to use" )
      next if parse_text( corpus, category, "to watch" )
      next if parse_text( corpus, category, "to wear" )
      next if parse_text( corpus, category, "to win" )
      next if parse_text( corpus, category, "to work" )
      #"Obama wants to import this behavior."
      
      ###############################
      ## Delta - OFFICIAL
      ###############################
      category = "delta"
      next if parse_text( corpus, category, "will" )
      next if parse_text( corpus, category, "might" )
      next if parse_text( corpus, category, "shall" )
      next if parse_text( corpus, category, "should" )
      next if parse_text( corpus, category, "would" )
      next if parse_text( corpus, category, "could" )
      next if parse_text( corpus, category, "can" )
      #next if parse_text( corpus, category, "does" )

      ###############################
      ## Gamma - OFFICIAL last
      ###############################
      category = "gamma"
      next if parse_text( corpus, category, "because" )
      next if parse_text( corpus, category, "when" )
      next if parse_text( corpus, category, "but" )
      next if parse_text( corpus, category, "which" )
      next if parse_text( corpus, category, "while" )
      next if parse_text( corpus, category, "that the" )
      next if parse_text( corpus, category, "that they" )
      next if parse_text( corpus, category, "that a" )
      
      ###############################
      ## Omega - OFFICIAL
      ###############################
      category = "omega"
      next if parse_text( corpus, category, "who" )
      
      ###############################
      ## Theta - OFFICIAL
      ###############################
      category = "theta"
      next if parse_text( corpus, category, "is a" )
      next if parse_text( corpus, category, "was a" )
          
    end

  end
  
end