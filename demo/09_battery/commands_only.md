# Example Battery

## Most basic example

Given a `.option` file:

    yard
      --title "Big Title"

When we run `yard`, we should get the arguments:

    --title
    Big Title

## Example with later matching commande

Given a `.option` file with a number of profiles:

    something
      --title "Little Title"

    yard
      --title "Orange Title"

When we run `yard` we should get the arguments:

    --title
    Orange Title

## Example with multiple matching commands

Given a `.option` file with a number of commands:

    yard
      --title "First Title"

    something
      --title "Little Title"

    yard
      --output-dir "doc"

When we run `yard` we should get the arguments:

    --title
    First Title
    --output-dir
    doc

