class Alpha3CountryCodesToAlpha2 < ActiveRecord::Migration[8.1]
  def up
    Hackathon.where("LENGTH(country_code) = 3").find_each do
      it.update! country_code: ISO3166::Country.from_alpha3_to_alpha2(it.country_code)
    end

    Hackathon::Subscription.where("LENGTH(country_code) = 3").find_each do
      it.update! country_code: ISO3166::Country.from_alpha3_to_alpha2(it.country_code)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
