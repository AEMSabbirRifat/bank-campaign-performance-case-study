"""Reshapes results/*.csv into one tidy table, results/dashboard_data.csv, for Tableau or Power BI.

One row per number: view, row, measure, value. Load the file, filter on `view`, put `row` on one axis,
`value` on the other and `measure` on colour.

Usage:  python build_dashboard_data.py
"""
import csv
import pathlib

HERE = pathlib.Path(__file__).parent
R = HERE / "results"

# For each summary table: the columns that name a row. Every other numeric column becomes a measure.
KEYS = {
    "02_by_year": ["campaign_year"],
    "03_by_month": ["month_label"],
    "04_channel_by_year": ["campaign_year", "channel"],
    "05_calls_per_client": ["calls_to_client"],
    "06_persistence": ["calls_to_client"],
    "07_history_by_year": ["history", "period"],
    "08_job_groups": ["job_group"],
    "09_age_bands": ["age_band"],
    "10_call_order": ["client_group"],
    "11_option_sizing": ["option", "rule"],
}

rows = []
for path in sorted(R.glob("[0-9]*.csv")):
    keys = KEYS.get(path.stem)
    if keys is None:
        continue
    with path.open(encoding="utf-8") as f:
        for order, r in enumerate(csv.DictReader(f), 1):
            label = " | ".join(r[k] for k in keys)
            for col, val in r.items():
                if col in keys or col.endswith("_order") or val == "":
                    continue
                try:
                    float(val)
                except ValueError:
                    continue
                rows.append([path.stem, label, order, col, val])

out = R / "dashboard_data.csv"
with out.open("w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["view", "row", "row_order", "measure", "value"])
    w.writerows(rows)
print(f"wrote {out} with {len(rows)} rows")
