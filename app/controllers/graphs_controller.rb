require_relative '../helpers/bugzilla_helper'
class GraphsController < ApplicationController

  def index
    @graph = Graph.new
    @graphs = Graph.all
    graph_params = {:product => params[:product],
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
    @graph_query = params if params.values.select{|x| x.nil?}.empty?
    @bugzilla_bugs = {}

    if @graph_query
      Graph.all.each do |graph|
        bugzilla_url = "http://bugzilla.corp.convio.com/buglist.cgi?"
        search = "&short_desc=#{graph.search}&short_desc_type=substring"
        bug_status = "&bug_status=NEW&bug_status=VERIFIED"
        product = "&product=#{@graph_query[:product]}"
        date_string = "&type0-1-0=lessthan&query_format=advanced&value0-1-0=#{@graph_query[:end_date]}&field0-1-0=creation_ts&field0-0-0=creation_ts&type0-0-0=greaterthan&value0-0-0=#{@graph_query[:start_date]}"
        @bugzilla_bugs[graph.search] = BugzillaHelper.bug_id_by_url(bugzilla_url + search + date_string+ bug_status + product).size
      end
    end
  end

  def fix_date_param date
    return if date.nil?
    date_arr = date.values
    Date.new(date_arr[0].to_i, date_arr[1].to_i)
  end
end
