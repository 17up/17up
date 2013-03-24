class WordsController < ApplicationController
	before_filter :authenticate_member!


end