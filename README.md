# Technical Analysis for Elixir [![Build Status](https://travis-ci.org/wuhkuh/talib.svg?branch=master)](https://travis-ci.org/wuhkuh/talib)

Talib provides easy access to indicators, oscillators and several utility
functions.

It's currently a work in progress; updates will be pushed on a regular basis.

## Features

- Utility
  - Change
  - Gain
  - High
  - Loss
  - Low
  - Occur

- Average
  - Mean
  - Median
  - Midrange
  - Mode

- Moving Average
  - Cumulative
  - Exponential
  - Simple

## Why?

As I was scanning the supported functions of the widely-used library 'TA-Lib',
I was missing some things I wanted to use, such as elasticity for comparison of
markets and indicators like the McClellan oscillator. Besides that, the project
seems abandoned as there have been no releases since 2007.

The goal of this library is to have most indicators built-in, where missing
indicators can be suggested through the issue tracker and pull requests.

If there's enough demand as well as developer time, the functions will be ported
to a language that will process them faster than Elixir currently can.

## Changelog

This repository uses [GitHub releases](https://github.com/wuhkuh/talib/releases)
to manage changes in the codebase.

## Contributing

To ensure correct functioning of this library, you could help out in several
ways.

1. Auditing  
   Verifying the inputs and outputs of a given function and the corresponding
   unit tests.

2. Refactoring  
   Updating the functions to a more readable state, or a state with better
   performance.

3. Suggesting  
   Suggesting missing indicators or functions.  
   If you're willing to do this, please send a draft with expected inputs and
   outputs of the function.

For more information, view [CONTRIBUTING.md](CONTRIBUTING.md). Thanks!

## Contributors

|   Role    |     Name     |              Referral               |
| --------- | ------------ | :---------------------------------: |
| Developer | Wouter Klijn | [GitHub](https://github.com/wuhkuh) |

Your name could be here!
