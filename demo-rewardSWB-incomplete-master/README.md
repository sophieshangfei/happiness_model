# demo-rewardSWB-incomplete
Robb Rutledge, October 2018

For papers, these are the most relevant (http://www.robbrutledge.com/papers/):
- Rutledge et al (2016) Curr Biol
- Rutledge et al (2015) J Neurosci
- Rutledge et al (2014) PNAS

This is the code for a task similar to that used in the 2014 paper in addition to code to fit simple decision and happiness models.

1) Download Cogent 2000, which is a Matlab toolbox developed at UCL for running the experiment on a PC. There is a PDF manual and some instructions on how to download here: http://www.vislab.ucl.ac.uk/cogent_2000.php

2) All files should be placed in the directory you will run the functions from. Cogent needs to be in your Matlab path. The commented out first line of code in rewardSWB could add the appropriate Cogent folder to the path.

3) It should take around half and hour to run through brief instructions and practice and then the 150-trial experiment. The MRI experiment in the 2014 paper was a lot slower (longer delay between choice and outcome and much longer ITIs). Go to the directory with those functions and type in something like:

        rewardSWB('test001');

4) Once the data is collected, you need to have the optimization toolbox in Matlab to do model fits. My two main models provide a useful starting point for the sorts of models we can use to understand decision making and mood. The code is incomplete so see what you can do to fix it!

5) First, run the script analyze_rewardSWB.m which will load an example subject. This will give a prospect theory fit used in the 2015 and 2016 papers. The example subject is not that interesting - not very loss or risk averse - but the model does fit well. It will also give you a very simple happiness model fit which has just a reward parameter, a time constant, and a constant term. It accounts for much of the variance in happiness in the example subject, but in general will not do as well as the full happiness model in the 2014 paper.

6) Sample data in ldopadata_anon.mat is included from the 2015 L-DOPA study. Run the code on those data sets and see what you get. See if you can generate something like figures 3b and 6c from that paper using your own code. 

7) Modify the happiness model code to implement the full happiness model in the 2014 paper. It should be preferred by Bayesian model comparison to a reward-only model.

8) You can do prospect theory fits on those subjects. Try to write the additional code to extend the prospect theory model to the approach-avoidance model in the 2015 and 2016 papers. Actually getting the approach-avoidance model to work as in the paper is a little tricky because it uses a shared noise parameter across both sessions. However, you should be able to get something similar with separate fits for all subjects and a significant increase in Pavlovian parameters on l-dopa.
