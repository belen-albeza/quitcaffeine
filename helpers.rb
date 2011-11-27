# ==================
# = Global helpers =
# ==================

require 'sinatra'
require 'data_mapper'
require 'time-lord'

helpers do
  def permalink(url)
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    "#{@base_url}#{url}"
  end
  
  def home_url
    '/' 
  end
  
  def about_url
    '/about'
  end
  
  def ago(date)
    Time.parse(date.to_s).ago_in_words
  end
  
  # more versatile partials!
  # taken from https://gist.github.com/119874 by Sam Elliott  
  def partial(template, *args)
    template_array = template.to_s.split('/')
    template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.merge!(:layout => false)
    locals = options[:locals] || {}
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << erb(:"#{template}", options.merge(:layout =>
        false, :locals => {template_array[-1].to_sym => member}.merge(locals)))
      end.join("\n")
    else
      erb(:"#{template}", options)
    end
  end
  
end

