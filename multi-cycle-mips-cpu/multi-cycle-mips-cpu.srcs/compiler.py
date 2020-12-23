import re
import sys


def regToNum(reg):
    regID = int(reg.lstrip(' $'))
    result = bin(regID)[2:].rjust(5, '0')
    return result


def signExtend(immediate):
    if immediate >= 0:
        immediate = bin(immediate)[2:].rjust(16, '0')
    else:
        immediate = bin(immediate + 2 ** 16)[2:].rjust(16, '1')
    return immediate


def typeR(op, operand):
    rs = regToNum(operand[1])
    rt = regToNum(operand[2])
    rd = regToNum(operand[0])
    return op + rs + rt + rd + 11 * '0'


def typeI(op, operand):
    rs = regToNum(operand[1])
    rt = regToNum(operand[0])
    immediate = int(operand[2])
    immediate = signExtend(immediate)
    return op + rs + rt + immediate


def typeJ(op, operand):
    addr = bin(int(operand[0], base=16))[2:-2].rjust(26, '0')
    return op + addr


def asmCompile(ins, operand):
    if ins == 'add':
        result = typeR('000000', operand)
    elif ins == 'sub':
        result = typeR('000001', operand)
    elif ins == 'addi':
        result = typeI('000010', operand)
    elif ins == 'and':
        result = typeR('010000', operand)
    elif ins == 'andi':
        result = typeI('010001', operand)
    elif ins == 'ori':
        result = typeI('010010', operand)
    elif ins == 'xori':
        result = typeI('010011', operand)
    elif ins == 'sll':
        sa = bin(int(operand[2]))[2:].rjust(5, '0')
        op = '011000'
        result = (
            op + '00000' + regToNum(operand[1]) + regToNum(operand[0]) + sa).ljust(32, '0')
    elif ins == 'slti':
        result = typeI('100110', operand)
    elif ins == 'slt':
        result = typeR('100111', operand)
    elif ins == 'sw' or ins == 'lw':
        tempRegex = re.compile('([0-9])+\((.+)\)')
        rt = regToNum(operand[0])
        rs = regToNum(tempRegex.search(operand[1]).group(2))
        immediate = signExtend(
            (int(bin(int(tempRegex.search(operand[1]).group(1)))[2:], base=2)))
        if ins == 'sw':
            op = '110000'
        else:
            op = '110001'
        result = op + rs + rt + immediate
    elif ins == 'beq':
        operand[0], operand[1] = operand[1], operand[0]
        result = typeI('110100', operand)
    elif ins == 'bne':
        operand[0], operand[1] = operand[1], operand[0]
        result = typeI('110101', operand)
    elif ins == 'bltz':
        operand.insert(1, '00000')
        operand[0], operand[1] = operand[1], operand[0]
        result = typeI('110110', operand)
    elif ins == 'j':
        result = typeJ('111000', operand)
    elif ins == 'jr':
        result = '111001' + \
            (bin(int((operand[0]).lstrip(' $')))
             [2:].rjust(5, '0')).ljust(26, '0')
    elif ins == 'jal':
        result = typeJ('111010', operand)
    elif ins == 'halt':
        result = '111111' + '0' * 26
    else:
        result = ''
    return result


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('[Failed] command format: python MIPS_compiler.py <input> <output>')
        exit()
    try:
        asmFile = open(sys.argv[1], 'r', encoding='UTF-8')
    except FileNotFoundError:
        print('the given file "{0}" can\'t be found'.format(sys.argv[1]))
    else:
        outputFile = open(sys.argv[2], 'w')
    regex = re.compile('([a-zA-Z]+)+[ \s]+(.+)')
    output = []
    for asmCode in asmFile:
        asmCode = asmCode.strip()
        match = regex.search(asmCode)
        if match is not None:
            instruction = match.group(1)
            operand = match.group(2).split(',')
        else:
            instruction = asmCode
            operand = []
        machineCode = asmCompile(instruction, operand)
        output.append(machineCode)
    outputFile.write('\n'.join(output))
    print('Complete the MIPS code assembly.')
