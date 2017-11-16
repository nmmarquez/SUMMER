#' Makes map plot
#' 
#' 
#' See package vignette for usage details.
#'
#' @param countryname Country name as a string
#' @param results output from \code{\link{fit_RW}}
#' @param geo geo output from \code{\link{read_shape}}
#' @param countrysum output from \code{\link{countrySummary_mult}}
#' @param inlamod output from \code{\link{fitINLA}}
#' 
#' 
#' @export
mapPlot <- function(countryname, results, geo, countrysum, inlamod) {
  out <- list(countryname = countryname, results.rw2 = results, geo = geo, 
              data.HT = countrysum, model.rw2 = inlamod)
  surveylabel <- paste0("DHS ", unique(countrysum$surveyYears))
  out$data.HT$survey.label <- surveylabel[out$data.HT$survey]
    years <- names(out$results.rw2)
    n.years <- length(years)
    n.area <- dim(out$geo)[1]
    areasCap <- out$geo@data$DHSREGEN
    if (is.null(areasCap)) {
        areasCap <- out$geo@data$NAME_final
    }
    areas.smooth <- rownames(out$results.rw2[[1]])

    
    plot.res <- expand.grid(District = areas.smooth, Year = years)
    plot.res$sd <- plot.res$mean <- plot.res$q90 <- plot.res$q10 <- plot.res$q975 <- plot.res$q025 <- plot.res$med <- NA
    
    
    for (i in 1:(n.years)) {
        plot.res$med[plot.res$Year == years[i]] <- apply(out$results.rw2[[i]], 1, function(x) {
            stats::median(expit(x))
        })
        plot.res$q025[plot.res$Year == years[i]] <- apply(out$results.rw2[[i]], 1, function(x) {
            stats::quantile(expit(x), 0.025)
        })
        plot.res$q975[plot.res$Year == years[i]] <- apply(out$results.rw2[[i]], 1, function(x) {
            stats::quantile(expit(x), 0.975)
        })
        plot.res$q10[plot.res$Year == years[i]] <- apply(out$results.rw2[[i]], 1, function(x) {
            stats::quantile(expit(x), 0.1)
        })
        plot.res$q90[plot.res$Year == years[i]] <- apply(out$results.rw2[[i]], 1, function(x) {
            stats::quantile(expit(x), 0.9)
        })
        plot.res$mean[plot.res$Year == years[i]] <- apply(out$results.rw2[[i]], 1, function(x) {
            mean(expit(x))
        })
        plot.res$sd[plot.res$Year == years[i]] <- apply(out$results.rw2[[i]], 1, function(x) {
            stats::sd(expit(x))
        })
    }
    
    
    plot.res$ratio <- plot.res$q975/plot.res$q025
    plot.res$unc_ratio <- plot.res$ratio > 3
    plot.res$unc_ratio0 <- plot.res$ratio >= 2 & plot.res$ratio < 2.25
    plot.res$unc_ratio1 <- plot.res$ratio >= 2.25 & plot.res$ratio < 2.5
    plot.res$unc_ratio2 <- plot.res$ratio >= 2.5
    
    med.palette <- RColorBrewer::brewer.pal(n = 9, name = "Purples")
    med.int <- classInt::classIntervals(round(plot.res$med, 3), n = 9, style = "jenks")
    med.col <- classInt::findColours(med.int, med.palette)
    plot.res$med.col <- med.col
    
    
    graphics::par(mfrow = c(2, 4), mai = c(0.25, 0.1, 0.3, 0.1), oma = c(0.5, 0.1, 0.1, 0.1))
    for (i in 1:(length(years) - 1)) {
        
        tmp <- plot.res[plot.res$Year == years[i], ]
        tmp.col <- rep(NA, n.area)
        for (j in 1:n.area) {
            tmp.col[j] <- tmp$med.col[tmp$District == areas.smooth[j]]
        }
        sp::plot(out$geo, col = tmp.col, border = FALSE, main = years[i])
        
    }
    
    graphics::plot(1, type = "n", axes = FALSE, xlab = "", ylab = "")
    graphics::legend(x = "center", inset = 0, legend = names(attr(med.col, "table")), fill = med.palette, cex = 1.25, horiz = FALSE, bty = "n")
}