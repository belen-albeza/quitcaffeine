# ==================
# = Global helpers =
# ==================

require 'sinatra'
require 'data_mapper'
require 'time-lord'

helpers do
  def since(date)
    Time.new(date.to_s).ago_in_words
  end
end