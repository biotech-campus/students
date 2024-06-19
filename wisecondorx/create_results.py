#!/usr/bin/env python3

import csv
import os
import argparse

def parse_bed_file(bed_file_path, output_csv_path):
    # Use the full path of the bed file
    file_path = os.path.abspath(bed_file_path)

    with open(bed_file_path, 'r') as bed_file, open(output_csv_path, 'w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(['File', 'Chr', 'Zscore', 'Type'])

        for line in bed_file:
            fields = line.strip().split('\t')
            chr_field = fields[0]
            zscore_field = fields[4]
            type_field = fields[5]
            csv_writer.writerow([file_path, chr_field, zscore_field, type_field])

def main():
    parser = argparse.ArgumentParser(description="Parse .bed file and extract chr, zscore, and type into a CSV file.")
    parser.add_argument('bed_file', help="Path to the input .bed file")
    parser.add_argument('csv_file', help="Path to the output CSV file")

    args = parser.parse_args()

    parse_bed_file(args.bed_file, args.csv_file)

if __name__ == "__main__":
    main()
