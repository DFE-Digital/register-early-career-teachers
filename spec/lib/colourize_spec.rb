require "rails_helper"

RSpec.describe Colourize do
  describe ".text" do
    Colourize::COLOURS.each_key do |key|
      it "wraps text in ANSI colour code #{key}" do
        expect(Colourize.text("Mary had a little lamb", key)).to eq "\e[#{Colourize::COLOURS[key]};#{Colourize::MODES[:bold]}mMary had a little lamb\e[#{Colourize::MODES[:clear]}m"
      end
    end
  end
end
