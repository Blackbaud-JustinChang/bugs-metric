require_relative '../helpers/bugzilla_helper'
class GraphsController < ApplicationController

  def index
    @graph = Graph.new
    @graphs = Graph.all
    @bugzilla_bugs_by_date = {}
    graph_params = {:product => params[:product],
                    :start_date => fix_date_param(params[:start_date]),
                    :end_date => fix_date_param(params[:end_date])}
    show_graph(graph_params)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @graph}
    end

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
    @graphs = Graph.all

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :template => 'graphs/remove_graph.js.erb', :layout => false}
      format.json
    end
  end

  private

  def show_graph params
    @graph_query = params if params.values.select { |x| x.nil? }.empty?
    @bugzilla_bugs = {}

    if @graph_query
      begin_time = Time.now
      Graph.all.each do |graph|
        bugzilla_url = "http://bugzilla.corp.convio.com/buglist.cgi?"
        search = "&short_desc=#{graph.search}&short_desc_type=substring"
        product = "&product=#{@graph_query[:product]}"
        date_param = date_string(@graph_query[:start_date], @graph_query[:end_date])
        bugzilla_bug_ids = BugzillaHelper.bug_id_by_url(bugzilla_url + search + date_param + product)
        @bugzilla_bugs[graph.search] = bugzilla_bug_ids.size

        # API way
        @bugzilla_bugs_by_date[graph.search] = {}
        bug_ids = BugzillaHelper.bug_info(bugzilla_bug_ids)
        date = @graph_query[:start_date].clone
        while date != @graph_query[:end_date] and !bug_ids.empty?
          @bugzilla_bugs_by_date[graph.search][date.to_s] = bug_ids.select { |x| x['creation_time'].to_date >= date and x['creation_time'].to_date < date.next_month }.size
          date = date.next_month
        end

        # Query url way
        #@debug[graph.search] = {}
        #date = @graph_query[:start_date].clone
        #while date != @graph_query[:end_date]
        #  date_param = date_string(date, date.next_month)
        #  bug_ids = BugzillaHelper.bug_id_by_url(bugzilla_url + search + date_param + product)
        #  @debug[graph.search][date.to_s] = bug_ids.size
        #  date = date.next_month
        #end

      end

      create_graph
      @total_time = Time.now - begin_time

    end
  end

  def date_string start_date, end_date
    "&type0-1-0=lessthan&query_format=advanced&value0-1-0=#{end_date}&field0-1-0=creation_ts&field0-0-0=creation_ts&type0-0-0=greaterthan&value0-0-0=#{start_date}"
  end

  def fix_date_param date
    return if date.nil?
    date_arr = date.values
    Date.new(date_arr[0].to_i, date_arr[1].to_i)
  end

  def create_graph
    @bar_graph = LazyHighCharts::HighChart.new('bar_graph') do |f|
      f.series(:name => 'Total Bugs', :data => @bugzilla_bugs.values)
      f.title({:text => "Total Bugs from #{@graph_query[:start_date]} to #{@graph_query[:end_date]}"})
      f.legend({:align => 'right',
                :x => -100,
                :verticalAlign => 'top',
                :y => 20,
                :floating => "true",
                :backgroundColor => '#FFFFFF',
                :borderColor => '#CCC',
                :borderWidth => 1,
                :shadow => "false"
               })
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:xAxis] = {:plot_bands => "none", :title => {:text => "Search"}, :categories => @bugzilla_bugs.keys}
      f.options[:yAxis][:title] = {:text => "Answers"}
    end



    @line_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({type: 'line'})
      f.title({text: 'Total Bugs per Month'})
      f.xAxis({
                  categories: @bugzilla_bugs_by_date.first[1].keys
              })
      f.yAxis({
                  title: {
                      text: 'Bugs'
                  }
              })
      f.tooltip({
                    shared: true,
                    crosshairs: true

                })
      f.plotOptions({
                        line: {
                            dataLabels: {
                                enabled: true
                            },
                            enableMouseTracking: true
                        }
                    })

      @bugzilla_bugs_by_date.each do |key, value|
        f.series({
                     name: key,
                     data: value.values
                 })
      end
    end
  end
end
