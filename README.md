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

## Author

Submitted by Sean O'Loughlin for the Zipline Technical Assessment.