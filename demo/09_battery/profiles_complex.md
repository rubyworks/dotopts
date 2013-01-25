# Environment Profile Battery

## Basic environment profile

Given an .opts file:

    [a=1]
    yard
      --title "Sexy Title"

When we run `a=1 yard`, we should get the arguments:

    --title
    Sexy Title

## Multi-matching profile

Given an .opts file:

    [a=1 b=2]
    yard
      --title "Soapy Title"

When we run `a=1 b=2 yard`, we should get the arguments:

    --title
    Soapy Title

## Multiple multi-matching profiles

Given an .opts file:

    [a=1 b=1]
    yard
      --title "Untimely Title"

    [a=1 b=3]
    yard
      --title "Timely Title"

When we run `a=1 b=3 yard`, we should get the arguments:

    --title
    Timely Title

## Multiple matching multi-matching profiles

Given an .opts file:

    [a=1 b=1]
    yard
      --title "Rocking Title"

    [a=1 b=3]
    yard
      --title "Hat Title"

    [a=1]
    yard
      --output-dir "doc"

When we run `a=1 b=1 yard`, we should get the arguments:

    --title
    Rocking Title
    --output-dir 
    doc

