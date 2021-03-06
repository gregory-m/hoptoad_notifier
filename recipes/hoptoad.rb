# When Hoptoad is installed as a plugin this is loaded automatically.
#
# When Hoptoad installed as a gem, you need to add 
#  require 'hoptoad_notifier/recipes/hoptoad'
# to your deploy.rb
#
# Defines deploy:notify_hoptoad which will send information about the deploy to Hoptoad.
# Use "set :hoptoad_notification, false" in your config, to not notify Hoptoad (usful for staging envs).
#
_cset :hoptoad_notification, true

after "deploy",            "deploy:notify_hoptoad"
after "deploy:migrations", "deploy:notify_hoptoad"

namespace :deploy do
  desc "Notify Hoptoad of the deployment"
  task :notify_hoptoad do
    if hoptoad_notification
      rails_env = fetch(:rails_env, "production")
      local_user = ENV['USER'] || ENV['USERNAME']
      notify_command = "rake hoptoad:deploy TO=#{rails_env} REVISION=#{current_revision} REPO=#{repository} USER=#{local_user}"
      puts "Notifying Hoptoad of Deploy (#{notify_command})"
      `#{notify_command}`
      puts "Hoptoad Notification Complete."
    else
      puts "Not notifying Hoptoad"
    end
  end
end
