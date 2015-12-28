require 'active_support'
require_relative 'source_text'
## require '../project/bernie-bot/bernie_bot'

class BernieBot

  MAX_CHARS = 140
  
  attr_accessor :texts
  
  def initialize( client )
    #@texts = source_texts
    @texts = source_texts_new(client)
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
=begin
    tweets = client.search("from:berniesanders -rt", result_type: "recent").take(100)
    
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
=end
    
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
      second_part: "prevent us from moving toward an Orwellian society.",
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
    texts << SourceText.new({
      first_part: "Any serious criminal justice reform must",
      second_part: "include removing marijuana from the Controlled Substances Act.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "If you take a look at my life’s work, there is one candidate in this campaign who is prepared to",
      second_part: "stand up to the billionaire class.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "On immigration, we must",
      second_part: "be aggressive in pursuing policies that are humane and sensible and that keep families together.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Instead of encouraging more people to vote, Republicans have passed laws to",
      second_part: "keep people away from the polls, especially low-income people.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Democracy is not a spectator sport. We must be truly engaged if we want to",
      second_part: "make real change. Go vote. #ElectionDay",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "I have always opposed Keystone XL. It isn't a distraction — it's a fundamental litmus test of your commitment to",
      second_part: "battle climate change.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "One in five Americans today cannot afford to",
      second_part: "fill the prescriptions their doctors write for them.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Congress cannot regulate Wall Street. It is time to",
      second_part: "break these too big to fail banks up.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "We cannot end DACA. We must fight to",
      second_part: "expand this successful program to legal limits. A president must be consistent on immigration.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "We must convince students that if they participate in the political process we can",
      second_part: "lower the outrageously high student debt they face.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "To my Republican colleagues I say:",
      second_part: "worry less about your campaign contributions and worry more about your children.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Every Democratic presidential candidate serious about addressing climate change should",
      second_part: "pledge to end fossil fuel leasing on public lands.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "The science is clear: we need to act to",
      second_part: "keep fossil fuels in the ground. #KeepItInTheGround",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "If Teddy Roosevelt were alive today, he would say:",
      second_part: "break up these too-big-to-fail banks.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "We already have the biggest military in the world, yet veterans",
      second_part: "sleep out on the streets. Will Republicans talk about this? #GOPDebate",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Let us stand today with the tens of millions of workers who are working hard to",
      second_part: "put food on the table.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Freedom of speech does not mean the freedom to",
      second_part: "buy the United States government.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "I'm listening to the #BlackOnCampus conversation. It's time to",
      second_part: "address structural racism on college campuses.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Glad to see so many young people here today. It’s important to",
      second_part: "understand the sacrifices veterans have made. #FITN",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "Republicans' family values are that our gay brothers and sisters shouldn't",
      second_part: "be able to get married.",
      category: preposition
    })
    texts << SourceText.new({
      first_part: "I don’t believe it is a terribly radical idea to say that someone who works 40 hours a week should not",
      second_part: "be living in poverty. #FightFor15",
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
    texts << SourceText.new({
      first_part: "At a time of massive inequality, the Republicans believe that",
      second_part: "the richest people in America need to be made even richer.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "There is something very wrong when",
      second_part: "one family owns more wealth than the bottom 130 million Americans. #nhpolitics",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "My friends, a political revolution is coming to New Hampshire and",
      second_part: "it’s coming to America. #fitn",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "The scientific community has been virtually unanimous:",
      second_part: "climate change is real. Our job is to aggressively transform our energy system.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Bike canvassing is one way",
      second_part: "our organizers in NH help reduce the use of fossil fuels while reaching voters. #fitn",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "Americans are working longer hours for lower wages and wondering how",
      second_part: "they're going to retire with dignity.",
      category: conjunction
    })
    texts << SourceText.new({
      first_part: "If patriotism means anything, it means that",
      second_part: "we do not turn our backs on those who defended us.",
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
    texts << SourceText.new({
      first_part: "We must fundamentally rewrite our trade policy so that American products, not American jobs, are",
      second_part: "our No. 1 export.",
      category: verb_to_be
    })    
    texts << SourceText.new({
      first_part: "The TPP is",
      second_part: "a continuation of our disastrous trade policies that have devastated manufacturing cities and towns all over this country.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "Now that the text of the Trans-Pacific Partnership has finally been released, it is",
      second_part: "even worse than I thought.",
      category: verb_to_be
    })    
    texts << SourceText.new({
      first_part: "We need a banking system that is",
      second_part: "part of creating a productive economy, not a handful of huge banks that engage in reckless activities.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "The only long-term solution to America's health care crisis is",
      second_part: "a single-payer national health care program.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "We must tell the fossil-fuel industry that their short-term profits are",
      second_part: "less important than caring for our planet.",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "The debate is over. Climate change is real, it is caused by humans and it is",
      second_part: "already causing devastating problems. #KeepItInTheGround",
      category: verb_to_be
    })
    texts << SourceText.new({
      first_part: "As we look back through history, we know women were",
      second_part: "at the forefront of every progressive victory in this country.",
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
    texts << SourceText.new({
      first_part: "Any serious criminal justice reform must include removing",
      second_part: "marijuana from the Controlled Substances Act.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "This campaign is sending a message to the billionaire class: you can’t have",
      second_part: "it all! #nhpolitics",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Like many other polls, the NBC/WSJ poll shows our campaign is the best shot for",
      second_part: "Democrats heading into the general.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "If I'm \"finished,\" I don't know what it says about",
      second_part: "Trump's situation when I'm 9pts ahead of him in the new NBC poll.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Billionaires should not be able to buy elections or candidates. We have got to overturn",
      second_part: "the Citizens United Supreme Court decision.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "We shouldn't be providing corporate welfare to multi-national corporations through",
      second_part: "the Export-Import Bank.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "We need pay equity in this country so that women make",
      second_part: "what a man makes for doing the same work.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "We need trade policies in this country that work for",
      second_part: "the working families of our nation.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Republicans should worry more about their kids and grandchildren and the future of this planet than",
      second_part: "their campaign contributors. #GOPDebate",
      category: verb_to_have
    })       
    texts << SourceText.new({
      first_part: "We will close the income inequality gap between",
      second_part: "the rich and the rest of us.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "The cost of war is real, and we have got to support",
      second_part: "those people who have put their lives on the line defending this country.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Medicare for All would eliminate payments to",
      second_part: "insurance companies that put profits before people.",
      category: verb_to_have
    })
    texts << SourceText.new({
      first_part: "Too often our Native American brothers and sisters have seen",
      second_part: "corporate profits put ahead of their sovereign rights.",
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