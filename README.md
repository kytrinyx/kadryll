# Kadryll

Drill notation generator for drums, with particular relevance to independence drills.

## Input

The drill generator takes a block of text on 5 lines.

The first line consists of the exercise name and the time signature, and the four subsequent lines define the drill for the right hand, left hand, right foot, and left foot respectively. E.g.

    ex1 4/4
    tt4 r4 tt4 r4
    r4 tt4 r4 tt4
    r1
    r1

This will create a lilypond file named `ex1.ly`, and a score called `ex1.png`.

## Configuration

You can configure the location of the input directory (where the `*.ly` files go -- default is `drills/data/`) and the output directory (where the `*.png` files go - default is `drills/scores/`).


    Kadryll.configure do |c|
      c.output_dir = 'my/images/'
      c.input_dir = 'my/lilypond/files/'
    end

In addition, you should set the copyright text which will be listed at the bottom of the score.

    Kadryll.configure do |c|
      c.copyright = 'Copyright 2012 - Chet'
    end
