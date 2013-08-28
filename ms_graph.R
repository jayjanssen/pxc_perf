library( ggplot2 )

all_res = read.csv( "all_res.data" )
qplot( time, tps, color=run, data=all_res, xaxs="i" )
qplot( time, resp_time, color=run, data=all_res, ylim = c(0,500) )