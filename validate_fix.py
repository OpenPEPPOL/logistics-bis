import re

with open('structure/syntax/ebxml-search-notice-request.xml', 'r', encoding='utf-8') as f:
    content = f.read()

# Check for remaining violations
remaining_violations = len(re.findall(r'</Reference>\n[ \t]*<DataType>', content))

# Also check what we have now
correct_order = len(re.findall(r'</DataType>\n[ \t]*<Reference', content))

print(f"Remaining Reference-before-DataType violations: {remaining_violations}")
print(f"Correct DataType-before-Reference patterns: {correct_order}")
