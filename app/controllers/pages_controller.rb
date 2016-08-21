class PagesController < ApplicationController
  layout 'site_main'

  def home
    render layout: 'site_main'
  end

  def entry
    render layout: 'entry'
  end
end
