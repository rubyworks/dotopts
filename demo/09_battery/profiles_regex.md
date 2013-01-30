# Environment Profile Battery

## Basic profile regex

Given an .option file:

    [~"q(x)?"]
    yard
      --title "Sexy Title"

When we run `p=q yard`, we should get the arguments:

    --title
    Sexy Title

And when we run `p=qx yard`, we should get the arguments:

    --title
    Sexy Title

## Basic environment profile regex

Given an .option file:

    [a=~"x|y"]
    yard
      --title "Reggie Title"

When we run `a=x yard`, we should get the arguments:

    --title
    Reggie Title

And when we run `a=y yard`, we should get the arguments:

    --title
    Reggie Title

## Complex profile

Given an .option file:

    [~"q(x)?" a=~"x|y"]
    yard
      --title "Complex Title"

When we run `p=q a=x yard`, we should get the arguments:

    --title
    Complex Title

When we run `p=q a=x yard`, we should get the arguments:

    --title
    Complex Title

When we run `p=qx a=x yard`, we should get the arguments:

    --title
    Complex Title

When we run `p=q a=y yard`, we should get the arguments:

    --title
    Complex Title

When we run `p=qx a=y yard`, we should get the arguments:

    --title
    Complex Title

