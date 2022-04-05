#!/usr/bin/ruby

class LogAnalyze
  attr_accessor :file_log, :log_stats
  def initialize(filepath)
    begin
      self.file_log = File.read(filepath)
      self.log_stats = {}
      log_process
    rescue ReadError => e
      puts e.message
    end
  end

  def print_log
    puts file_log
  end

  def log_process
    file_log.each_line { |x|
      path, ip = x.split(" ")
      if log_stats.has_key? path
        self.log_stats[path] << ip
      else
        self.log_stats[path] = [ip]
      end
    }
  end

  def page_views
    page_views = log_stats.inject({}) { |hash, (path,ips)| hash.merge(path => ips.count) }
    page_views.sort_by {|path, count| count}.reverse
  end

  def unique_page_views
    unique_page_views = log_stats.inject({}) { |hash, (path,ips)| hash.merge(path => ips.uniq.count) }
    unique_page_views.sort_by { |path, count| count }.reverse
  end
end

class ReadError < StandardError
end