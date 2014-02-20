require 'spec_helper'

describe ApplicationHelper do

  describe "#format_date" do
    subject { helper.format_date(date) }
    context "date is nil" do
      let(:date) { nil }
      it { expect(subject).to eq "" }
    end
    context "date is blank" do
      let(:date) { "" }
      it { expect(subject).to eq "" }
    end
    context "date is '2014/01/01'" do
      let(:date) { '2014/01/01' }
      it { expect(subject).to eq "2014-01-01" }
    end
    context "date is '2014-01-01 00:00:00 UTC'" do
      let(:date) { '2014-01-01 00:00:00 UTC' }
      it { expect(subject).to eq "2014-01-01" }
    end
  end

  describe "#difference_from_now" do
    subject { helper.difference_from_now(time) }
    before { allow(Time).to receive(:now).and_return(now) }
    let(:now) { Time.local(2014,1,1,12,0,0) }
    context "time is nil" do
      let(:time) { nil }
      it { expect(subject).to be_nil }
    end
    context "time equal now" do
      let(:time) { now }
      it { expect(subject).to eq "0 s ago" }
    end
    context "time is 59 sec ago" do
      let(:time) { now - 59 }
      it { expect(subject).to eq "59 s ago" }
    end
    context "time is 60 sec ago" do
      let(:time) { now - 60 }
      it { expect(subject).to eq "1 m ago" }
    end
    context "time is (59m and 59s) ago" do
      let(:time) { now - ((60*60)-1) }
      it { expect(subject).to eq "59 m ago" }
    end
    context "time is 60 min ago" do
      let(:time) { now - (60*60) }
      it { expect(subject).to eq "1 h ago" }
    end
    context "time is 12 hour ago" do
      let(:time) { now - (60*60*12) }
      it { expect(subject).to eq "12 h ago" }
    end
    context "time is (12h and 1s) ago" do
      let(:time) { now - ((60*60*12)+1) }
      it { expect(subject).to eq "yesterday, 23:59" }
    end
    context "time is 27 hour ago" do
      let(:time) { now - ((60*60*27)) }
      it { expect(subject).to eq time.to_date }
    end
  end

end