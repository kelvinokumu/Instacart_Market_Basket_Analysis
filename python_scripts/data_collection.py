import os
import pandas as pd

# Define the base directory and use relative paths
base_dir = os.path.dirname(os.path.abspath(__file__))  # Get the directory of the script
raw_dir = os.path.join(base_dir, '..', 'data', 'raw')
processed_dir = os.path.join(base_dir, '..', 'data', 'processed')  # Processed folder
schema_output = os.path.join(base_dir, '..', 'sql', 'schema.sql')  # Corrected path for schema output

# Ensure the processed directory exists
os.makedirs(processed_dir, exist_ok=True)


# Function to infer PostgreSQL data types
def infer_postgres_type(dtype):
    if pd.api.types.is_integer_dtype(dtype):
        return "INTEGER"
    elif pd.api.types.is_float_dtype(dtype):
        return "FLOAT"
    elif pd.api.types.is_datetime64_any_dtype(dtype):
        return "TIMESTAMP"
    elif pd.api.types.is_bool_dtype(dtype):
        return "BOOLEAN"
    else:
        return "TEXT"


# Initialize a list for table schemas
schemas = []

# Read all files from the raw directory
for filename in os.listdir(raw_dir):
    if filename.endswith(".csv"):
        # Construct full file paths
        raw_file_path = os.path.join(raw_dir, filename)
        processed_file_path = os.path.join(processed_dir, filename)

        # Read the raw CSV file
        print(f"Processing file: {filename}")
        df = pd.read_csv(raw_file_path)

        # Save the cleaned file to the processed directory
        df.to_csv(processed_file_path, index=False)
        print(f"Saved processed file: {processed_file_path}")

        # Create a SQL schema for the file
        table_name = os.path.splitext(filename)[0]
        schema = f"CREATE TABLE {table_name} (\n"
        for col in df.columns:
            col_type = infer_postgres_type(df[col])
            schema += f"    {col} {col_type},\n"
        schema = schema.rstrip(",\n") + "\n);\n\n"
        schemas.append(schema)

# Save the schemas to a .sql file
os.makedirs(os.path.dirname(schema_output), exist_ok=True)  # Ensure the sql directory exists
with open(schema_output, "w") as f:
    f.writelines(schemas)

print(f"SQL schema saved to: {schema_output}")
