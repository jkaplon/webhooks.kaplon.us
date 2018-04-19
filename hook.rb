require 'sinatra'
require 'json'

git_user = "jkaplon"
tmp_dir = "/tmp/webhooks/"
web_dir = "/var/www/"
output = ""

puts "Process ID: #{Process.pid}"

get '/particle062015' do
    'OK'
end

post '/particle062015' do
    payload = JSON.parse(params[:payload])
    post_event = payload["postEvent"]
    source = payload["source"]
    output += "\nReceived from Sparticle, postEvent = #{post_event}, source = #{source}"
    puts output
end

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

post '/8c18e7e321e683854951a696318a55a4/jodyblog' do
    payload = JSON.parse(params[:payload])
    site_name = "blog.kaplon.us"

    # Payload["name"] is name given to doc at time of publication from draftin.com.
    Dir.chdir("#{tmp_dir}#{site_name}/_posts/")
    file_name = payload["name"]
    file_content_front_matter_plus_md = "---\ntitle: " + payload["name"] + "\ncreated_at: " + payload["created_at"] + "\nupdated_at: " + payload["updated_at"] + "\n---\n" + payload["content"]
    File.write("#{file_name}.md", file_content_front_matter_plus_md) 

    # Need to get rest of jekyll dir's setup...not sure if better to do under /tmp/webhooks/blog.kaplon.us/
    # or maybe cp newly published posts from /tmp/webhooks/blog.kaplon.us/_posts/ to more permaent jekyll location.

    if File.exists?("#{tmp_dir}#{site_name}/Gemfile")
        output += "\n\nBundling Gems\n"
        output += `pushd #{tmp_dir}#{site_name}; bundle; popd;`
    end

    build_cmd = "jekyll build --source #{tmp_dir}#{site_name} --destination #{web_dir}#{site_name}/public_html"

    output += "\n\nBuilding from source using Jekyll\n\n"
    output += `#{build_cmd}`

    puts output
    output
end
