# 23 calls for every sale: a performance marketing story from problem to call plan

**Live case study:** https://scaleupwithsabbir.github.io/#bank-campaign-calls

**The question.** A Portuguese bank sold a term deposit by phone for three years. Which calls paid, and how should the next campaign spend its calls?

**The answer in four numbers** (UCI Bank Marketing, 41,188 clients contacted, May 2008 to November 2010)

| Finding | Value |
|---|---|
| Calls made for every deposit sold | 22.8 (105,754 calls, 4,640 sales) |
| Share of all calls made in 2008, and the share of sales they produced | 73.3% of calls, 28.9% of sales |
| Calls per sale for first-time contacts: landline against mobile | 61 against 21.5 |
| Clients called ten times or more | 1,094 clients, 16,326 calls, 39 sales |

The six-view investigation, what was tried, the three options and the scored recommendation are on the live page.

## How it is built

1. **Data.** One public file, included in `data/`.
2. **SQL.** `sql/00_clean_contacts.sql` builds the analysis table. Files `01` to `12` each answer one question.
3. **Summary tables.** `run_analysis.py` runs every query with DuckDB and writes `results/*.csv`.
4. **Dashboards.** `build_dashboard_data.py` reshapes the summary tables into one tidy file, `results/dashboard_data.csv`, that loads straight into Tableau or Power BI.
5. **Page.** `build_site_data.py` writes `results/site_data.ts`. The portfolio page reads every number from it, so the page cannot drift from the SQL output.

```
data/bank-additional-full.csv.gz   the source file, gzip
sql/                            13 SQL files (DuckDB dialect), one per question
results/                        12 summary tables (CSV)
results/dashboard_data.csv      the same numbers as one tidy table for Tableau or Power BI
results/site_data.ts            the same numbers as the page's data file
run_analysis.py                 runs the SQL, writes results/
build_dashboard_data.py         writes results/dashboard_data.csv
build_site_data.py              writes results/site_data.ts
```

## Reproduce it

```bash
git clone https://github.com/AEMSabbirRifat/bank-campaign-performance-case-study.git
cd bank-campaign-performance-case-study
pip install duckdb
python run_analysis.py
python build_dashboard_data.py
python build_site_data.py
```

No model and no AI step: the analysis is SQL from start to finish. The call order in query 10 is five plain rules, not a scoring model.

## Data source and licence

- Source: Moro, S., Rita, P. and Cortez, P. (2014). *Bank Marketing* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5K306, https://archive.ics.uci.edu/dataset/222/bank+marketing
- Related paper: Moro, S., Cortez, P. and Rita, P. (2014). A data-driven approach to predict the success of bank telemarketing. *Decision Support Systems*, 62, 22-31.
- Licence: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). The file may be shared and adapted with attribution.
- `data/bank-additional-full.csv.gz` is the file `bank-additional-full.csv` from the dataset, compressed: 41,188 rows, 21 columns, in the original row order (SHA-256 of the uncompressed file `74adfc578bf77a7ff4bb1ba4a9f8709d9e3c6907342959c2c8416847e0afb4d8`).
- Changes made in the analysis: aggregation into counts, shares and ratios.
- The bank is not named in the source. This is independent work, not affiliated with or endorsed by the bank, UCI or the dataset's authors.

## Privacy

The source file holds no names, account numbers or other identifiers. Results are summary tables only, and rate cells with fewer than 30 clients are left empty.

## Definitions and limits

- **One row** is one client in the campaign, with the number of calls made to that client (`campaign` in the source) and whether the client opened the deposit (`y`).
- **Calls per sale:** calls made divided by deposits sold.
- **Year:** the source file gives the month but not the year. Its documentation states that rows are in date order from May 2008 to November 2010, so the year is rebuilt by counting each time the month number falls.
- **Compare inside a year.** Market interest rates fell from about 5% to under 1% over the period and the three years differ widely, so pooled comparisons mislead. Query 07 shows one case where the pooled ranking is the reverse of the ranking in every single year.
- **Call duration** is in the file but is not used: it is only known after the call.
- **Options** replay the calls that were made under each rule. The file records the outcome at a client's last call, so a three-call cap keeps the sales that closed within three calls. These are not forecasts.
- There are no costs or deposit amounts, so the unit is calls, not euros.

Independent analysis by Sabbir Rifat.
