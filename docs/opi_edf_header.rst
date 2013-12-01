=================
 opi edf header
=================

could paste it on pastebin.com so here is a quick fix. 

::


    header
    header =

      scalar structure containing the fields:

	ver = 0
	patientID = X X X X                                                                         
	recordID = Startdate 22-OCT-2012 X X UTC+02:00_OPITS190                                    
	startdate = 22.10.12
	starttime = 14.48.16
	bytes =  2048
	records =  129
	duration =  8
	ns =  7
	label = 
	{
	  [1,1] = ADC
	  [1,2] = AccelXaxis
	  [1,3] = AccelYaxis
	  [1,4] = AccelZaxis
	  [1,5] = Temperature
	  [1,6] = Activity
	  [1,7] = EDFAnnotations
	}
	transducer = 
	{
	  [1,1] =                                                                                 
	  [1,2] =                                                                                 
	  [1,3] =                                                                                 
	  [1,4] =                                                                                 
	  [1,5] =                                                                                 
	  [1,6] =                                                                                 
	  [1,7] =                                                                                 
	}
	units = 
	{
	  [1,1] = uV
	  [1,2] = g
	  [1,3] = g
	  [1,4] = g
	  [1,5] = degreeC
	  [1,6] = dB
	  [1,7] = 
	}
	physicalMin =

	  -800    -2    -2    -2   -47   -50    -1

	physicalMax =

	   800     2     2     2   241    50     1

	digitalMin =

	  -20480  -32768  -32768  -32768       0  -32768  -32768

	digitalMax =

	   20480   32767   32767   32767    4080   32767   32767

	prefilter = 
	{
	  [1,1] =                                                                                 
	  [1,2] =                                                                                 
	  [1,3] =                                                                                 
	  [1,4] =                                                                                 
	  [1,5] =                                                                                 
	  [1,6] =                                                                                 
	  [1,7] =                                                                                 
	}
	samples =

	   4096     64     64    256     64     64     30
