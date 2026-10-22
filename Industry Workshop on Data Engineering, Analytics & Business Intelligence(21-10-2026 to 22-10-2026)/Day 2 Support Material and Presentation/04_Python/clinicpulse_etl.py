"""ClinicPulse Day 2: beginner ETL. Only NumPy + Python standard library."""
import csv, pathlib, collections
import numpy as np
BASE=pathlib.Path(__file__).resolve().parents[1]
RAW=BASE/"02_Bronze_Raw_Data"
OUT=BASE/"04_Python"/"output"
OUT.mkdir(exist_ok=True)
def read(name):
    with (RAW/(name+".csv")).open(encoding="utf-8-sig",newline="") as f:
        return list(csv.DictReader(f))
def save(name,rows,fields):
    with (OUT/(name+".csv")).open("w",encoding="utf-8-sig",newline="") as f:
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
# BRONZE: import raw source records
doctors={r["doctor_id"]:r for r in read("doctors")}
patients={r["patient_id"]:r for r in read("patients")}
appointments=read("appointments")
billing=read("billing")
# SILVER: normalize statuses, reject invalid doctor/patient IDs, deduplicate
mapping={"completed":"Completed","complete":"Completed","cancelled":"Cancelled","no-show":"No-show","no show":"No-show"}
seen=set();silver=[]
for a in appointments:
    aid=a["appointment_id"].strip()
    if aid in seen: continue
    seen.add(aid)
    status=mapping.get(a["status"].strip().lower())
    d=doctors.get(a["doctor_id"].strip());p=patients.get(a["patient_id"].strip())
    if not status or not d or not p:continue
    silver.append(dict(appointment_id=aid,patient_id=a["patient_id"].strip(),
      doctor_id=a["doctor_id"].strip(),appointment_date=a["appointment_date"],
      status=status,specialization=d["specialization"],city=p["city"]))
save("silver_appointments",silver,list(silver[0]))
valid={a["appointment_id"] for a in silver}
sb=[]
for b in billing:
    if b["appointment_id"] not in valid:continue
    try:amount=float(b["amount"].replace("₹","").replace(",","").strip())
    except ValueError:continue
    if amount<=0:continue
    sb.append(dict(bill_id=b["bill_id"],appointment_id=b["appointment_id"],amount=amount,
        payment_status="Paid" if b["payment_status"].strip().lower()=="paid" else "Pending"))
save("silver_billing",sb,list(sb[0]))
# GOLD: KPIs and aggregations for Tableau
counts=collections.Counter(a["status"] for a in silver)
total=len(silver)
summary=[dict(total_appointments=total,completed=counts["Completed"],
 cancelled=counts["Cancelled"],no_shows=counts["No-show"],
 completion_rate_pct=round(100*np.divide(counts["Completed"],total),1))]
save("gold_summary",summary,list(summary[0]))
for field,output in [("appointment_date","gold_daily"),("specialization","gold_specialization")]:
    groups=collections.defaultdict(list)
    for a in silver:groups[a[field]].append(a)
    rows=[{field:k,"appointments":len(v),"completed":sum(x["status"]=="Completed" for x in v)}
          for k,v in sorted(groups.items())]
    save(output,rows,list(rows[0]))
groups=collections.defaultdict(list)
for b in sb:groups[b["payment_status"]].append(b)
rows=[dict(payment_status=k,bills=len(v),amount=sum(x["amount"] for x in v))
      for k,v in sorted(groups.items())]
save("gold_billing",rows,list(rows[0]))
print("Success. Gold summary:",summary[0])
print("Open the gold_*.csv files in Tableau to create a dashboard.")
