from cnvpytor.root import Root
from cnvpytor.viewer import Viewer
import argparse
import logging
import pandas as pd


def cnvpytor(args):
    bam_name = args.bam.split('/')[-1].split('.')[0] # use bam-file name to name cache files 
    app = Root(f'{args.output_dir}/{bam_name}.pytor', create=True, max_cores=args.cpu)

    # Calling CNVs
    chroms = args.chroms
    if len(chroms) == 1 and isinstance(chroms, list):
        chroms = chroms[0].split(',')
    app.rd([args.bam], chroms=chroms)
    app.calculate_histograms(args.hists, chroms=chroms)
    app.partition(args.hists, chroms=chroms)
    calls = app.call(args.hists, chroms=chroms)

    # Write to CSV file
    for bin_size in calls:
        pd.DataFrame(calls[bin_size]).to_csv(f'{args.output_dir}/{bam_name}_h{bin_size}.csv',
                                             index=False,
                                             header=['id', 'type', 'start', 'end', 'size', 'cnv', 'p_val',
                                                     'p_val_2', 'p_val_3', 'p_val_4', 'Q0', 'pN', 'dG'])
    # Write to VCF file
    for bin_size in args.hists:
        viewer = Viewer([f'{args.output_dir}/{bam_name}.pytor'],
                        params={'print_filename': f'{args.output_dir}/{bam_name}_{bin_size}.vcf',
                                'annotate': True,
                                'bin_size': bin_size})
        viewer.print_calls_file()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--bam', '-b', type=str, help='BAM filename', required=True)
    parser.add_argument('-o', '--output-dir', type=str, help='Dir for output files', required=True)
    
    parser.add_argument('--hists', nargs='+', help=' List of histogram bin sizes', default=[10000])
    parser.add_argument('--chroms', nargs='+', help=' List of chromosomes used in analysis', default=[])
    parser.add_argument('--cpu', type=int, help='Max CPUs to use', default=4)
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger = logging.getLogger('cnvpytor')

    cnvpytor(args)
        

if __name__ == '__main__':
    main()
    