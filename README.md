#              **B2B Sales Funnel Analytics**
<img width="1495" height="834" alt="gif dashboard" src="https://github.com/user-attachments/assets/a3065dfb-15ae-48f4-862d-0a2ef3780b78" />


## Introduction


This project explores the conversion mechanics of sellers registering on a large marketplace ecosystem. By connecting raw lead touchpoints with CRM deal progression data, the objective is to diagnose acquisition bottlenecks, determine sales cycle duration, and measure the revenue impact of consultative sales representatives (SDRs and Closers).

## Project Files
- [Analytical Base Extraction (PostgreSQL File)](analytical_base_extraction.sql)
- [Audit Table (Excel File)](marketing_funnel_audit.xlsx)
- [Dashboard (Power BI file)](b2b_sales_pipeline_analysis.pbix)

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

*  **MQL Acquisition**
*  **Commercial Roles**
*  **Business Demographics**
*  **Sales Velocity**


---

## <img src="https://github.com/user-attachments/assets/475cb456-ce8a-42b3-aefa-0ddb508cdf99" width="20" alt="Excel" style="vertical-align: middle;"> Data Extraction & Transformation



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

## <img src="https://github.com/user-attachments/assets/76f3d093-4297-42e1-92b4-8897454a3cd3" width="20" alt="Excel" style="vertical-align: middle;"> Data Audit & Validation 


Key Data Cleansing Actions:
- Date Parsing & Localization: Converted first_contact_date and won_date into proper regional date timestamps.

- Text Null Handling: Detected literal string entries ("NULL") across sales_rep_id and business_segment columns and coerced them into true blanks to prevent downstream calculation skew.

---

Mathematical Integrity Audit: Verified with Pivot Tables that the dataset totaled exactly:

- Total Leads: **8,000**

- Closed Deals: **842**

- Conversion Rate: **10.53%**

- Average Sales Cycle: **48.4 days**

<img width="697" height="240" alt="image" src="https://github.com/user-attachments/assets/d4c5a611-25ec-4c96-a932-f98bd1a69a7b" />



## <img src="https://github.com/user-attachments/assets/707d9604-b5e0-4bc7-b0c4-a401b6ed001f" width="20" alt="Excel" style="vertical-align: middle;"> Power BI Dashboards & Analysis


### 1. Marketing Performance

- High-Volume Drivers: **organic_search** (2,296 leads) and **paid_search** (1,586 leads) generate 48.5% of total pipeline volume.

- Conversion Leaders: **paid_search** (12.30%) and **organic_search** (11.80%) exhibit strong qualification rates, while untracked sources **(unknown)** convert at 16.65%.

- Funnel Leakage: **social** generated 1,350 leads but converted at just 5.56% (75 closed deals), highlighting poor lead targeting.

<img width="584" height="150" alt="image" src="https://github.com/user-attachments/assets/dbc972a1-5072-4f5b-a55e-6effc87a2e73" />

---

<img width="579" height="251" alt="image" src="https://github.com/user-attachments/assets/5ab477a5-3f4e-4f79-82d2-939128864cc7" />

---

### 2. Sales Performance

- Top Revenue Generators: Sales rep 4ef15afb... led commercial performance with 133 deals and R$ 501.8M in declared monthly client revenue, averaging 30.5 days to close.

- Deal Size vs. Cycle Length: High-ticket enterprise accounts average ticket sizes above R$ 1.0M and require long sales cycles ranging between 61.7 and 234.0 days, whereas transactional reps close within 17 to 25 days.

- Market Fit Categories: Closed volume is strongly concentrated in retail and consumer products:

   - home_decor: **105 deals**

   - health_beauty: **93 deals**

   - car_accessories: **77 deals**
 
<img width="472" height="61" alt="image" src="https://github.com/user-attachments/assets/e4357fba-099b-4e30-8392-43afae58dc92" />



## 💡 Conclusions

**1. Reallocate Acquisition Budgets**
paid_search yields more than double the conversion rate of social. Shifting marketing spend away from social media campaigns and towards high-intent search terms will immediately improve pipeline quality.

**2. Segmented Sales Processes**
Enterprise leads with high declared revenues demand up to 234 days to convert. Setting a unified quota or SLA across all closers distorts rep performance. High-ticket enterprise prospects should be routed to a dedicated consultative sales track.

**3. Supply Expansion Focus**
Because home_decor, health_beauty, and car_accessories account for over 32% of all seller conversions, outbound sales motions should prioritize merchant acquisition in these specific retail categories.
