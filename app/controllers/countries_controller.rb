class CountriesController < ApplicationController
  def new
  end

  def create
    # obviously this is throwaway test code, we probably want to check
    # what's been written to the database
    File.write('tmp/selection', params['input-autocomplete'], mode: 'w')

    render(:new)
  end
end
