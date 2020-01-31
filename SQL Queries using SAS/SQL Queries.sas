libname deep "C:\Users\spavot\Documents\GitHub\BRT\Group assignment";run;
/* TOP 5 avg max delay routes */
Proc SQL outobs = 5;
Create table final.top5_maxdelay_routes as
Select avg(dep_delay + arr_delay) as delay, origin, dest
From deep.flights as f
Group by origin, dest
Having count(flight) > 10
Order by delay desc
;
Quit;
Run;

/* TOP 5 avg min delay routes */
Proc SQL outobs = 5;
Create table final.top5_mindelay_routes as
Select avg(dep_delay + arr_delay) as delay, origin, dest
From deep.flights as f
Group by origin, dest
Having count(flight) > 10
Order by delay
;
Quit;
Run;
/*TOP 5 AVG carrier max delay*/
Proc SQL outobs =5;
Create table final.top5_avg_carrier_maxdelay as
Select avg(dep_delay + arr_delay) as delay, a.carrier, a.name as Airlines
From deep.flights as f,
deep.airlines as a
Where f.carrier = a.carrier
Group by a.carrier, a.name
Having count(flight) > 50
Order by delay desc
;
Quit;
Run;

/*TOP 5 AVG carrier min delay*/
Proc SQL outobs =5;
Create table final.top5_avg_carrier_mindelay as
Select avg(dep_delay + arr_delay) as delay, a.carrier, a.name as Airlines
From deep.flights as f,
deep.airlines as a
Where f.carrier = a.carrier
Group by a.carrier, a.name
Having count(flight) > 50
Order by delay 
;
Quit;
Run;

/*AVG Delay per month*/
Proc SQL;
/* Create table final.avg_delay_month as */
Select avg(dep_delay + arr_delay) as delay, month, count(f.flight) as nbr_flights_year
From deep.flights as f
Group by month
Order by delay desc
;
Quit;
Run;

/* AVG Delay per airports with sum of all flight over the year*/
Proc SQL;
Create table final.avg_delay_airport_with_flights as
Select avg(dep_delay + arr_delay) as delay, f.origin, a.name, count(f.flight) as nbr_flights_year
From deep.flights as f,
deep.airports as a
Where f.origin = a.faa
Group by f.origin, a.name
Order by delay desc
;
Quit;
Run;
/* Impact of visibility on delay */
Proc SQL;
Create table final.visibility_delay as
Select avg(dep_delay + arr_delay) as delay, 
Case when visib < 2 Then "Very low visibility"
	 when visib < 4 Then "Low visibility"
	 when visib < 6 Then "Medium visibility"
	 when visib < 8 Then "Good visiblity"
	 when visib < 9 Then "Very good visibility"
	 Else "Awesome visibility" end "Visibility"
From deep.weather as w,
deep.flights as f
Where f.origin = w.origin
And f.time_hour = w.time_hour
Group by 2
Order by delay
;
Quit;
Run;

/* Impact of pressure on delay */
Proc SQL;
Create table final.pressure_delay as
Select avg(dep_delay + arr_delay) as delay, 
Case when pressure < 980 Then "Very low pressure"
	 when pressure < 1000 Then "Low pressure"
	 when pressure < 1020 Then "Medium pressure"
	 when pressure < 1040 Then "High pressure"
	 Else "Extreme pressure" end "Pressure"
From deep.weather as w,
deep.flights as f
Where f.origin = w.origin
And f.time_hour = w.time_hour
Group by 2
Order by delay
;
Quit;
Run;

/* Impact of windspeed on delay */
Proc SQL;
Create table final.windspeed_delay as
Select avg(dep_delay + arr_delay) as delay, 
Case when wind_speed < 5 Then "Very low wind"
	 when wind_speed < 15 Then "Low wind"
	 when wind_speed < 25 Then "Medium wind"
	 when wind_speed < 35 Then "High wind"
	 Else "Extreme Wind" end "Wind Speed"
From deep.weather as w,
deep.flights as f
Where f.origin = w.origin
And f.time_hour = w.time_hour
Group by 2
Order by delay
;
Quit;
Run;

/* Impact of precip on delay */
Proc SQL;
Create table final.precip_delay as
Select avg(dep_delay + arr_delay) as delay, 
Case when precip = 0 Then "No precipitations"
	 when precip < 0.2 Then "Very Low precipitation"
	 when precip < 0.4 Then "Low precipitation"
	 when precip < 0.6 Then "Medium precipitation"
	 when precip < 0.8 Then "High wind"
	 Else "Extreme Precipitation" end "Wind Speed"
From deep.weather as w,
deep.flights as f
Where f.origin = w.origin
And f.time_hour = w.time_hour
Group by 2
Order by delay
;
Quit;
Run;


/* Aiport with the lowest quality weather */

Proc SQL;
Create table final.weather_airport as
Select a.faa, a.name, avg(pressure)as pressure, avg(wind_speed)as Wind_Speed, avg(precip)as Precipitation, 
avg(visib) as Visibility, avg(dep_delay + arr_delay) as Delay
From deep.airports as a,
deep.weather as w,
deep.flights as f
Where a.faa = w.origin
and w.origin = f.origin
and w.time_hour = f.time_hour
Group by a.name, a.faa
;
Quit;
Run;
