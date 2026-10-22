# 🏥 Industry Workshop on Data Engineering, Analytics & Business Intelligence

**📅 21-10-2026 to 22-10-2026 · K. R. Mangalam University** · Project: **ClinicPulse**

> A 2-day hands-on industry workshop where I took messy hospital data and turned it into clean, decision-ready insights using **SQL, Python, Excel and Tableau**.

![Level](https://img.shields.io/badge/Level-Beginner-green)
![SQL](https://img.shields.io/badge/SQL-SQLite-blue)
![Python](https://img.shields.io/badge/Python-NumPy-yellow)
![Excel](https://img.shields.io/badge/Excel-Pivot%20%26%20Charts-brightgreen)
![Tableau](https://img.shields.io/badge/Tableau-Dashboard-orange)
![Data](https://img.shields.io/badge/Data-100%25%20Synthetic-lightgrey)

---

## 📖 About the Project

**ClinicPulse Hospital** wants a simple management dashboard. Reception, doctor rosters, patient records and billing all live in separate files, and the data is messy. The goal is to answer questions like:

- How many appointments were scheduled, completed, cancelled or no-show?
- What is the completion rate?
- How does appointment volume change by date?
- Which specializations are the busiest?
- How much has been billed, and how much is still pending?

To answer them, the data is moved through the **Medallion Architecture** (Bronze → Silver → Gold).

```
 Bronze (raw)          Silver (cleaned)            Gold (business-ready)
┌──────────────┐     ┌────────────────────┐     ┌──────────────────────┐
│ patients     │     │ remove duplicates  │     │ KPI summary          │
│ doctors      │ ──► │ fix status text    │ ──► │ daily trend          │ ──► Tableau Dashboard
│ appointments │     │ drop bad doctor IDs│     │ by specialization    │
│ billing      │     │ clean ₹ amounts    │     │ billing (paid/pending)│
└──────────────┘     └────────────────────┘     └──────────────────────┘
```

> ⚠️ All data is **fully synthetic** (invented). No real patient information is used.

---

## 📅 Workshop Structure

| Day | Theme | What was covered |
|-----|-------|------------------|
| **Day 1 – Understand** | Data fundamentals | Business questions, structured / semi-structured / unstructured data, related tables, ETL basics, Bronze-Silver-Gold, KPIs, choosing the right chart, intro to Excel / SQL / pandas tools |
| **Day 2 – Create** | Build the capstone | SQL, Excel, Tableau and Python refreshers, then the ClinicPulse ETL pipeline and a Tableau dashboard, followed by a project review and live quiz |

---

## 🗂️ Repository Structure

This README sits inside the workshop folder of the **All-Workshops** repository.

```
All-Workshops/
└── Industry Workshop on Data Engineering, Analytics & Business Intelligence(21-10-2026 to 22-10-2026)/
    │
    ├── Day 1 Support Material and Presentation/
    │   ├── KR Mangalam Day 1 PPT for Data Analytics Workshop.pptx
    │   ├── Slide 15 - Structured semi-structured unstructured/   # CSV, JSON, TXT examples
    │   ├── Slide 17 - Three related tables/                      # patients, doctors, appointments
    │   ├── Slide 21 - Three source systems/                      # RAW reception, roster, billing
    │   ├── Slide 25 - Bronze Silver Gold/                        # layered data + quality issues
    │   ├── Slide 39 - Understand appointment data/
    │   ├── Slide 41 - Appointments dashboard/                    # Gold KPI files
    │   ├── Slide 42 - Which chart tells the right story/         # chart & pivot examples
    │   ├── Slide 45 - Tools you can start with/                  # pandas, SQL join, SQLite, notebook
    │   └── Slide 58 - Day 2 preview examples/                    # retail raw -> cleaned -> SQL -> chart
    │
    └── Day 2 Support Material and Presentation/
        ├── KR Mangalam Day 2 PPT for Data Analytics Workshop.pptx
        ├── 01_Problem_Statement/                  # scenario, challenge, business questions
        ├── 02_Bronze_Raw_Data/                    # patients, doctors, appointments, billing (6,200 rows each)
        ├── 03_SQL/
        │   ├── Step_01_Create_Tables/             # create bronze tables
        │   ├── Step_02_Insert_Data/               # 100-row insert batches
        │   └── Step_03_Clean_Transform_Gold/      # bronze -> silver -> gold
        ├── 04_Python/
        │   ├── clinicpulse_etl.py                 # beginner ETL script (NumPy + std library)
        │   ├── requirements.txt
        │   └── output/                            # generated silver & gold CSVs
        ├── 05_Silver_Gold_Expected_Outputs/       # answer key + SQLite database
        └── 06_Dashboard_Designs/                  # 3 dashboard layout options
```

---

## 🧱 Data Model

| Table | Key columns |
|-------|-------------|
| `patients` | `patient_id`, `patient_name`, `age`, `city` |
| `doctors` | `doctor_id`, `doctor_name`, `specialization` |
| `appointments` | `appointment_id`, `patient_id`, `doctor_id`, `appointment_date`, `status` |
| `billing` | `bill_id`, `appointment_id`, `amount`, `payment_status` |

**Join guide**

```
appointments.patient_id     → patients.patient_id
appointments.doctor_id      → doctors.doctor_id
billing.appointment_id      → appointments.appointment_id
```

---

## 🧹 Data Quality Issues Handled

The Bronze data includes deliberate problems that the pipeline fixes:

- ❌ Duplicate appointment IDs → **deduplicated**
- ❌ Blank / missing status → **rejected**
- ❌ Inconsistent capitalization (`complete`, `no show`, …) → **standardized** to `Completed`, `Cancelled`, `No-show`
- ❌ Invalid doctor IDs (broken references) → **rejected**
- ❌ Currency formatting (`₹`, commas) in billing → **converted to numbers**

---

## 📊 Results (Gold Layer)

| Metric | Value |
|--------|-------|
| Total appointments (after cleaning) | **6,197** |
| Completed | **4,728** |
| Cancelled | **1,031** |
| No-shows | **438** |
| Completion rate | **76.3%** |
| Paid bills | 3,099 (₹30,71,800) |
| Pending bills | 3,098 (₹30,44,250) |

Gold outputs: `gold_summary`, `gold_daily`, `gold_specialization`, `gold_billing`.

---

## 🚀 How to Run

### Option 1 – Python (easiest)

```bash
cd "Day 2 Support Material and Presentation/04_Python"
pip install -r requirements.txt
python clinicpulse_etl.py
```

The cleaned Silver and Gold CSV files are written to `04_Python/output/`.

### Option 2 – SQL (SQLite)

1. Run `03_SQL/Step_01_Create_Tables/01_create_tables.sql`
2. Run every file in `03_SQL/Step_02_Insert_Data/` (patients, doctors, appointments, billing)
3. Run `03_SQL/Step_03_Clean_Transform_Gold/03_bronze_to_silver_to_gold.sql`

> The scripts target **SQLite** syntax. Some online editors limit execution size, so if inserts fail, open the ready-made `05_Silver_Gold_Expected_Outputs/clinicpulse_day2.sqlite` instead.

### Option 3 – Tableau

Connect Tableau to the Gold CSVs and build the dashboard using one of the layouts in `06_Dashboard_Designs/`.

**Minimum dashboard:** 3 KPI cards, 2 charts, 1 status distribution and 2 business recommendations.

---

## 🛠️ Tech Stack

| Purpose | Tools |
|---------|-------|
| Data cleaning & transformation | SQL (SQLite), Python (NumPy, csv) |
| Exploration | pandas, Jupyter Notebook, Excel (pivot tables & charts) |
| Visualization | Tableau, Excel charts |
| Concepts | ETL, Medallion Architecture (Bronze / Silver / Gold), KPIs |

---

## 🎯 Key Learnings

- Always ask *"Can we trust the data?"* before analysing it.
- Turn vague requests ("Is the hospital doing well?") into **measurable business questions**.
- Layering data (Bronze → Silver → Gold) keeps raw data safe and results reproducible.
- The same ETL can be done in **SQL or Python**, and the right chart depends on the story.

---

## 👤 Author

**Vishal Kumar Jha**
Frontend Developer & UI/UX Designer
🔗 [GitHub – @vishalkumarjha192](https://github.com/vishalkumarjha192)

---

## 📄 License & Disclaimer

Workshop material was created for learning at **K. R. Mangalam University**. All datasets are synthetic and for educational use only.
