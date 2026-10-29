-- Daily Energy Summary (Total Consumption & Production per Day)--

SELECT 
    Date,
    ROUND(SUM(power_consumed_kw) / 60, 2) AS daily_consumption_kwh,
    ROUND(SUM(power_produced_kw) / 60, 2) AS daily_production_kwh,
    ROUND(AVG(Temperature), 1) AS avg_temperature_c
FROM energy_db.energy_simulation_master
GROUP BY Date
ORDER BY Date
LIMIT 30;

-- Highest Consumption Days --

SELECT 
    Date,
    ROUND(SUM(power_consumed_kw) / 60, 2) AS total_daily_consumption_kwh,
    ROUND(MAX(power_consumed_kw), 2) AS peak_minute_spike_kw,
    ROUND(AVG(Temperature), 1) AS avg_temp
FROM energy_db.energy_simulation_master
GROUP BY Date
ORDER BY total_daily_consumption_kwh DESC
LIMIT 5;

-- Daily Net Energy Balance (Consumption vs. Production) --

SELECT 
    Date,
    ROUND(SUM(power_consumed_kw) / 60, 2) AS daily_consumption_kwh,
    ROUND(SUM(power_produced_kw) / 60, 2) AS daily_production_kwh,
    ROUND((SUM(power_produced_kw) - SUM(power_consumed_kw)) / 60, 2) AS net_energy_balance_kwh
FROM energy_db.energy_simulation_master
GROUP BY Date
ORDER BY Date
LIMIT 30;

-- Weather Impact: Coldest Days vs. Energy Consumption --

SELECT 
    Date,
    ROUND(AVG(Temperature), 1) AS avg_daily_temperature_c,
    ROUND(SUM(power_consumed_kw) / 60, 2) AS total_consumption_kwh
FROM energy_db.energy_simulation_master
GROUP BY Date
ORDER BY avg_daily_temperature_c ASC
LIMIT 10;

-- Solar Performance vs. Cloud Cover --

SELECT 
    Date,
    Cloud_cover,
    ROUND(SUM(power_produced_kw) / 60, 2) AS daily_solar_production_kwh
FROM energy_db.energy_simulation_master
WHERE Cloud_cover IS NOT NULL
GROUP BY Date, Cloud_cover
ORDER BY daily_solar_production_kwh DESC
LIMIT 10;

-- Self consumption rate --

SELECT 
    Date,
    ROUND(SUM(power_produced_kw) / 60, 2) AS total_production_kwh,
    ROUND(SUM(power_consumed_kw) / 60, 2) AS total_consumption_kwh,
    ROUND(
        SUM(CASE 
            WHEN power_produced_kw >= power_consumed_kw THEN power_consumed_kw 
            ELSE power_produced_kw 
        END) / NULLIF(SUM(power_produced_kw), 0) * 100, 1
    ) AS self_consumption_rate_pct
FROM energy_db.energy_simulation_master
GROUP BY Date
ORDER BY Date
LIMIT 30;