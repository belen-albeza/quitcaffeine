require 'sinatra'

helpers do
  def new_shot_url(source_slug=nil)
    if source_slug.nil?
      "/shot"
    else
      "/shot/#{source_slug}"
    end
  end
end
