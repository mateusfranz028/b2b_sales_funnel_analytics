-- Auditoria de volumetria: Topo de Funil vs Fundo de Funil
SELECT 
    (SELECT COUNT(*) FROM marketing_qualified_leads) AS total_leads,
    (SELECT COUNT(*) FROM closed_deals) AS total_closed_deals;
	
-----------------------

SELECT 
    m.origin AS acquisition_channel,
    COUNT(m.mql_id) AS total_leads,
    COUNT(c.mql_id) AS closed_deals,
    ROUND(COUNT(c.mql_id)::numeric / COUNT(m.mql_id) * 100, 2) AS conversion_rate_pct
FROM marketing_qualified_leads m
LEFT JOIN closed_deals c ON m.mql_id = c.mql_id
GROUP BY m.origin
ORDER BY total_leads DESC;

----------------------

SELECT 
    m.origin AS acquisition_channel,
    COUNT(c.mql_id) AS total_deals,
    ROUND(AVG(DATE_PART('day', c.won_date - m.first_contact_date))::numeric, 1) AS avg_days_to_close,
    MIN(DATE_PART('day', c.won_date - m.first_contact_date)) AS min_days,
    MAX(DATE_PART('day', c.won_date - m.first_contact_date)) AS max_days
FROM marketing_qualified_leads m
JOIN closed_deals c ON m.mql_id = c.mql_id
GROUP BY m.origin
ORDER BY total_deals DESC;


------------------------

SELECT 
    c.sr_id AS sales_rep_id,
    COUNT(c.mql_id) AS deals_won,
    ROUND(SUM(c.declared_monthly_revenue), 2) AS total_declared_revenue,
    ROUND(AVG(c.declared_monthly_revenue), 2) AS avg_deal_size
FROM closed_deals c
WHERE c.declared_monthly_revenue IS NOT NULL
GROUP BY c.sr_id
ORDER BY total_declared_revenue DESC
LIMIT 10;

------------------------

SELECT 
    m.mql_id,
    m.first_contact_date,
    COALESCE(m.origin, 'unknown') AS acquisition_channel,
    c.won_date,
    CASE 
        WHEN c.mql_id IS NOT NULL THEN 1 
        ELSE 0 
    END AS is_closed_deal,
    ROUND(DATE_PART('day', c.won_date - m.first_contact_date)::numeric, 0) AS days_to_close,
    c.business_segment,
    c.lead_type,
    c.sr_id AS sales_rep_id,
    c.sdr_id AS sdr_rep_id,
    c.declared_monthly_revenue
FROM marketing_qualified_leads m
LEFT JOIN closed_deals c ON m.mql_id = c.mql_id;
	