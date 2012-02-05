require 'bulker/buffer'
require 'bulker/pager'
require 'bulker/criteria'

# *bulker* provides Bulker::Pager and Bulker::Buffer.  
#
# Bulker::Pager gives you paging functionality to split large number of data to devided segments.
# When 1000,000 records in your database, and you're going to do some process for each record,
# Bulker::Pager will help you.
# It can handle large data very easily such like array with Bulker::Pager#each method.
#
# Bulker::Buffer provides simple buffer that enables implimenting bulk insert or bulk upload behavior.
module Bulker
end