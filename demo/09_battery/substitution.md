# Substituions Battery

## Most basic example

Given an .opts file:

    yard
      --title $title

When we run `title=Title yard`, we should get the arguments:

    --title
    Title

## Environment profile substitutions

Given an .opts file:

    [a=$b]
    yard
      --title "New Title"

When we run `a=1 b=1 yard`, we should get the arguments:

    --title
    New Title
