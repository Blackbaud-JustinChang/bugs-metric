class GraphsController < ApplicationController

  def index
    @graph = Graph.new
    @graphs = Graph.all
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

  def show_graph
    puts "hello"
    puts "hello"
    redirect_to root_path
  end
end
