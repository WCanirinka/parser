# frozen_string_literal: true

require_relative '../analyze_parser'
require_relative '../parser'
require 'spec_helper'

describe LogParser do
  let(:data) do
    "/index 0.0.0.0\n/about 1.1.1.1\n/contact 2.2.2.2
    /index 0.0.0.0\n/about 1.1.1.2\n/contact 2.2.2.3
    /index 0.0.0.0\n/about 1.1.1.1\n/contact 2.2.2.4
    /contact 2.3.45\n/index 0.0.0.0\n/index 0.0.0.0"
  end
  let(:subject) { LogParser.new('test.log') }

  before(:each) do
    allow(File).to receive(:read).and_return(data)
    allow(subject).to receive(:parser).and_return LogAnalyze.new('test.log')
  end

  it 'sets parser' do
    expect(subject.parser).to_not be_nil
  end

  it 'shows most page views' do
    expect(subject.most_page_views).to include('/index - 5 visits')
  end

  it 'shows most unique views' do
    expect(subject.most_unique_page_views).to include('/index - 1 unique views')
  end

  it 'most page views should not include unique views' do
    expect(subject.most_page_views).to_not include('/index - 1 unique views')
  end

  it 'shows_summary' do
    expect(subject.summary).to include('/index - 5 visits')
    expect(subject.summary).to include('/index - 1 unique views')
  end
end
