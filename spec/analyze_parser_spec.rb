# frozen_string_literal: true

require_relative '../analyze_parser'
require 'spec_helper'

describe LogAnalyze do
  let(:data) do
    "/help 10.10.10.10\n/about 11.11.11.11\n/contact 12.12.12.12
    /help 10.10.10.10\n/about 11.11.11.12\n/contact 12.12.12.13
    /help 10.10.10.10\n/about 11.11.11.11\n/contact 12.12.12.14
    /contact 12.13.14.15\n/help 10.10.10.10\n/help 10.10.10.10"
  end
  let(:subject) { LogAnalyze.new('test.log') }

  before(:each) do
    allow(File).to receive(:read).and_return(data)
  end

  context :setup do
    it 'injects a log file' do
      expect(subject.file_log).to_not be_nil
    end

    it 'extracts log stats' do
      expect(subject.log_stats).to_not be_nil
    end
  end

  context :results do
    it 'stores results in log_stats' do
      expect(subject.log_stats).to have_key('/help')
    end

    it 'stores all paths as log_stats keys' do
      expect(subject.log_stats.keys.count).to be(3)
    end
  end

  context :page_views do
    it 'shows most page views sorted by count' do
      expect(subject.page_views.map(&:first)).to eq ['/help', '/contact', '/about']
      expect(subject.page_views.map(&:last)).to eq [5, 4, 3]
    end

    it 'shows most unique views sorted by count' do
      expect(subject.unique_page_views.map(&:first)).to eq ['/contact', '/about', '/help']
      expect(subject.unique_page_views.map(&:last)).to eq [4, 2, 1]
    end
  end
end
