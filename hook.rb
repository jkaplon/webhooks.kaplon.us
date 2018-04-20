require 'sinatra'
require 'json'

git_user = "jkaplon"
tmp_dir = "/tmp/webhooks/"
web_dir = "/var/www/"
output = ""

puts "Process ID: #{Process.pid}"

get '/' do
    'OK'
end

post '/alytfeed' do
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
