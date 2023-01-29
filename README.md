# glmmLasso-bmb

A hacked version of the glmmLasso package, in response to [this SO question](https://stackoverflow.com/questions/75252583/can-glmmlasso-be-used-with-the-tweedie-distribution?noredirect=1#comment132835132_75252583).

I added the Tweedie distribution and generalized a little bit of the code. 
With a little more work it might be possible to extend it to generalize to arbitrary user-specified families
(the original only handled Gaussian/binomial/Poisson, plus "acat" for adjacent-category and "cumulative" for cumulative-link models),
provided a `d*` function is available to compute the log-likelihood.
