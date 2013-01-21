require 'spec_helper'

describe Story do
  let(:story) { Story.create! :title => "Test Title", :subtitle => "The best thing you'll ever read",
                       :content => "Once upon a time... the end." }

  it 'is valid with valid attributes' do
    story.should be_valid
  end

  it 'is not valid without a title' do
    story.title = nil
    story.should_not be_valid
  end
  
  describe "#save_draft" do
    context "when draft exists" do
      it "updates the draft" do
        story.instantiate_draft!
        story.save_draft("new text").content.should eql "new text"
      end
    end

    context "when draft does not exist" do
      it "should create a draft" do
        story.save_draft("new text").content.should eql "new text"
      end
    end
  end

  describe "#draft_or_story_text" do
    context "when draft exists" do
      it "returns draft content" do
        story.instantiate_draft!
        story.draft.update_attributes :content => "draft content"
        story.draft_or_story_text.should eql story.draft.content
      end
    end

    context "when draft does not exist" do
      it "returns published content" do
        story.draft_or_story_text.should eql story.content
      end
    end
  end

  describe "#destroy_draft" do
    context "when draft exists" do
      it "destroys the draft" do
        story.instantiate_draft!
        story.destroy_draft
        story.draft.should be_nil
      end
    end
  end
end
