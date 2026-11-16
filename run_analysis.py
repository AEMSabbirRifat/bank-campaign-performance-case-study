"""Runs every SQL file in sql/ with DuckDB and writes each result to results/<name>.csv.

Usage:  python run_analysis.py
Needs:  pip install duckdb, and data/bank-additional-full.csv.gz - see README.md (UCI "Bank Marketing", CC BY 4.0).
"""
import csv
import pathlib
import duckdb

ROOT = pathlib.Path(__file__).parent
con = duckdb.connect()  # in-memory database

for sql_file in sorted((ROOT / "sql").glob("*.sql")):
    query = sql_file.read_text(encoding="utf-8")
    cur = con.execute(query)
    if sql_file.name.startswith("00_"):
        print(f"{sql_file.name}: table built, {con.execute('SELECT count(*) FROM contacts').fetchone()[0]} rows")
        continue
    rows = cur.fetchall()
    header = [d[0] for d in cur.description]
    out = ROOT / "results" / (sql_file.stem + ".csv")
    with out.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(header)
        w.writerows(rows)
    print(f"\n{sql_file.name} -> results/{out.name}")
    print("  " + " | ".join(header))
    for r in rows:
        print("  " + " | ".join("" if v is None else str(v) for v in r))
