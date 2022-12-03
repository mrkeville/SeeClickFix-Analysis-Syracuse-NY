#PRECODE SCRIPTS----

rm(list=ls())
library(sf)
library(tidyverse)
library(lubridate)
library(ggalluvial)
setwd("H:/IST 719")
seeclickfix<-read_csv("SeeClickFix_Requests_(2021-Present)__SYRCityline.csv")
syr_quadrants<-read_sf("Syracuse_Quadrants/Syracuse_Quadrants.shp")

#Cleaning----

seeclickfix_clean <- seeclickfix %>% 
  select(!c(X,Y,F20,OBJECTID)) %>%
  group_by(Category, Agency_Name)%>%
  mutate(hours_to_closed=Minutes_to_closed/60,hours_to_closed=round(hours_to_closed,2))%>%
  mutate(days_to_closed=Minutes_to_closed/1440,days_to_closed=round(days_to_closed,2))%>%
  mutate(mean_days_to_closed=mean(days_to_closed, na.rm=T))%>%
  mutate(Created_at_local=mdy_hm(Created_at_local))%>%
  mutate(Acknowledged_at_local=mdy_hm(Acknowledged_at_local))%>%
  mutate(Closed_at_local=mdy_hm(Closed_at_local))%>%
  mutate(Date_created=as.Date(Created_at_local))%>%
  mutate(month_created=floor_date(Date_created,unit=c("month")))%>%
  mutate(year_created=floor_date(Date_created,unit=c("year")))%>%
  mutate(Quadrant = recode(Export_tagged_places,
                           "Northeast Quadrant,Syracuse,Syracuse Boundary(don't use this)"="Northeast",
                           "Southeast Quadrant,Syracuse,Syracuse Boundary(don't use this)"="Southeast",
                           "Southwest Quadrant,Syracuse,Syracuse Boundary(don't use this)"="Southwest",
                           "Northwest Quadrant,Syracuse,Syracuse Boundary(don't use this)"="Northwest",
                           "Syracuse Boundary(don't use this)"="Syracuse Boundary",
                           "Syracuse,Syracuse Boundary(don't use this)"="Syracuse Boundary",
                           "Southwest Quadrant,Syracuse Boundary(don't use this)"="Southwest",
                           "Southeast Quadrant"="Southeast",
                           "Northeast Quadrant,Syracuse Boundary(don't use this)"="Northeast"))%>%
  mutate(Category = recode(Category,
                           "Adopt-A-Block - Request for Trash pick up"="Adopt-A-Block", 
                           "Register for Adopt-A-Block"="Adopt-A-Block",
                           "Dog Control"="Animal Control",
                           "Mayor's Office (Internal)"="Feedback to the City",
                           "Please use this space to provide feedback to the City"="Feedback to the City",
                           "Other Housing & Property Maintenance Concern"="Home & Building Maintenance",
                           "Report Trash/Debris Outside a Home/Building"="Home & Building Maintenance",
                           "Illegal setout/sanitation violation dispute"="Illegal Setouts/Sanitation Violations",
                           "Illegal Setouts"="Illegal Setouts/Sanitation Violations",
                           "Large or Bulk Items- Setout notification only"="Specialty Disposal",
                           "Large or Bulk Items- Skipped Pickup"="Missed Waste Pickup",
                           "Recycling (pick up that has been skipped)"="Missed Waste Pickup",
                           "Other Parking & Vehicles Concern"="Parking & Vehicles",
                           "Parking Meter"="Parking & Vehicles",
                           "To report an illegally parked vehicle, please call the Syracuse Police Ordinance at 315-448-8650. If this is an emergency, please call 911. Do NOT submit requests to Cityline."="Parking & Vehicles",
                           "To report an abandoned vehicle, please call the Syracuse Police Ordinance at 315-448-8650. If this is an emergency, please call 911. Do NOT submit requests to Cityline."="Parking & Vehicles",
                           "Other Parks, Trees & Public Utilities Concern"="Parks, Trees & Public Utilities",
                           "Park Maintenance"="Parks, Trees & Public Utilities",
                           "Playground Equipment"="Parks, Trees & Public Utilities",
                           "Tree Care and Removal"="Parks, Trees & Public Utilities",
                           "Graffiti on Private Land"="Private Land Concerns",
                           "Report Litter on Private Land"="Private Land Concerns",
                           "Report Overgrown Grass on Private Land"="Private Land Concerns",
                           "Property Damage- INTERNAL"="Property Damage",
                           "Graffiti on Public Land"="Public Land Concerns",
                           "Overgrown Grass in Public Spaces"="Public Land Concerns",
                           "Report Litter on Public Land"="Public Land Concerns",
                           "Public Trash Can"="Public Sanitation",
                           "Street Sweeping (INTERNAL)"="Public Sanitation",
                           "Sewer Back-ups (INTERNAL)"="Sewer-Related Concerns",
                           "Sewer-related Concerns"="Sewer-Related Concerns",
                           "Unshoveled Sidewalks"="Snow & Ice",
                           "Construction Debris"="Specialty Disposal",
                           "Electronics & Hazardous Waste"="Specialty Disposal",
                           "Yard Waste"="Specialty Disposal",
                           "SPD Support (Internal)"="Syracuse Police Department",
                           "Traffic & Parking Signs"="Traffic Signs & Signals",
                           "Traffic Signals"="Traffic Signs & Signals",
                           "Vacant Buildings"="Vacant Land & Buildings",
                           "Vacant Land"="Vacant Land & Buildings",
                           "Water-related Concerns"="Water-Related Concerns"))



#Plots----

##Requests by Category----

seeclickfix_clean_cat<-seeclickfix_clean%>%
  group_by(Category)%>%
  summarize(`Number of Requests`=n())

ggplot(data=seeclickfix_clean_cat)+
  geom_col(aes(x=reorder(Category, -`Number of Requests`),
               y=`Number of Requests`,
               fill=Category))+
  ggtitle("Requests By Category")+
  xlab("Category")+
  ylab("Number of Service Requests")+
  theme(axis.text.x=element_text(angle=45,hjust=1),
        legend.position= "none",
        plot.title = element_text(hjust=0.5),
        panel.background = element_blank(),
        panel.grid.major = element_blank())+
  labs(caption="Data Source: SeeClickFix Requests (2021-Present) SYRCityLine")+
  scale_fill_viridis_d(option="mako")

ggsave("requestsbycategory.pdf", height = 10, width=15)

##Average Days to Close Service Requests by Category----

seeclickfix_clean_avgclosed<-seeclickfix_clean%>%
  summarise(days_to_closed=mean(days_to_closed, na.rm=T),
            `Number of Requests`=n())

ggplot(data=seeclickfix_clean_avgclosed)+
  geom_col(aes(x=reorder(Category, -days_to_closed),y=days_to_closed, fill= Category))+
  ggtitle("Average Days to Close Service Requests By Category")+
  xlab("Category")+
  ylab("Mean Number of Days to Close a Request")+
  theme(legend.position= "none",
        axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=0.5),
        panel.background = element_blank(),
        panel.grid.major = element_blank())+
  labs(caption="Data Source: SeeClickFix Requests (2021-Present) SYRCityLine")+
  scale_fill_viridis_d(option="mako")

ggsave("avgdaystoclose_cat.pdf", height=10, width=15)

##Number of Open Requests----

seeclickfix_clean_openvclose<-seeclickfix_clean%>%
  subset(select=-c(Agency_Name))%>%
  summarise(requests_open=sum(is.na(Closed_at_local)),
            requests_closed=sum(!is.na(Closed_at_local)))


ggplot(data=seeclickfix_clean_openvclose)+
  geom_col(aes(x=reorder(Category, -requests_open), y= requests_open, fill=Category))+
  ggtitle("Number of Requests Open per Category (as of Aug 2022)")+
  xlab("Category")+
  ylab("Number of Open Requests")+
  theme(legend.position= "none",
        axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=0.5),
        panel.background = element_blank(),
        panel.grid.major = element_blank())+
  labs(caption="Data Source: SeeClickFix Requests (2021-Present) SYRCityLine")+
  scale_fill_viridis_d(option="mako")

ggsave("open_cat.pdf", height=10, width=15)

##Mean Number of Days to Close A Request per City Agency, by Quadrant----

seeclickfix_clean_quad<-seeclickfix_clean%>%
  filter(Quadrant!="Syracuse Boundary" & !is.na(Quadrant))%>%
  group_by(Agency_Name, Quadrant)%>%
  summarise(days_to_closed=mean(days_to_closed, na.rm=T))

ggplot(data=seeclickfix_clean_quad)+
  geom_col(aes(x=Agency_Name,
               y=days_to_closed,
               fill= Agency_Name))+
  ggtitle("Average Days to Close Service Requests per Agency, by Quadrant")+
  xlab("Agency")+
  ylab("Mean Number of Days to Close a Request")+
  theme(legend.position= "none",
        axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=0.5),
        panel.background = element_blank(),
        panel.grid.major = element_blank())+
  labs(caption="Data Source: SeeClickFix Requests (2021-Present) SYRCityLine")+
  facet_wrap(~Quadrant)+
  scale_fill_viridis_d(option="mako")

ggsave("avgclose_quad.pdf", height=10, width=15)

##Time plot of requests----

seeclickfix_clean_time<-seeclickfix_clean%>%
  group_by(month_created)%>%
  summarise(`Number of Requests`=n(),
            requests_open=sum(is.na(Closed_at_local)),
            requests_closed=sum(!is.na(Closed_at_local)))

ggplot(data=seeclickfix_clean_time, aes(x=month_created))+
  geom_line(aes(y=`Number of Requests`),color="#51C0A8", size=1.5)+
  geom_point(aes(y=`Number of Requests`),color="#51C0A8", size=4)+
  geom_line(aes(y=requests_closed),color="#1986A5", size=1.5)+
  geom_point(aes(y=requests_open),color="#23063F", size=4)+ 
  geom_line(aes(y=requests_open),color="#23063F", size=1.5)+
  geom_point(aes(y=requests_closed),color="#1986A5", size=4)+ 
  ggtitle("Total,Closed & Outstanding Requests by Month")+
  xlab("Month")+
  ylab("Number of Requests")+
  theme(axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=0.5),
        panel.background = element_blank(),
        panel.grid.major = element_blank())+
  labs(color="Request Status", 
       caption="Data Source: SeeClickFix Requests (2021-Present) SYRCityLine")+
  scale_fill_viridis_d(option="mako")

ggsave("time_requests.pdf", height=10, width=15)



#Outstanding Requests by Quadrant and Agency----

seeclickfix_clean <- seeclickfix_clean %>% 
  mutate(Quadrant=toupper(Quadrant))%>%
  left_join(syr_quadrants, by=c("Quadrant"="NAME"))

seeclickfix_clean_top<-seeclickfix_clean%>%
  group_by(Quadrant, Category,Agency_Name)%>%
  summarize(`Number of Requests`=n(),
            requests_open=sum(is.na(Closed_at_local)))

ggplot(data=seeclickfix_clean_top,
       aes(y = `requests_open`, 
           axis1 = Quadrant, 
           axis2 = Agency_Name)) + 
  geom_alluvium(aes(fill = Quadrant), 
                width = 1/12)+
  geom_stratum(width = 1/12, 
               fill = "grey",
               color = "black")+
  geom_label(stat = "stratum", 
             aes(label = after_stat(stratum)),
             size=2.5)+
  geom_text(stat = "stratum",
            aes(label = after_stat(stratum)),
            size=2.5)+
  theme(axis.ticks.x=element_blank(), 
        axis.text.x=element_blank(), 
        axis.title.y=element_blank(),
        legend.position= "none",
        plot.title = element_text(hjust=0.5),
        panel.background = element_blank(),
        panel.grid.major = element_blank())+
  ggtitle("Outstanding Requests by Quadrant and Agency")+
  labs(caption="Data Sources: SeeClickFix Requests (2021-Present) SYRCityLine & Syracuse Quandrants")+
  scale_fill_viridis_d(option="mako")

ggsave("outstanding_quad.png", height=10, width= 15)