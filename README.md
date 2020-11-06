# msi_reviewer
Shiny app for rapid review of single ion images

Bellow is an idealised version of what could be the inputs, workflow, and outputs of this GUI, so it can be used for peak picking algorithm assertion
## Inputs
  + csv table containing for each peak
    - mean measured mz (over all peaks aligned)
    - standard deviation of measured mz (over all peaks aligned)
    - signal to noise ratio
    - any other peak quality metric
  + images (one per peak) representing the single ion image next to the representation of the neighbourhood of this peak in the spectral domain

## Workflow
  + An expert starts the GUI;
  + Indicates the address of a folder which as the same structure as the output from Teresa's pipeline
  + the program fetches the single ion images and the peaks informations table
  + the program picks a mz value "randomly", it can be a peak which was picked or rejected by the algorithm
  + the GUI presents the single ion image along with the neighbourhood of the peak in the spectral domain (and quality statistics?) to the user
  + the user is asked to qulify the peak/single ion image as good, bad, or unknown (and to justify if bad?)
  
## Outputs
After evaluation of the peaks by experts, a table is created containing
  + mz value
  + peak quality metrics
  + picked by the algorithm (Y/N)
  + picked by the users (percentage)
  + (percentage of each reason to reject ?)
A classification/regression analysis based on this table
