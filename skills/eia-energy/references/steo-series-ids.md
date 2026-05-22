# STEO Series IDs — Petroleum Supply & Storage

The EIA Short Term Energy Outlook (`steo` route) contains both historical data
and 18-month projections. These are the key series IDs for petroleum supply,
inventories, and balances.

## Inventories / Storage

| Series ID                   | Description                                              | Unit       |
| --------------------------- | -------------------------------------------------------- | ---------- |
| `PASC_OECD_T3`              | OECD commercial crude & liquids inventory                | M bbl, EOP |
| `PASC_OOECD_T3`             | Other OECD (non-US) commercial crude & liquids inventory | M bbl, EOP |
| `PASC_US`                   | US commercial crude & liquids inventory                  | M bbl, EOP |
| `PASXPUS`                   | Total commercial crude & liquids inventory (US)          | M bbl, EOP |
| `COSXPUS`                   | US crude oil inventory (excluding SPR)                   | M bbl, EOP |
| `MGTSPUS`                   | US motor gasoline inventory                              | M bbl, EOP |
| `MGTSPP1` through `MGTSPP5` | Motor gasoline by PADD 1-5                               | M bbl, EOP |
| `DFPSPUS`                   | US distillate fuel oil inventory                         | M bbl, EOP |
| `PRPSPUS`                   | US propane/propylene inventory                           | M bbl, EOP |
| `C3PSPUS`                   | US propane inventory                                     | M bbl, EOP |
| `P3PSPUS`                   | US propylene (refinery-grade) inventory                  | M bbl, EOP |
| `NGUSPUS`                   | US natural gas total inventory                           | Bcf, EOP   |
| `NGWGPUS`                   | US natural gas working inventory                         | Bcf, EOP   |

## Inventory Changes (Draws / Builds)

Negative = stock draw. Positive = stock build.

| Series ID           | Description                                       | Unit |
| ------------------- | ------------------------------------------------- | ---- |
| `T3_STCHANGE_WORLD` | Global net inventory withdrawals                  | mb/d |
| `T3_STCHANGE_OECD`  | OECD net inventory withdrawals                    | mb/d |
| `T3_STCHANGE_NOECD` | Non-OECD net inventory withdrawals                | mb/d |
| `T3_STCHANGE_OOECD` | Other OECD (non-US) net inventory withdrawals     | mb/d |
| `T3_STCHANGE_US`    | US net inventory withdrawals                      | mb/d |
| `COSX_DRAW`         | US crude oil net commercial inventory withdrawals | mb/d |
| `DAPSPUS_DRAW`      | US distillate fuel stock draw                     | mb/d |

## Supply & Production

| Series ID       | Description                                 | Unit |
| --------------- | ------------------------------------------- | ---- |
| `PAPR_WORLD`    | Total world petroleum production            | mb/d |
| `PAPR_OPEC`     | Total OPEC petroleum supply                 | mb/d |
| `PAPR_OPECPLUS` | Total OPEC+ petroleum supply                | mb/d |
| `PAPR_NONOPEC`  | Total non-OPEC liquids petroleum production | mb/d |
| `PAPR_NONOECD`  | Total non-OECD crude & liquids supply       | mb/d |

## Consumption / Demand

| Series ID       | Description                                   | Unit |
| --------------- | --------------------------------------------- | ---- |
| `PATC_OECD`     | Total OECD liquid fuels consumption           | mb/d |
| `PATC_NON_OECD` | Total non-OECD liquid fuels consumption       | mb/d |
| `PATCPUSX`      | Total US petroleum & liquids product supplied | mb/d |
| `PASUPPLY`      | Total US petroleum product supply             | mb/d |

## Trade

| Series ID  | Description                    | Unit |
| ---------- | ------------------------------ | ---- |
| `PAIMPORT` | Total US petroleum net imports | mb/d |

## Discovery

To find more series IDs:

```bash
scripts/eia-data steo --freq monthly --length 5000 \
  | python3 -c "
import sys, json
d = json.load(sys.stdin)
seen = set()
for item in d['response']['data']:
    sid = item.get('seriesId','')
    desc = item.get('seriesDescription','')
    if sid and sid not in seen:
        seen.add(sid)
        print(f'{sid}: {desc}')
" | less
```
