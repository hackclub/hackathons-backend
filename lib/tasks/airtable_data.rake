namespace :airtable_data do
  desc "Migrates data from Airtable to the database"
  task :migrate, [:skip_hackathons, :skip_subscriptions] => [:environment] do |t, args|
    def migrate_hackathons
      airtable_swag_mailing_address_fields = [
        "Address Line 1",
        "Address Line 2",
        "Mailing address (City)",
        "Mailing Address (State)",
        "Mailing Address (Zip code)",
        "Mailing Address (Country)"
      ]

      puts "MIGRATING HACKATHONS"
      Airtable::Hackathon.all(sort: {created_at: :asc}).each do |record|
        if Hackathon.find_by(airtable_id: record.id)
          puts "Skipping #{record.name} (#{record.id})"
          next
        end

        ActiveRecord::Base.transaction do
          hackathon = Hackathon.new
          hackathon.airtable_id = record.id

          %w[name status starts_at ends_at website high_school_led
            expected_attendees modality apac].each do |field|
            value = record.send field
            hackathon.send "#{field}=", value
          end

          # Re-geocoding existing address
          hackathon.address = record.full_address

          # Attach logo and banner images
          hackathon.logo.attach(io: record.logo, filename: record.logo_filename) if record.logo
          hackathon.banner.attach(io: record.banner, filename: record.banner_filename) if record.banner

          hackathon.record(:imported_from_airtable, data: record.fields.except(airtable_swag_mailing_address_fields))

          # Financial assistance
          if record.offers_financial_assistance
            hackathon.tag_with("Offers Financial Assistance")
          end

          # Swag mailing address
          if record.swag_mailing_address
            hackathon.swag_mailing_address_attributes = {
              **record.swag_mailing_address,
              created_at: record.created_at
            }

            original_address = record.fields.slice(airtable_swag_mailing_address_fields)

            hackathon.swag_mailing_address.record(:imported_from_airtable, data: original_address)
          end

          # Applicant
          hackathon.applicant = User.find_or_initialize_by(email_address: record.applicant_email) do |applicant|
            applicant.created_at = record.created_at
            applicant.record(:imported_from_airtable)
          end

          # Save it!
          puts "Creating #{hackathon.name} (#{hackathon.airtable_id})"
          hackathon.created_at = record.created_at
          hackathon.save!

          # Correct :created Event's created_at
          [hackathon, hackathon.swag_mailing_address].compact.each do |object|
            object.events.find_by(action: :created).update!(created_at: hackathon.created_at)
          end

          # Flag geocoding errors
          if hackathon.in_person? && !hackathon.geocoded?
            hackathon.record(:airtable_migration_geocoding_error, data: {airtable_coordinates: record.coordinates})
          end
          if record.coordinates && hackathon.geocoded? && hackathon.distance_to(record.coordinates) > 100
            hackathon.record(:airtable_migration_geocoding_distance_error, data: {airtable_coordinates: record.coordinates})
          end
        end
      end
    end

    def migrate_subscriptions
      puts "MIGRATING SUBSCRIPTIONS"
      Airtable::Subscriber.all(sort: {created_at: :asc}).each do |record|
        if (subscription = Hackathon::Subscription.find_by(airtable_id: record.id))
          puts "Skipping #{record.id} (#{subscription.location})"
          next
        end

        ActiveRecord::Base.transaction do
          subscription = Hackathon::Subscription.new
          subscription.airtable_id = record.id

          # Re-geocoding existing address
          subscription.location_input = record.location

          subscription.status = record.status
          if subscription.inactive? && record.unsubscribed_at
            subscription.record(:disabled, created_at: record.unsubscribed_at)
          end

          subscription.record(:imported_from_airtable, data: record.fields)

          # Subscriber
          subscription.subscriber = User.find_or_initialize_by(email_address: record.email) do |subscriber|
            subscriber.created_at = record.created_at
            subscriber.record(:imported_from_airtable)
          end

          # Save it!
          subscription.created_at = record.created_at
          subscription.save!
          puts "Creating #{subscription.airtable_id} (#{subscription.location})"

          # Correct :created Event's created_at
          subscription.events.find_by(action: :created).update!(created_at: subscription.created_at)
        end
      rescue ActiveRecord::RecordInvalid => e
        puts "Skipping #{record.id} (#{record.location}) because of validation error: #{e.message}"
      end
    end

    if args[:skip_hackathons] == "true"
      puts "Skipping hackathons migration"
    else
      migrate_hackathons
    end

    if args[:skip_subscriptions] == "true"
      puts "Skipping subscriptions migration"
    else
      migrate_subscriptions
    end
  end
end
