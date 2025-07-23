# 🏥 Healthcare No-Show Appointment Analysis

## 📌 Project Overview

This is a real-world, end-to-end data analytics project focused on analyzing patient no-show appointments in the healthcare domain. 
The goal is to identify key reasons for missed appointments and offer actionable, visual insights for hospital administrators.

✅ **Workflow:**  
SQL (Cleaning & EDA) → Excel (Transfer) → Python (Analysis & ML) → Power BI (Dashboard with DAX)

---

## 🧰 Tools & Technologies

| Phase                 | Tools Used                                               |
|----------------------|----------------------------------------------------------|
| Data Cleaning & Storage | MySQL, Excel                                          |
| Analysis & Modeling     | Python (Pandas, Matplotlib, Scikit-learn)             |
| Dashboard & Reporting   | Power BI, DAX                                          |
| Machine Learning        | Logistic Regression, Random Forest (for comparison)   |
| Version Control         | Git & GitHub                                           |

---

## 🔁 Project Pipeline

### 1️⃣ Data Cleaning in SQL
- Loaded the dataset into MySQL
- Cleaned nulls, fixed data types, and removed duplicates
- Created new columns: `Waiting_Days`, `Age_Group`, `Appointment_Weekday`

### 2️⃣ Export to Excel
- exported to Excel for model preparation

### 3️⃣ Python Analysis & Modeling
- Used Python for EDA to find:
  - No-show rate across gender, age group, weekdays, medical conditions
- Built classification models:
  - Logistic Regression & Random Forest
- Extracted key patterns for dashboard insights

### 4️⃣ Dashboard in Power BI
- Connected Excel/SQL to Power BI
- Built a clean, professional **two-page dashboard**
- Used **DAX** to create:
  - No-Show Rate %
  - Monthly Attendance Trend
  - Age Group Share & Medical Condition Impact
- Added interactive **slicers**: Gender, SMS Received, Age Group, etc.

---

## 📈 Key Insights

- 📲 SMS reminders improve appointment show-up rates
- 👶 Teens and Young Adults are more likely to miss appointments
- 🗓️ Friday & Saturday have lowest no-show rates
- 🏘️ Certain neighborhoods have consistently high no-show rates
- 🧠 Conditions like Hypertension & Alcoholism impact patient reliability

---

## 📊 Dashboard Snapshots

### 🔹 Page 1: Executive Summary  
![Dashboard Page 1](https://github.com/student423/Healthcare_Analysis/blob/main/healthcare_analysis%20dashboard-1.jpg)

---

### 🔹 Page 2: Patient & Department Insights  
![Dashboard Page 2]()

---

## 📦 Project Deliverables

- ✅ SQL scripts for cleaning and feature creation
- ✅ Excel file with final cleaned dataset
- ✅ Python notebook for EDA and modeling
- ✅ Power BI dashboard (.pbix + images)
- ✅ This GitHub `README.md`

---

## 💼 Why This Project Matters

This project demonstrates:
- Structured thinking: SQL → Python → Power BI
- Realistic business problem-solving in the **healthcare domain**
- Strong grasp of feature engineering and classification models
- Visual storytelling using KPIs, DAX, slicers, and drill-down dashboards

---
