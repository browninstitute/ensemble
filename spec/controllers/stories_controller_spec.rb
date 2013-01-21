require 'spec_helper'

describe StoriesController do
  let(:story) { mock_model(Story, :title => "test title", :subtitle => "test subtitle",
                                  :content => "test content", 
                                  :versions => [mock_model(Version).as_null_object, mock_model(Version).as_null_object]).as_null_object }

  before(:each) do
    Story.stub(:find).and_return(story)
  end

  describe "GET current" do
    it "returns the current story"
  end

  describe "POST save_draft" do
    it "saves a draft of the story" do
      story.should_receive(:save_draft)
      post :save_draft, :id => story.id, :story => {:content => story.content}
    end

    context "when draft saves successfully" do
      it "sets a flash message" do
        post :save_draft, :id => story.id, :story => {:content => story.content}
        flash[:notice].should match("Draft successfully saved.")
      end

      it "redirects to edit action" do
        post :save_draft, :id => story.id, :story => {:content => story.content}
        response.should redirect_to(:action => "edit")
      end
    end
  end

  describe "POST destroy_draft" do
    it "destroys the draft" do
      story.should_receive(:destroy_draft)
      post :destroy_draft, :id => story.id
    end

    context "when draft is destroyed successfully" do
      it "sets a flash message" do
        post :destroy_draft, :id => story.id
        flash[:notice].should match("Draft successfully discarded.")
      end

      it "redirects to edit action" do
        post :destroy_draft, :id => story.id
        response.should redirect_to(:action => "edit")
      end
    end
  end

  describe "POST preview" do
    let(:story_params) { {:content => "param content", :title => "param title",
                          :subtitle => "param subtitle"} }
    
    it "sets @story attributes from params" do
      story.should_receive(:assign_attributes).and_return true
      post :preview, :id => story.id, :story => story_params
    end
  end

  describe "GET history" do
    it "assigns @versions" do
      get :history, :id => story.id
      assigns[:versions].should eq(story.versions)
    end
  end

  describe "GET version" do
    it "assigns @story as past version" do
      get :view_version, :id => story.id, :version => "1"
      assigns[:story].should eq(story.versions[1].reify)
    end
  end
end
