namespace :hackathons do
  desc "Archive all hackathon websites"
  task archive_all_websites: :environment do
    # I recommend running this task using:
    # ```sh
    # rake to_stdout hackathons:archive_all_websites
    # ```
    # In order to see the output logs
    Hackathon.find_each do |hackathon|
      Hackathons::ArchiveWebsiteJob.perform_now(hackathon)
    end
  end
end
