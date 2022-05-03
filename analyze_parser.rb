# frozen_string_literal: true

# !/usr/bin/ruby

# class log analyzer
class LogAnalyze
  attr_accessor :file_log, :log_stats

  def initialize(filepath)
    self.file_log = File.read(filepath)
    self.log_stats = {}
    log_process
  rescue ReadError => e
    puts e.message
  end

  def print_log
    puts file_log
  end

  def log_process
    file_log.each_line do |x|
      path, ip = x.split(' ')
      if log_stats.key? path
        self.log_stats[path] << ip
      else
        self.log_stats[path] = [ip]
      end
    end
  end

  def page_views
    page_views = log_stats.inject({}) { |hash, (path, ips)| hash.merge(path => ips.count) }
    page_views.sort_by { |_path, count| count }.reverse
  end

  def unique_page_views
    unique_page_views = log_stats.inject({}) { |hash, (path, ips)| hash.merge(path => ips.uniq.count) }
    unique_page_views.sort_by { |_path, count| count }.reverse
  end
end

class ReadError < StandardError
end
