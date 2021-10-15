"""The purpose of this script is to just remove the file timestamp information from the output
of a docker container export.
This could be done within the shell script but I'm lazy and didn't want to re-write this with sed/awk
"""

import sys

MONTH_COL = 5
DAY_COL = 6
TIME_COL = 7

def main():
    dumpfile = sys.argv[1]
    with open(dumpfile) as f:
        lines = f.readlines()

    with open(dumpfile + '.processed', 'w') as fw:
        for line in lines:
            line_segments = line.strip().split()
            new_line_segments = line_segments[:MONTH_COL] + line_segments[TIME_COL+1:]
            fw.write('\t'.join(new_line_segments))
            fw.write('\n')

if __name__ == '__main__':
    main()
