# assembler for 1-bit computer
# generates a human-readable hex file for FPGA ROM initialization
# note that the FPGA Verilog must also agree with the configuration
# usage: python3 1-bit_assembler.py source_file hex_file
import math, sys

# user configuration, edit me:
# named input addresses
in0 = 0
in1 = 1
in2 = 2
in3 = 3
in4 = 4
in5 = 5
in6 = 6
in7 = 7
# named output addresses
out0 = 0
out1 = 1
out2 = 2
out3 = 3
out4 = 4
out5 = 5
out6 = 6
out7 = 7
# these must be an integral power of 2
inputs = 8
outputs = 8
ROM_cells = 256
# end user configuration

# auto-configuration
code = [0 for i in range(ROM_cells)] # zeroed ROM image
# instruction field widths
dout_width = 1 # by definition
outputs_width = int(math.log2(outputs))
inputs_width = int(math.log2(inputs))
next_addr_width = int(math.log2(ROM_cells))
# instruction field << shifts
# false_shift = 0 # rightmost field
true_shift = next_addr_width
inputs_shift = true_shift + next_addr_width
outputs_shift = inputs_shift + inputs_width
dout_shift = outputs_shift + outputs_width
# aggregate instruction width
instruction_width = dout_shift + dout_width
print('instruction width is', instruction_width, 'bits')
# hex digits per instruction
instruction_digits = instruction_width // 4
if instruction_width % 4 != 0:
    instruction_digits += 1
format_str = '0' + str(instruction_digits) + 'X'
# end auto-configuration

# assembler line syntax:
#   [label] dout out_addr in_addr true_addr false_addr [comment]
#   label is optional, must occur starting at the first text column
#   dout must be literally 0 or 1
#   out_addr must evaluate to a positive integer that fits the configured outputs_width
#   in_addr must evaluate to a positive integer that fits the configured inputs_width
#   true_addr and false_addr must be one of the following:
#     _0 (the current instruction address)
#     _1 (the current instruction address + 1)
#     a defined label
#   the optional trailing comment is ignored (starting the comment with # is good form)
#   lines with # in the first text column are ignored
#   blank lines are ignored

# the first assembler pass collects labels
# the second assembler pass generates code

infile = sys.argv[1] # source filename
outfile = sys.argv[2] # hex filename

# find the next whitespace
def find_space(string, start):
    while not string[start].isspace():
        start += 1
    return start

# find the next non-whitespace
def skip_space(string, start):
    while string[start].isspace():
        start += 1
    return start

# assemble the code fields in the current line
def asm(line, head, tail):
    instruction = eval(line[head:tail]) << dout_shift
    head = find_space(line, head)
    head = skip_space(line, head)
    tail = find_space(line, head)
    instruction |= eval(line[head:tail]) << outputs_shift
    head = find_space(line, head)
    head = skip_space(line, head)
    tail = find_space(line, head)
    instruction |= eval(line[head:tail]) << inputs_shift
    head = find_space(line, head)
    head = skip_space(line, head)
    tail = find_space(line, head)
    instruction |= eval(line[head:tail]) << true_shift
    head = find_space(line, head)
    head = skip_space(line, head)
    tail = find_space(line, head)
    instruction |= eval(line[head:tail])
    return instruction

# first pass

with open(infile, 'r') as f:
    _0 = 0
    _1 = 1
    for line in f:
        if line == '\n': # blank line
            pass
        elif line[0] == '#': # comment line
            pass
        elif line[0].isspace(): # no label
            _0 += 1
            _1 += 1
        else: # define label
            label = line[0:find_space(line, 0)]
            if label in dir():
                sys.exit('Error: duplicate definition of label ' + label)
            label = label + ' = ' + str(_0)
            exec(label)
            print(label)
            _0 += 1
            _1 += 1

# second pass

with open(infile, 'r') as f:
    _0 = 0
    _1 = 1
    for line in f:
        if line == '\n': # blank line
            pass
        elif line[0] == '#': # comment line
            pass
        elif not line[0].isspace(): # skip label
            head = find_space(line, 0)
            head = skip_space(line, head)
            tail = find_space(line, head)
            code[_0] = asm(line, head, tail)
            _0 += 1
            _1 += 1
        else: # no label
            head = skip_space(line, 0)
            tail = find_space(line, head)
            code[_0] = asm(line, head, tail)
            _0 += 1
            _1 += 1

with open(outfile, 'w') as f:
    for i in code:
        f.write(format(i, format_str) + ' ')

print(_0, 'instructions assembled')
