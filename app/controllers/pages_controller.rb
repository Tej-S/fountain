class PagesController < ApplicationController
  def index
    @pages = Page.find(:all)
    @heading = 'Search and Index'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  def show
    @page = Page.find_by_slug(params[:id])
    @heading = @page.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def new
    @page = Page.new
    @heading = 'New Page'
    render :action => 'edit'
  end

  def edit
    @page = Page.find_by_slug(params[:id])
    @heading = "Editing #{@page.title}"
    redirect_to @page unless admin?
  end

  def create
    @page = Page.new(params[:page])
    @heading = 'New Page'
    if @page.save
      flash[:notice] = "<strong>#{@page.title}</strong> was successfully created"
      redirect_to(@page)
    else
      render :action => "new"
    end
  end

  def update
    @page = Page.find(params[:id])
    @heading = "Editing #{@page.title}"

    if @page.update_attributes(params[:page])
      flash[:notice] = "<strong>#{@page.title}</strong> was successfully updated"
      redirect_to(@page)
    else
      render :action => "edit"
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to(pages_url)
  end
end
