require 'twitter'
require_relative 'bernie_bot'

class BotController
  
  def initialize
    ## Bot user
    @user_screen_name = "Bernie_ebooks"
    ## App config settings
    config = {
      consumer_key:        ENV['BERNIE_BOT_CONSUMER_KEY'],
      consumer_secret:     ENV['BERNIE_BOT_CONSUMER_SECRET'],
      access_token:        ENV['BERNIE_BOT_ACCESS_TOKEN'],
      access_token_secret: ENV['BERNIE_BOT_ACCESS_TOKEN_SECRET']
    }
    ## Get client
    @client = Twitter::REST::Client.new( config )
    ## Setup bots
    @bots = setup_bots
  end
  
  def tweet
    bot = @bots.first
    5.times do
      success, result = bot.build_text
      if success
        next if duplicate?( result )
        @client.update( result )
        puts result
        break
      else
        puts "ERROR: #{result}"
      end
    end
  end
  
  def duplicate?( result )
    search_str = "from:#{@user_screen_name} #{result}"
    results = @client.search( search_str )
    results.any? ? true : false
  end
  
  def list
    bot = @bots.first
    success, result = bot.build_text
    if success
      puts result
    else
      puts "ERROR: #{result}"
    end
  end
  
  private
  
  def setup_bots
    bots = []
    bots << BernieBot.new(@client)
    bots
  end

end