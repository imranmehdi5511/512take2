output_file = "output-for-sgx-on-21000.txt"

with open(output_file, "w") as f:
    for i in range(21001):
        line = f'gramine-sgx test-gramine test-data/file{i}.txt\n'
        f.write(line)
