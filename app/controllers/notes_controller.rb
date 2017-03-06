class NotesController < ApplicationController

  def new
    @note = Note.new
  end

  def edit
    @note = Note.find(params[:id])
    unless @note.creator == current_agent 
      flash[:error] = "Unauthorized to edit note"
      redirect_to dashboard_index_path
    end
  end

  def update
    
  end

  def create
    if n = Note.create(note_params)
      n.creator = current_agent
      flash[:notice] = "Thank you for your feedback"
      redirect_to dashboard_index_path
    else
      flash[:notice] = "Error creating note"
      redirect_to new_note_path
    end
  end

  def destroy
    note = Note.find(params[:id])
    if note.creator == current_agent
      puts "destroy successful"
      note.deleted = true
      note.save!
    else 
      puts note.creator
      puts current_agent
      flash[:error] = "not authorized"
    end
    redirect_to dashboard_index_path
  end

  private
  
  def note_params
    params.require(:note)
      .permit(:pmid, :gene, :condition, :case_variant, :case_segregation,
              :case_summary, :case_control_single_variant,
              :case_control_aggregate_variant, :case_control_summary,
              :experimental_function, :experimental_function_alteration,
              :experimental_model, :experimental_summary)
  end

end
