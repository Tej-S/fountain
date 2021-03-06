require 'spec_helper'

describe History do
  include History

  def stub_session(with = {})
    @session = with
    stub!(:session).and_return(@session)
  end

  before(:each) do
    @page = stub_model(Page, :name => 'A Page')
  end

  it "should add to history when none existing" do
    stub_session
    record @page
    @session[:history].should == [@page.name]
  end

  it "should add to history when history already exists" do
    stub_session({:history => ['page']})
    record @page
    @session[:history].should == ['page', @page.name]
  end

  it "should return the current history from the session" do
    stub_session({:history => ['home', 'another']})
    history.should == ['home', 'another']
  end

  it "should return empty history when no history in session" do
    stub_session
    history.should == []
  end

  it "should remove object if already in history then add it" do
    another_page = stub_model(Page, :name => 'Another Page')
    stub_session({:history => [@page.name, another_page.name]})
    record @page
    @session[:history].should == [another_page.name, @page.name]
  end

  it "should remove first page when adding another page exceeds limit" do
    stub_session({:history => History::SIZE.times.map {|i| "page #{i}"}})
    record @page
    @session[:history].size.should == History::SIZE
    @session[:history].last.should == @page.name
  end

  it "should not record home page" do
    stub_session
    page = stub_model(Page, :name => 'HomePage')
    record page
    @session.should be_empty
  end
end

