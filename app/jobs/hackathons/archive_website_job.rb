class Hackathons::ArchiveWebsiteJob < ApplicationJob
  def perform(hackathon)
    return if hackathon.website_down?

    # Web Archive will only save status 200 pages by default
    capture_job = InternetArchive.instance.capture hackathon.website

    if capture_job["status"] == "error"
      Rails.logger.debug "Internet Archive: error capturing #{hackathon.website}"
      Rails.logger.debug "Internet Archive: #{capture_job["message"]}"
      return
    end

    @job_id = capture_job["job_id"]
    Rails.logger.debug "Internet Archive: job id #{@job_id}"

    wait_until_finished
    status = get_status

    Rails.logger.debug "Internet Archive Job Status: #{status}"
    hackathon.send(:record, :archived_website) if status == "success"
  end

  private

  def wait_until_finished
    # Timeout after 3 minutes
    Timeout.timeout(60 * 3) do
      sleep 5 until finished?
    end
  rescue Timeout::Error
    Rails.logger.info "Archive Website Job timed out waiting for Internet Archive to finish capture"
  end

  def finished?
    get_status != "pending"
  end

  def get_status
    response = InternetArchive.instance.status(@job_id)
    response["status"]
  end
end
