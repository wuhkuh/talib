# Talib Documentation

At this point in time, Talib is undergoing some major changes.  
Functions will be written in C and ported to Elixir using a NIF.

This change of direction will happen in 4 phases:

|    Phase     | Status  |
| ------------ | :-----: |
| Planning     | Ongoing |
| Research     | Planned |
| Description  | Planned |
| Development  | Planned |


### 1. Planning phase

A list of indicators will be collected and designated to a version of Talib.

This is based on indicator popularity - for example: RSI and MACD will be  
released early, while the DeMark indicator will be planned for a later phase.

For the proposed planning, view [PLANNING.md](PLANNING.md).

### 2. Research phase

Studies will be read to extract the appropriate formulas. Every indicator will  
be based on the **original** research. Different implementations of the same  
indicator will be named accordingly.

For example: RSI will be based on an SMMA (which is from the original study),  
while the RSI based on EMA will be called RSI_EMA.

Mathematical formulas will be collected for each indicator, as well as unit  
tests that will be based on (primarily) data from these studies. Edge cases  
will be documented as well.

For example: when the prices rise constantly, RSI will attempt to divide by   
zero, which would normally throw an error.

This is compressed into the same phase, because it does not require deep  
understanding of the involved formulas. It is actually better not to know how  
the formulas work - this could taint the unit tests.

### 3. Description phase

This phase does require mathematical skills. The formulas from phase 2 will be  
converted to pseudo-code, so it is clear for developers with limited math  
understanding how the code should work.

### 4. Development phase

This is when the code (finally) gets written. This is based on the pseudo-code  
written in phase 3.

CI plays a major role in this phase, as it should determine whether the code  
is correct or not.

These two factors enable developers without extensive math (or developing)  
knowledge to collaborate without having to worry about making mistakes.
