output_file = "output.txt"

with open(output_file, "w") as f:
    for i in range(21001):
        line = f'  "file:test-data/file{i}.txt",\n'
        f.write(line)
