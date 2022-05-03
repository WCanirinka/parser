# frozen_string_literal: true

# !/usr/bin/ruby

require './analyze_parser'
# Class log parser
class LogParser
  attr_accessor :parser

  def initialize(filepath)
    self.parser = LogAnalyze.new(filepath)
  end

  def most_page_views
    page_views = parser.page_views
    page_views.map { |path, ip_count| "#{path} - #{ip_count} visits" }.join("\n")
  end

  def most_unique_page_views
    unique_views = parser.unique_page_views
    unique_views.map { |path, uniq_ips| "#{path} - #{uniq_ips} unique views" }.join("\n")
  end

  def summary
    ['Most Views:', most_page_views, 'Most unique Views:', most_unique_page_views].join("\n")
  end

  def print_summary
    puts summary
  end
end

if ARGV.first
  begin
    lp = LogParser.new ARGV.first
    lp.print_summary
  rescue StandardError => e
    puts e.message
  end
else
  puts 'Usage: ./parser.rb webserver.log'
end
