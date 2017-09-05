
import sys

class parser:
    def __init__(self):
        self.counter = 0
        pass

    def extraction_from_blast(self, input_file=None, output_file=None):

        in_fd = open(input_file, 'r') if input_file else sys.stdin
        out_fd = open(output_file, 'w') if output_file else sys.stdout

        for line in in_fd:
            tmp_line = line.strip('\n').split('\t')
            tmp_line = tmp_line[:4]
            string = '\t'.join(tmp_line) + '\n'
            out_fd.write(string)
