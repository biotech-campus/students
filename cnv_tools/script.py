from cnvpytor.root import Root
import argparse
import logging
import pandas as pd


def cnvpytor(args):
    bam_name = args.bam.split('/')[-1].split('.')[0] # use bam-file name to name cache files 
    app = Root(f'{args.output_dir}/{bam_name}.pytor', create=True, max_cores=args.cpu)

    # Calling CNVs
    app.rd([args.bam])
    app.calculate_histograms(args.hists)
    app.partition(args.hists)
    calls = app.call(args.hists)

    #Write to output file
    for bin_size in calls:
        pd.DataFrame(calls[bin_size]).to_csv(f'{args.output_dir}/{bam_name}_h{bin_size}.csv',
                                             index=False,
                                             header=['id', 'type', 'start', 'end', 'size', 'cnv', 'p_val',
                                                     'p_val_2', 'p_val_3', 'p_val_4', 'Q0', 'pN', 'dG'])

def cnvkit(args):
    raise NotImplementedError('CNVkit calling is not implemented yet!')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('tool', type=str, help='Tool name to launch')
    parser.add_argument('--bam', '-b', type=str, help='BAM filename', required=True)
    parser.add_argument('-o', '--output-dir', type=str, help='Dir for output files', required=True)
    
    parser.add_argument('--hists', nargs='+', help=' List of histogram bin sizes', default=[10000])
    parser.add_argument('--cpu', type=int, help='Max CPUs to use', default=4)
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(args.tool)

    if args.tool == 'cnvpytor':
        cnvpytor(args)


    elif args.tool == 'cnvkit':
        cnvkit(args)


if __name__ == '__main__':
    main()
    