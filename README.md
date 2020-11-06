# msi_reviewer
Shiny app for rapid review of single ion images

<img width="964" alt="Screenshot" src="https://github.com/NICE-MSI/simple_image_reviewer/blob/main/msi_reviewer.png?raw=true">


## Setup
This is a Shiny web application.   
You'll need to have the `tidyverse` and `shiny` packages installed.  
You can run the application by clicking the 'Run App' button when you have app.R open in RStudio.  
To run accross the local network navigate to the simple_image_reviewer folder and run `shiny::runApp(port = 1234, host = "0.0.0.0")`.  

This can then be accessed at `http://computer_name:1234` or `http://computer_ip_address:1234`


## Inputs
A folder fontaining `.png` or `.jpg` files that you wish to rate The host of the shiny app must have read and write permissions to this folder.

## Use
- Run the app
- Paste the full folder path into the folder text box
- Wait for the first image to load
- Rate the image as "good", "unsure" or "bad
- Wait for the next image to load
- Repeat until you run our of images
- Press save
- Navigate to the folder path in your explorer - the csv file will contain ranking results with a unique ID.
