======================
 Alpha BCI experiment
======================

Introduction to the experiment
==============================


<TODO - make it short>


Ordering
--------


+------------+--------------------+--------------------+--------------------+
|Participant |Headset 1           |Headset 2           |Headset 3           |
+============+====================+====================+====================+
|1           |EPOC (o/c)          |MindWave (c/o)      |TrueSense Kit (o/c) |
|            |                    |                    |                    |
+------------+--------------------+--------------------+--------------------+
|2           |MindWave (c/o)      |TrueSense Kit (o/c) |EPOC (c/o)          |
|            |                    |                    |                    |
+------------+--------------------+--------------------+--------------------+
|3           |TrueSense Kit (o/c) |EPOC (c/o)          |MindWave (o/c)      |
|            |                    |                    |                    |
+------------+--------------------+--------------------+--------------------+
|4           |TrueSense Kit (c/o) |MindWave (o/c)      |EPOC (c/o)          |
|            |                    |                    |                    |
+------------+--------------------+--------------------+--------------------+
|5           |EPOC (o/c)          |TrueSense Kit (c/o) |MindWave (o/c)      |
|            |                    |                    |                    |
+------------+--------------------+--------------------+--------------------+
|6           |MindWave (c/o)      |EPOC (o/c)          |TrueSense Kit (c/o) |
|            |                    |                    |                    |
+------------+--------------------+--------------------+--------------------+



Run analysis
============

Prerequests
-----------

Install Octave 3.6.4 and up: http://www.gnu.org/software/octave/download.html


Load and run
------------

::

    $ cd 
    # load signal processing package of Octave 
    octave> libs_install_and_load
    ...
      class opts;
      ^~~~~
      struct
    1 warning generated.

Just ignore the warning for now we have loaded the signal package successfully
and are ready to run the analysis - do:

::

    octave> run_analysis
    number_of_files =  24
    mindwave/1-20130814-pelle-2-open.mat
    OPEN EYES FIRST
    Discarded bins:0
    Discarded bins:0
    alpha_peak_start_sample =  19
    alpha_peak_end_sample =  23
    ...
    ...

Coffee break while the whole data of the experiment gets processed and
analyzed - at the end we get the result:

:: 

    ============ result start ================

    Measure  EPOC  MindWave  TrueSense Kit (OPI)

    Absolute alpha  4.50 ±3.12  2.37 ±1.54  0.87 ±0.40

    Relative alpha  2.12 ±0.63  1.55 ±0.60  1.06 ±0.21

    ============ result end ================


Credits
=======


Martin Poulsen and Pelle Krøgholt
