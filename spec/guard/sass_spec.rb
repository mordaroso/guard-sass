require 'spec_helper'

describe Guard::Sass do
  subject { Guard::Sass.new }

  describe "initialize" do
    it "should set default output path" do
      subject.options[:output].should == 'css'
    end
  end

  describe "run all" do
    it "should rebuild all files being watched" do
      subject.should_receive(:run_on_change).with([]).and_return([])
      subject.run_all
    end
  end

  describe "building sass to css" do
    it "should convert sass to css" do
      file = "spec/fixtures/_sass/screen.sass"

      res = <<EOS
.error, .badError {
  border: 1px red;
  background: #ffdddd; }

.error.intrusion, .intrusion.badError {
  font-size: 1.3em;
  font-weight: bold; }

.badError {
  border-width: 3px; }
EOS

      subject.build_sass(file).should == res
    end

    it "should convert scss to css" do
      file = "spec/fixtures/_sass/print.scss"

      res = <<EOS
.error, .badError {
  border: 1px #f00;
  background: #fdd; }

.error.intrusion, .intrusion.badError {
  font-size: 1.3em;
  font-weight: bold; }

.badError {
  border-width: 3px; }
EOS

      subject.build_sass(file).should == res
    end
  end

  describe "getting path to output file" do
    it "should change extension to css" do
      subject.options[:output] = "css"
      r = subject.get_output("spec/fixtures/_sass/screen.sass")
      r[-3..-1].should == "css"
    end

    it "should change the folder to /css (by default)" do
      subject.options[:output] = "css"
      r = subject.get_output("spec/fixtures/_sass/screen.scss")
      File.dirname(r).should == "spec/fixtures/_sass/../css"
    end

    it "should not change the file name" do
      subject.options[:output] = "csS"
      r = subject.get_output("spec/fixtures/_sass/screen.scss")
      File.basename(r)[0..-5].should == "screen"
    end
  end

end

