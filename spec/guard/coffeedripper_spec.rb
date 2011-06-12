require 'spec_helper'

describe Guard::CoffeeDripper do
  subject { Guard::CoffeeDripper.new }

  describe "#initialize" do
    it "should set default output path" do
      subject.options[:output].should == 'app/coffeescripts/'
    end

    it "should set default input path" do
      subject.options[:input].should == 'app/coffeescripts/'
    end

    it "should set default ext" do
      subject.options[:ext].should == 'coffeebean'
    end

    it "should set default config path" do
      subject.options[:config].should == 'config/coffeedripper.yaml'
    end
    describe "load conifg" do
      it "is success" do
        subject.config.should == {"app.coffee" => ["hoge.bean", "huga.bean"]}
      end
    end
  end

  describe "#start" do
    it "should run all" do
      subject.should_receive(:run_all)
      subject.start
      subject.load_coffee("app.coffee").should == "hoge\nhuga\n"
    end
  end
  describe "#run_on_change" do
    it "update coffee script" do
      s = File::stat("app/coffeescripts/app.coffee")
      mt = s.mtime
      subject.run_on_change(["app/coffeescripts/hoge.bean"])
      s = File::stat("app/coffeescripts/app.coffee")
      mt2 = s.mtime
      mt.should_not == mt2
    end
  end
end


