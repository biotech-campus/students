from cnvpytor.root import Root
import argparse
import logging

def cnvpytor(args):
    logger = logging.getLogger(args.tool)
    app = Root(args.pytor, create=True, max_cores=args.cpu)
    app.rd([args.bam])
    app.calculate_histograms(args.hists)
    app.partition(args.hists)
    calls = app.call(args.hists, print_calls=True)


def cnvkit(args):
    raise NotImplementedError('CNVkit calling is not implemented yet!')

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('tool', type=str, help='Tool name to launch')
    parser.add_argument('--bam', '-b', type=str, help='BAM filename', required=True)
    parser.add_argument('--pytor', '-n', type=str, help='CNVpytor filename', default='cache.pytor')
    parser.add_argument('--hists', nargs='+', help=' List of histogram bin sizes', default=[10000])
    parser.add_argument('--cpu', type=int, help='Max CPUs to use', default=4)
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    if args.tool == 'cnvpytor':
        cnvpytor(args)
    elif args.tool == 'cnvkit':
        cnvkit(args)

if __name__ == '__main__':
    main()
    