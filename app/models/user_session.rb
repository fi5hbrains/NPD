class UserSession < Authlogic::Session::Base
  consecutive_failed_logins_limit 5
  failed_login_ban_for 5.minutes
end
