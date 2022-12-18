# SeeClickFix Analysis Syracuse NY
 Analysis of SeeClick Fix Dataset from City of Syracuse Open Data Portal

## DATASET METADATA

### SeeClickFix Dataset

 - https://data.syr.gov/datasets/a6600662aa164d968a695b983aa2a7ea_0/explore?location=43.034364%2C-76.140132%2C13.29&showTable=true

- https://data.syr.gov/datasets/a6600662aa164d968a695b983aa2a7ea_0/about

### Syracuse Quadrants Dataset
- https://data-syr.opendata.arcgis.com/datasets/0039ea50ceb649f099b17c52e1ff6fa8_0/explore?location=43.035384%2C-76.139400%2C12.79

- https://data-syr.opendata.arcgis.com/datasets/0039ea50ceb649f099b17c52e1ff6fa8_0/about

## About This Analysis

 This examines the SeeClickFix data available from the City of Syracuse Open Data Portal. Dataset covers the time period from June 2021-August 2022. The analysis examines the municipal needs of Syracuse residents by time and city region, as well as examining the efficency of the city's response to these needs.

 The R code file imports the SeeClickFix data as a .CSV and cleans it as follows:

- Recoded Variables:
    - Export_tagged_places -> Quadrants
    - Category -> Category
    - Created_at_local -> Created_at_local
    - Acknowledged_at_local -> Acknowledged_at_local
    - Closed_at_local -> Closed_at_local

- Dropped Variables
    - X
    - Y
    - F20
    - OBJECTID

- Created Variables
    - hours_to_closed
    - days_to_closed
    - mean_days_to_closed
    - Date_created
    - month_created
    - year_created

The R code file uses the following packages: 

- sf
- tidyverse
- lubridate
- ggalluvial

## Limitations of Analysis and Suggestions for Future Analysis

Limitations on joining of shapefiles with dataset precluded development of a map to visualize the distribution of requests and average time to respond by neighborhood. 

Future analysis could include:
- Developing a neighborhood-level analysis using available address data in conjunction with Census TIGERLINE shapefiles/available neighborhood shapefiles from Syracuse Open Data Portal
- Examining time to close by other statistical measures
- Examining other timing measures
- Examining distributions and timing by agency and request type to remove influence of major outliers

## About The Author
Mary Rachel Keville is a Research & Evaluation Analyst at Syracuse University and a graduate of the Maxwell School at Syracuse University.