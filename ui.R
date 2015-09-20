library(shiny);library(ggplot2)


# Define UI for dataset viewer application
shinyUI(fluidPage(
    
    titlePanel("Plot selector"),
    
    sidebarLayout(
        
        sidebarPanel(
            selectInput("plot_type", "Select a plot type", c("Line chart", "Histogram")), #Next:Panel for Line Charts
            conditionalPanel(
                condition = "input.plot_type == 'Line chart'",
                radioButtons("radio_line_simple", "Simple or function based lined?", choices = list("Simple" = 1, "Function based" = 2), selected = 1), #Next: Subpanel LineCharts for Simple
                conditionalPanel(
                    condition = "input.radio_line_simple == 1",
                    numericInput("line_simple_slope", "Slope of the line", 0, step=0.5),
                    numericInput("line_simple_intercept", "Intercept on the Y-axis", 0, step=0.5),
                    sliderInput("line_minX_maxX", label = "Set min and max values on the X-Axis", min = -100, max = 100, value = c(-10, 10))
                ), #Next: Subpanel LineCharts for Function based
                conditionalPanel(
                    condition = "input.radio_line_simple == 2",
                    radioButtons("radio_line_function", "Which function?", choices = list("Random exponentials" = 1, "Gaussian" = 2, "Sigmoid (logistic)"=3), selected = 1),#Next: Subpanel LineCharts, Function based for exponential
                    conditionalPanel(
                        condition = "input.radio_line_function == 1",
                        sliderInput("line_exp_no", label="How many random exponentials?", min=2, max = 1000, value=100),
                        sliderInput("line_exp_lambda", label="Which lambda?", min=0.01, max = 100, value=2)), #Next: Subpanel LineCharts, Function based for gaussian
                    conditionalPanel(
                        condition = "input.radio_line_function == 2",
                        sliderInput("line_gaus_no", label="Which intervall for the gaussians?", min=-1000, max = 1000, value=c(-100,100)),
                        sliderInput("line_gaus_mu", label="Which mean?", min=-100, max = 100, value=0),
                        sliderInput("line_gaus_sigma", label="Which sigma?", min=0.1, max = 20, value=1)), #Next: Subpanel LineCharts, Function based for sigmoid
                        
                    conditionalPanel(
                        condition = "input.radio_line_function == 3",
                        sliderInput("line_sig_no", label="Which intervall for the sigmoids?", min=-10, max = 10, value=c(-5,5)),
                        selectInput("line_sig_inc", "Increment x by?", c(0.25,0.5,1,1.5,2))
                        )
                    )
            ),
            
            #Conditional Panel for histograms
            conditionalPanel(
                condition = "input.plot_type == 'Histogram'",
                radioButtons("radio_hist_function", "Which function?", choices = list("Random exponentials" = 1, "Random gaussians" = 2), selected = 1),
                #Next: Subpanel Histogram, Function based for exponential
                    conditionalPanel(
                        condition = "input.radio_hist_function == 1",
                        sliderInput("hist_exp_no", label="How many random exponentials?", min=2, max = 1000, value=100),
                        sliderInput("hist_exp_lambda", label="Which lambda?", min=0.01, max = 100, value=2)),
                #Next: Subpanel Histogram, Function based for gaussian
                    conditionalPanel(
                        condition = "input.radio_hist_function == 2",
                        sliderInput("hist_gaus_no", label="Which intervall for the gaussians?", min=1, max = 1000, value=100),
                        sliderInput("hist_gaus_mu", label="Which mean?", min=-100, max = 100, value=0),
                        sliderInput("hist_gaus_sigma", label="Which sigma?", min=0.1, max = 20, value=1))
                ),
        tags$small(paste0(
            "Explanation: This little application lets the user interactively explore",
            " line charts and histograms on the basis of data, which is created",
            " on the basis of the parameters he defines. Which parameters can be",
            " defined, depends on the selected chart type and other parameters.",
            " The plot resulting from the defined parameters is shown in the tab ",
            " 'Plot'. The actual data that was created with the parameters can be",
            " looked at in the tab 'Table'"
        ))
        ),
            #submitButton('Submit')
        mainPanel(
            tabsetPanel(
                tabPanel("Plot", plotOutput("Plot")),
                tabPanel("Table", dataTableOutput("Table"))
            )
        )
    )
))