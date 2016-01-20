require 'active_support'
require_relative 'source_text'
## require '../project/bernie-bot/bernie_bot'

class BernieBot

  MAX_CHARS = 140
  
  attr_accessor :texts
=begin  
  def initialize( client )
    #@texts = source_texts
    @texts = source_texts_new(client)
  end
=end
  
  def initialize( client )
    @texts = source_texts( client )
    #@texts = source_texts_new_test
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
    return false, "INVALID WORD COMBO: #{result}" if result =~ /because was/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /can have to/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /from teens pleads/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /it should it/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /might it/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /one who aren't/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /shall of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /should do that is/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /their will/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /we should it/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when is to/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when here/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when also/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when was/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /when would/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /which also to/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /while is/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /while of/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will for/i
    return false, "INVALID WORD COMBO: #{result}" if result =~ /will it be/i
    
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
      ## Remove rogue quotes
      #result.gsub!('"', '')
      #end
    
    ## Remove extra period
    result.gsub!("?.", "?")
    result.gsub!("!.", "!")
    result.gsub!(":.", ":")
    result.gsub!("..", ".")
    if result.split(//).last(2).join == ".." and result.split(//).last(3).join != "..."
      result = result.chomp(".")
    end

    if result[0] == '@'
      result = ".#{result}"
    end
    
    ## Unescape result
    result = CGI.unescapeHTML( result )
    
    if valid_tweet?(result)
      return true, result
    else
      return false, "TOO LONG"
    end
  end
  
  def source_texts_new_test
    @texts = []
    corpus_list = ["Making public colleges and universities tuition free would save middle-class families sending kids to college $9,400 a year on average..", "Join my friend @billmckibben for a Town Hall in Portsmouth, New Hampshire tonight: #FITN #NHPolitics.", "It's wrong when over the last 30 years trillions of dollars have been transferred from the middle class to the top one-tenth of one percent..", "In a democratic society, politics should not be treated like a baseball game or a soap opera. We need discussion about serious issues..", "I'll be on the Rachel @maddow show on MSNBC shortly. Tune in now. #iacaucus.", "Volunteers like Braden Joplin are the heart and soul of the democratic process. Our thoughts are with his family..", "I am asking people not just for your vote, but to be part of a revolution to transform our country. #iacaucus.", "Now is NOT the time for thinking small or the same-old, same-old establishment politics and stale inside-the-beltway ideas..", "A way to provide banking opportunities for low-income communities is to allow the U.S. Postal Service to engage in basic banking services..", "Join Dr. @CornelWest, scholar Adolph Reed and others for a Higher Ed for Bernie Town Hall in Columbia tomorrow:.", "If Congress continues to fail to act, as president I would uphold and expand the president's action..", "The president did exactly the right thing and I'm confident he has the legal authority to take this bold action..", "Americans understand that corporate greed is destroying our country. They fully understand that American politics is dominated by big money..", "Real Wall Street reform means breaking up the big banks and re-establishing firewalls that separates risk taking from traditional banking..", "We need to look at addiction not as a crime, but a health issue. #BernieInAL.", "Health care is a right, not a privilege. That's why my plan will insure every American..", "Some people told me Alabama was a conservative state. I guess not. Watch live: #BernieInAL.", "This is a campaign of the people, by the people, and for the people. #BernieinAL.", "Tune in LIVE to @CornelWest and @ninaturner in Alabama here: #BernieinAL.", "Tune in LIVE as we address thousands who came out to Birmingham to say: “Enough is enough!\" #BernieinAL.", "Excited to be in Birmingham tonight for a rally to discuss the issues facing our nation. #BernieInAL.", "Health care should be a right of all people, not a privilege. This is not a radical idea. It exists in every other major country on earth..", "This country was built by immigrants. I believe we are a nation that wants to see comprehensive immigration reform passed..", "There's a disparity in education for children in poor communities. We’ve gotta change that..", "Higher education must be a right for all - not just wealthy families..", "There are no excuses. The governor long ago knew about the lead in Flint’s water. He did nothing. Gov. Snyder should resign. #DemDebate.", "Bernie’s immigration plan is the gold standard. \"We hope [Hillary] is inspired to match his boldness.” -@nytimes.", "If elected president, Goldman Sachs will not be in my cabinet. #DebateWithBernie.", "Bernie supports a defense budget that looks after our national security interests not the profits of defense contractors. #DebateWithBernie.", "Bernie is the only candidate that voted against giving the NSA power to spy on Americans. #DebateWithBernie.", "We can protect America without violating our citizens' constitutional rights. That's why Bernie voted against the Patriot Act. #DemDebate.", "The test of a great nation is not how many wars it can engage in, but how it can resolve international conflicts in a peaceful manner..", "It's amazing that Republicans are so owned by fossil fuel contributors that they don't have the courage to listen to science. #DemDebate.", "We bailed out Wall Street, it’s their turn to bail out the middle class and help our kids go to college tuition-free. #DebateWithBernie.", "Making public colleges and universities tuition free would save middle-class families sending kids to college $9,400 a year. #DemDebate.", "I find it strange that the kid who smokes marijuana gets arrested but the crooks on Wall Street get off scot free. #DemDebate.", "I don't get personal speaking fees from Goldman Sachs. #DebateWithBernie.", "We don't have a super PAC. We don't want a super PAC. And we don't NEED a super PAC. This is a people’s campaign. #FeelTheBern.", "Looking forward to your plan, @HillaryClinton. #DemDebate.", "#MedicareForAll will save the American people and businesses over $6 trillion in the next decade..", "Under Bernie's plan, the average family would pay less for an entire year of health care than they currently do in a month. #DemDebate.", "Health care should be a right of all people, not a privilege. This is not a radical idea. It exists in every other major country on earth..", "Bernie's plan will expand on the ACA and create a system that puts people's health over profits. #DemDebate.", "Addiction is a disease, not a criminal activity. #DemDebate.", "We must demilitarize our police forces so they don’t look and act like invading armies. #DebateWithBernie.", "We need police forces that reflect the diversity of our communities, including in training academies and leadership. #DemDebate.", "Whenever anyone is killed in police custody it should automatically trigger a federal investigation. #DemDebate.", "Polls confirm: Bernie is the best Democratic candidate to take on Republicans in the general election. #DemDebate.", "We must make certain that people who should not have guns, do not have guns. We must fight for sensible gun control legislation..", "In 1988, Bernie stood up to the gun lobby and said we should not be selling military assault weapons. #DemDebate.", "Our campaign is about thinking big: health care for all, $15 minimum wage and creating millions of new jobs. #DebateWithBernie.", "This campaign is about a political revolution to transform our country economically, socially and environmentally. #DebateWithBernie.", "We need to raise the minimum wage to a living wage. #FightFor15.", "Before we head to the #DemDebate, I'll be rallying with workers in Charleston in the #FightFor15 and a union..", "#MedicareForAll means no more copays, no more deductibles and no more fighting with insurance companies when they fail to pay for charges..", "Es hora de unirnos a las naciones que garantizan la atención médica como un derecho para todos, no un privilegio..", "My #MedicareForAll plan is the only plan that provides health care to ALL Americans, including the 50 million uninsured or underinsured..", "It’s time to join every other major nation and guarantee health care to all as a right, not a privilege..", "When you’re sick you should go to the doctor. And when you come out of the hospital you should not come out in bankruptcy. #MedicareForAll.", "We're reminded when we knock doors in the snow that our environment is worth fighting for. #FITN.", "Live with @KillerMike: “I’ll give you an example of our broken criminal justice system...”.", "Streaming live right now discussing MLK’s legacy:.", "Happening now. Bernie, Senator Turner, Killer Mike and Dr. Cornel West LIVE:.", "We have more people in jail than any other country on earth including China, an authoritarian country 4 times our size..", "We are going to create a nation that works for all of us, not just for a handful of millionaires and billionaires..", "When it comes to our responsibilities as human beings and parents, it is imperative our planet stays habitable for our kids and grandkids..", "Actor Stephen Bishop, Senator @ninaturner and Dr. @CornelWest enjoying @ClyburnSC06's Charleston famous fish fry..", "We can live in a country where every person who dreams of becoming a citizen has a rational path forward, not just a dark corner to hide in..", "The greed of the pharmaceutical industry is killing Americans. That cannot continue..", "Congrats to Zeta Phi Beta and members of my team @cspain1920, @o_kersh and @bremaxwell on 96 years of service. Happy Founders' Day. #ZPHIB96.", "Congrats, @POTUS. The test of a great nation is how we use our strength to resolve conflicts in a peaceful way..", "Not one major Wall Street executive has been prosecuted for the near collapse of our economy. That will change under my administration..", "I will fight for a 21st Century Glass-Steagall Act to clearly separate commercial banking, investment banking, and insurance services..", "This good news shows that diplomacy can work even in this volatile region of the world..", "Children in Flint will be plagued with brain damage and other health problems. The people of Flint deserve more than an apology..", "Because of the conduct by Gov. Snyder's administration, families will suffer from lead poisoning for the rest of their lives..", "There are no excuses. The governor long ago knew about the lead in Flint's water. He did nothing. Gov. Snyder should resign..", "Sanders Statement: Michigan Governor Must Resign over Flint Lead-Poisoning Crisis.", "Three out of the four largest financial institutions are bigger now than before we bailed them out..", "Kids are jailed for possessing marijuana or other minor crimes. Nothing happens to Wall Street execs whose illegal behavior harmed millions..", "The reality is that Congress doesn’t regulate Wall Street. Wall Street, its lobbyists and their billions of dollars regulate Congress..", "And within one year, my administration will break these institutions up so that they no longer pose a grave threat to the economy..", "During the first 100 days of my administration, the Treasury Department will create a too-big-to fail list of banks and insurance companies..", "Under my administration, Goldman Sachs execs and other Wall Street CEOs won’t go through the revolving door from Wall Street to government..", "We need federal prosecutors and regulators with clear track records of standing up to the greed and recklessness on Wall Street..", "The Koch brothers are spending huge sums of money to sow doubt about climate change. The reality is climate change is real and man-made..", "It is absolutely vital that we act boldly to move our energy system away from fossil fuels..", "The debate is over. Climate change is real and caused by human activity. This planet and its people are in trouble..", "As a society which proclaims human freedom as its goal, the United States must work unceasingly to end discrimination against all people..", "It's unbelievable that the Koch brothers saw their wealth increase by $18 billion in 2 years, yet paid lower taxes than the middle class..", "As a nation, we must remain consistent with our immigrant tradition by welcoming those fleeing violence and ending the raids..", "Our job is to tell every kid in this country, that if they work hard, regardless of family income, they will get a college education..", "I got a message for the Walton family of Walmart: Get off of welfare and pay your workers a living wage..", "Americans understand we have a rigged economy, where 47 million people are living in poverty and almost all new income is going to the top..", "We have to make Congress respond to the needs of the people, not big money..", "\"This country has socialism for the rich, rugged individualism for the poor.\" -Dr. Martin Luther King Jr. #MLKDay.", "\"Call it democracy, or call it democratic socialism, but there must be a better distribution of wealth.\" -Dr. Martin Luther King Jr. #MLKDay.", "Whenever anybody in this country is killed while in police custody, it should automatically trigger a U.S. attorney general's investigation..", "As we honor Dr. King, we must not only remember what he stood for, but also pledge to continue his vision to transform our country. #MLKDay.", "The black unemployment rate has remained roughly twice as high as the white rate over the last 40 years. This is unacceptable..", "We need to end prisons for profit, which result in an over-incentive to arrest, jail and detain, in order to keep prison beds full..", "The war on drugs has been a failure and has ruined the lives of too many people..", "It's time for the US to join almost every other Western, industrialized country in saying no to the death penalty..", "We are spending almost twice as much per capita on health care as does any other nation..", "The current federal minimum wage of $7.25 an hour is a starvation wage and must be raised to a living wage!.", "Climate change is real, it is caused by human activity and it is already causing huge devastation across the world..", "When you're sick, you should have access to health care. When you go to the hospital, you should not come out in bankruptcy..", "The measure of success for law enforcement should not be how many people get locked up..", "Today, if an employee is engaged in a union organizing campaign, they have a one in five chance of getting fired. This has got to end!.", "It's embarrassing that 20% of kids in America are living in poverty, the highest childhood poverty rate of any major developed country..", "It is unacceptable that the typical female worker made $1,337 less last year than she did in 2007..", "We must continue to boldly take on powerful political forces who are more concerned with short-term profits than the future of the planet..", "We can create a government that works for all of us, not just powerful special interests. This is not a radical idea..", "We have a moral responsibility to leave our kids a healthy planet. The best way we can do that is by keeping fossil fuels in the ground..", "Unbelievably, today in many states, it is still legal to fire someone for being gay. That is unacceptable and must change..", "NEWS: Sanders statement on Obama's decision to halt new federal coal leases on public lands.", "America should be known as the country with the best educated population in the world, not the country with the most jailed population..", "We must move away from the militarization of police forces and completely redo how we train police officers..", "Sen. Ted Kennedy: Health care is \"a matter of right and not of privilege.\".", "One family will spend more money this election cycle than either the Democratic or Republican parties. This isn't democracy. It's oligarchy..", "It seems to me that instead of building more jails, maybe, just maybe, we should be putting money into education and jobs for our kids..", "I have spent my career fighting for something that I consider to be a human right. That human right is health care..", "We're the only major country that doesn’t guarantee healthcare to all as a right, yet we spend more per capita on healthcare than any nation.", "I say to Walmart: Get off of welfare. Start paying your employees a living wage!.", "We'll no longer tolerate an economy and political system rigged by Wall St. to benefit the wealthiest at the expense of everyone else..", "The greed of the pharmaceutical industry is killing Americans. That cannot continue..", "29 million Americans still have no health insurance. We must resolve that health care is a right, not a privilege of those who can afford it.", "We need to change campaign finance so the work being done by Congress reflects the needs of working families, not just the billionaire class.", "There is no rational economic reason why women should earn 78 cents on the dollar compared to men. That has got to change..", "I appreciated @POTUS's point that we need more civil politics, to get big money out of politics, and to revitalize American democracy..", "NEWS: Sanders Statement on the State of the Union Address.", "We must make the Fed a more democratic institution, responsive to the needs of ordinary Americans rather than the billionaires on Wall St..", "Too much of the Fed’s business is conducted in secret, known only to the bankers on its various boards and committees..", "NEWS: Sanders Supports Audit the Fed Bill.", "Medicare for all would guarantee health care for all people and save middle class families and our entire nation lot of money..", "This country was built by immigrants. I believe we are a nation that wants to see comprehensive immigration reform passed..", "We must do everything we can to make sure the generation that fought to defend democracy and built our great nation does not go hungry..", "We need someone who will work to lower drug prices &amp; implement rules to import brand-name drugs from Canada. Dr. Califf is not that person..", "When millions of Americans cannot afford the drugs they need, we need a leader at the FDA who is prepared to stand up to the drug companies..", "It is unacceptable that the monthly cost of cancer drugs has more than doubled over the last ten years to $9,900..", "It's unacceptable that 1 out of 5 Americans between the ages of 19 and 64 cannot afford the drugs they are prescribed..", "NEWS: Sanders Votes No on FDA Nominee.", "Health care should be a right of all people, not a privilege. This is not a radical idea. It exists in every other major country on earth..", "In my view, corporations should not be allowed to make a profit by building more jails and keeping more Americans behind bars..", "It makes no sense to me that the United States of America has more jails and prisons than colleges and universities..", "In 2015, a college degree is equivalent to what a high school degree was 50 years ago. Public colleges should be tuition free..", "We can live in a nation where everyone, no matter their race, religion or sexual orientation realizes the full promise of equality..", "In my view, no single financial institution should have holdings so extensive that its failure could send the world economy into crisis..", "We have a situation now where Wall Street banks are not only too big to fail, they are too big to jail. That has got to change.."]    
    build_source_texts( corpus_list )
    texts
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
      next if text =~ /\?/
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
      next if parse_text( corpus, category, "to advance" )
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
      next if parse_text( corpus, category, "to break" )
      next if parse_text( corpus, category, "to build" )
      next if parse_text( corpus, category, "to buy" )
      next if parse_text( corpus, category, "to call" )
      next if parse_text( corpus, category, "to close" )
      next if parse_text( corpus, category, "to commemorate" )
      next if parse_text( corpus, category, "to control" )
      next if parse_text( corpus, category, "to create" )
      next if parse_text( corpus, category, "to criminalize" )
      next if parse_text( corpus, category, "to cut" )
      next if parse_text( corpus, category, "to deliver" )
      next if parse_text( corpus, category, "to deport" )
      next if parse_text( corpus, category, "to destroy" )
      next if parse_text( corpus, category, "to develop" ) 
      next if parse_text( corpus, category, "to dig" ) 
      next if parse_text( corpus, category, "to drive" )
      next if parse_text( corpus, category, "to drop" ) 
      next if parse_text( corpus, category, "to eat" )  
      next if parse_text( corpus, category, "to end" )  
      next if parse_text( corpus, category, "to ensure" )
      next if parse_text( corpus, category, "to expand" )   
      next if parse_text( corpus, category, "to fight" )      
      next if parse_text( corpus, category, "to fund" )
      next if parse_text( corpus, category, "to get" )
      next if parse_text( corpus, category, "to give" )
      next if parse_text( corpus, category, "to grasp" )
      next if parse_text( corpus, category, "to have" )  
      next if parse_text( corpus, category, "to here" )  
      next if parse_text( corpus, category, "to import" )
      next if parse_text( corpus, category, "to integrate" )
      next if parse_text( corpus, category, "to join" )
      next if parse_text( corpus, category, "to judge" )
      next if parse_text( corpus, category, "to jump" )
      next if parse_text( corpus, category, "to keep" )
      next if parse_text( corpus, category, "to kidnap" )
      next if parse_text( corpus, category, "to kill" )
      next if parse_text( corpus, category, "to limit" )
      next if parse_text( corpus, category, "to make" )
      next if parse_text( corpus, category, "to mandate" )
      next if parse_text( corpus, category, "to mention" )
      next if parse_text( corpus, category, "to move" )
      next if parse_text( corpus, category, "to offend" )
      next if parse_text( corpus, category, "to operate" )
      next if parse_text( corpus, category, "to oppose" )
      next if parse_text( corpus, category, "to prevent" )
      next if parse_text( corpus, category, "to promote" )
      next if parse_text( corpus, category, "to protect" )
      next if parse_text( corpus, category, "to pull" )
      next if parse_text( corpus, category, "to punish" )
      next if parse_text( corpus, category, "to pursuade" )
      next if parse_text( corpus, category, "to quit" )
      next if parse_text( corpus, category, "to rebuild" )
      next if parse_text( corpus, category, "to refuse" )
      next if parse_text( corpus, category, "to return" )
      next if parse_text( corpus, category, "to sell" )
      next if parse_text( corpus, category, "to share" )
      next if parse_text( corpus, category, "to shut" )
      next if parse_text( corpus, category, "to spend" )
      next if parse_text( corpus, category, "to stop" )
      next if parse_text( corpus, category, "to support" )
      next if parse_text( corpus, category, "to scrap" )
      next if parse_text( corpus, category, "to understand" )
      next if parse_text( corpus, category, "to take" )
      next if parse_text( corpus, category, "to target" )
      next if parse_text( corpus, category, "to think" )
      next if parse_text( corpus, category, "to tweet" )
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
  
  
  
  
=begin  
  def build_text
    first_text = @texts.shuffle.first
    second_texts = @texts.find_all { |t| t.category == first_text.category }
    second_texts.delete_if { |t| ( t.first_part == first_text.first_part ) or ( !valid_tweet?("#{first_text.first_part} #{t.second_part}") ) }
    return false, "NOT POSSIBLE: #{first_text.first_part}" if second_texts.empty?
    second_text = second_texts.shuffle.first
    result = "#{first_text.first_part} #{second_text.second_part}"
    
    ## Edit result
    result.sub!('“', '"')
    result.sub!('”', '"')
    
    quote_count = result.count('"')
    if quote_count > 0 and quote_count.odd?
      ## Remove rogue quotes
      result.sub!('"', '')
    end
    
    ## Remove extra period
    result.sub!("?.", "?")

    if result[0] == '@'
      result = ".#{result}"
    end
    
    if valid_tweet?(result)
      return true, result
    else
      return false, "TOO LONG"
    end
  end
  
  def source_texts_new_test
    
    @texts = []
    
    alpha = "alpha"
    
    corpus_list = ["In my view, some of the real heroines in our country today are single moms.", "Our nation has always been a beacon of hope, a refuge for the oppressed.", "We cannot turn our backs on that essential element of who we are as a nation.", "I'm running for president because the middle class is disappearing and more than half of new income is going to the top 1 percent.", "The health insurance lobbyists and big pharmaceutical companies try to make \"national health care\" sound scary.", "Too many lives have been destroyed because of police records.", "It is not their kids who are going into war.", "You’ll forgive me, this is an emotional issue for me.", "We must take steps to protect children and families seeking refuge here, not cast them out.", "We who are parents should ask ourselves what we would do if our children faced the danger and violence these children do?.", "Very disturbed by reports that the government may commence raids to deport families who've fled here to escape violence in Central America.", "When they divide us up, they win.", "When we stand together as one people, we win.", "We should not be firing teachers, we should be hiring teachers.", "School teachers and educators are real American heroes.", "Don't know how to break this to you, but Trump has discovered that women go to the bathroom.", "If Congress does not act, we will use the executive authority of the president to stop the dividing up of families.", "You want to keep the minimum wage low, and give tax breaks to millionaires.", "@realDonaldTrump, that is not what makes America great.", "Any official who helped suppress the videotape of Laquan McDonald’s murder should be held accountable.", "Garcia for inviting me to Chicago today.", "Two agents for real change.", "Reforming our criminal justice system is one of the most important things that a President can do.", "Corporate America and Wall Street: you can hate me all you want, but we’re going to end your greed.", "We need to end mandatory minimum sentencing and give judges the discretion to better tailor sentences to the specific facts of a given case.", "We cannot jail our way out of health problems like drug addiction or social and economic problems like poverty.", "Spending some time tonight with @CornelWest, @NinaTurner, @JesusChuyGar and @KillerMike in Chicago.", "If you don’t have a lot of money and you have a high health insurance deductible, you’re not gonna go to the doctor.", "I’m getting a very good feeling about Iowa.", "We have to ask ourselves, “Is it morally acceptable, is it economically sustainable, that so few have so much while so many have so little?”.", "This election is not just about electing a President.", "Far more significantly, it is about transforming America.", "We need to tell the drug companies to stop ripping off the American people.", "To rein in Wall Street, we should begin by reforming the Federal Reserve.", "There comes a time when you have to take on the establishment and not be part of that establishment.", "There is nothing that is more important than passing on a Mother Earth that is healthy and habitable for our kids and grandchildren.", "Climate change is real and caused by human activity.", "It's already causing devastating problems around the world.", "It’s all hands on deck for a pre-holiday phone bank.", "We're going to move to public funding of elections so candidates don't have to beg the wealthy and powerful for money when they want to run.", "You have a right to health care regardless of whether you are rich or poor.", "The Koch brothers are prepared to spend $889 million this election to end Social Security and dismantle our safety net.", "I am going to take on Wall Street.", "They do not like me today.", "They will like me even less if I am elected president.", "Congress bailed out Wall St.", "because it was too big to fail.", "In my view, if a bank is too big to fail, it's too big to exist.", "We're gonna have some fun, we're gonna make a political revolution, we're gonna transform America.", "Other than that, not much.", "The second 100 days of the political revolution.", "I believe that we need a political revolution.", "The same old, same old just isn't going to do it.", "We have to be bold.", "You are looking at one candidate for president who does not have a super PAC and I’m damn proud of that.", "Despite growing poverty among seniors, Republicans want more austerity for the elderly and more tax breaks for the rich.", "If we're going to stand up to the greed of the billionaire class and the greed of corporate America, I accept Wall Street not liking me.", "We have a broken immigration system that divides families and keeps millions of hard-working people in the shadows.", "\"I guess Christmas Eve was booked.", "” - Michael Briggs, Comms.", "The time is now for the United States to end capital punishment.", "Voter ID laws aren't intended to discourage fraud, they are intended to discourage voting.", "If we are to retain the fundamentals of American democracy, we need to overturn the disastrous Citizens United Supreme Court decision.", "We must convince students that if they participate in the political process we can lower the outrageously high student debt they face.", "Let’s be clear: in terms of protecting the needs of our families the United States lags behind virtually every major country on earth.", "The fossil fuel industry is destroying the planet with impunity and getting rich while doing it.", "This campaign is about the needs of the American people, and the proposals that effectively address those needs.", "I support 12 weeks of paid leave for every worker.", "Say you support paid leave for mothers &amp; fathers too.", "We now have the highest incarceration rate in the entire world with over 2 million in prison and millions more on probation or parole.", "Post-debate breakfast from this morning at IHOP in Bedford, New Hampshire.", "\"Get in on the love train.", "That’s what Bernie Sanders’ campaign is.", "Corporate greed is rampant, and the very rich keep growing richer while everyone else grows poorer.", "This campaign will be driven by issues and serious debate.", "The United States once led the world in terms of the percentage of our young people who had college degrees.", "Today we’re now in 12th place.", "I got into politics not to figure out how to become President.", "I got into politics because I give a damn.", "Addiction is a disease, not a criminal activity.", "Addiction is ravaging families and communities in NH.", "This is a crisis, and we need to treat it as a health issue—not throw people in jail.", "I know you have heard these names before but they bear repeating so we do not lose sight of the real human price being paid.", "Michael Brown, Eric Garner, Jessica Hernandez, Freddie Gray, Sandra Bland, Tamir Rice, Samuel Dubose, Rekia Boyd and too many more.", "Any serious criminal justice reform must include removing marijuana from the Controlled Substances Act.", "We need to rethink the \"War on Drugs\" and treat substance abuse as a serious health issue, not a criminal issue.", "'Socialist' programs from FDR and LBJ:\n✅Social Security\n✅Minimum Wage\n✅Medicare and Medicaid\n✅40-hour work week\n#DemDebate.", "When a husband can’t get time off to care for his cancer-stricken wife, that is not a family value.", "Medicare for All would eliminate payments to insurance companies that put profits before people.", "Bernie’s college plan is the only plan that affords lower-income kids the same opportunity for a quality education.", "CEO's of large multinationals may like @HillaryClinton, but they ain't gonna like me.", "We need debt-free college and free tuition is the best way to get there.", "I don’t think it’s a radical idea that in the richest country in the history of the world health care should be a right, not a privilege.", "Bernie helped lead the effort against @billclinton who thought it would be a great idea to deregulate Wall Street.", "\"The greed of the billionaire class, the greed of Wall Street is destroying this economy.", "We do not have a super PAC.", "We do not want the money of corporate America.", "This is a people’s campaign.", "You can’t take on Wall Street banks and billionaires by taking their money.", "A $1 trillion investment in infrastructure could create 13 million decent paying jobs.", "Invest in infrastructure, not more war.", "Equal pay for equal work.", "It’s not a radical idea.", "\"I worry that @HillaryClinton is too much into regime change and too aggressive without knowing what the unintended consequences might be.", "Bernie supports a defense budget that secures our national security interests not the profits of defense contractors.", "\"I listened to what Bush and Cheney had to say about Iraq.", "I listened carefully, and I didn't believe them so I voted against the war.", "Qatar will spend $200 billion on the 2022 World Cup – $200 billion a soccer event, yet very little to fight against ISIS.", "\"I voted against the war in Iraq.", "That was the right vote.", "We must be vigorous in combatting terrorism, but we can’t do it alone.", "We will not turn our backs on the refugees who are fleeing Syria and Afghanistan.", "“Trump thinks lower wages are a good idea.", "I believe we must stand together.", "We can not be divided by race or religion.", "It's time to strengthen gun safety laws:\n✅Universal background checks\n✅Assault weapon ban\n✅Stricter gun trafficking laws\n#DebateWithBernie.", "There’s only one candidate on stage who voted against (and led the opposition to) the Iraq War.", "✅America’s 20 wealthiest people now own more wealth than the bottom half of the American population combined.", "Let’s talk about data that matters to working families:\n✅47 million are living in poverty\n✅51% of African-American youth are unemployed.", "I am running for president because it is too late for establishment politics and economics.", "Change never takes place from the top down.", "It always takes place from the bottom up.", "Most new wealth flows to the top 1 percent.", "It's a system held in place by corrupt politics.", "Make sure to add Bernie."] 
    corpus_list = ["\"Government by organized money is just as dangerous as government by organized mob.", "Calling voters is one of highest impact things you can do to help our campaign.", "The greed of corporate America is destroying our economy.", "You have to take them on.", "I'm running for president because a handful of billionaires and wealthy families are trying to buy elections just to make themselves richer.", "It is my very strong inclination that if Sandra Bland was a white middle-class woman that would not have happened.", "What the polls are showing is the American people are responding to our message and we are on a path to victory.", "This morning I’ll be on NBC’s @MeetThePress and CBS @FaceTheNation.", "Criminal justice reform must be the civil rights issue of the 21st century and the first piece has to be police reform.", "Today, 29 million of our sisters and brothers are without health care.", "We can and must do better.", "I'm running for president because it is harder than ever for students to pay for college and for working parents to afford daycare.", "I will do everything that I can to make sure that the United States does not get involved in another quagmire like we did in Iraq.", "I need you to help me get out the vote.", "It's time to end religious bigotry and build a nation in which we all stand together and condemn the anti-Muslim rhetoric we're hearing.", "We would not tolerate the head of Exxon Mobil running the Environmental Protection Agency.", "A single-payer system already exists in the United States.", "It's called Medicare and the people enrolled give it high marks.", "Every man, woman and child in our country should be able to access quality care regardless of their income.", "In my view, some of the real heroines in our country today are single moms.", "Our nation has always been a beacon of hope, a refuge for the oppressed.", "We cannot turn our backs on that essential element of who we are as a nation.", "I'm running for president because the middle class is disappearing and more than half of new income is going to the top 1 percent.", "The health insurance lobbyists and big pharmaceutical companies try to make \"national health care\" sound scary.", "Too many lives have been destroyed because of police records.", "It is not their kids who are going into war.", "You’ll forgive me, this is an emotional issue for me.", "We must take steps to protect children and families seeking refuge here, not cast them out.", "We who are parents should ask ourselves what we would do if our children faced the danger and violence these children do?.", "Very disturbed by reports that the government may commence raids to deport families who've fled here to escape violence in Central America.", "When they divide us up, they win.", "When we stand together as one people, we win.", "We should not be firing teachers, we should be hiring teachers.", "School teachers and educators are real American heroes.", "Don't know how to break this to you, but Trump has discovered that women go to the bathroom.", "If Congress does not act, we will use the executive authority of the president to stop the dividing up of families.", "You want to keep the minimum wage low, and give tax breaks to millionaires.", "@realDonaldTrump, that is not what makes America great.", "Any official who helped suppress the videotape of Laquan McDonald’s murder should be held accountable.", "Garcia for inviting me to Chicago today.", "Two agents for real change.", "Reforming our criminal justice system is one of the most important things that a President can do.", "Corporate America and Wall Street: you can hate me all you want, but we’re going to end your greed.", "We need to end mandatory minimum sentencing and give judges the discretion to better tailor sentences to the specific facts of a given case.", "We cannot jail our way out of health problems like drug addiction or social and economic problems like poverty.", "Spending some time tonight with @CornelWest, @NinaTurner, @JesusChuyGar and @KillerMike in Chicago.", "If you don’t have a lot of money and you have a high health insurance deductible, you’re not gonna go to the doctor.", "I’m getting a very good feeling about Iowa.", "We have to ask ourselves, “Is it morally acceptable, is it economically sustainable, that so few have so much while so many have so little?”.", "This election is not just about electing a President.", "Far more significantly, it is about transforming America.", "We need to tell the drug companies to stop ripping off the American people.", "To rein in Wall Street, we should begin by reforming the Federal Reserve.", "There comes a time when you have to take on the establishment and not be part of that establishment.", "There is nothing that is more important than passing on a Mother Earth that is healthy and habitable for our kids and grandchildren.", "Climate change is real and caused by human activity.", "It's already causing devastating problems around the world.", "It’s all hands on deck for a pre-holiday phone bank.", "We're going to move to public funding of elections so candidates don't have to beg the wealthy and powerful for money when they want to run.", "You have a right to health care regardless of whether you are rich or poor.", "The Koch brothers are prepared to spend $889 million this election to end Social Security and dismantle our safety net.", "I am going to take on Wall Street.", "They do not like me today.", "They will like me even less if I am elected president.", "Congress bailed out Wall St.", "because it was too big to fail.", "In my view, if a bank is too big to fail, it's too big to exist.", "We're gonna have some fun, we're gonna make a political revolution, we're gonna transform America.", "Other than that, not much.", "The second 100 days of the political revolution.", "I believe that we need a political revolution.", "The same old, same old just isn't going to do it.", "We have to be bold.", "You are looking at one candidate for president who does not have a super PAC and I’m damn proud of that.", "Despite growing poverty among seniors, Republicans want more austerity for the elderly and more tax breaks for the rich.", "If we're going to stand up to the greed of the billionaire class and the greed of corporate America, I accept Wall Street not liking me.", "We have a broken immigration system that divides families and keeps millions of hard-working people in the shadows.", "\"I guess Christmas Eve was booked.", "” - Michael Briggs, Comms.", "The time is now for the United States to end capital punishment.", "Voter ID laws aren't intended to discourage fraud, they are intended to discourage voting.", "If we are to retain the fundamentals of American democracy, we need to overturn the disastrous Citizens United Supreme Court decision.", "We must convince students that if they participate in the political process we can lower the outrageously high student debt they face.", "Let’s be clear: in terms of protecting the needs of our families the United States lags behind virtually every major country on earth.", "The fossil fuel industry is destroying the planet with impunity and getting rich while doing it.", "This campaign is about the needs of the American people, and the proposals that effectively address those needs.", "I support 12 weeks of paid leave for every worker.", "Say you support paid leave for mothers &amp; fathers too.", "We now have the highest incarceration rate in the entire world with over 2 million in prison and millions more on probation or parole.", "Post-debate breakfast from this morning at IHOP in Bedford, New Hampshire.", "\"Get in on the love train.", "That’s what Bernie Sanders’ campaign is.", "Corporate greed is rampant, and the very rich keep growing richer while everyone else grows poorer.", "This campaign will be driven by issues and serious debate.", "The United States once led the world in terms of the percentage of our young people who had college degrees.", "Today we’re now in 12th place.", "I got into politics not to figure out how to become President.", "I got into politics because I give a damn.", "Addiction is a disease, not a criminal activity.", "Addiction is ravaging families and communities in NH.", "This is a crisis, and we need to treat it as a health issue—not throw people in jail.", "I know you have heard these names before but they bear repeating so we do not lose sight of the real human price being paid.", "Michael Brown, Eric Garner, Jessica Hernandez, Freddie Gray, Sandra Bland, Tamir Rice, Samuel Dubose, Rekia Boyd and too many more.", "Any serious criminal justice reform must include removing marijuana from the Controlled Substances Act.", "We need to rethink the \"War on Drugs\" and treat substance abuse as a serious health issue, not a criminal issue.", "'Socialist' programs from FDR and LBJ:\n✅Social Security\n✅Minimum Wage\n✅Medicare and Medicaid\n✅40-hour work week\n#DemDebate.", "When a husband can’t get time off to care for his cancer-stricken wife, that is not a family value.", "Medicare for All would eliminate payments to insurance companies that put profits before people.", "Bernie’s college plan is the only plan that affords lower-income kids the same opportunity for a quality education.", "CEO's of large multinationals may like @HillaryClinton, but they ain't gonna like me.", "We need debt-free college and free tuition is the best way to get there.", "I don’t think it’s a radical idea that in the richest country in the history of the world health care should be a right, not a privilege.", "Bernie helped lead the effort against @billclinton who thought it would be a great idea to deregulate Wall Street.", "\"The greed of the billionaire class, the greed of Wall Street is destroying this economy.", "We do not have a super PAC.", "We do not want the money of corporate America.", "This is a people’s campaign."] 
    corpus_list = ["\"Government by organized money is just as dangerous as government by organized mob.", "Calling voters is one of highest impact things you can do to help our campaign.", "The greed of corporate America is destroying our economy.", "You have to take them on.", "I'm running for president because a handful of billionaires and wealthy families are trying to buy elections just to make themselves richer.", "It is my very strong inclination that if Sandra Bland was a white middle-class woman that would not have happened.", "What the polls are showing is the American people are responding to our message and we are on a path to victory.", "This morning I’ll be on NBC’s @MeetThePress and CBS @FaceTheNation.", "Criminal justice reform must be the civil rights issue of the 21st century and the first piece has to be police reform.", "Today, 29 million of our sisters and brothers are without health care.", "We can and must do better.", "I'm running for president because it is harder than ever for students to pay for college and for working parents to afford daycare.", "I will do everything that I can to make sure that the United States does not get involved in another quagmire like we did in Iraq.", "I need you to help me get out the vote.", "It's time to end religious bigotry and build a nation in which we all stand together and condemn the anti-Muslim rhetoric we're hearing.", "We would not tolerate the head of Exxon Mobil running the Environmental Protection Agency.", "A single-payer system already exists in the United States.", "It's called Medicare and the people enrolled give it high marks.", "Every man, woman and child in our country should be able to access quality care regardless of their income.", "In my view, some of the real heroines in our country today are single moms.", "Our nation has always been a beacon of hope, a refuge for the oppressed.", "We cannot turn our backs on that essential element of who we are as a nation.", "I'm running for president because the middle class is disappearing and more than half of new income is going to the top 1 percent.", "The health insurance lobbyists and big pharmaceutical companies try to make \"national health care\" sound scary.", "Too many lives have been destroyed because of police records.", "It is not their kids who are going into war.", "You’ll forgive me, this is an emotional issue for me.", "We must take steps to protect children and families seeking refuge here, not cast them out.", "We who are parents should ask ourselves what we would do if our children faced the danger and violence these children do?.", "Very disturbed by reports that the government may commence raids to deport families who've fled here to escape violence in Central America.", "When they divide us up, they win.", "When we stand together as one people, we win.", "We should not be firing teachers, we should be hiring teachers.", "School teachers and educators are real American heroes.", "Don't know how to break this to you, but Trump has discovered that women go to the bathroom.", "If Congress does not act, we will use the executive authority of the president to stop the dividing up of families.", "You want to keep the minimum wage low, and give tax breaks to millionaires.", "@realDonaldTrump, that is not what makes America great.", "Any official who helped suppress the videotape of Laquan McDonald’s murder should be held accountable.", "Garcia for inviting me to Chicago today.", "Two agents for real change.", "Reforming our criminal justice system is one of the most important things that a President can do.", "Corporate America and Wall Street: you can hate me all you want, but we’re going to end your greed.", "We need to end mandatory minimum sentencing and give judges the discretion to better tailor sentences to the specific facts of a given case.", "We cannot jail our way out of health problems like drug addiction or social and economic problems like poverty.", "Spending some time tonight with @CornelWest, @NinaTurner, @JesusChuyGar and @KillerMike in Chicago.", "If you don’t have a lot of money and you have a high health insurance deductible, you’re not gonna go to the doctor.", "I’m getting a very good feeling about Iowa.", "We have to ask ourselves, “Is it morally acceptable, is it economically sustainable, that so few have so much while so many have so little?”.", "This election is not just about electing a President.", "Far more significantly, it is about transforming America.", "We need to tell the drug companies to stop ripping off the American people.", "To rein in Wall Street, we should begin by reforming the Federal Reserve.", "There comes a time when you have to take on the establishment and not be part of that establishment.", "There is nothing that is more important than passing on a Mother Earth that is healthy and habitable for our kids and grandchildren.", "Climate change is real and caused by human activity.", "It's already causing devastating problems around the world.", "It’s all hands on deck for a pre-holiday phone bank.", "We're going to move to public funding of elections so candidates don't have to beg the wealthy and powerful for money when they want to run.", "You have a right to health care regardless of whether you are rich or poor.", "The Koch brothers are prepared to spend $889 million this election to end Social Security and dismantle our safety net.", "I am going to take on Wall Street.", "They do not like me today.", "They will like me even less if I am elected president.", "Congress bailed out Wall St.", "because it was too big to fail.", "In my view, if a bank is too big to fail, it's too big to exist.", "We're gonna have some fun, we're gonna make a political revolution, we're gonna transform America.", "Other than that, not much.", "The second 100 days of the political revolution.", "I believe that we need a political revolution.", "The same old, same old just isn't going to do it.", "We have to be bold.", "You are looking at one candidate for president who does not have a super PAC and I’m damn proud of that.", "Despite growing poverty among seniors, Republicans want more austerity for the elderly and more tax breaks for the rich.", "If we're going to stand up to the greed of the billionaire class and the greed of corporate America, I accept Wall Street not liking me.", "We have a broken immigration system that divides families and keeps millions of hard-working people in the shadows.", "\"I guess Christmas Eve was booked.", "” - Michael Briggs, Comms.", "The time is now for the United States to end capital punishment.", "Voter ID laws aren't intended to discourage fraud, they are intended to discourage voting.", "If we are to retain the fundamentals of American democracy, we need to overturn the disastrous Citizens United Supreme Court decision.", "We must convince students that if they participate in the political process we can lower the outrageously high student debt they face.", "Let’s be clear: in terms of protecting the needs of our families the United States lags behind virtually every major country on earth.", "The fossil fuel industry is destroying the planet with impunity and getting rich while doing it.", "This campaign is about the needs of the American people, and the proposals that effectively address those needs.", "I support 12 weeks of paid leave for every worker.", "Say you support paid leave for mothers &amp; fathers too.", "We now have the highest incarceration rate in the entire world with over 2 million in prison and millions more on probation or parole.", "Post-debate breakfast from this morning at IHOP in Bedford, New Hampshire.", "\"Get in on the love train.", "That’s what Bernie Sanders’ campaign is.", "Corporate greed is rampant, and the very rich keep growing richer while everyone else grows poorer.", "This campaign will be driven by issues and serious debate.", "The United States once led the world in terms of the percentage of our young people who had college degrees.", "Today we’re now in 12th place.", "I got into politics not to figure out how to become President.", "I got into politics because I give a damn.", "Addiction is a disease, not a criminal activity.", "Addiction is ravaging families and communities in NH.", "This is a crisis, and we need to treat it as a health issue—not throw people in jail.", "I know you have heard these names before but they bear repeating so we do not lose sight of the real human price being paid.", "Michael Brown, Eric Garner, Jessica Hernandez, Freddie Gray, Sandra Bland, Tamir Rice, Samuel Dubose, Rekia Boyd and too many more.", "Any serious criminal justice reform must include removing marijuana from the Controlled Substances Act.", "We need to rethink the \"War on Drugs\" and treat substance abuse as a serious health issue, not a criminal issue.", "'Socialist' programs from FDR and LBJ:\n✅Social Security\n✅Minimum Wage\n✅Medicare and Medicaid\n✅40-hour work week\n#DemDebate.", "When a husband can’t get time off to care for his cancer-stricken wife, that is not a family value.", "Medicare for All would eliminate payments to insurance companies that put profits before people.", "Bernie’s college plan is the only plan that affords lower-income kids the same opportunity for a quality education.", "CEO's of large multinationals may like @HillaryClinton, but they ain't gonna like me.", "We need debt-free college and free tuition is the best way to get there.", "I don’t think it’s a radical idea that in the richest country in the history of the world health care should be a right, not a privilege.", "Bernie helped lead the effort against @billclinton who thought it would be a great idea to deregulate Wall Street.", "\"The greed of the billionaire class, the greed of Wall Street is destroying this economy.", "We do not have a super PAC.", "We do not want the money of corporate America.", "This is a people’s campaign.", "This nation and its government belong to all of the people, and not solely to a handful of billionaires, their super PACs and lobbyists.", "Elections should be influenced by grassroots movements not a billionaire’s checkbook.", "We have seen far too many people, often African Americans, who are unarmed, shot and killed by police officers.", "There is nothing that is more important than passing on an earth that is healthy and habitable for our kids and grandchildren.", "It's time to end religious bigotry and build a nation where we all stand together and condemn the anti-Muslim rhetoric.", "Nearly two-thirds of the electorate didn't vote in 2014.", "It's clear we need radical change to bring more people into the political system.", "The Koch brothers intend to spend $750 million on this election.", "That's more than either the Democratic or Republican Party will spend.", "Over the last 30 years there has been a transfer of trillions of dollars from the middle class to the top one-tenth of one percent.", "There is something profoundly wrong when the top one-tenth of one percent owns almost as much wealth as the bottom 90 percent.", "You have families out there paying 6, 8, 10 percent on student debt but you can refinance your homes at 3 percent.", "We have a major health care crisis.", "29 million Americans still have no health insurance and millions more can't afford to go to the doctor.", "Why is it that the United States today is the only major country on earth that does not guarantee health care to all people as a right?.", "I believe we stand together to address the real issues facing this country, not allow them to divide us by race or where we come from.", "We must bring people together to take on the powerful who've hurt the middle class.", "Trump is trying to play on fears and divide us up.", "Our nation has always been a refuge for the oppressed.", "We need to take steps to protect children and families, not cast them out.", "Blacks are imprisoned at six times the rate of whites.", "I consider reforming our criminal justice system one of the most important things we must do.", "I want the word to go out to every kid that if you study hard, regardless of your family's income, you will be able to go to college.", "Addiction is a disease, not a criminal activity.", "I want a new foreign policy that destroys ISIS but does not get us involved in perpetual warfare in the quagmire of the Middle East.", "We have a campaign finance system which is corrupt.", "I do not want to be liked by everybody.", "I want to be liked and supported by working families because I am going to take on Wall Street.", "Our government belongs to all of us, and not just the hand full of billionaires.", "We've got a corrupt campaign finance system in which millionaires and billionaires are heavily influencing the political process.", "I do not want to be liked by everybody.", "There comes a time when you have to take on the establishment and not be part of that establishment.", "Regime change without worrying about what happens the day after you get rid of the dictator doesn't make sense.", "Wall Street is a threat to the economy.", "They've got to be broken up.", "Scapegoating minorities is not going to solve the problems facing our country.", "We need to reform a very broken criminal justice system.", "We are going to provide free tuition to public colleges and universities by imposing a tax on Wall Street speculation.", "The greed of Wall Street is destroying this economy and is destroying the lives of millions of Americans.", "We cannot just destroying ISIS.", "We must make sure we do it in a way that leads to a better future and more stability in the region.", "The greed of corporate America is destroying our economy.", "They've got to be confronted.", "We need changes in the power structure of America.", "We need pay equity for women workers.", "Women should not be making 79 cents on the dollar compared to men.", "People are looking at Washington, and they're saying the rich are getting much richer, I'm getting poorer, what are you doing about it?.", "In my view, we have got to see that weapons designed by the military to kill people are not in the hands of civilians.", "Three out of four of the largest banks are larger today than when we bailed them out.", "If they're too big to fail they're too big to exist.", "Countries like Saudi Arabia and Qatar have got to step up to the plate to contribute money and troops to destroy ISIS with American support.", "I know I have been considered to be very, very radical but on almost every issue that I’m talking about there is vast support among people.", "The greed of corporate America and Wall Street is destroying the economy of the United States.", "These guys have got to be confronted.", "We are living in a country that is moving quite rapidly toward an economic and political oligarchy, where a handful of people have control.", "Understand that Donald Trump thinks a low minimum wage in America is a good idea.", "He thinks low wages are a good idea.", "was right when he said: “This country has socialism for the rich, and rugged individualism for the poor.", "True freedom does not occur without economic security.", "In other words, people are not truly free when they are unable to feed their family.", "In the United States today, we have more income and wealth inequality than at any time since 1928.", "Anyone think that makes sense?.", "The minimum wage was originally described as “socialist.", "”  Today it is seen as the foundation of the middle class.", "The great middle class of America, once the envy of the entire world, has been disappearing.", "We must address this economic and moral issue.", "Congress must pass legislation that make our rigged political and economic systems work for the vast majority of Americans not just the 1%.", "The truth is we can't afford another spending package that expands the billionaire class's power and wealth at the expense of everyone else.", "The current federal minimum wage of $7.", "25 an hour is a starvation wage and must be raised to a living wage.", "Since the Wall Street crash of 2008, more than 58% of all new income has gone to the top 1%.", "We must make our economy work for the 99%."]
    corpus_list.each do |corpus|
  
      ## Alpha
      category = alpha
      
      next if parse_text( corpus, category, "should" )
      next if parse_text( corpus, category, "would" )
      next if parse_text( corpus, category, "could" )
      
      next if parse_text( corpus, category, "to make" )
      next if parse_text( corpus, category, "to protect" )
      next if parse_text( corpus, category, "to deport" )
      next if parse_text( corpus, category, "to stop" )
      next if parse_text( corpus, category, "to keep" )
      next if parse_text( corpus, category, "to take" )
      next if parse_text( corpus, category, "to beg" )
      next if parse_text( corpus, category, "to spend" )
      next if parse_text( corpus, category, "to end" )
      next if parse_text( corpus, category, "to rebuild" )
      next if parse_text( corpus, category, "to stay" )
      next if parse_text( corpus, category, "to focus" )
      next if parse_text( corpus, category, "to cut" )
      next if parse_text( corpus, category, "to answer" )
      next if parse_text( corpus, category, "to control" )
      next if parse_text( corpus, category, "to suffer" )
      next if parse_text( corpus, category, "to use" )
      next if parse_text( corpus, category, "to create" )
      next if parse_text( corpus, category, "to prevent" )
      next if parse_text( corpus, category, "to ensure" )
      next if parse_text( corpus, category, "to stand" )
      next if parse_text( corpus, category, "to battle" )
      next if parse_text( corpus, category, "to fill" )
      next if parse_text( corpus, category, "to break" )
      next if parse_text( corpus, category, "to expand" )
      next if parse_text( corpus, category, "to buy" )
      next if parse_text( corpus, category, "to address" )
      next if parse_text( corpus, category, "to understand" )
      

      next if parse_text( corpus, category, "must" )
      next if parse_text( corpus, category, "can" )

      ## Beta
      category = "beta"
      next if parse_text( corpus, category, "because" )
      next if parse_text( corpus, category, "when" )
      next if parse_text( corpus, category, "but" )
      next if parse_text( corpus, category, "which" )
      next if parse_text( corpus, category, "while" )
      next if parse_text( corpus, category, "that the" )
      next if parse_text( corpus, category, "that they" )
      next if parse_text( corpus, category, "that a" )
     
      
      ## Gamma
      category = "gamma"
      next if parse_text( corpus, category, "is" )
      next if parse_text( corpus, category, "was" )
      next if parse_text( corpus, category, "are" )

      
    end
    
    texts
    
  end
  
  def parse_text( corpus, category, keyword )
    m = corpus.match( " #{keyword} " )
    if m
      location = corpus =~ /#{keyword}/
      return false if location < 10
      return false if (corpus.size-location < 10)
      
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
  
  def source_texts_new(client)
    
    @texts = []
    
    tweets = client.search("from:berniesanders -rt", result_type: "recent").take(100)
    tweets.concat( client.search("from:berniesanders -rt", result_type: "recent").take(100) )

    corpus_list = []
    tweets.each do |tweet|
      sentences = tweet.text.split('.')
      sentences.each do |sentence|
        next if sentence =~ /http/
        words = sentence.split(' ')
        next if words.size < 5
        corpus_list << "#{sentence.strip}."
      end
    end
    
    corpus_list.each do |corpus|
  
      ## Alpha
      category = "alpha"
      
      next if parse_text( corpus, category, "should" )
      next if parse_text( corpus, category, "would" )
      next if parse_text( corpus, category, "could" )
      
      next if parse_text( corpus, category, "to make" )
      next if parse_text( corpus, category, "to protect" )
      next if parse_text( corpus, category, "to deport" )
      next if parse_text( corpus, category, "to stop" )
      next if parse_text( corpus, category, "to keep" )
      next if parse_text( corpus, category, "to take" )
      next if parse_text( corpus, category, "to beg" )
      next if parse_text( corpus, category, "to spend" )
      next if parse_text( corpus, category, "to end" )
      next if parse_text( corpus, category, "to rebuild" )
      next if parse_text( corpus, category, "to stay" )
      next if parse_text( corpus, category, "to focus" )
      next if parse_text( corpus, category, "to cut" )
      next if parse_text( corpus, category, "to answer" )
      next if parse_text( corpus, category, "to control" )
      next if parse_text( corpus, category, "to suffer" )
      next if parse_text( corpus, category, "to use" )
      next if parse_text( corpus, category, "to create" )
      next if parse_text( corpus, category, "to prevent" )
      next if parse_text( corpus, category, "to ensure" )
      next if parse_text( corpus, category, "to stand" )
      next if parse_text( corpus, category, "to battle" )
      next if parse_text( corpus, category, "to fill" )
      next if parse_text( corpus, category, "to break" )
      next if parse_text( corpus, category, "to expand" )
      next if parse_text( corpus, category, "to buy" )
      next if parse_text( corpus, category, "to address" )
      next if parse_text( corpus, category, "to understand" )
      

      next if parse_text( corpus, category, "must" )
      next if parse_text( corpus, category, "can" )

      ## Beta
      category = "beta"
      next if parse_text( corpus, category, "because" )
      next if parse_text( corpus, category, "when" )
      next if parse_text( corpus, category, "but" )
      next if parse_text( corpus, category, "which" )
      next if parse_text( corpus, category, "while" )
      next if parse_text( corpus, category, "that the" )
      next if parse_text( corpus, category, "that they" )
      next if parse_text( corpus, category, "that a" )
     
      
      ## Gamma
      category = "gamma"
      next if parse_text( corpus, category, "is" )
      next if parse_text( corpus, category, "was" )
      next if parse_text( corpus, category, "are" )
      
    end
    
    texts
    
  end
  
=end
  
end