# Examples with Just Profiles

## Basic example with multiple profiles

Given an .option file:

    yard
      --title "Cool Title"

    [something]
    yard
      --title "Big Title"

When we run `yard`, we should get the arguments:

    --title
    Cool Title

## Example with single profile

Given an .option file with a leading profile:

    [example]
    yard
      --title "Funny Title"

When we run `p=example yard`, we should get the arguments:

    --title
    Funny Title

## Example with later matching profile

Given an .option file with a number of profiles:

    [something]
    yard
      --title "Little Title"

    [example]
    yard
      --title "Orange Title"

When we run `p=example yard` we should get the arguments:

    --title
    Orange Title

## Example with multiple matching profiles

Given an .option file with a number of profiles:

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

