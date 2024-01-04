class Admin::Hackathons::Submissions::NotificationsController < Admin::BaseController
  def index
    Current.user.update! new_hackathon_submission_notifications: !Current.user.new_hackathon_submission_notifications
    action = Current.user.new_hackathon_submission_notifications ? "enabled" : "disabled"
    redirect_to admin_hackathons_path, notice: "Notifications #{action} for new submissions"
  end
end
