logLik.glmmLasso<-function(y, yhelp, mu, ranef.logLik=NULL, family, penal=FALSE, K = NULL, phi = 1) {
  fam <- family$family

  loglik <- switch(fam, 
                   poisson = dpois(y, lambda = mu, log = TRUE),
                   ## n.b. assumes binary!
                   binomial = dbinom(y, prob = mu, size = 1, log = TRUE),
                   gaussian = dnorm(y, mu, sd = sqrt(phi), log = TRUE),
                   acat = {
                       mu_cat <- matrix(mu, byrow = TRUE, ncol = K)
                       mu_cat <- cbind(mu_cat,1-rowSums(mu_cat))
                       ## yhelp <- matrix(y, byrow = TRUE, ncol = K)
                       ## yhelp <- cbind(yhelp,1-rowSums(yhelp))
                       sum(yhelp*log(mu_cat))
                   },
                   cumulative = {
                       mu_cat <- matrix(mu, byrow = TRUE, ncol = K)  
                       mu_help <- mu_cat
                       for (i in 2:K){
                           mu_cat[,i] <- mu_help[,i]-mu_help[,i-1]
                       }
                       mu_cat <- cbind(mu_cat,1-mu_help[,K])
                       sum(yhelp*log(mu_cat))
                   },
                   Tweedie = {
                       if (!requireNamespace("tweedie")) {
                           stop("please install the 'tweedie' package")
                       }
                       ## hack: recover power param from environment of
                       ##  variance function
                       tpow <- eval(expression(p),environment(family$variance))
                       ## would rather use log = TRUE
                       sum(log(tweedie::dtweedie(y, mu = mu, phi = phi, xi = tpow)))
                   },
                   ## default:
                   ## try harder? look for an appropriate 'd' function?
                   stop("unrecognized family")
                   ) ## end switch
  
  if(penal)
  loglik <- loglik + ranef.logLik 

  return(loglik)
}
