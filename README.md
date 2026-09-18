# b2b_sales_funnel_analytics
End-to-end B2B sales funnel &amp; pipeline performance analysis using PostgreSQL, Excel, and Power BI.

## Introduction
In high-velocity B2B environments, scaling pipeline revenue requires granular visibility over both acquisition channel quality and sales execution velocity.

This project explores the conversion mechanics of sellers registering on a large marketplace ecosystem. By connecting raw lead touchpoints with CRM deal progression data, the objective is to diagnose acquisition bottlenecks, determine sales cycle duration, and measure the revenue impact of consultative sales representatives (SDRs and Closers).

## Project Files
Analytical Base Extraction:
Audit Table:
Final Dashboard:

## Skills Used
The following technical skills were utilized across the analysis:

### <img src="https://github.com/user-attachments/assets/475cb456-ce8a-42b3-aefa-0ddb508cdf99" width="20" alt="Excel" style="vertical-align: middle;"> PostgreSQL Skills
*  **Multi-Table Joins**
*  **Conditional Logic**
*  **Data Cleansing**
---

### <img src="https://github.com/user-attachments/assets/76f3d093-4297-42e1-92b4-8897454a3cd3" width="20" alt="Excel" style="vertical-align: middle;"> Excel & Power Query Skills
*  **ETL & Data Transformation**
*  **Pivot Tables & Aggregations**
*  **Data Audit & Validation**

---

### <img src="https://github.com/user-attachments/assets/707d9604-b5e0-4bc7-b0c4-a401b6ed001f" width="20" alt="Excel" style="vertical-align: middle;"> Power BI Skills
*  **DAX Measures**
*  **Executive Data Visualization**
*  **Conditional Formatting & UI**
  


## B2B Marketing Funnel Dataset
The dataset used for this project contains real-world B2B sales funnel data from the Olist Marketplace ecosystem, linking marketing qualified leads to closed deals handled by an Inside Sales team. It provides a foundation for analyzing acquisition channels, sales cycle velocity, and commercial performance. It includes detailed information on:

* 🎯 **MQL Acquisition**
* 🤝 **Commercial Roles**
* 🏢 **Business Demographics**
* ⏱️ **Sales Velocity**


---

## <img src="https://github.com/user-attachments/assets/475cb456-ce8a-42b3-aefa-0ddb508cdf99" width="20" alt="Excel" style="vertical-align: middle;"> Data Extraction & Transformation (SQL)

To evaluate funnel mechanics, the raw tables `marketing_qualified_leads` and `closed_deals` were queried and joined in PostgreSQL. The objective was to build a single consolidated analytical table containing both top-of-funnel touchpoints and bottom-of-funnel sales metrics.

### 1. Building the Analytical Funnel Table
```sql
SELECT 
    mql.mql_id,
    mql.first_contact_date,
    mql.landing_page_id,
    COALESCE(mql.origin, 'unknown') AS acquisition_channel,
    cd.sdr_id,
    cd.sr_id AS sales_rep_id,
    cd.won_date,
    cd.business_segment,
    cd.lead_type,
    COALESCE(cd.declared_monthly_revenue, 0) AS declared_monthly_revenue,
    CASE 
        WHEN cd.won_date IS NOT NULL THEN 1 
        ELSE 0 
    END AS is_closed_deal,
    CASE 
        WHEN cd.won_date IS NOT NULL THEN (cd.won_date::date - mql.first_contact_date::date)
        ELSE NULL 
    END AS days_to_close
FROM marketing_qualified_leads mql
LEFT JOIN closed_deals cd 
    ON mql.mql_id = cd.mql_id;
```

## <img src="https://github.com/user-attachments/assets/76f3d093-4297-42e1-92b4-8897454a3cd3" width="20" alt="Excel" style="vertical-align: middle;"> Data Audit & Validation (Excel & Power Query)
Before building visual reports, the analytical dataset was imported into Microsoft Excel via Power Query to perform data sanitization, handle string anomalies, and reconcile baseline metrics.

Key Data Cleansing Actions:
- Date Parsing & Localization: Converted first_contact_date and won_date into proper regional date timestamps.

- Text Null Handling: Detected literal string entries ("NULL") across sales_rep_id and business_segment columns and coerced them into true blanks to prevent downstream calculation skew.

---

Mathematical Integrity Audit: Verified with Pivot Tables that the dataset totaled exactly:

- Total Leads: 8,000

- Closed Deals: 842

- Conversion Rate: 10.53%

- Average Sales Cycle: 48.4 days




## <img src="https://github.com/user-attachments/assets/707d9604-b5e0-4bc7-b0c4-a401b6ed001f" width="20" alt="Excel" style="vertical-align: middle;"> Power BI Dashboards & Analysis


### 1. Marketing Performance (Acquisition & Conversion Efficiency)

- High-Volume Drivers: organic_search (2,296 leads) and paid_search (1,586 leads) generate 48.5% of total pipeline volume.

- Conversion Leaders: paid_search (12.30%) and organic_search (11.80%) exhibit strong qualification rates, while untracked sources (unknown) convert at 16.65%.

- Funnel Leakage: social generated 1,350 leads but converted at just 5.56% (75 closed deals), highlighting poor lead targeting.

---

### 2. Sales Performance (Commercial Pipeline & Rep Velocity)

- Top Revenue Generators: Sales rep 4ef15afb... led commercial performance with 133 deals and R$ 501.8M in declared monthly client revenue, averaging 30.5 days to close.

- Deal Size vs. Cycle Length: High-ticket enterprise accounts (de63de0d..., 9749123c...) average ticket sizes above R$ 1.0M and require long sales cycles ranging between 61.7 and 234.0 days, whereas transactional reps close within 17 to 25 days.

- Market Fit Categories: Closed volume is strongly concentrated in retail and consumer products:

   - home_decor: 105 deals

   - health_beauty: 93 deals

   - car_accessories: 77 deals
