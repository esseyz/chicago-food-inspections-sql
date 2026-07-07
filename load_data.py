import psycopg2
import csv

# Database connection
conn = psycopg2.connect(
    host="localhost",
    port="5432",
    database="chicago_inspections",
    user="postgres",
    password="postgres"
)
cur = conn.cursor()

# Drop and recreate table
cur.execute("DROP TABLE IF EXISTS food_inspections;")
cur.execute("""
    CREATE TABLE food_inspections (
        inspection_id     TEXT,
        dba_name          TEXT,
        aka_name          TEXT,
        license_num       TEXT,
        facility_type     TEXT,
        risk              TEXT,
        address           TEXT,
        city              TEXT,
        state             TEXT,
        zip               TEXT,
        inspection_date   TEXT,
        inspection_type   TEXT,
        results           TEXT,
        violations        TEXT,
        latitude          TEXT,
        longitude         TEXT,
        location          TEXT
    );
""")

# Load CSV
file_path = r'D:\Projects\chicago-food-inspections-sql\data\food_inspections.csv'

with open(file_path, encoding='utf-8-sig') as f:
    reader = csv.DictReader(f)
    rows = []
    for row in reader:
        rows.append((
            row.get('Inspection ID'),
            row.get('DBA Name'),
            row.get('AKA Name'),
            row.get('License #'),
            row.get('Facility Type'),
            row.get('Risk'),
            row.get('Address'),
            row.get('City'),
            row.get('State'),
            row.get('Zip'),
            row.get('Inspection Date'),
            row.get('Inspection Type'),
            row.get('Results'),
            row.get('Violations'),
            row.get('Latitude'),
            row.get('Longitude'),
            row.get('Location')
        ))

    cur.executemany("""
        INSERT INTO food_inspections VALUES
        (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """, rows)

conn.commit()
print(f"Loaded {len(rows)} rows successfully")

cur.close()
conn.close()