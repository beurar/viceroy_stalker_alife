
import re
import os

input_file = r'c:\Source\viceroy_stalker_alife\addons\main\settings.inc.sqf'
output_xml = r'c:\Source\viceroy_stalker_alife\addons\main\Stringtable.xml'
output_sqf = r'c:\Source\viceroy_stalker_alife\addons\main\settings.inc.sqf'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

xml_entries = []
new_sqf_content = content

# Regex to find settings
# Matches: [ "VAR", "TYPE", ["Name", "Tooltip"], "Category", ...
# Use DOTALL to match across lines? No, some are single line.
# Let's iterate through matches.

pattern = re.compile(r'\[\s*"(\w+)"\s*,\s*"\w+"\s*,\s*\[\s*"(.*?)"\s*,\s*"(.*?)"\s*\]\s*,\s*"(.*?)"\s*,', re.DOTALL)
# Note: This pattern assumes the structure [ "VAR", "TYPE", ["Name", "Tooltip"], "Category",
# It stops matching after Category.

matches = []
# Find all occurrences.
# Since re.findall doesn't give us positions to replace easily, and we want to replace strings in the original content.
# Actually, we can use re.sub with a callback function!

categories = set()

def replace_match(match):
    var_name = match.group(1)
    display_name = match.group(2)
    tooltip = match.group(3)
    category = match.group(4)

    # Generate keys
    base_key = var_name.replace("VSA_", "")
    # Handle "VSA_anomalyWeight_Burner" -> "anomalyWeight_Burner"
    
    # Let's standardize keys. STR_VSA_Setting_<Name>
    key_name = f"STR_VSA_Setting_{base_key}"
    key_tooltip = f"STR_VSA_Setting_{base_key}_Tooltip"
    
    # Category Key
    # "Viceroy's STALKER ALife - Core" -> "STR_VSA_Category_Core"
    cat_cleaned = category.replace("Viceroy's STALKER ALife - ", "").replace("VSA - ", "").replace(" ", "")
    key_category = f"STR_VSA_Category_{cat_cleaned}"
    
    # Add to XML entries
    xml_entries.append((key_name, display_name))
    xml_entries.append((key_tooltip, tooltip))
    categories.add((key_category, category))

    # Construct replacement string
    # We need to reconstruct the start of the array
    # The match is: [ "VAR", "TYPE", ["Name", "Tooltip"], "Category",
    
    # Get the full matched string to see indentation/formatting? 
    # match.group(0) contains the matched text.
    
    original_text = match.group(0)
    
    # Replace the strings with localize calls
    # [ "VSA_AIPanicEnabled", "CHECKBOX", ["Enable AI Emission Panic", "AI units..."], "Category",
    # becomes
    # [ "VSA_AIPanicEnabled", "CHECKBOX", [localize "STR_VSA_Setting_AIPanicEnabled", localize "STR_VSA_Setting_AIPanicEnabled_Tooltip"], localize "STR_VSA_Category_Core",
    
    # We need to accept that we are rewriting the code structure slightly.
    # The regex captured exactly the parts we need.
    
    # Let's try to preserve the "Type" and formatting if possible.
    # The regex `\[\s*"(\w+)"\s*,\s*"(\w+)"` ... wait my regex above had `\w+` for type which discards it.
    
    # Let's re-match strictly to capture type.
    full_pattern = re.compile(r'(\[\s*"(\w+)"\s*,\s*"(\w+)"\s*,\s*\[\s*)"(.*?)"\s*,\s*"(.*?)"\s*(\]\s*,\s*)"(.*?)"\s*(,)', re.DOTALL)
    
    # Re-running logic inside the replacement is hard if we change the pattern now.
    pass

# Improved pattern to capture surroundings
# Group 1: Prefix `[ "VAR", "TYPE", [`
# Group 2: VAR
# Group 3: TYPE
# Group 4: Name
# Group 5: Tooltip
# Group 6: Middle `], `
# Group 7: Category
# Group 8: Suffix `,`
pattern_full = re.compile(r'(\[\s*"(\w+)"\s*,\s*"(\w+)"\s*,\s*\[\s*)"(.*?)"\s*,\s*"(.*?)"\s*(\]\s*,\s*)"(.*?)"\s*(,)', re.DOTALL)

def sub_callback(match):
    prefix = match.group(1)
    var_name = match.group(2)
    # type_name = match.group(3) # unused
    display_name = match.group(4)
    tooltip = match.group(5)
    middle = match.group(6)
    category = match.group(7)
    suffix = match.group(8)

    base_key = var_name
    if base_key.startswith("VSA_"):
        base_key = base_key[4:]
        
    key_name = f"STR_{var_name}"
    key_tooltip = f"STR_{var_name}_Tooltip"
    
    # Category
    # special handling for "VSA - Chemical" -> "Chemical"
    cat_val = category
    if "Viceroy's STALKER ALife - " in cat_val:
        cat_suffix = cat_val.split(" - ")[1]
    elif "VSA - " in cat_val:
        cat_suffix = cat_val.split(" - ")[1]
    else:
        cat_suffix = cat_val
        
    cat_cleaned = cat_suffix.replace(" ", "")
    key_category = f"STR_VSA_Category_{cat_cleaned}"

    # Add to list
    xml_entries.append((key_name, display_name))
    xml_entries.append((key_tooltip, tooltip))
    categories.add((key_category, category))
    
    new_text = f'{prefix}localize "{key_name}", localize "{key_tooltip}"{middle}localize "{key_category}"{suffix}'
    return new_text

new_sqf_content = pattern_full.sub(sub_callback, content)

# Also handle the dropdown options for storm reactions etc if they exist as strings?
# The regex likely skipped list content `[[0,1,2],["None","Shuffle","Replace"],1]`
# We should look for those specific patterns separately if we want to localize them.
# For now, let's focus on main settings.

# Generate XML
xml_lines = [
    '<?xml version="1.0" encoding="utf-8"?>',
    '<Project name="Viceroy Stalker ALife">',
    '    <Package name="Main">',
    '        <Container name="Settings">'
]

# Sort categories
xml_lines.append('            <!-- Categories -->')
for key, original in sorted(list(categories)):
    xml_lines.append(f'            <Key ID="{key}">')
    xml_lines.append(f'                <Original>{original}</Original>')
    xml_lines.append(f'            </Key>')

xml_lines.append('            <!-- Settings -->')
# Deduplicate settings
seen_keys = set()
for key, original in xml_entries:
    if key in seen_keys: continue
    seen_keys.add(key)
    xml_lines.append(f'            <Key ID="{key}">')
    xml_lines.append(f'                <Original>{original}</Original>')
    xml_lines.append(f'            </Key>')

xml_lines.append('        </Container>')
xml_lines.append('    </Package>')
xml_lines.append('</Project>')

with open(output_xml, 'w', encoding='utf-8') as f:
    f.write('\n'.join(xml_lines))

with open(output_sqf, 'w', encoding='utf-8') as f:
    f.write(new_sqf_content)

print("Updates complete.")
