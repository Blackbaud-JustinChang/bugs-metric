require_relative '../helpers/bugzilla_helper'
class GraphsController < ApplicationController

  def index
    @graph = Graph.new
    @graphs = Graph.all
    graph_params = {:product_id => params[:product_id],
                    :start_date => fix_date_param(params[:start_date]),
                    :end_date => fix_date_param(params[:end_date])}
    show_graph(graph_params)
  end

  def create
    @graph = Graph.new(params[:graph])
    if @graph.save
      redirect_to root_path
    else
      #show error message
      redirect_to root_path
    end
  end

  def remove_graph
    graph = Graph.find(params[:id])
    graph.destroy
    redirect_to root_path
  end

  private

  def show_graph params
    Graph.all #get all graphs
    @graph_query = params if params.values.select{|x| x.nil?}.empty?
    flash.now[:notice] = "Query has been submitted" if @graph_query
    @bugzilla = BugzillaHelper.bug_info(61442)
  end

  def fix_date_param date
    return if date.nil?
    date_arr = date.values
    Date.new(date_arr[0].to_i, date_arr[1].to_i)
  end
end
