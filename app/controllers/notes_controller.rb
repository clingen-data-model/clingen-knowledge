class NotesController < ApplicationController

  def new
  	@note = Note.new;
  	render "notes/edit"
  end

  def edit
  end

end
