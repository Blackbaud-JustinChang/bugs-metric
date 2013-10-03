require 'xmlrpc/client'
require 'cgi'
require 'open-uri'

module BugzillaHelper

  module_function
  def bug_info(bug_ids)
    bugzilla = XMLRPC::Client.new_from_hash(:host => "bugzilla.corp.convio.com", :path => "/xmlrpc.cgi", :timeout => 10000)
    bugzilla.call("Bug.search", {:id => bug_ids})["bugs"]
  end

  def bug_id_by_url(url)
    return [] unless url
    bugs = []
    begin
      source = open(unescape_character(URI.escape(url))){ |f| f.read }
      source.scan(/a name=\"b(\d+?)\"/) { |m| bugs << $1 } #Capture all the bugs # through regular expression
      #return -1 if source.to_s =~ /Bugzilla_login/ && bugs.length == 0
    end
    bugs
  end

  def unescape_character(str)
    str_new = str
    str_new.scan(/%25(..)/){|x| str_new = str_new.to_s.gsub("%25#{$1}", "%#{$1}")}
    str_new
  end

end