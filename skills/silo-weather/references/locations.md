# SILO Location Reference

Australian weather grid-point locations for SILO DataDrill queries. SILO interpolates from BoM observations — any lat/lon within Australia works, but these are pre-verified points in key regions.

## NSW Grain Belt (Northern)

| Location | Lat      | Lon      | Elevation | Notes                        |
| -------- | -------- | -------- | --------- | ---------------------------- |
| Moree    | -29.4600 | 149.8400 | 208m      | Northern NSW wheat/heartland |
| Narrabri | -30.3300 | 149.7800 | 212m      | Northern slopes              |
| Gunnedah | -30.9800 | 150.2500 | 264m      | Liverpool Plains             |
| Tamworth | -31.0800 | 150.8400 | 404m      | Northern tablelands fringe   |

## NSW Grain Belt (Central)

| Location   | Lat      | Lon      | Elevation | Notes            |
| ---------- | -------- | -------- | --------- | ---------------- |
| Dubbo      | -32.2500 | 148.6000 | 284m      | Central west NSW |
| Parkes     | -33.1400 | 148.1700 | 324m      | Central slopes   |
| Forbes     | -33.3800 | 148.0100 | 240m      | Lachlan valley   |
| Condobolin | -33.0800 | 147.1500 | 195m      | Western slopes   |

## NSW Grain Belt (Southern)

| Location    | Lat      | Lon      | Elevation | Notes                |
| ----------- | -------- | -------- | --------- | -------------------- |
| Wagga Wagga | -35.1100 | 147.3600 | 221m      | Riverina wheat/sheep |
| Temora      | -34.4500 | 147.5300 | 280m      | Southern Riverina    |
| Griffith    | -34.2900 | 146.0500 | 134m      | MIA irrigation       |
| Albury      | -36.0700 | 146.9200 | 164m      | Murray border region |
| Cootamundra | -34.6400 | 148.0300 | 318m      | South-west slopes    |

## QLD Grain Belt (Darling Downs / Border)

| Location    | Lat      | Lon      | Elevation | Notes                       |
| ----------- | -------- | -------- | --------- | --------------------------- |
| Dalby       | -27.1800 | 151.2600 | 344m      | Darling Downs heartland     |
| Goondiwindi | -28.5500 | 150.3100 | 217m      | Border rivers region        |
| Roma        | -26.5700 | 148.7900 | 299m      | Maranoa region              |
| Emerald     | -23.5300 | 148.1600 | 179m      | Central Highlands (sorghum) |
| St George   | -28.0400 | 148.5800 | 199m      | Balonne region              |

## VIC Grain Belt (Wimmera / Mallee / Northern)

| Location   | Lat      | Lon      | Elevation | Notes                   |
| ---------- | -------- | -------- | --------- | ----------------------- |
| Horsham    | -36.7100 | 142.2000 | 128m      | Wimmera heartland       |
| Bendigo    | -36.7600 | 144.2800 | 225m      | Northern Vic            |
| Swan Hill  | -35.3400 | 143.5600 | 70m       | Mallee region           |
| Shepparton | -36.3800 | 145.4000 | 114m      | Goulburn Valley         |
| Ouyen      | -35.0700 | 142.3200 | 65m       | Southern Mallee         |
| Birchip    | -35.9800 | 142.9200 | 100m      | Mallee-Wimmera boundary |

## SA Grain Belt

| Location   | Lat      | Lon      | Elevation | Notes          |
| ---------- | -------- | -------- | --------- | -------------- |
| Clare      | -33.8300 | 138.6100 | 395m      | Mid North SA   |
| Port Pirie | -33.1800 | 138.0100 | 4m        | Spencer Gulf   |
| Minnipa    | -32.8400 | 135.1500 | 165m      | Eyre Peninsula |
| Loxton     | -34.4500 | 140.5700 | 66m       | Riverland SA   |

## WA Grain Belt

| Location  | Lat      | Lon      | Elevation | Notes                        |
| --------- | -------- | -------- | --------- | ---------------------------- |
| Merredin  | -31.4800 | 118.2800 | 315m      | Central wheatbelt            |
| Katanning | -33.6900 | 117.5600 | 311m      | Great Southern               |
| Geraldton | -28.7700 | 114.6100 | 30m       | Northern agricultural region |
| Esperance | -33.8600 | 121.8900 | 25m       | South coast                  |

## Capital Cities / Reference

| Location  | Lat      | Lon      | Elevation | Notes            |
| --------- | -------- | -------- | --------- | ---------------- |
| Sydney    | -33.8700 | 151.2100 | 39m       | Observatory Hill |
| Melbourne | -37.8100 | 144.9700 | 31m       | CBD              |
| Brisbane  | -27.4800 | 153.0300 | 8m        | CBD              |
| Adelaide  | -34.9300 | 138.6000 | 48m       | CBD              |
| Perth     | -31.9500 | 115.8600 | 19m       | CBD              |
| Canberra  | -35.2800 | 149.1300 | 577m      | Airport          |
| Darwin    | -12.4600 | 130.8400 | 30m       | Airport          |
| Hobart    | -42.8800 | 147.3300 | 51m       | CBD              |

## Column Reference (Standard Format)

| Col | Field  | Description             | Missing Value |
| --- | ------ | ----------------------- | ------------- |
| 1   | Date   | YYYYMMDD                | —             |
| 2   | Day    | Day of year (1-366)     | —             |
| 3   | T.Max  | Max temperature (°C)    | -99.9         |
| 4   | Smx    | Source flag for T.Max   | 999           |
| 5   | T.Min  | Min temperature (°C)    | -99.9         |
| 6   | Smn    | Source flag for T.Min   | 999           |
| 7   | Rain   | Daily rainfall (mm)     | -99.9         |
| 8   | Srn    | Source flag for Rain    | 999           |
| 9   | Evap   | Evaporation (mm)        | -99.9         |
| 10  | Sev    | Source flag for Evap    | 999           |
| 11  | Radn   | Solar radiation (MJ/m²) | -99.9         |
| 12  | Ssl    | Source flag for Radn    | 999           |
| 13  | VP     | Vapour pressure (hPa)   | -99.9         |
| 14  | Svp    | Source flag for VP      | 999           |
| 15  | RHmaxT | RH at T.Max (%)         | -99.9         |
| 16  | RHminT | RH at T.Min (%)         | -99.9         |
| 17  | Date2  | DD/MM/YYYY display      | —             |

Source flags: 25 = interpolated daily observation, 75 = interpolated long-term average.
