-- loading the covid-19 dataset
cv = load '/PigInput/covidworld.csv' using PigStorage(',') as (date:chararray, country:chararray, confirmed:int, recovered:int, deaths:int);

-- creating bags for the data to perform aggregate functions
grp_cv = group cv all;

-- Finding total no. of death cases
total_deaths = foreach grp_cv generate SUM(cv.deaths);

-- Finding total no. of confirmed cases
total_confirmed = foreach grp_cv generate SUM(cv.confirmed);

-- Finding total no. of recovered cases
total_recovered = foreach grp_cv generate SUM(cv.recovered);


-- Finding the place with highest no. of deaths
max_deaths = foreach grp_cv generate MAX(cv.deaths) as X;
result = filter cv by deaths == max_deaths.X;


country_cv = group cv by country;

-- Finding total death cases by country ordered by highest no. of deaths
total_deaths_by_country = foreach country_cv generate group as country, SUM(cv.deaths) as total_deaths;
X = order total_deaths_by_country by total_deaths desc;

-- Finding total cured cases by country ordered by highest no. of cured
total_recovered_by_country = foreach country_cv generate group as country, SUM(cv.recovered) as total_recovered;
Y = order total_recovered_by_country by total_recovered desc;

-- Finding total confirmed cases by country ordered by highest no. of confirmed
total_confirmed_by_country = foreach country_cv generate group as country, SUM(cv.confirmed) as total_confirmed;
Z = order total_confirmed_by_country by total_confirmed desc;
dump Z;
