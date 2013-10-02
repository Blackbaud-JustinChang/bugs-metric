require 'xmlrpc/client'
require 'cgi'
require 'open-uri'

module BugzillaHelper

  module_function
  def bug_info(bug_ids)
    bugzilla = XMLRPC::Client.new_from_hash(:host => "bugzilla.corp.convio.com", :path => "/xmlrpc.cgi", :timeout => 10000)
    bugzilla.call("Bug.search", {:id => bug_ids})["bugs"]
  end

end