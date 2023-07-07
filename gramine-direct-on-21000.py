output_file = "output-for-direct-gramine-on-21000.txt"

with open(output_file, "w") as f:
    for i in range(21001):
        line = f'gramine-direct test-gramine test-data/file{i}.txt\n'
        f.write(line)
