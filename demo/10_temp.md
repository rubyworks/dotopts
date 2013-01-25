# Temporary Battery

## Example with multiple matching profiles

Given an .opts file with a number of profiles:

    [example]
    yard
      --title "First Title"

    [something]
    yard
      --title "Little Title"

    [example]
    yard
      --output-dir "doc"

When we run `p=example yard` we should get the arguments:

    --title
    First Title
    --output-dir
    doc

