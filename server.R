library(ggplot2)
gaussian <- function(x,mu,sigma) {
    a<-1/(sigma*(2*pi)^0.5)
    y<- a* exp(-((x-mu)^2)/(2*sigma^2))
    return(y)
}

sigmoid <- function(x) {
    y<-(1 / (1 + exp(-x)))
    return(y)
}

plot <- function(input) {
    #Line charts
    if (input$plot_type=="Line chart") {
        if (input$radio_line_simple==1) {
            data<-data.frame(x=input$line_minX_maxX)
            data$y<-input$line_simple_intercept+input$line_simple_slope*data$x
            g<-ggplot(data=data, aes(x=x, y=y, group=1)) + geom_line() + coord_cartesian(xlim=c(-100, 100), ylim=c(-100, 100)) +theme(axis.title = element_text(face="bold", size=18), axis.text  = element_text(size=16))
        }
        else if (input$radio_line_simple==2) {
            if (input$radio_line_function==1) {
                data<-data.frame(y=rexp(input$line_exp_no,input$line_exp_lambda))
                data$x<-log(data$y)
                data<-data[order(data$x),]
                g<-ggplot(data=data, aes(x=x, y=y)) + geom_line(aes(group=1), colour="#000099") + geom_point(size=2, colour="#CC0000") + theme(axis.title = element_text(face="bold", size=18), axis.text  = element_text(size=16))
            }
            else if (input$radio_line_function==2) {
                data<-data.frame(x=input$line_gaus_no[1]:input$line_gaus_no[2])
                data$y <- gaussian(data$x, input$line_gaus_mu, input$line_gaus_sigma)
                g<-ggplot(data=data, aes(x=x, y=y)) + geom_line(aes(group=1), colour="#000099") + geom_point(size=2, colour="#CC0000") + theme(axis.title = element_text(face="bold", size=18), axis.text  = element_text(size=16))
            }
            else if (input$radio_line_function==3) {
                data<-data.frame(x=seq(input$line_sig_no[1],input$sig_no[2],as.numeric(input$line_sig_inc)))
                data$y <- sigmoid(data$x)
                g<-ggplot(data=data, aes(x=x, y=y)) + geom_line(aes(group=1), colour="#000099") + geom_point(size=2, colour="#CC0000")+ theme(axis.title = element_text(face="bold", size=18), axis.text  = element_text(size=16))
                
            }
        } 
    }
    #Histograms
    else if (input$plot_type=="Histogram") {
        if (input$radio_hist_function==1) {
            data<-data.frame(exponentials=rexp(input$hist_exp_no,input$hist_exp_lambda))
            g<-ggplot(data,aes(x=exponentials)) + geom_histogram(fill="red", alpha=0.3) + theme(axis.title = element_text(face="bold", size=18), axis.text  = element_text(size=16))
        }
        else if (input$radio_hist_function==2) {
            data<-data.frame(gaussians=rnorm(input$hist_gaus_no, input$hist_gaus_mu, input$hist_gaus_sigma))
            g<-ggplot(data,aes(x=gaussians)) + geom_histogram(fill="orange", alpha=0.3) + theme(axis.title = element_text(face="bold", size=18), axis.text  = element_text(size=16))
        }
    }
    browser
    return(list(g,data))
}

shinyServer(
    function(input, output) {
        output$Plot <- renderPlot(plot(input)[1])
        output$Table <- renderDataTable(data.frame(plot(input)[2]))
    }
)
