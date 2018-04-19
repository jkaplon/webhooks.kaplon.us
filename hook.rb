require 'sinatra'
require 'json'

git_user = "jkaplon"
tmp_dir = "/tmp/webhooks/"
web_dir = "/var/www/"
output = ""

puts "Process ID: #{Process.pid}"

get '/8c18e7e321e683854951a696318a55a4' do
    'OK'
end

post '/8c18e7e321e683854951a696318a55a4/alytfeed' do
    payload = JSON.parse(params[:payload])
    site_name = payload["repository"]["name"]

    # Use https address to clone repo and NOT ssh-style URL (eg. NOT git@github.com:jkaplon/alytfeed).
    # ssh URL requires key exchange w/github...not something i want to setup on VPS.
    repo = "https://github.com/#{git_user}/#{site_name}.git"

    clone_cmd = "rm -rf #{tmp_dir}#{site_name}; git clone #{repo} #{tmp_dir}#{site_name};"
    output = `#{clone_cmd}`

    output += "\nCopying newly cloned alytfeed to final destination in /var/www/kaplon.us\n"
    output += `cp #{tmp_dir}#{site_name}/alytfeed.xml /var/www/kaplon.us/alytfeed.xml;`
    
    puts output
    output
    'OK'
end
