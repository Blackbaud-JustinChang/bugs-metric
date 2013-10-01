class GraphsController < ApplicationController

  def new
    @graph = Graph.new
    @graphs = Graph.all
  end

  def create
    @graph = Graph.new(params[:graph])
    if @graph.save
      redirect_to new_graph_path
    else
      #show error message
      redirect_to new_graph_path
    end
  end

  def graph


  end
end
