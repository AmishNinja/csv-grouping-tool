# CSV Grouping Utility

This tool groups CSV rows based on email address, phone number, or both.

## Setup

```bash
bundle install
```

## Running

```bash
bin/group_csv -f sample_inputs/input1.csv -m email_or_phone
```

This will generate a new file called `prepended_input1.csv` in the `sample_inputs/` directory.

- Matching types (`-m` flag): `phone`, `email`, or `email_or_phone`.
- File path (`-f` flag): Path to input CSV file.

## Testing

```bash
bundle exec rspec
```

## Sample Inputs

The `sample_inputs/` directory contains the same example input files that were included in the [challenge repository](https://github.com/retailzipline/hiring-exercises/tree/main/grouping). They are unmodified from their original format, and are provided for convenience and demonstration of expected output. 

You can add other input CSVs for additional manual testing. Output files will follow the same pattern of having `prepended_` as the prefix.

## Design Notes

- **Unique Group Identifiers**: I used a `GROUP_X` format (`GROUP_1`, `GROUP_2`) for readability. If we wanted unique identifiers in a more global sense, I'd opt for `SecureRandom.uuid`.

- **Row Line Numbers**: I thought about adding line numbers to `Row` for logging purposes. It wasn't necessary, but could be useful for line-specific error handling and logging in a production environment.

- **ETL Structure**: This project follows an ETL (Extract + Transform + Load) structure, represented by `Importer`, `Grouper` and `Exporter`, for separation of concerns and ease of testing.

## Validation Notes

Output sanity check: the largest sample input file (input3.csv) contains exactly 20,000 records. After processing it with this tool, using matching_type of `email_or_phone`:

- 40 groups contained **4 records each**
- 9920 groups contained **2 records each**
- Total records grouped verified: **(40 * 4) + (9920 * 2) = 20000**

The distribution lines up perfectly, which confirms correct grouping at larger scale.

## Flexible Field Matching

At this time, the matching logic for email addresses and phone numbers is based on a very finite set of column names:

- `Email`, `Email1` and `Email2` for email addresses.
- `Phone`, `Phone1` and `Phone2` for phone numbers.

In a real world scenario, there could be a significantly larger set of column names from disparate data sources. This would require updating the code manually each time a new data source was onboarded with a unique key for one of those data types (`phone_1`, `phonePrimary`, `emailPrimary`, etc). There are a couple of potential improvements to account for this:

- Dynamically detect fields based on the presence of keywords like `phone` or `email` (case-insensitive matching) in headers.
- Utilizing a user-defined schema configuration for the fields; idea is that new users would supply you with a JSON or YAML file in a prescribed format that indicates which fields correlate to phone numbers and emails. That way, the codebase could be adjusted to make use of that configuration and ingest data from a wide variety of formats without having to manually update it each time a new one showed up.

Either approach could work well if new datasets were onboarded frequently.

## Extensibility Consideration

A tempting stretch goal would be to implement additional matching fields, such as Zip codes. This would introduce a combinatorial explosion (if bringing in `zip`, you'd also want to accommodate `zip_or_phone`, `zip_or_email_or_phone`, and `zip_or_email`), which would become progressively more unwieldy to hardcode. A flag based interface for the program would make the most sense in this case; so you'd have an indeterminant number of matching keys (`bin/group_csv -f input.csv -m email -m phone -m zip`), and the ETL process would combine them as needed behind the scenes. Happy to dive in and discuss this during a code review conversation if that would be helpful.

## Author

Submitted by Sean O'Loughlin for the Zipline Technical Assessment.