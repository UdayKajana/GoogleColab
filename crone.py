import re

# Define the path to your .txt file
file_path = 'your_file.txt'

# Define regex patterns
pattern1 = r"call\s+([a-zA-Z0-9_]+)\.([a-zA-Z0-9_]+)\("
pattern2 = r"object\s+([a-zA-Z0-9_]+)\s*/arrival"

# Open the file and search for patterns in each line
with open(file_path, 'r') as file:
    for line in file:
        # Search for the first pattern
        match1 = re.search(pattern1, line)
        if match1:
            dataset_name = match1.group(1)
            stored_procedure_name = match1.group(2)
            print(f"Pattern 1 - Dataset: {dataset_name}, Stored Procedure: {stored_procedure_name}")

        # Search for the second pattern
        match2 = re.search(pattern2, line)
        if match2:
            object_name = match2.group(1)
            print(f"Pattern 2 - Object: {object_name}")
