# Air Demand Gap Finder

**Mission:** Help airlines, airport authorities and investors see where air travel in Africa is under-served compared with what a country's economy can support, so new routes, airports and jobs go where people need them most.

**Problem:** Predict how many air passengers a country should carry in a year from its economic and social indicators. A big gap between the prediction and the real number marks a market worth investigating.

## Dataset

World Bank World Development Indicators (the air passenger data comes from ICAO), joined with the World Bank country classification for region and income group. It has 5,211 rows (184 countries, 1990 to 2023). The target is the number of air passengers carried, and the model uses 9 features: GDP per capita, population, land area, urban %, internet use %, tourism receipts %, year, region and income group.
- WDI: https://databank.worldbank.org/source/world-development-indicators
- Country classification: https://datahelpdesk.worldbank.org/knowledgebase/articles/906519



## Swagger UI (API)

https://air-demand-gap-api.onrender.com/docs

The free Render service sleeps after 15 minutes, so the first request can take up to a minute.

## YouTube video demo

(https://youtu.be/y4hUme_Wk8U)

