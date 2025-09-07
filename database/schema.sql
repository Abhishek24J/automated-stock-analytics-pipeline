-- PostgreSQL Database Schema for Automated Stock Analytics Pipeline
-- Create database (run as superuser)
-- CREATE DATABASE stock_analytics;

-- Connect to the database and create table
\c stock_analytics;

-- Create stock_data table
CREATE TABLE IF NOT EXISTS stock_data (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    open DECIMAL(10,2) NOT NULL,
    high DECIMAL(10,2) NOT NULL,
    low DECIMAL(10,2) NOT NULL,
    close DECIMAL(10,2) NOT NULL,
    volume BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_stock_data_symbol ON stock_data(symbol);
CREATE INDEX idx_stock_data_date ON stock_data(date);
CREATE INDEX idx_stock_data_symbol_date ON stock_data(symbol, date);

-- Create unique constraint to prevent duplicate entries
ALTER TABLE stock_data ADD CONSTRAINT unique_symbol_date UNIQUE (symbol, date);

-- Create function to update timestamp on record update
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update the updated_at column
CREATE TRIGGER update_stock_data_updated_at 
    BEFORE UPDATE ON stock_data 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Grant permissions (adjust username as needed)
-- GRANT ALL PRIVILEGES ON TABLE stock_data TO your_username;
-- GRANT USAGE, SELECT ON SEQUENCE stock_data_id_seq TO your_username;

-- Sample query to verify table creation
-- SELECT * FROM stock_data LIMIT 5;