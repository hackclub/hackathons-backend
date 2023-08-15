# Airtable Data Migration

Here are my notes on the data migration.

- Imported records will have an `airtable_id` column
- `apac` field
  - `false`: not APAC (imported from Airtable)
  - `true`: APAC (imported from Airtable)
  - `nil`: this record was NOT imported from Airtable, and Country gem will
    decide whether it's APAC or not
- If a hackathon on Airtable has an empty email field, the default applicant
  is `hackathons+airtable_migration@hackclub.com`
- If a hackathon on Airtable was missing expected attendees, it defaulted to 1
- Modality (online, in-person, hybrid) were booleans on Airtable, meaning that
  it could be possible to have more than one modality. To determine the true
  modality, I used the following order of precedence: online (virtual), hybrid,
  in-person.
  This is the same order being used in the front-end.
- Same thing applies for status (approved, rejected, pending). Order: approved,
  rejected, pending
- There are quite a bit of bad data I discovered and fix on Airtable before
  running the migration
  - End dates before start dates
  - Invalid website URLs
  - Invalid email addresses
- If there is invalid data for Subscriptions (a location that can't be
  geocoded), then that Airtable record is skipped.
- The migration script is idempotent, meaning that you may run it multiple times
  and it will not create duplicates. It also won't update existing records.

Run it with

```shell
rake airtable_data:migrate

# or the following to skip hackathons (1st arg) or subscriptions (2nd arg)
rake "airtable_data:migrate[true, false]"
```

I'm estimate it'll take a little over an hour to run due to the rate limit on geocoding.
We have a total of 4,200 records that will need to be geocoded.

~ @garyhtou
