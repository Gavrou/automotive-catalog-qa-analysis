-- Evolución del mercado EV/año
q_evolucion = """
SELECT
    model_year,
    COUNT(*) AS total_models,
    ROUND(AVG(range_km), 1) AS avg_range_km,
    ROUND(AVG(motor_power_kw), 1) AS avg_power_kw,
    ROUND(AVG(comb_kwh_100km), 2) AS avg_consumption_kwh
FROM ev_models
GROUP BY model_year
ORDER BY model_year ASC;
"""
-- Marcas con mejor autonomía promedio
q_marcas = """
SELECT
    brand,
    COUNT(*) AS models_count,
    MAX(range_km) AS max_range_km,
    ROUND(AVG(range_km), 1) AS avg_range_km,
    ROUND(AVG(km_charged_per_hour), 1) AS avg_charging_speed_kmh
FROM ev_models
GROUP BY brand
HAVING COUNT(*) >= 3
ORDER BY avg_range_km DESC;
"""

-- Ranking de los modelos con consumo más eficiente
q_eficiencia = """
WITH RankedModels AS (
    SELECT
        vehicle_size,
        brand,
        model,
        model_year,
        comb_kwh_100km,
        range_km,
        RANK() OVER (PARTITION BY vehicle_size ORDER BY comb_kwh_100km ASC, range_km DESC) AS efficiency_rank
    FROM ev_models
)
SELECT *
FROM RankedModels
WHERE efficiency_rank <= 2
ORDER BY vehicle_size, efficiency_rank;
"""

-- Comparativa enfocada en Ford contra el promedio del mercado
q_ford = """
SELECT
    model_year,
    model,
    vehicle_size,
    motor_power_kw,
    range_km,
    comb_kwh_100km,
    charging_time_h
FROM ev_models
WHERE brand = 'Ford'
ORDER BY model_year DESC, range_km DESC;
"""