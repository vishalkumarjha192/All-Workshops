import pandas as pd

visits = pd.read_csv('ClinicPulse_Silver_Appointments.csv')

summary = (visits.groupby('specialization')
           .size().sort_values(ascending=False))
print(summary)
summary.plot(kind='bar', title='Appointments by specialization')
