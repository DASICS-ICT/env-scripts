import sys
import re
import os

# Check if command line argument is provided for directory name, if not, raise an error
if len(sys.argv) > 1:
    directory = sys.argv[1]
else:
    print("Error: No directory provided.")
    sys.exit(1)

# Define regular expressions to match module names
module_pattern_clkgt = re.compile(r"module\s+STD_CLKGT_func")
module_pattern_sram = re.compile(r"module\s+sram_[^\s]+_multicycle")
# Define regular expression to match RW0_rdata
rdata_pattern = re.compile(r"output\s+\[(\d+):0\]\s+RW0_rdata")

# Function to process a single file
def process_file(file_name):
    # Open the file to read
    with open(file_name, 'r') as file:
        # Read all lines of the file
        lines = file.readlines()

    # Iterate through all lines
    for i in range(len(lines)):
        # Match STD_CLKGT_func module name and exclude interference statement
        if module_pattern_clkgt.match(lines[i]) and not lines[i].startswith("//"):
            # Execute replacement operation for STD_CLKGT_func module within the module
            for j in range(i, len(lines)):
                if "assign Q = CK & clk_en_reg;" in lines[j]:
                    lines[j] = lines[j].replace("assign Q = CK & clk_en_reg;", "assign Q = CK; //& clk_en_reg\n")
                    break
        # Match sram_*_multicycle module name
        elif module_pattern_sram.match(lines[i]) and not lines[i].startswith("//"):
            # Find rdata_width and add wire and reg inside the module
            for j in range(i, len(lines)):
                rdata_width_match = rdata_pattern.search(lines[j])
                if rdata_width_match:
                    rdata_width = int(rdata_width_match.group(1))  # Get the width of RW0_rdata
                    lines.insert(j + 3, "  wire [%d:0] RW0_rdata_wire;\n" \
                                        "  reg  [%d:0] RW0_rdata_reg;\n" % (rdata_width, rdata_width))
                    break
            # Match RW0_rdata assignments or submodule arguments, and submodule
            for j in range(i, len(lines)):
                if "(RW0_rdata)" in lines[j]:
                    lines[j] = lines[j].replace("(RW0_rdata)", "(RW0_rdata_wire)")
                elif "assign RW0_rdata =\n" in lines[j]:
                    lines[j] = lines[j].replace("assign RW0_rdata =\n", "assign RW0_rdata_wire =\n")
                elif "endmodule\n" in lines[j]:
                    # Insert always block and assign statement before endmodule
                    lines.insert(j, "  always @(posedge RW0_clk) begin\n"\
                                    "    RW0_rdata_reg <= RW0_rdata_wire;\n" \
                                    "  end  // always @(posedge)\n" \
                                    "  assign RW0_rdata = RW0_rdata_reg;\n")
                    break

    # Open the file to write modified content
    with open(file_name, 'w') as file:
        # Write modified content to the file
        file.writelines(lines)

# Iterate through all files in the directory
for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith(".sv"):
            process_file(os.path.join(root, file))