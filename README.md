Smart Grid, Smarter Habits: Optimizing Household Energy Spend Under 2027 Dutch Solar Rules

Overview
As the Netherlands transitions away from traditional net-metering (salderingsregeling) heading into 2027, residential solar owners face a new economic landscape characterized by static grid feed-in penalties (terugleverkosten) and hourly dynamic pricing volatility.   
IPYNB

This project builds an end-to-end data pipeline and decision-support simulation model using 1 year of high-frequency historical data (October 2025 – September 2026) from a real Dutch residential property. By integrating smart meter telemetry, official meteorological records, and wholesale European electricity spot prices, the project evaluates how behavioral shifting and contract optimization can outpace traditional tariffs without requiring costly hardware upgrades like home batteries.

Key Findings & Financial Scenarios
The simulation models total annual household energy spend under three distinct operational strategies:

Unoptimized Dynamic Contract (€973.76): Adopting a dynamic hourly pricing model without modifying consumption habits incurs the highest overall cost due to peak-hour exposure and negative pricing penalties.   

Traditional Fixed Contract (€913.47): The incumbent baseline contract providing monthly budgeting predictability, though burdened by supplier-specific feed-in penalty fees (terugleverkosten) during solar peaks.   

Behaviorally Optimized Dynamic Plan (€885.04): Strategically shifting heavy appliance usage (e.g., washing machines, dishwashers) to coincide with midday solar generation and EPEX spot-price lows reduces total annual costs and bypasses export penalties entirely.

Data Architecture & Sources
The pipeline integrates three core data pillars processed across sequential Jupyter notebooks:

Pillar: Weather Telemetry	
Source: KNMI (Station 240 - Schiphol) 
Resolution: Hourly	
Description: Tracks temperature, sunshine duration, global radiation, and cloud cover to model solar output. 

Pillar: Household Telemetry	
Source: Home Assistant (P1 Smart Meter & Inverter) 
Resolution: 1-Minute / Daily 
Description: High-frequency grid import/export power draw (kW), phase-1 telemetry, and direct photovoltaic output. 

Pillar: Wholesale Market Pricing	
Source: ENTSO-E Transparency Platform API 
Resolution: Hourly / 15-Min	
Description: Day-ahead wholesale electricity spot prices (spot_price_eur_kwh) and negative pricing flags for the Netherlands (NL). 

Project Structure & Pipeline Flow
Plaintext
├── 01_weather_and_energy_prep.ipynb  # Ingests KNMI weather data & Home Assistant P1 telemetry; cleans & merges datasets
├── 02_baseline_pricing_analysis.ipynb # Calculates historical Vattenfall/Greenchoice baseline costs, solar revenues, and TLK penalties
├── 03_dynamic_pricing_simulation.ipynb# Pulls ENTSO-E wholesale prices, simulates dynamic contracts, and models smart load-shifting
├── 04_statistical_analysis_mysql.ipynb# Executes hypothesis tests (SciPy/Statsmodels) and exports master data to MySQL
├── clean_master_energy_weather.parquet # Intermediate merged dataset (Notebook 1)
├── clean_master_with_actuals.parquet  # Enhanced baseline dataset with actual supplier costs (Notebook 2)
└── clean_master_dynamic_simulated.parquet # Complete simulation master file with dynamic pricing (Notebook 3 & 4)

Notebook Breakdown:
Notebook 1 (Data Engineering & Cleaning): Parses raw KNMI text files, structures 1-minute Home Assistant P1 telemetry, handles missing values via forward-filling and boundary logic, and executes an asof merge to align weather and energy timestamps.   

Notebook 2 (Baseline Reality & Tariffs): Implements supplier-specific pricing logic (transitioning from Vattenfall to Greenchoice in February 2026), computes actual consumption costs, and calculates complex feed-in penalty structures (terugleverkosten) alongside fixed annual government tax credits (vermindering energiebelasting).   

Notebook 3 (Dynamic Pricing & What-If Simulation): Connects to the ENTSO-E API using environment variables to pull hourly wholesale spot prices. Models dynamic consumer bills and simulates a "smart appliance" shift (moving 1.5 kWh cycles from evening peaks to midday solar windows).   

Notebook 4 (Statistical Testing & MySQL Export): Runs rigorous statistical tests (Welch’s Independent T-Tests and Paired T-Tests via SciPy) to validate behavioral differences between weekdays/weekends and overcast/clear skies. Automatically initializes and populates a local MySQL relational database (energy_db).   

Statistical Validation & Hypothesis Testing

To ensure the reliability of the insights, the pipeline evaluates key operational assumptions:

Weekday vs. Weekend Generation: Evaluates whether household energy dynamics differ significantly between weekdays and weekends during peak solar hours.   

Cloud Cover Impact: Confirms a statistically significant drop in solar production (p<0.001) under heavy overcast conditions versus clear skies.   

Load-Shifting Efficacy: Utilizes a paired T-test to prove that shifting appliance usage to EPEX spot-price lows produces a statistically significant reduction in daily energy costs (p<10 −50).   

Getting Started & Prerequisites

1. Clone the Repository & Install Dependencies
Ensure you have Python 3.10+ installed along with the required analytical and database libraries:

Bash
pip install pandas numpy python-dotenv entsoe-py statsmodels scipy pymysql sqlalchemy pyarrow

2. Configure Environment Variables
Create a .env file in the root directory containing your API keys and local database credentials:

ENTSOE_API_KEY=your_entsoe_transparency_api_key_here
DB_PASSWORD=your_mysql_root_password_here

3. Run the Pipeline
Execute the Jupyter notebooks sequentially (01 through 04) to regenerate cleaned intermediate files, execute simulations, and populate your local MySQL database instance.   

