require_relative 'source_text'
## require '../project/bernie-bot/bernie_bot'

class BernieBot

  MAX_CHARS = 140
  
  attr_accessor :texts
  
  def initialize
    @texts = source_texts
  end
  
  def tweet_length(text)
    ActiveSupport::Multibyte::Chars.new(text).normalize(:c).length 
  end
  
  def valid_tweet?(text)
    return false if text.nil?
    tweet_length(text) <= MAX_CHARS ? true : false
  end
=begin  
  def build_text
    source_text_1 = @texts.shuffle.first
    
    #first_part = @texts.shuffle.first.first_part
    second_part_texts = @texts.find_all { |t| t.category == "conjunction" }
    
    
    # = @texts.dup
    second_part_texts.delete_if { |t| ( t.first_part == first_part ) or ( !valid_tweet?("#{first_part} #{t.second_part}") ) }
    return "NOT POSSIBLE: #{first_part}" if second_part_texts.empty?
    second_part = second_part_texts.shuffle.first.second_part
    result = "#{first_part} #{second_part}"
    if valid_tweet?(result)
      return result
    else
      return "TOO LONG"
    end
  end
=end
  
  def build_text
    first_text = @texts.shuffle.first
    second_texts = @texts.find_all { |t| t.category == first_text.category }
    second_texts.delete_if { |t| ( t.first_part == first_text.first_part ) or ( !valid_tweet?("#{first_text.first_part} #{t.second_part}") ) }
    return "NOT POSSIBLE: #{first_text.first_part}" if second_texts.empty?
    second_text = second_texts.shuffle.first
    result = "#{first_text.first_part} #{second_text.second_part}"
    if valid_tweet?(result)
      return result
    else
      return "TOO LONG"
    end
  end
    
  def source_texts
    
    preposition  = "preposition"
    conjunction  = "conjunction"
    verb_to_be   = "verb_to_be"
    verb_to_have = "verb_to_have"
    
    texts = []
    
    texts << SourceText.new({
      first_part: "Instead of sending American jobs to China, corporate America has got to",
      second_part: "re-invest in this country and create decent-paying jobs in America.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Instead of giving tax breaks to millionaires, we need to",
      second_part: "rebuild our crumbling infrastructure and create millions of decent-paying jobs.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "We must demilitarize police departments so they do not",
      second_part: "look like oppressing armies.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Rising costs are making it harder and harder for ordinary Americans to",
      second_part: "get the education they want and need.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "We need to expand Social Security to",
      second_part: "make sure every American can retire in dignity.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "The time is now for the United States to",
      second_part: "end capital punishment.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "A society which proclaims human freedom as its goal, as we do, must work unceasingly to",
      second_part: "end discrimination against all people.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "The time is long overdue for us to",
      second_part: "take marijuana off the federal government’s list of outlawed drugs.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "In my view, a two-year budget deal gives us time to",
      second_part: "focus on the most important issues confronting our nation.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Parents should have the right to",
      second_part: "stay home with their newborn baby for at least 3 months with paid family leave.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "As a nation, we are going to have to",
      second_part: "answer whether it's morally & economically acceptable that so few have so much & so many have so little",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "It's time to build on the progressive movement of the past and",
      second_part: "make public colleges and universities tuition-free.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "We need to end voter suppression, and",
      second_part: "make it easier for people to vote, not harder.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "It’s unacceptable that, at every turn, huge companies use their power to",
      second_part: "cut wages, cut benefits and cut pensions. Their greed has no end.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "A lot of Republican candidates talk about family values. What they are saying is that no woman should have the right to",
      second_part: "control her own body",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "With so much violence in this world today, I just don't think the state itself should",
      second_part: "be in the business of killing people.",
      category: preposition
    })  
    texts << SourceText.new({
      first_part: "The State, in a democratic, civilized society, should itself not",
      second_part: "be involved in the murder of other Americans.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "If the Ex-Im Bank cannot be reformed to become a vehicle for real job creation in the US, it should",
      second_part: "be eliminated.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "$7.25 is a starvation wage, which must",
      second_part: "be raised. The minimum wage must become a living wage.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "A mom and a dad should have the right to at least a couple of weeks of paid vacation so they can",
      second_part: "spend quality time with their kids.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "When millions of seniors are trying to survive on incomes of $12,000 a year, we must",
      second_part: "resist Republican efforts to cut Social Security.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Our civil liberties and right to privacy shouldn’t",
      second_part: "be the price we pay for security. #CISA",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Let’s be clear: Defaulting on our debt would",
      second_part: "be a disaster.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Puerto Ricans should not be forced to",
      second_part: "suffer so that a handful of wealthy investors can make even more money",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "People have a right to",
      second_part: "make a telephone call without that information being collected by the government.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "An education should",
      second_part: "be available to all regardless of anyone’s station.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "As the largest and most powerful military in the world, we need to",
      second_part: "use military force as a last resort, not a first option.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "We will win in 2016 because we are going to",
      second_part: "create an unprecedented grassroots movement. #Bernie2016",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "I voted against the USA Patriot Act and will continue to do all that I can to",
      second_part: "prevent us from moving toward and Orwellian society.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Our goal as a nation must be to",
      second_part: "ensure that no full-time worker lives in poverty. #Bernie2016",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "I remember reading picture books of World War II with tears coming out of my eyes. We've got to",
      second_part: "stand together and end all forms of racism.",
      category: preposition
    })
    
    
=begin
    texts << SourceText.new({
      first_part: "",
      second_part: "",
      category: preposition
    })
=end
    
    ## CONJUNCTIONS
    texts << SourceText.new({
      first_part: "Too many Americans have seen their lives destroyed because",
      second_part: "they have criminal records as a result of marijuana use. That has got to change.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Democrats win when people come out. Republicans win when",
      second_part: "their big money buys low voter turnout elections.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "The American people are angry because",
      second_part: "they know this recession was not caused by the middle class and working families of this country.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "It makes no sense that you can get an auto loan with an interest rate of 2.5% but",
      second_part: "millions of college graduates are forced to pay 7% or more",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Wall Street should not believe that",
      second_part: "they can get blood from a stone.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Republicans win when",
      second_part: "voter turnout is low.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Republicans win when",
      second_part: "people become demoralized.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Republicans win when",
      second_part: "they don't think their vote matters.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Glad the @FCC acted. It is outrageous that",
      second_part: "a fifteen-minute phone call could cost upwards of twelve dollars.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "There is no justice when",
      second_part: "so few have so much and so many have so little.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "In America, we have a casino-capitalist society in which",
      second_part: "a handful of very wealthy exercise enormous control over our economy and politics.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "My nightmare is that",
      second_part: "the United States once again gets caught up in a quagmire in the Middle East that never ends.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "All over this country people are working two or three jobs, yet",
      second_part: "they can’t afford child care or to send their kids to college.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "A key pathway to the middle class runs through college, but",
      second_part: "rising costs are making it harder for Americans to get the education they need.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "This campaign is sending a message to the billionaires: you can’t continue sending our jobs to China while",
      second_part: "millions are looking for work.",
      category: conjunction
    })
    
=begin
        texts << SourceText.new({
          first_part: "",
          second_part: "",
          category: conjunction
        })
=end
    
    ## VERB TO BE
    texts << SourceText.new({
      first_part: "A college degree today is",
      second_part: "the equivalent of a high school degree 50 years ago.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "I worry very much that our country, both economically and politically, is",
      second_part: "sliding into oligarchy.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "The Defense of Marriage Act was",
      second_part: "simply homophobic legislation.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "The future of America is",
      second_part: "with our children.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "How can we have a great country if we aren’t",
      second_part: "educating our children the way we should.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "The American people understand that our current economic system is",
      second_part: "rigged, and that our campaign finance system is corrupt.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "In my view, health care is",
      second_part: "a right of the people, not a privilege.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "The skyrocketing level of income and wealth inequality is not only grotesque and immoral, it is",
      second_part: "economically unsustainable.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "It is totally unacceptable that Americans are",
      second_part: "drowning in $1.3 trillion in student loan debt.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "We are going to fight voter suppression in all forms. If you are 18 years of age, you will be",
      second_part: "automatically registered to vote.",
      category: verb_to_be
    })
    
=begin
    texts << SourceText.new({
      first_part: "",
      second_part: "",
      category: verb_to_be
    })
=end

    ## VERB TO HAVE
    texts << SourceText.new({
      first_part: "We need",
      second_part: "tuition-free public colleges.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "This country belongs to all of us, not just",
      second_part: "wealthy campaign donors.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Tragically, in America today we have",
      second_part: "more people in jail than any other country on Earth.",
      category: verb_to_have
    }) 
    texts << SourceText.new({
      first_part: "We must not cut",
      second_part: "programs that the elderly, children, sick, poor and working families desperately depend upon.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "America stands ready to provide everything the people of Mexico need as they endure",
      second_part: "the strongest hurricane in recorded history.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "DOJ Should Investigate Exxon Mobil for misleading public about",
      second_part: "climate change #ExxonKnew",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "We need to end minimum sentencing. Too many lives have been destroyed for",
      second_part: "non-violent crimes.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "It is an embarrassment that we have a major political party that rejects",
      second_part: "the overwhelming science on climate change.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Real criminal justice reform must include joining every other major democracy in eliminating",
      second_part: "the death penalty.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Congratulations to @SenatorLeahy not only on 15,000 votes but on your many years of",
      second_part: "service to the people of Vermont",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Americans have more student debt than",
      second_part: "credit card or auto-loan debt. That is a tragedy for our young people and our nation.",
      category: verb_to_have
    })
    
    
=begin
    texts << SourceText.new({
      first_part: "",
      second_part: "",
      category: verb_to_have
    })
=end
             
    texts
    
  end
  
end